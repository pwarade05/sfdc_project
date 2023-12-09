import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import verifyMob from '@salesforce/apex/ApplicationRequestAPI.verifyMob';

export default class ApplicationMobileVerify extends LightningElement {
    @api recordId;

    verifyMobHandler() {
        this.dispatchEvent(new CloseActionScreenEvent());
        window.location.reload();
        console.log(this.recordId);

        verifyMob({'appliRecordId' : this.recordId})
            .this(result=>{
                console.log(result);
                this.dispatchEvent(new CloseActionScreenEvent());
               
            })
            .catch(error=>{
                console.log(error);
                this.dispatchEvent(new CloseActionScreenEvent());
            })
    }
}