global class AppliStatusBatchClass implements Database.Batchable<SObject>, Database.Stateful{
    SET<String> successIdSet = new SET<String>();
    SET<String> failedIdSet = new SET<String>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, Name, First_Name__c, Last_Name__c, CreatedDate, Active_Applicant__c, Asset_Products__c from Applicant_Details__c where CreatedDate = LAST_MONTH and Active_Applicant__c = true');
    }

    global void execute(Database.BatchableContext BC, List<Applicant_Details__c> appList){
        if(!appList.isEmpty()){
            for(Applicant_Details__c objApp : appList){
                if(String.isBlank(objApp.Asset_Products__c)){
                    objApp.Active_Applicant__c = false;
                }
                Database.SaveResult[] result =  Database.update(appList, false);
                Integer index=0;

                for(Database.SaveResult sr: result){
                    if(sr.isSuccess()){
                        System.debug('Succes = '+appList[index].Name);
                        successIdSet.add(appList[index].Name);
                        index++;
                    }
                    else{
                        System.debug('Failed = '+appList[index].Name);
                        failedIdSet.add(appList[index].Name);
                        index++;
                    }
                    System.debug('Success= '+successIdSet);
                    System.debug('Failed = '+failedIdSet);  
                }
            }
        }
    }
    global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'waradepranav99@gmail.com'});
        mail.setSenderDisplayName('MS Amlin');
        mail.setSubject('Application Status is Updated');
        mail.setPlainTextBody('Success '+successIdSet+'\n Failed= '+failedIdSet);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}
