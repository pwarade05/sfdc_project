public with sharing class ApplicationRequestAPI {

    @AuraEnabled
    public static void verifyMob(ID appliRecordId){
        System.debug('Recevied Application Id '+appliRecordId);

        String mobileNumber = [select id, Mobile_Number__c from Applicant_Details__c where ID =: appliRecordId].Mobile_Number__c;

        if(String.isNotBlank(mobileNumber)){
            System.debug('mobile '+mobileNumber);

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.veriphone.io/v2/verify?phone='+mobileNumber+'&key=C2A393963D9B49B28791AEDAD8001B68');
            request.setMethod('GET');

            HttpResponse response = http.send(request);
                System.debug('%%Status_Code = '+response.getStatusCode());
            
                if(response.getStatusCode() == 200){
                    System.debug('@@received body = '+response.getBody());

                    ApplicationRequestAPIWrapper objWrap = (ApplicationRequestAPIWrapper) JSON.deserialize(response.getBody(), ApplicationRequestAPIWrapper.class);

                    Applicant_Details__c objAppl = new Applicant_Details__c(Id=appliRecordId);

                        if(objWrap.phone_valid){
                            objAppl.Mobile_Number_Status__c = true;
                        }
                        else{
                            objAppl.Mobile_Number_Status__c = false;
                        }
                        
                        update objAppl;
                    }
                }
            }
            
            public class ApplicationRequestAPIWrapper{
                public Boolean phone_valid;
            }
        }