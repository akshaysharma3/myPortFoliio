import { LightningElement, wire, track } from 'lwc';
import getAccountsWithContacts from '@salesforce/apex/LWCDataTableExample.getAccountsWithContacts';
import { NavigationMixin } from 'lightning/navigation';
// datatable columns with row actions. Set sortable = true
const columns = [
    {
        label: 'Account Name', fieldName: 'accountName', sortable: 'true',
        cellAttributes: {
            iconName: 'standard:account',
            iconPosition: 'left',
        },
    },
    {
        label: 'First Name', fieldName: 'contactFirstName', sortable: "true",
    },
    {
        label: 'Last Name', fieldName: 'contactLastName', sortable: "true",
    },
    {
        label: 'Phone', fieldName: 'phone', type: 'phone', sortable: "true",
    },
    {
        label: 'Email', fieldName: 'contactEmail', type: 'email', sortable: "true",
    },
];

export default class AllAccountsData extends NavigationMixin(LightningElement) {

    @track data;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;

    @wire(getAccountsWithContacts)
    accounts(result) {
        if (result.data) {
            let tempData = JSON.parse(JSON.stringify(result.data.accountsList));
            console.log(JSON.stringify(tempData));
            for (let i = 0; i < tempData.length; i++) {
                if (tempData[i].contactList.length > 0) {
                    tempData[i]._children = tempData[i].contactList;
                } else {
                    delete tempData[i]._children;
                }

                delete tempData[i].contactList;
            }
            this.data = tempData;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }

    expandAll() {
        const grid = this.template.querySelector('lightning-tree-grid');
        grid.expandAll();
    }

    collapseAll() {
        const grid = this.template.querySelector('lightning-tree-grid');
        grid.collapseAll();
    }

    // handleRowAction(event) {
    //     const row = event.detail.row;
    //     this[NavigationMixin.Navigate]({
    //         type: 'standard__recordPage',
    //         attributes: {
    //             recordId: row.accId,
    //             actionName: 'view'
    //         }
    //     });
    // }
}