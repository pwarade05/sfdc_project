public with sharing class ApplicationProvider {

    @AuraEnabled 
    public static List<Applicant_Details__c> searchAppAssRecords(Date startDate, Date endDate){
        System.debug('# Received Dates '+startDate+','+endDate);
        try{
            return [select id, Name, First_Name__c, Last_Name__c, Email_Id__c, Mobile_Number__c, Date_of_Birth__c, CreatedDate from Applicant_Details__c where CreatedDate >=:startDate and CreatedDate <=:endDate];
        }
        catch(Exception e) {
            return null;
        }
    }
}