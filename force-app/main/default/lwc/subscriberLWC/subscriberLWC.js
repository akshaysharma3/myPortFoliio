import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';

export default class SubscriberLWC extends LightningElement {
    message;

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        registerListener('messagesent', this.getMessage, this);
    }

    getMessage = event => {
        this.message = event.detail.value;
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }
}