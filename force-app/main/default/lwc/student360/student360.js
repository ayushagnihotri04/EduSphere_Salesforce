import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

export default class Student360 extends LightningElement {
    @api recordId;
    contact;
    contactName;
    contactEmail;
    contactPhone;
    error;

    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD] })
    wiredContact({ error, data }) {
        if (data) {
            this.contact = data;
            this.contactName = getFieldValue(data, NAME_FIELD);
            this.contactEmail = getFieldValue(data, EMAIL_FIELD);
            this.contactPhone = getFieldValue(data, PHONE_FIELD);
            this.error = undefined;
        } else if (error) {
            this.contact = undefined;
            this.error = error;
        }
    }
}
