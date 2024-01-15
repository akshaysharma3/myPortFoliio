({
	doInit : function(component, event, helper) {
        //helper.callServerSideMethod(component, event, 'getCurrencyExchangeRates');
		
	},
    
    handleClick : function(component, event, helper) {
        helper.callServerSideMethod(component, event, 'getCurrencyExchangeRates');
    }
})