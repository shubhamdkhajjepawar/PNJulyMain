import { api,LightningElement } from 'lwc';
import getTaskFileData from "@salesforce/apex/CMT_TaskListLWC.getTaskFileData";
import Name from '@salesforce/schema/Account.Name';

const columns = [
    { label: 'File Name', fieldName: 'Id', type:'url', typeAttributes : {target:'_blank', label:{fieldName:'File_Name__c'}} },
    { label: 'CreatedDate', fieldName: 'CreatedDate', type: 'date' },
    { label: 'File Preview', fieldName: 'External_ID__c', type:'url', typeAttributes : {target:'_blank', label:'Preview'} }
];

export default class Cmt_TaskList extends LightningElement {
    @api recordId
    data = [];
    columns = columns;

    async connectedCallback() {
        this.getData();
    }

    getData() {
        getTaskFileData({recordId:this.recordId})
        .then((data)=>{
            console.log(data);
            data.forEach(function (row) {
                row['Id'] = '/'+row['Id'];
                row['External_ID__c'] = '/lightning/n/CMT_DocumentView?c__s3fileId='+row['External_ID__c'];
              });   
            this.data = data;          
        }).catch((error)=>{
            console.log(error);
        });  
    }
}