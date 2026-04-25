using { esp.costbooking as db } from '../db/schema';
using from './annotations';

service CostBookingService @(
  path    : '/odata/v4/cost-booking',
  requires: 'authenticated-user'
) {

  @odata.draft.enabled
  @(restrict: [
    { grant: '*', to: 'Admin' },
    { grant: ['READ','CREATE','UPDATE','DELETE'], to: 'ChapterLeadUser',
      where: 'chapterLead = $user.chapterLead' }
  ])
  entity CostBookings as projection on db.CostBookings
    actions {
      @(Common.SideEffects.TargetEntities: ['/CostBookingService.EntityContainer/CostBookings'])
      action copyBooking() returns CostBookings;
    };

  // Value help entities (read-only)
  @readonly entity Departments              as projection on db.Departments;
  @readonly entity ChapterLeads             as projection on db.ChapterLeads;
  @readonly entity SrnStatuses              as projection on db.SrnStatuses;
  @readonly entity InvoiceStatuses          as projection on db.InvoiceStatuses;
  @readonly entity PlwCostBookingStatuses   as projection on db.PlwCostBookingStatuses;
  @readonly entity BillingMonths            as projection on db.BillingMonths;
  @readonly entity Periods                  as projection on db.Periods;
  @readonly entity Vendors                  as projection on db.Vendors;
}
