public class SalesforceConnect {
    
    public static void getCasesFromAnotherOrg(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SFDCB/services/apexrest/Contacts');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            List<Object> results = (List<Object>)JSON.deserializeUntyped(response.getBody());
            for(Object obj : results){
                Map<String, Object> contProps = (Map<String, Object>)obj;
                Map<String, Object> acctProps = (Map<String, Object>)contProps.get('Account');
                System.debug(acctProps.get('Name') + ' - ' + contProps.get('Name'));
            }
        }
    }
    
}