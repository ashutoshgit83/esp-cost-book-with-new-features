using CostBookingService as service from './service';

// ─── Side Effects ───

// When Rate changes → recalculate Annual Rate and Annual Rate (EUR)
annotate service.CostBookings with @(
  Common.SideEffects #RateChanged: {
    SourceProperties: ['rate'],
    TargetProperties: ['annualRate', 'annualRateEuro']
  }
);

// When Euro Conversion Rate changes → recalculate all EUR fields
annotate service.CostBookings with @(
  Common.SideEffects #EuroRateChanged: {
    SourceProperties: ['euroConversionRate'],
    TargetProperties: [
      'annualRateEuro',
      'srnValueEuro',
      'srnValuePlusSurcharge',
      'plwCostBookingEuro',
      'plwCostBookingPercent',
      'srnValueInEuros'
    ]
  }
);

// When SRN Value changes → recalculate GST, SRN EUR, PLW fields
annotate service.CostBookings with @(
  Common.SideEffects #SrnValueChanged: {
    SourceProperties: ['srnValue'],
    TargetProperties: [
      'gst',
      'srnValueEuro',
      'srnValuePlusSurcharge',
      'plwCostBookingEuro',
      'plwCostBookingPercent',
      'srnValueInEuros'
    ]
  }
);

// When Capacity Utilized changes → recalculate PLW % 
annotate service.CostBookings with @(
  Common.SideEffects #CapacityChanged: {
    SourceProperties: ['capacityUtilized'],
    TargetProperties: ['plwCostBookingPercent']
  }
);

// When Vendor Name changes → refresh Vendor No
annotate service.CostBookings with @(
  Common.SideEffects #VendorChanged: {
    SourceProperties: ['vendorName'],
    TargetProperties: ['vendorNo']
  }
);

// ─── Value Helps ───
annotate service.CostBookings with {
  departmentGroup @(
    Common.ValueListWithFixedValues,
    Common.ValueList: {
      Label         : 'Department',
      CollectionPath: 'Departments',
      Parameters    : [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: departmentGroup, ValueListProperty: 'code' },
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'description' }
      ]
    }
  );

  chapterLead @(
    Common.ValueListWithFixedValues,
    Common.ValueList: {
      Label         : 'Chapter Lead',
      CollectionPath: 'ChapterLeads',
      Parameters    : [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: chapterLead, ValueListProperty: 'code' },
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name' }
      ]
    }
  );

  srnStatus @(
    Common.ValueListWithFixedValues,
    Common.ValueList: {
      Label         : 'SRN Status',
      CollectionPath: 'SrnStatuses',
      Parameters    : [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: srnStatus, ValueListProperty: 'code' },
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'description' }
      ]
    }
  );

  invoiceStatus @(
    Common.ValueListWithFixedValues,
    Common.ValueList: {
      Label         : 'Invoice Status',
      CollectionPath: 'InvoiceStatuses',
      Parameters    : [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: invoiceStatus, ValueListProperty: 'code' },
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'description' }
      ]
    }
  );

  plwCostBookingStatus @(
    Common.ValueListWithFixedValues,
    Common.ValueList: {
      Label         : 'PLW Cost Booking Status',
      CollectionPath: 'PlwCostBookingStatuses',
      Parameters    : [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: plwCostBookingStatus, ValueListProperty: 'code' },
        { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'description' }
      ]
    }
  );

  billingMonth @(
    Common.ValueListWithFixedValues,
    Common.ValueList: {
      Label         : 'Billing Month',
      CollectionPath: 'BillingMonths',
      Parameters    : [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: billingMonth, ValueListProperty: 'code' }
      ]
    }
  );

  vendorName @(
    Common.ValueListWithFixedValues,
    Common.ValueList: {
      Label         : 'Vendor Name',
      CollectionPath: 'Vendors',
      Parameters    : [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: vendorName, ValueListProperty: 'name' },
        { $Type: 'Common.ValueListParameterOut',   LocalDataProperty: vendorNo,   ValueListProperty: 'number' }
      ]
    }
  );

  period @(
    Common.ValueListWithFixedValues,
    Common.ValueList: {
      Label         : 'Period',
      CollectionPath: 'Periods',
      Parameters    : [
        { $Type: 'Common.ValueListParameterInOut', LocalDataProperty: period, ValueListProperty: 'code' }
      ]
    }
  );
};

// ─── Selection Fields (filter bar) ───
annotate service.CostBookings with @(
  UI.SelectionFields: [
    departmentGroup,
    chapterLead,
    espAssociateCostCenter,
    employeeName,
    billingMonth,
    srnStatus,
    plwCostBookingStatus
  ]
);

