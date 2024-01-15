import { LightningElement, api, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/AccountOpportunitiesController.getOpportunities';

export default class AccountOpportunities extends LightningElement {
    @api recordId;
    @track opportunities;

    @wire(getOpportunities, { accId: '$recordId' })
    wiredOpps({ data, error }) {
        if (data) {
            this.opportunities = data;
            this.error = undefined;
        }
    }
    // connectedCallback() {
    //     getOpportunities({ accId: '$recordId' })
    //         .then((result) => {
    //             console.log('Data ' + JSON.stringify(result));
    //             this.Opportunities = result;
    //         }).then((error) => {
    //             console.log('Error : ' + JSON.stringify(error));
    //         });
    // }

}