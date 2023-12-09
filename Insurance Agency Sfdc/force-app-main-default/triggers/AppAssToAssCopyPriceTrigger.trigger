trigger AppAssToAssCopyPriceTrigger on Applications_Assets__c (before insert,before update){
    SET<id> assIdSet = new SET<id>();
    if(trigger.isInsert || trigger.isUpdate){
        for(Applications_Assets__c objAppAss : trigger.new){
            if(objAppAss.Select_Assets_Insurance__c!=null){
                assIdSet.add(objAppAss.Select_Assets_Insurance__c);
            }
            if(trigger.isUpdate){
                if(objAppAss.Select_Assets_Insurance__c!=trigger.oldMap.get(objAppAss.Id).Select_Assets_Insurance__c){
                    assIdSet.add(objAppAss.Select_Assets_Insurance__c);
                }
            }
        }
    }
    Map<id,Asset> assMap = new Map<id,Asset>();
    if(!assIdSet.isEmpty()){
        for(Asset objAss :[select id, Name, Price from Asset where ID IN : assIdSet]){
            assMap.put(objAss.id, objAss);
        }
    }
    if(trigger.isInsert || trigger.isUpdate){
        for(Applications_Assets__c objAppAss : trigger.new){
            if(!assMap.isEmpty()){
                if(assMap.containsKey(objAppAss.Select_Assets_Insurance__c)){
                    objAppAss.Price__c = assMap.get(objAppAss.Select_Assets_Insurance__c).Price;
                }
            }
        }
    }
}