// ─── Field Labels ───
annotate service.CostBookings with {
  ID                      @title: 'ID';
  billingMonth            @title: 'Billing Month';
  employeeName            @title: 'Employee Name';
  departmentGroup         @title: 'Department Group';
  chapterLead             @title: 'Chapter Lead';
  tafAnchor               @title: 'TAF Anchor';
  employeeNumber          @title: 'Employee Number';
  ntId                    @title: 'NT ID';
  skillsetSowJd           @title: 'Skillset (As per SoW JD)';
  skill                   @title: 'Skill';
  grade                   @title: 'Grade';
  empStatus               @title: 'Emp Status';
  inActiveDate            @title: 'In-Active Date';
  rateMode                @title: 'Rate Mode';
  rate                    @title: 'Rate';
  annualRate              @title: 'Annual Rate (INR)';
  annualRateEuro          @title: 'Annual Rate (EUR)';
  srnId                   @title: 'SRN ID';
  sowJdId                 @title: 'SOW JD ID';
  descriptionSrn          @title: 'Description (As per SRN)';
  skilletSowJdType        @title: 'Skillet SOW JD Type';
  vendorNo                @title: 'Vendor No' @Core.Computed;
  vendorName              @title: 'Vendor Name';
  poNumber                @title: 'PO Number';
  poEndDate               @title: 'PO End Date';
  contractEndDate         @title: 'Contract End Date';
  period                  @title: 'Period';
  billingPeriod           @title: 'Billing Period';
  srnValue                @title: 'SRN Value (INR)';
  srnValueEuro            @title: 'SRN Value (EUR)';
  srnQty                  @title: 'SRN Qty';
  absentDays              @title: 'Absent Days';
  workingDays             @title: 'Working Days';
  workingHours            @title: 'Working Hours';
  gst                     @title: 'GST (18%)';
  srnStatus               @title: 'SRN Status';
  srnApprovedDate         @title: 'SRN Approved Date';
  invoiceNo               @title: 'Invoice No';
  invoiceValue            @title: 'Invoice Value';
  invoiceStatus           @title: 'Invoice Status';
  invoiceApprovedDate     @title: 'Invoice Approved Date';
  surcharge               @title: 'Surcharge (~46K)' @Core.Computed;
  srnValuePlusSurcharge   @title: 'SRN Value + Surcharge (46K)' @Core.Computed;
  euroConversionRate      @title: 'Euro Conversion Rate';
  plwCostBookingEuro      @title: 'PLW Cost Booking (EUR)';
  projectId               @title: 'Project ID';
  phaseId                 @title: 'Phase ID';
  capacityUtilized        @title: 'Capacity Utilized (%)';
  plwCostBookingPercent   @title: 'PLW Cost Booking (As per %)';
  espAssociateCostCenter  @title: 'ESP Associate Cost Center';
  plwCostBookingStatus    @title: 'PLW Cost Booking Status';
  deliveryRemarks         @title: 'Delivery Remarks';
  openPoints              @title: 'Open Points';
  estimateAtCompletion    @title: 'Estimate at Completion (EAC)';
  plwPostingDate          @title: 'PLW Posting Date';
  srnValueInEuros         @title: 'SRN Value (In Euros)';
};

