import { LightningElement } from 'lwc';

export default class LwcCalloutExample extends LightningElement {
    receivedMessage;
    hasRendered = false;

    getTheJoke() {
        const calloutURI = 'https://icanhazdadjoke.com';
        // requires whitelisting of calloutURI in CSP Trusted Sites
        fetch(calloutURI, {
            method: "GET",
            headers: {
                "Accept": "application/json"
            }
        }).then(
            (response) => {
                if (response.ok) {
                    return response.json();
                }
            }
        ).then(responseJSON => {
            this.receivedMessage = responseJSON.joke;
            console.log(this.receivedMessage);
        });
    }

    renderedCallback() {
        if (this.hasRendered == false) {
            this.getTheJoke();
            this.hasRendered = true;
        }
    }
}