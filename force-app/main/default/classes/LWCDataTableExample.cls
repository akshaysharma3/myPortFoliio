/**
 * @description       : 
 * @author            : Akshay Sharma
 * @group             : 
 * @last modified on  : 10-27-2021
 * @last modified by  : Akshay Sharma
**/
public with sharing class LWCDataTableExample {
    @AuraEnabled(cacheable=true)
    public static ResultWrapper getAccountsWithContacts(){
        try {
            ResultWrapper wrapper = new ResultWrapper();
            wrapper.accountsList = new List<TreeData>();
            for(Account acc : [SELECT Id, Name, Phone, 
                               (SELECT Id, FirstName, LastName, Phone, Email FROM Contacts) 
                                FROM Account]){
                                    TreeData accData = new TreeData(acc);
                                    for(Contact con : acc.Contacts){
                                        TreeData conData = new TreeData(con);
                                        conData.accountName = accData.accountName;
                                        conData.accId = accData.accId;
                                        accData.addContactToTree(conData);
                                    }
                                    wrapper.accountsList.add(accData);
                                }
            System.debug(wrapper.accountsList);
            if(!wrapper.accountsList.isEmpty()){
                return wrapper;
            }

            return null;                   
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class ResultWrapper{
        @AuraEnabled public List<TreeData> accountsList;
    }
    public class TreeData{
        @AuraEnabled public Id accId;
        @AuraEnabled public String accountName;
        @AuraEnabled public String contactId;
        @AuraEnabled public String contactFirstName;
        @AuraEnabled public String contactLastName;
        @AuraEnabled public String phone;
        @AuraEnabled public String contactEmail;
        @AuraEnabled public List<TreeData> contactList;
        
        public TreeData(Account acc){
            this.accId = acc.Id;
            this.accountName = acc.Name;
            this.phone = acc.Phone;
            this.contactList = new List<TreeData>();
        }

        public TreeData(Contact con){
            this.contactId = con.Id;
            this.contactEmail = con.Email;
            this.contactFirstName = con.FirstName;
            this.contactLastName = con.LastName;
            this.phone = con.Phone;
        }

        public void addContactToTree(TreeData con){
            this.contactList.add(con);
        }
    }
}