// ─── List Report Columns ───
annotate service.CostBookings with @(
  UI.LineItem: [
    {
      $Type : 'UI.DataFieldForAction',
      Label : 'Copy',
      Action: 'CostBookingService.copyBooking',
      InvocationGrouping: #Isolated
    },
    { Value: billingMonth,            Position: 10 },
    { Value: employeeName,            Position: 20 },
    { Value: departmentGroup,         Position: 30 },
    { Value: chapterLead,             Position: 40 },
    { Value: employeeNumber,          Position: 50 },
    { Value: skill,                   Position: 60 },
    { Value: grade,                   Position: 70 },
    { Value: empStatus,               Position: 80 },
    { Value: annualRate,              Position: 90 },
    { Value: annualRateEuro,          Position: 100 },
    { Value: srnId, Position: 45, ![@UI.Importance]: #High },
    { Value: vendorName,              Position: 120 },
    { Value: poNumber,                Position: 130 },
    { Value: srnValue,                Position: 140 },
    { Value: srnValueEuro,            Position: 150 },
    { Value: srnStatus,               Position: 160 },
    { Value: invoiceNo,               Position: 170 },
    { Value: invoiceValue,            Position: 180 },
    { Value: plwCostBookingEuro,      Position: 190 },
    { Value: projectId,               Position: 200 },
    { Value: plwCostBookingStatus,    Position: 210 },
    { Value: espAssociateCostCenter,  Position: 220 }
  ]
);

// ─── Object Page Header ───
annotate service.CostBookings with @(
  UI.HeaderInfo: {
    TypeName      : 'Cost Booking',
    TypeNamePlural: 'Cost Bookings',
    Title         : { $Type: 'UI.DataField', Value: employeeName },
    Description   : { $Type: 'UI.DataField', Value: srnId }
  },
  UI.HeaderFacets: [
    { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Header' }
  ]
);

annotate service.CostBookings with @(
  UI.FieldGroup #Header: {
    Data: [
      { Value: billingMonth },
      { Value: departmentGroup },
      { Value: chapterLead },
      { Value: plwCostBookingStatus }
    ]
  }
);

// ─── Object Page Facets ───
annotate service.CostBookings with @(
  UI.Facets: [
    {
      $Type : 'UI.CollectionFacet',
      ID    : 'EmployeeInfo',
      Label : 'Employee Information',
      Facets: [
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Employee', Label: 'Employee Details' },
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#SkillInfo', Label: 'Skill & Grade' }
      ]
    },
    {
      $Type : 'UI.CollectionFacet',
      ID    : 'RateInfo',
      Label : 'Rate & Annual Cost',
      Facets: [
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Rate', Label: 'Rate Details' }
      ]
    },
    {
      $Type : 'UI.CollectionFacet',
      ID    : 'SRNInfo',
      Label : 'SRN & SOW Details',
      Facets: [
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#SRN', Label: 'SRN Details' },
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Vendor', Label: 'Vendor & PO' }
      ]
    },
    {
      $Type : 'UI.CollectionFacet',
      ID    : 'BillingInfo',
      Label : 'Billing & Working',
      Facets: [
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Billing', Label: 'Billing Details' },
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Working', Label: 'Working Details' }
      ]
    },
    {
      $Type : 'UI.CollectionFacet',
      ID    : 'InvoiceInfo',
      Label : 'Invoice & Surcharge',
      Facets: [
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Invoice', Label: 'Invoice' },
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Surcharge', Label: 'Surcharge & Euro Conversion' }
      ]
    },
    {
      $Type : 'UI.CollectionFacet',
      ID    : 'PLWInfo',
      Label : 'PLW Cost Booking',
      Facets: [
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#PLW', Label: 'PLW Details' },
        { $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Delivery', Label: 'Delivery & Remarks' }
      ]
    }
  ]
);

// ─── Field Groups ───

annotate service.CostBookings with @(
  UI.FieldGroup #Employee: {
    Data: [
      { Value: employeeName },
      { Value: employeeNumber },
      { Value: ntId },
      { Value: departmentGroup },
      { Value: chapterLead },
      { Value: tafAnchor },
      { Value: empStatus },
      { Value: inActiveDate }
    ]
  },
  UI.FieldGroup #SkillInfo: {
    Data: [
      { Value: skillsetSowJd },
      { Value: skill },
      { Value: grade }
    ]
  },
  UI.FieldGroup #Rate: {
    Data: [
      { Value: rateMode },
      { Value: rate },
      { Value: annualRate },
      { Value: annualRateEuro },
      { Value: euroConversionRate },
      {
        $Type: 'UI.DataFieldWithUrl',
        Label: 'Check EUR to INR Rate',
        Value: 'OANDA Currency Converter',
        Url  : 'https://www.oanda.com/currency-converter/en/?from=EUR&to=INR&amount=1'
      }
    ]
  },
  UI.FieldGroup #SRN: {
    Data: [
      { Value: srnId },
      { Value: sowJdId },
      { Value: descriptionSrn },
      { Value: skilletSowJdType }
    ]
  },
  UI.FieldGroup #Vendor: {
    Data: [
      { Value: vendorNo },
      { Value: vendorName },
      { Value: poNumber },
      { Value: poEndDate },
      { Value: contractEndDate }
    ]
  },
  UI.FieldGroup #Billing: {
    Data: [
      { Value: billingMonth },
      { Value: period },
      { Value: billingPeriod },
      { Value: srnValue },
      { Value: srnValueEuro },
      { Value: srnQty }
    ]
  },
  UI.FieldGroup #Working: {
    Data: [
      { Value: absentDays },
      { Value: workingDays },
      { Value: workingHours },
      { Value: gst }
    ]
  },
  UI.FieldGroup #Invoice: {
    Data: [
      { Value: srnStatus },
      { Value: srnApprovedDate },
      { Value: invoiceNo },
      { Value: invoiceValue },
      { Value: invoiceStatus },
      { Value: invoiceApprovedDate }
    ]
  },
  UI.FieldGroup #Surcharge: {
    Data: [
      { Value: surcharge },
      { Value: srnValuePlusSurcharge },
      { Value: euroConversionRate },
      { Value: plwCostBookingEuro },
      { Value: srnValueInEuros }
    ]
  },
  UI.FieldGroup #PLW: {
    Data: [
      { Value: projectId },
      { Value: phaseId },
      { Value: capacityUtilized },
      { Value: plwCostBookingPercent },
      { Value: espAssociateCostCenter },
      { Value: plwCostBookingStatus },
      { Value: plwPostingDate },
      { Value: estimateAtCompletion }
    ]
  },
  UI.FieldGroup #Delivery: {
    Data: [
      { Value: deliveryRemarks },
      { Value: openPoints }
    ]
  }
);
