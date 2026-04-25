sap.ui.define(["sap/ui/core/mvc/ControllerExtension", "sap/ui/core/routing/HashChanger"], function (ControllerExtension, HashChanger) {
    "use strict";
    return ControllerExtension.extend("esp.costbooking.costbookingapp.ext.ExternalLinkHandler", {
        override: {
            onAfterRendering: function () {
                // Force all external links to open in new tab
                setTimeout(function () {
                    var links = document.querySelectorAll('a[href^="http"]');
                    links.forEach(function (link) {
                        var href = link.getAttribute("href");
                        if (href && !href.includes(window.location.host)) {
                            link.setAttribute("target", "_blank");
                            link.setAttribute("rel", "noopener noreferrer");
                        }
                    });
                }, 2000);
            }
        }
    });
});
