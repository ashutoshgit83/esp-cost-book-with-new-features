namespace esp.costbooking;

using { cuid, managed } from '@sap/cds/common';

// ─── Code Lists ───

entity Departments : cuid {
  code        : String(20);
  description : String(100);
}

entity ChapterLeads : cuid {
  code : String(50);
  name : String(100);
}

entity EmpStatuses : cuid {
  code        : String(20);
  description : String(100);
}

entity RateModes : cuid {
  code        : String(20);
  description : String(100);
}

entity SrnStatuses : cuid {
  code        : String(20);
  description : String(100);
}

entity InvoiceStatuses : cuid {
  code        : String(20);
  description : String(100);
}

entity PlwCostBookingStatuses : cuid {
  code        : String(20);
  description : String(100);
}

entity BillingMonths : cuid {
  code        : String(20);
  description : String(20);
}

entity Periods : cuid {
  code        : String(5);
  description : String(20);
}

entity Vendors : cuid {
  name   : String(100);
  number : String(20);
}

// ─── Main Entity ───

entity CostBookings : cuid, managed {
  billingMonth            : String(20);
  employeeName            : String(150);
  departmentGroup         : String(20);   // BD/PTD-TAF3 .. TAF12
  chapterLead             : String(50);   // Ashutosh, Gobi, Damo, Balaji, Jyothsna, Sasi
  tafAnchor               : String(100);
  employeeNumber          : String(20);
  ntId                    : String(50);
  skillsetSowJd           : String(200);  // Skillset (As per SoW JD)
  skill                   : String(100);
  grade                   : String(20);
  empStatus               : String(20);
  inActiveDate            : Date;
  rateMode                : String(20);
  rate                    : Decimal(15,2);
  annualRate              : Decimal(15,2);
  annualRateEuro          : Decimal(15,2); // computed: annualRate / euroConversionRate
  srnId                   : String(50);
  sowJdId                 : String(50);
  descriptionSrn          : String(500);  // Description (As per SRN)
  skilletSowJdType        : String(100);
  vendorNo                : String(20);
  vendorName              : String(150);
  poNumber                : String(30);
  poEndDate               : Date;
  contractEndDate         : Date;
  period                  : String(20);
  billingPeriod           : String(20);
  srnValue                : Decimal(15,2);
  srnValueEuro            : Decimal(15,2); // computed: srnValue / euroConversionRate
  srnQty                  : Integer;
  absentDays              : Integer;
  workingDays             : Integer;
  workingHours            : Decimal(10,2);
  gst                     : Decimal(15,2); // GST 18%
  srnStatus               : String(20) default 'In Progress';
  srnApprovedDate         : Date;
  invoiceNo               : String(50);
  invoiceValue            : Decimal(15,2);
  invoiceStatus           : String(20) default 'In Progress';
  invoiceApprovedDate     : Date;
  surcharge               : Decimal(15,2) default 46000; // Fixed 46K
  srnValuePlusSurcharge   : Decimal(15,2); // computed: srnValue + surcharge
  euroConversionRate      : Decimal(10,4); // 1 EUR = X INR
  plwCostBookingEuro      : Decimal(15,2); // computed: (srnValue + surcharge) / euroConversionRate
  projectId               : String(50);
  phaseId                 : String(50);
  capacityUtilized        : Decimal(5,2);  // percentage
  plwCostBookingPercent   : Decimal(15,2); // computed: plwCostBookingEuro * capacityUtilized / 100
  espAssociateCostCenter  : String(100);
  plwCostBookingStatus    : String(20) default 'In Progress';
  deliveryRemarks         : String(500);
  openPoints              : String(500);
  estimateAtCompletion    : Decimal(15,2); // EAC
  plwPostingDate          : Date;
  srnValueInEuros         : Decimal(15,2); // SRN Value (In Euros) - final
}
