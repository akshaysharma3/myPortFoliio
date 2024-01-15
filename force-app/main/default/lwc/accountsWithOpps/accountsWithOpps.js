import { LightningElement, api, track, wire } from 'lwc';
import getOpportunities from '@salesforce/apex/AccountOpportunitiesController.getOpportunities';

export default class AccountsWithOpps extends LightningElement {
    @api recordId;
    @track opportunities = [
        id = 0
    ];



    @wire(getOpportunities, { accId: '$recordId' })
    wiredOpps({ data, error }) {
        if (data) {

            console.log('Data ::>> ' + JSON.stringify(data));
            this.opportunities = data;
            this.error = undefined;
        }
    }
}