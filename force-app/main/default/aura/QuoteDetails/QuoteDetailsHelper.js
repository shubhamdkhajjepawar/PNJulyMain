({
	jsQuoteDetails: function (component, event, helper) {
        var action = component.get("c.getQuoteDetails");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.quoteId", result.getReturnValue());
                component.set("v.isOnLoad", true);
            }
        });
        $A.enqueueAction(action);
    },
})