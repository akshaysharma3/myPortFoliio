import { LightningElement } from 'lwc';
import currencyExchange from '@salesforce/apex/CurrencyExchangeController.getCurrencyExchangeRates';
export default class CurrencyExchangeLwc extends LightningElement {

    value = "USD";
    get options() {
        return [
            { label: 'Indian Rupee', value: 'INR' },
            { label: 'US Dollars', value: 'USD' },
        ];
    }

    exchangeData;

    handleChange(event) {
        console.log(event.detail.value);
        this.value = event.detail.value;
    }

    connectedCallback() {
        currencyExchange({ fromSymbol: this.value })
            .then(result => {
                this.exchangeData = result;
                console.log('exchange result : > ' + JSON.stringify(result));
                console.log('exchange data : > ' + JSON.stringify(this.exchangeData));
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleClick() {
        console.log('In Handle CLick');
        this.connectedCallback();

    }

}