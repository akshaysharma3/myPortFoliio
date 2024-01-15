import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import sendMessage from '@salesforce/apex/WhatsAppMessageService.sendMessage';


export default class WhatsAppMessageSenderLWC extends LightningElement {
    mobileNo;
    message;
    @wire(CurrentPageReference) pageRef;

    updateMobileNumber(event) {
        this.mobileNo = event.target.value;
        console.log('Mobile Entered : ' + this.mobileNo);
    }

    updateMessage(event) {
        this.message = event.target.value;
        console.log('Message Entered : ' + this.message);
        const messagesent = new CustomEvent("messagesent", {
            detail: {
                value: this.message
            }
        });
        fireEvent(this.pageRef, 'messagesent', messagesent);

    }



    sendWhatsappMessage() {
        if (this.message && this.mobileNo) {
            sendMessage({ 'mobileno': this.mobileNo, 'message': this.message })
                .then(result => {
                    if (result) {
                        console.log('Result ::>> ' + result);
                        this.mobileNo = '';
                        this.message = '';
                        this.showToast('Success!', 'WhatsApp Message Sent', 'success');
                    } else {
                        console.log('Result ::>> ' + result);
                        this.mobileNo = '';
                        this.message = '';
                        this.showToast('Something has gone wrong!', 'Unfortunately, there was a problem while sending WhatsApp Message', 'error');
                    }
                }).catch(error => {
                    this.error = error;
                    this.mobileNo = '';
                    this.message = '';
                    this.showToast('Something has gone wrong!', 'Unfortunately, there was a problem while sending WhatsApp Message', 'error');
                });
        } else {
            this.showToast('Data Missing!', 'Please enter mobile number and message to send', 'error');
        }
    }


    showToast(title, msg, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: msg,
            variant: variant,
        });
        this.dispatchEvent(event);
    }


}