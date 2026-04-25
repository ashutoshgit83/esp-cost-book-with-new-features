sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/m/MessageToast"
], function (ControllerExtension, MessageToast) {
    "use strict";
    return ControllerExtension.extend("esp.costbooking.costbookingapp.ext.ObjectPageExt", {
        override: {
            routing: {
                onAfterBinding: function () {
                    // After object page loads, ensure back navigation works
                }
            }
        },
        onBackToList: function () {
            window.history.back();
        }
    });
});
