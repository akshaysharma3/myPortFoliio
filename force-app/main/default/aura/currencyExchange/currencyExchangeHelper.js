({
	callServerSideMethod : function(component, event, methodName) {
        console.log('In Helper Methid');
		var method = "c."+methodName;
        var action = component.get(method);
        action.setParams({
            fromSymbol : component.find('selectFrom').get('v.value'),
            toSymbol : component.find('selectTo').get('v.value')
        });
        action.setCallback(this, function(response){
            console.log('In setCallback Method');
            if(response.getState() === "SUCCESS"){
                //console.log(response.getReturnValue());
                //component.set('v.exchnageData', response.getReturnValue());
                //console.log(typeof(response.getReturnValue()));
                //console.log('set data'+component.get('v.exchnageData'));
                var data = [];
                var resp = response.getReturnValue();
                for(var key in resp){
                    console.log(key);
                    console.log(resp[key]);
                    data.push({key:key, value:resp[key]});
                    console.log(data);
                    console.log(JSON.Stringify(data));
                }
                component.set('v.exchnageData', data);
            }
            
        });
        $A.enqueueAction(action);
	}
})