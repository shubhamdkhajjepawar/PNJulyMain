import { LightningElement, track } from 'lwc';
import getAttachmentData from "@salesforce/apex/CMT_AWSUploaderLWC.getAttachmentData";
import getUploadConfiguration from "@salesforce/apex/CMT_AWSUploaderLWC.getUploadConfiguration";
import createAWSLinkRecord from "@salesforce/apex/CMT_AWSUploaderLWC.createLogicalLink";
import uploadFile from "@salesforce/apex/CMT_AWSUploaderLWC.uploadFile";

import { loadStyle, loadScript } from "lightning/platformResourceLoader";
import awsJS from "@salesforce/resourceUrl/awsJS";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class Cmt_AWSUploader extends LightningElement {
    @track uploadInfo
    @track hideUploadedFiles
    AWS;
    s3;

    @track fileName; //to display the selected file name
    fileType; //holding file type
    selectedFilesToUpload = []; //store selected files
    fileReaderObj;
    base64FileData;
    myFile;

    connectedCallback() {
        this.getUploadInfo();
    }

    getUploadInfo() {
        this.hideUploadedFiles = true;
        loadScript(this, awsJS).then(() => {
            /* callback */
            this.getAWSConfig();
            console.log('--> Loaded '+this);
        });
        getAttachmentData().then((data)=>{
            this.uploadInfo = data;
        }).catch((error)=>{
            console.log(error);
        });  
    }

    uploadFileSFDC() {
      uploadFile({attachmentId:'00P0p000001wIw2EAE'}).then((data)=>{
          console.log('Upload: '+data);         
      }).catch((error)=>{
          console.log(error);
      });  
    }

    getAWSConfig() {
        getUploadConfiguration().then((data)=>{
            console.log('Config: '+JSON.stringify(data));   
            this.AWS = window.AWS;
            this.AWS.config.update({
                accessKeyId: data["key"],
                secretAccessKey: data["secret"]
            });
            console.log('Config here: '+JSON.stringify(data));   
            this.AWS.config.region = data["region"];
            console.log('Config here 2: '+JSON.stringify(data));   
            this.s3 = new AWS.S3({
                apiVersion: "2006-03-01",
                params: {
                  Bucket: data["bucket"]//Assigning S3 bucket name
                }
            });
            console.log('Config here 3: '+JSON.stringify(data));     
        }).catch((error)=>{
            console.log(error);
        });  
    }

    uploadFiles(path, ctype, body, attId) {
        //starting file upload
        this.s3.putObject(
          {
            Key: path,
            ContentType: ctype,
            Body: body,
            ACL: "public-read"
          },
          (err) => {
            if (err) {
              console.error(err);
            } else {
              console.log("Success "+JSON.stringify(attId));
              createAWSLinkRecord({attRecordId:attId,taskRecordId:null,fileUrl:path})
              .then(result => {
                console.log('Success AWS Link '+result);
                this.uploadInfo.forEach(function(data) {
                  if(data.attRecord.Id == attId)
                  {
                    console.log(' Target data: '+data.attRecord.id);
                    data.status = 'Uploaded';
                  }
                });
              })
              .catch(error => {
                console.log('Error AWS Link '+JSON.stringify(error));
                this.uploadInfo.forEach(function(data) {
                  if(data.attRecord.Id == attId)
                  {
                    console.log(' Target data: '+data.attRecord.id);
                    data.status = JSON.stringify('Upload Failed:\n'+error);
                  }
                });
              });
            }
          }
        );
    }


    downloadFile(fileName, blob) {
        //Check the Browser type and download the File.
        var isIE = false || !!document.documentMode;
        if (isIE) {
            window.navigator.msSaveBlob(blob, fileName);
        } else {
            var binaryData = [];
            binaryData.push(blob);
            var url = window.URL || window.webkitURL;
            link = url.createObjectURL(new Blob(binaryData, {type: "application/zip"}));
            console.log('--- '+link);
            var a = document.createElement("a");
            a.setAttribute("download", fileName);
            a.setAttribute("href", link);
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }
    }

    getFileToDownload(fileName, blob) {
      let xhr = new XMLHttpRequest();
      xhr.open("GET", "https://printninjauat--uat.lightning.force.com/servlet/servlet.FileDownload?file=00P0p000001wIw2EAE&operationContext=S1");
      xhr.onload = function() {
        this.downloadFile('Sample.pdf', xhr.response)
      };
      xhr.send(null);
    }

    // get the file name from the user's selection
    handleSelectedFiles(event) {
        if (event.target.files.length > 0) {
          console.log(' Target: '+event.target.id.split('-')[0]);

          this.uploadInfo.forEach(function(data) {
              if(data.attRecord.Id == event.target.id.split('-')[0])
              {
                console.log(' Target data: '+data.attRecord.id);
                data.fileObj = event.target.files[0];
                data.fileName = event.target.files[0].name;
                data.fileType = event.target.files[0].type;
              }
          });
          this.selectedFilesToUpload = event.target.files;
          console.log(' Target END: '+event.target.id);
        }
    }

    //parsing the file and prepare for upload.
  handleFileUpload(event){
    if(this.selectedFilesToUpload.length > 0) {
      
      let fn,ft,fo, attId;
      let proceed = false;
      console.log(' Target Upload: '+event.target.id.split('-')[0]);
      this.uploadInfo.forEach(function(data) {
          console.log(' Target Upload ID: '+JSON.stringify(data));
          if(data.attRecord.Id == event.target.id.split('-')[0])
          {
            console.log(' Uploading Start: '+data.fileURL); 
            fn = data.fileURL;
            ft = data.fileType;
            fo = data.fileObj;
            attId = data.attRecord.Id;
            console.log(' Uploading END: '+data.attRecord); 
            proceed = true;
          }
      })
      if(proceed === true) {
        this.uploadFiles(fn,ft,fo,attId);
        console.log(' Uploading Sent: '+fn); 
      }
    }
    else {
        this.fileName = 'Please select a file to upload!';
    }
  }

  showHideUploadFiles()
  {
    console.log(' Toggle'+this.hideUploadedFiles);
    this.hideUploadedFiles = !this.hideUploadedFiles;

    let fileShow = this.hideUploadedFiles;
    this.uploadInfo.forEach(function(data) {
      if(fileShow == false) {
        data.hideRow = false;
      } else {
        data.hideRow = data.isFilePresent == true;
      }
    })

  }
}