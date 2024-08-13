trigger DuplicateContactAccTrigger on Contact (before insert, before update, after undelete){
    SET<ID> accIdSet = new SET<ID>();
    if( (trigger.isInsert || trigger.isUpdate || trigger.isUndelete) ){
        for(Contact objCon : trigger.new){
            if(trigger.isInsert || trigger.isUndelete){
                accIdSet.add(objCon.AccountId);
            }
            if(trigger.isUpdate){
                if(objCon.AccountId != trigger.oldMap.get(objCon.Id).AccountId){
                    accIdSet.add(objCon.AccountId);
                }
            }
        }
    }
    Map<Id,Account> accMap = new Map<Id, Account>();
    if(!accIdSet.isEmpty()){
        for(Account objAcc : [select Id, Name, (select Id, Name, Email, AccountId from Contacts) from Account where ID IN : accIdSet]){
            accMap.put(objAcc.Id,objAcc);
        }
    }
    if( (trigger.isInsert || trigger.isUpdate || trigger.isUndelete) ){
        for(Contact objCon : trigger.new){ 
            if(accMap.containsKey(objCon.AccountId)){
                List<Contact> ExistConList = accMap.get(objCon.AccountId).Contacts;
                for(Contact objExistingCon : ExistConList){
                    if(objCon.Email == objExistingCon.Email && objCon.AccountId == objExistingCon.AccountId){
                        objCon.addError('This Email Id '+objCon.Email+' and same accountId '+accMap.get(objCon.AccountId).Name+' is already exists');
                        break;
                    }
                }
            } 
        }
    }
}