global class BatchClassAppStatus implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, First_Name__c, Last_Name__c,Asset_Products__c, Active_Applicant__c from Applicant_Details__c where Active_Applicant__c = true');
    }
    global void execute(Database.BatchableContext BC, List<Applicant_Details__c> appList){
        if(!appList.isEmpty()){
            for(Applicant_Details__c objApp : appList){
                if(String.isBlank(objApp.Asset_Products__c)){
                    objApp.Active_Applicant__c = false;
                }
            }
            Database.update(appList, false);
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}