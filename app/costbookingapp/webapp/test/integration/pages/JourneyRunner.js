sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"esp/costbooking/costbookingapp/test/integration/pages/CostBookingsList",
	"esp/costbooking/costbookingapp/test/integration/pages/CostBookingsObjectPage"
], function (JourneyRunner, CostBookingsList, CostBookingsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('esp/costbooking/costbookingapp') + '/test/flp.html#app-preview',
        pages: {
			onTheCostBookingsList: CostBookingsList,
			onTheCostBookingsObjectPage: CostBookingsObjectPage
        },
        async: true
    });

    return runner;
});

