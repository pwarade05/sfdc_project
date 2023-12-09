trigger PreventDupDocForAppTrigger on Document_Details__c (before insert, before update, after undelete){
    SET<Id> docSetId = new SET<Id>();
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
        for(Document_Details__c objDoc:trigger.new){
            if(trigger.isInsert || trigger.isUpdate){
                docSetId.add(objDoc.Select_Application__c);
            }
            if(trigger.isUpdate){
                if(objDoc.Select_Application__c!=trigger.oldMap.get(objDoc.Id).Select_Application__c){
                    docSetId.add(objDoc.Select_Application__c);
                }
            }
        }
    }
    Map<id,Applicant_Details__c> appDetMap = new Map<Id,Applicant_Details__c>();
    if(!docSetId.isEmpty()){
        for(Applicant_Details__c objAppDet :[select id, Name, (select id, Select_Identity_Proof_Document__c, Select_Application__c from Documents_Details__r) from Applicant_Details__c where ID IN : docSetId]){
            appDetMap.put(objAppDet.id, objAppDet);
        }
    }
    if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
        for(Document_Details__c objDoc:trigger.new){
            if(!appDetMap.isEmpty()){
                if(appDetMap.containsKey(objDoc.Select_Application__c)){
                    List<Document_Details__c> existDocList = appDetMap.get(objDoc.Select_Application__c).Documents_Details__r;
                    for(Document_Details__c objExistDoc : existDocList){
                        if(objDoc.Select_Identity_Proof_Document__c=='Driving Licence' && objDoc.Select_Application__c==objExistDoc.Select_Application__c){
                            objDoc.addError('This '+objDoc.Select_Identity_Proof_Document__c+' record is already exist with the same '+appDetMap.get(objDoc.Select_Application__c).Name+' applicant');
                        }
                    }
                }
            }
        }
    }
}