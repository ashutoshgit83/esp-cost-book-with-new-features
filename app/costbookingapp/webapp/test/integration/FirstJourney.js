sap.ui.define([
    "sap/ui/test/opaQunit",
    "./pages/JourneyRunner"
], function (opaTest, runner) {
    "use strict";

    function journey() {
        QUnit.module("First journey");

        opaTest("Start application", function (Given, When, Then) {
            Given.iStartMyApp();

            Then.onTheCostBookingsList.iSeeThisPage();
            Then.onTheCostBookingsList.onFilterBar().iCheckFilterField("Department Group");
            Then.onTheCostBookingsList.onFilterBar().iCheckFilterField("Chapter Lead");
            Then.onTheCostBookingsList.onFilterBar().iCheckFilterField("ESP Associate Cost Center");
            Then.onTheCostBookingsList.onFilterBar().iCheckFilterField("Employee Name");
            Then.onTheCostBookingsList.onFilterBar().iCheckFilterField("Billing Month");
            Then.onTheCostBookingsList.onFilterBar().iCheckFilterField("SRN Status");
            Then.onTheCostBookingsList.onFilterBar().iCheckFilterField("PLW Cost Booking Status");
            Then.onTheCostBookingsList.onTable().iCheckColumns(22, {"billingMonth":{"header":"Billing Month"},"employeeName":{"header":"Employee Name"},"departmentGroup":{"header":"Department Group"},"chapterLead":{"header":"Chapter Lead"},"employeeNumber":{"header":"Employee Number"},"skill":{"header":"Skill"},"grade":{"header":"Grade"},"empStatus":{"header":"Emp Status"},"annualRate":{"header":"Annual Rate (INR)"},"annualRateEuro":{"header":"Annual Rate (EUR)"},"srnId":{"header":"SRN ID"},"vendorName":{"header":"Vendor Name"},"poNumber":{"header":"PO Number"},"srnValue":{"header":"SRN Value (INR)"},"srnValueEuro":{"header":"SRN Value (EUR)"},"srnStatus":{"header":"SRN Status"},"invoiceNo":{"header":"Invoice No"},"invoiceValue":{"header":"Invoice Value"},"plwCostBookingEuro":{"header":"PLW Cost Booking (EUR)"},"projectId":{"header":"Project ID"},"plwCostBookingStatus":{"header":"PLW Cost Booking Status"},"espAssociateCostCenter":{"header":"ESP Associate Cost Center"}});

        });


        opaTest("Navigate to ObjectPage", function (Given, When, Then) {
            // Note: this test will fail if the ListReport page doesn't show any data
            
            When.onTheCostBookingsList.onFilterBar().iExecuteSearch();
            
            Then.onTheCostBookingsList.onTable().iCheckRows();

            When.onTheCostBookingsList.onTable().iPressRow(0);
            Then.onTheCostBookingsObjectPage.iSeeThisPage();

        });

        opaTest("Teardown", function (Given, When, Then) { 
            // Cleanup
            Given.iTearDownMyApp();
        });
    }

    runner.run([journey]);
});