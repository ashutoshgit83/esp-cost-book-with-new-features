const cds = require('@sap/cds');

module.exports = (srv) => {

  // ─── Default values on NEW draft ───
  srv.before('NEW', 'CostBookings.drafts', (req) => {
    console.log('[ESP] before NEW.drafts triggered');
    if (req.data) {
      req.data.surcharge = req.data.surcharge ?? 46000;
      req.data.srnStatus = req.data.srnStatus ?? 'In Progress';
      req.data.invoiceStatus = req.data.invoiceStatus ?? 'In Progress';
      req.data.plwCostBookingStatus = req.data.plwCostBookingStatus ?? 'In Progress';
    }
    computeFields(req.data);
  });

  // ─── Validation + computation on SAVE (draft activation → active entity) ───
  srv.before('SAVE', 'CostBookings', (req) => {
    console.log('[ESP] before SAVE triggered');
    const data = req.data;
    // Validate: if rate or annualRate is given, euroConversionRate must be provided
    const hasINRValues = (parseFloat(data?.annualRate) || parseFloat(data?.rate) || parseFloat(data?.srnValue));
    if (hasINRValues && !parseFloat(data?.euroConversionRate)) {
      req.error(400, 'Please provide Euro Conversion Rate to calculate EUR values', 'euroConversionRate');
    }
    computeFields(data);
  });

  // ─── Currency conversion on CREATE (for drafts) ───
  srv.before('CREATE', 'CostBookings.drafts', (req) => {
    console.log('[ESP] before CREATE.drafts triggered');
    computeFields(req.data);
  });

  // ─── After UPDATE on drafts: recompute all derived fields with full data ───
  srv.after('UPDATE', 'CostBookings.drafts', async (data, req) => {
    const ID = data?.ID;
    if (!ID) return;

    const { CostBookings } = srv.entities;

    // Read the full draft (now includes the updated values)
    const current = await SELECT.one.from(CostBookings.drafts).where({ ID });
    if (!current) return;

    // Auto-populate vendorNo from vendorName
    if (current.vendorName) {
      const vendor = await SELECT.one.from('esp.costbooking.Vendors').where({ name: current.vendorName });
      current.vendorNo = vendor ? vendor.number : current.vendorNo;
    }

    // Compute all derived fields from full data
    computeFields(current);

    // Write computed fields back to the draft DB
    await cds.run(
      UPDATE.entity(CostBookings.drafts).set({
        vendorNo:             current.vendorNo,
        annualRate:           current.annualRate,
        annualRateEuro:       current.annualRateEuro,
        srnValueEuro:         current.srnValueEuro,
        srnValuePlusSurcharge:current.srnValuePlusSurcharge,
        plwCostBookingEuro:   current.plwCostBookingEuro,
        plwCostBookingPercent:current.plwCostBookingPercent,
        srnValueInEuros:      current.srnValueInEuros,
        gst:                  current.gst,
        surcharge:            current.surcharge
      }).where({ ID })
    );

    console.log('[ESP] after UPDATE computed: annualRate=' + current.annualRate + ', annualRateEuro=' + current.annualRateEuro);
  });

  // ─── Copy Booking action ───
  srv.on('copyBooking', 'CostBookings', async (req) => {
    const { CostBookings } = srv.entities;
    const ID = req.params[0]?.ID || req.params[0];

    // Read the source record (all fields)
    const source = await SELECT.one.from(CostBookings).where({ ID });
    if (!source) return req.error(404, 'Source record not found');

    // Remove keys and audit fields - keep all business data
    const copy = { ...source };
    delete copy.ID;
    delete copy.createdAt;
    delete copy.createdBy;
    delete copy.modifiedAt;
    delete copy.modifiedBy;
    delete copy.IsActiveEntity;
    delete copy.HasActiveEntity;
    delete copy.HasDraftEntity;
    delete copy.DraftAdministrativeData_DraftUUID;

    // Reset statuses to default
    copy.srnStatus = 'In Progress';
    copy.invoiceStatus = 'In Progress';
    copy.plwCostBookingStatus = 'In Progress';

    // Create a new draft via the CostBookings entity
    const newDraft = await srv.send({
      event: 'NEW',
      entity: CostBookings.drafts,
      data: copy
    });

    // Patch the draft with all copied field values
    if (newDraft?.ID) {
      await UPDATE(CostBookings.drafts).set(copy).where({ ID: newDraft.ID });
      // Re-read the full draft to return
      const result = await SELECT.one.from(CostBookings.drafts).where({ ID: newDraft.ID });
      return result;
    }

    return newDraft;
  });

  // ─── Row-level filtering for chapter leads on READ ───
  srv.before('READ', 'CostBookings', (req) => {
    if (req.user.is('Admin')) return;
    const userChapterLead = req.user.attr?.chapterLead;
    if (userChapterLead) {
      if (!req.query.SELECT.where) {
        req.query.SELECT.where = [];
      } else {
        req.query.SELECT.where.push('and');
      }
      req.query.SELECT.where.push(
        { ref: ['chapterLead'] }, '=', { val: userChapterLead }
      );
    }
  });
};

function computeFields(data) {
  if (!data) return;

  // Auto-calculate Annual Rate = Rate * 12
  const monthlyRate = parseFloat(data.rate) || 0;
  if (monthlyRate > 0) {
    data.annualRate = round(monthlyRate * 12);
  }

  const conversionRate = parseFloat(data.euroConversionRate) || 0;
  const srnValue = parseFloat(data.srnValue) || 0;
  const annualRate = parseFloat(data.annualRate) || 0;
  const capacityUtilized = parseFloat(data.capacityUtilized) || 0;

  if (data.surcharge === undefined || data.surcharge === null) data.surcharge = 46000;
  const surchargeVal = parseFloat(data.surcharge) || 46000;

  if (conversionRate > 0) {
    data.annualRateEuro = round(annualRate / conversionRate);
    data.srnValueEuro = round(srnValue / conversionRate);
    const srnPlusSurcharge = srnValue + surchargeVal;
    data.srnValuePlusSurcharge = round(srnPlusSurcharge);
    data.plwCostBookingEuro = round(srnPlusSurcharge / conversionRate);
    data.plwCostBookingPercent = round((srnPlusSurcharge / conversionRate) * (capacityUtilized / 100));
    data.srnValueInEuros = round(srnValue / conversionRate);
  } else {
    data.annualRateEuro = 0;
    data.srnValueEuro = 0;
    data.srnValuePlusSurcharge = round(srnValue + surchargeVal);
    data.plwCostBookingEuro = 0;
    data.plwCostBookingPercent = 0;
    data.srnValueInEuros = 0;
  }

  if (data.srnValue !== undefined && data.srnValue !== null) {
    data.gst = round(srnValue * 0.18);
  }
  console.log('[ESP] Computed: annualRateEuro=' + data.annualRateEuro + ', srnValueEuro=' + data.srnValueEuro);
}

function round(v) { return Math.round(v * 100) / 100; }
