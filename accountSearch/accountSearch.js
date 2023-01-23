import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ACCOUNTNUMBER_FIELD from '@salesforce/schema/Account.AccountNumber'
import NAME_FIELD from '@salesforce/schema/Account.Name'
import PHONE_FIELD from '@salesforce/schema/Account.Phone'
import SITE_FIELD from '@salesforce/schema/Account.Site'
import BILLINGSTATE_FIELD from '@salesforce/schema/Account.BillingState'

import findAccounts from '@salesforce/apex/AccountController.findAccounts';

const columns = [
    { label: '取引先番号', fieldName: ACCOUNTNUMBER_FIELD.fieldApiName, sortable:true },
    { label: '取引先名', fieldName: 'AccountURL', type:'url', sortable:true,
    typeAttributes: { label: { fieldName: NAME_FIELD.fieldApiName },
    tooltip: { fieldName: NAME_FIELD.fieldApiName } } },
    { label: '電話番号', fieldName: PHONE_FIELD.fieldApiName, sortable:true, type:'phone' },
    { label: '取引先 部門', fieldName: SITE_FIELD.fieldApiName, sortable:true },
    { label: '都道府県', fieldName: BILLINGSTATE_FIELD.fieldApiName, sortable:true }
];

export default class AccountSearch extends LightningElement {
    accounts;
    columns = columns;
    searchKeyName = '';
    searchKeyPhone = '';
    searchKeyAccountNumber = '';
    searchKeySite = '';
    searchKeyBillingState = '';

    sortedBy;
    sortedDirection;

    // 初期処理
    connectedCallback(){
        this.getAccounts();
    }

    // 検索ボタン押下
    searchHandler(){
        this.searchKeyName = this.template.querySelector('[data-id="searchKeyName"]').value;
        this.searchKeyPhone = this.template.querySelector('[data-id="searchKeyPhone"]').value;
        this.searchKeyAccountNumber = this.template.querySelector('[data-id="searchKeyAccountNumber"]').value;
        this.searchKeySite = this.template.querySelector('[data-id="searchKeySite"]').value;
        this.searchKeyBillingState = this.template.querySelector('[data-id="searchKeyBillingState"]').value;
        this.getAccounts();
    }

    // 取引先取得
    getAccounts(){
        findAccounts({searchKeyName:this.searchKeyName, searchKeyPhone:this.searchKeyPhone,
            searchKeyAccountNumber:this.searchKeyAccountNumber,searchKeySite:this.searchKeySite,
            searchKeyBillingState:this.searchKeyBillingState
        })
        .then(result=>{
            this.accounts = this.addNameUrl(result);
        }).catch(error=>{
            console.error(error);
            const toastEvent = new ShowToastEvent({
                title:"エラー",
                variant:"error"
            })
            this.dispatchEvent(toastEvent);
        });
    }

    // Name項目にレコードページへのリンクを設定する
    addNameUrl(data){
        return data.map(_ => {
            let record = JSON.parse(JSON.stringify(_));
            record.AccountURL = '/lightning/r/' + _.Id + '/view';
            console.log(record);
            return record;
        });
    }

    // 列をクリック時
    handleSortData(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;

        // 取引先名の場合はfieldNameが異なるため直接指定
        if(event.detail.fieldName === 'AccountURL'){
            this.sortData(NAME_FIELD.fieldApiName, event.detail.sortDirection);
        }else{
            this.sortData(event.detail.fieldName, event.detail.sortDirection);
        }
    }

    // ソート処理
    sortData(fieldname, direction) {
        let sortingData = JSON.parse(JSON.stringify(this.accounts));
        let keyValue = (a) => {
            return a[fieldname];
        };
        
        let isReverse = direction === 'asc' ? 1 : -1;
        sortingData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.accounts = sortingData;
    }
}