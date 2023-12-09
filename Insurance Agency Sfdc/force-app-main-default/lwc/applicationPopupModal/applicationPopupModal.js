import { LightningElement, track } from 'lwc';
import searchAppAssRecords from '@salesforce/apex/ApplicationProvider.searchAppAssRecords';

export default class ApplicationPopupModal extends LightningElement {

    objApp = { 'sObjectType': 'Applicant_Details__c' };
    appList;
    start_date;
    end_date;
   
    showAppFlag = false;
    @track start_date;
    @track end_date;

    draftValues = [];

    startDateHandler(event) {
        console.log(event.target.value);
        this.start_date = event.target.value;
    }

    endDateHandler(event) {
        console.log(event.target.value);
        this.end_date = event.target.value;
    }

    appColumns = [
        { label: 'Application ID', fieldName: 'Name', editable: true },
        { label: 'First Name', fieldName: 'First_Name__c', editable: true },
        { label: 'Last Name', fieldName: 'Last_Name__c', editable: true },
        { label: 'Email Id', fieldName: 'Email_Id__c', editable: true },
        { label: 'DOB', fieldName: 'Date_of_Birth__c', editable: true },
        { label: 'Created Date', fieldName: 'CreatedDate', editable: true },
        { label: 'Mobile Number', fieldName: 'Mobile_Number__c', editable: true },
    ];

    closeButtonHandler(){
        this.showAppFlag = false;
    }

    buttonHandler() {
        searchAppAssRecords({ 'startDate': this.start_date , 'endDate' :  this.end_date })
            .then(result => {
                console.log(result);
                console.log(this.appList);
                this.appList = result;
                this.showAppFlag = true;
            })
            .catch(error => {
                console.log(error);
                this.showAppFlag = false;
            })
    }
}