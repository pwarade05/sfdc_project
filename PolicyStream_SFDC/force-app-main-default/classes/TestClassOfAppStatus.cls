@isTest(seeAllData=false)
public class TestClassOfAppStatus{

    @isTest
    public static void testAppBatchMethod(){

        List<Applicant_Details__c> appList = new List<Applicant_Details__c>();
        for(Integer i=1; i<=200; i++){
            Applicant_Details__c objApp = new Applicant_Details__c(First_Name__c='Shankar'+i, Last_Name__c='Pratap'+i, Asset_Products__c= null, Active_Applicant__c = true);
            appList.add(objApp);
        }
        if(!appList.isEmpty()){
            Database.insert(appList, false);
        }
        Test.startTest();
            Database.executeBatch(new BatchClassAppStatus(), 200);
        Test.stopTest();

        List<Applicant_Details__c> actualAppList =[select id, First_Name__c, Last_Name__c, Active_Applicant__c,	Asset_Products__c from Applicant_Details__c where Active_Applicant__c=false];
        System.assertEquals(200, actualAppList.size());
    }
    
}