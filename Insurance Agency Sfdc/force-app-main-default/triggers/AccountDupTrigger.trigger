trigger AccountDupTrigger on Account (after insert, after update, after undelete){
    SET<String> accNameSet = new SET<String>();
    SET<String> accWebSet = new SET<String>();
    SET<String> accPhSet = new SET<String>();
    if(trigger.isInsert || trigger.isUpdate ||  trigger.isUndelete){
        for(Account objAcc : trigger.new){
            accNameSet.add(objAcc.Name);
            accWebSet.add(objAcc.Website);
            accPhSet.add(objAcc.Phone);
        }
    }
    Map<String,Account> accNameMap = new Map<String,Account>();
    Map<String,Account> accWebMap =  new Map<String,Account>();
    Map<String,Account> accPhMap = new Map<String,Account>();
    for(Account objAcc : [Select id, Name, Website, Phone from Account where Name IN: accNameSet and Website IN: accWebSet and Phone IN: accPhSet]){
        accNameMap.put(objAcc.Name, objAcc);
        accWebMap.put(objAcc.Website, objAcc);
        accPhMap.put(objAcc.Phone, objAcc);
    }
    if(trigger.isInsert || trigger.isUpdate ||  trigger.isUndelete){
        for(Account objAcc : trigger.new){
            if(accNameMap.containsKey(objAcc.Name)&&accWebMap.containsKey(objAcc.Website)&&accPhMap.containsKey(objAcc.Phone)){
                objAcc.addError(objAcc.Name+' this name is already exists with same website and phone');
            }
        }
    }
}