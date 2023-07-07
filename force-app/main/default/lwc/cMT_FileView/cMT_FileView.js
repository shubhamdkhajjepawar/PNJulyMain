import { LightningElement, api } from 'lwc';

import filePreview from "@salesforce/apex/CMT_FileViewLWC.generateFilePreview";

export default class CMT_FileView extends LightningElement {

    @api s3fileId;
    @api fileUrl ='';

    connectedCallback(){
        console.log('calbackfunction--->');

        this.parameters = this.getQueryParameters();
        console.log(this.parameters);
        console.log('-->'+this.parameters.c__s3fileId);
        this.s3fileId = this.parameters.c__s3fileId;
        console.log('--->'+this.s3fileId);
        this.showfilePreview();
    }

    showfilePreview(){
        filePreview({key:this.s3fileId})
        .then((data)=>{
            console.log(data);   
            this.fileUrl = data;          
        }).catch((error)=>{
            console.log(error);
        });   
    }

    downloadFile(){
        window.open(this.fileUrl, '_blank');                 
    }

    refereshPage(){
        this.showfilePreview();
    }

    getQueryParameters() {

        var params = {};
        var search = location.search.substring(1);

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }

}