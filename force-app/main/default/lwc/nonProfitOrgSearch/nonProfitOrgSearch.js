import { LightningElement,api } from 'lwc';
import getNonProfits from '@salesforce/apex/SearchNonProfitOrgController.searchNonprofitOrg';
import {createRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NON_PROFIT_OBJECT from '@salesforce/schema/Non_profit_Organization__c';
import NAME_FIELD from '@salesforce/schema/Non_profit_Organization__c.Name';
import ACC_FIELD from '@salesforce/schema/Non_profit_Organization__c.Account__c';
import ORG_IDFIELD from '@salesforce/schema/Non_profit_Organization__c.Org_Id__c';
import LOOKUP_RECID from '@salesforce/schema/Non_profit_Organization__c.Parent_Record_Id__c'; // Use this field and make this component work on all object. wtrite trigger to update correct lookup field based on id keyprefix.

export default class NonProfitOrgSearch extends LightningElement {
    @api recordId;
    orgList = [];
    handleSearchKeyUp(event) {
        let key = event.target.value;
        getNonProfits({ 'searchKey': key })
            .then(result => {
                if (result.code === 200) {
                    this.orgList = result.data.hits;
                }
                console.log('response>>>>>>>>>>', result.data.hits);
                // data.hits[0]
            }).catch(error => {
                console.error('response>>>error>>>>>>>', error);
            })
    }
    handleSelectOrg(event) {
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = event.target.dataset.orgname;
        fields[ACC_FIELD.fieldApiName] = this.recordId;
        fields[ORG_IDFIELD.fieldApiName] = event.target.dataset.orgid;
        fields[LOOKUP_RECID.fieldApiName] = this.recordId;

        const recordInput = {
            apiName: NON_PROFIT_OBJECT.objectApiName,
            fields
        };
        createRecord(recordInput).then(account => {
            const event = new ShowToastEvent({
                title: 'Non Profit',
                message: 'Non Profit record created!!',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            // TODO : REfresh page need to use AURA Component

        }).catch(error => {

            this.error = error;
        });
    }
}