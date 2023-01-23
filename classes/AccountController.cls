public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> findAccounts(String searchKeyName, String searchKeyPhone,String searchKeyAccountNumber,
    String searchKeySite, String searchKeyBillingState){
        String queryStr = 'SELECT Id, AccountNumber, Name, Phone, Site, BillingState FROM Account';
        String whereQuery = '';
        whereQuery = createwhereQuery(whereQuery, searchKeyName, 'Name');
        whereQuery = createwhereQuery(whereQuery, searchKeyPhone, 'Phone');
        whereQuery = createwhereQuery(whereQuery, searchKeyAccountNumber, 'AccountNumber');
        whereQuery = createwhereQuery(whereQuery, searchKeySite, 'Site');
        whereQuery = createwhereQuery(whereQuery, searchKeyBillingState, 'BillingState');

        if(!String.isBlank(whereQuery)){
            queryStr = queryStr + ' WHERE ' + whereQuery + 'LIMIT 100';
        }

        List<Account> accountList = Database.query(queryStr);
        return accountList;
    }

    private static String createWhereQuery(String prevwhereQuery, String searchStr, String fieldName){
        String whereQuery = '';
        whereQuery = prevwhereQuery;

        if(!String.isBlank(searchStr)){
            if(!String.isBlank(whereQuery)){
                whereQuery += ' AND ';
            }

            whereQuery += '(' + fieldName + 
                            ' LIKE \'%' + String.escapeSingleQuotes(searchStr) + '%\'' + ')';
        }
        return whereQuery;
    }
}