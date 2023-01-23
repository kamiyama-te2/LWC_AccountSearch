@isTest
private class AccountControllerTest {    
    @testSetup
    static void setup(){
        List<Account> testAccts = new List<Account>();
        for (Integer i=0; i<100; i++) {
            testAccts.add(new Account(
            Name = 'TestAccount' + String.valueOf(i).leftPad(4, '0'),
            Phone ='090-1111-' + String.valueOf(i).leftPad(4, '0'),
            AccountNumber = 'A' + String.valueOf(i).leftPad(4, '0'),
            Site = '部門 ' + String.valueOf(i).leftPad(4, '0'),
            BillingState = '都道府県 ' + String.valueOf(i).leftPad(4, '0')
            ));
        }
        insert testAccts;
    }
    
    // 複数取引先検索
    @IsTest
    static void testAccounts(){
        List<Account> expectAccts = new List<Account>();
        for (Integer i=0; i<100; i++) {
            expectAccts.add(new Account(
            Name = 'TestAccount' + String.valueOf(i).leftPad(4, '0'),
            Phone ='090-1111-' + String.valueOf(i).leftPad(4, '0'),
            AccountNumber = 'A' + String.valueOf(i).leftPad(4, '0'),
            Site = '部門 ' + String.valueOf(i).leftPad(4, '0'),
            BillingState = '都道府県 ' + String.valueOf(i).leftPad(4, '0')
            ));
        }
        Test.startTest();
        List<Account> actualAccts = AccountController.findAccounts('TestAccount', '090-1111-', 'A', '部門 ', '都道府県 ');
        Test.stopTest();

        for (Integer i=0; i<expectAccts.size(); i++) {
			assertAccount(expectAccts[i], actualAccts[i]);
        }
    }
    
    // 検索値取引先名のみ
    @IsTest
    static void testSearchName(){
        Account expectAcct = new Account(
            Name = 'TestAccount0099',
            Phone ='090-1111-0099',
            AccountNumber = 'A0099',
            Site = '部門 0099',
            BillingState = '都道府県 0099');
        
        Test.startTest();
        List<Account> actualAcct = AccountController.findAccounts(expectAcct.Name, '', '', '', '');
        Test.stopTest();

        assertAccount(expectAcct, actualAcct[0]);
    }
    
    // 検索値電話番号のみ
    @IsTest
    static void testSearchPhone(){
        Account expectAcct = new Account(
            Name = 'TestAccount0088',
            Phone ='090-1111-0088',
            AccountNumber = 'A0088',
            Site = '部門 0088',
            BillingState = '都道府県 0088');
        
        Test.startTest();
        List<Account> actualAcct = AccountController.findAccounts('', expectAcct.Phone, '', '', '');
        Test.stopTest();

        assertAccount(expectAcct, actualAcct[0]);
    }
    
    // 検索値取引先番号のみ
    @IsTest
    static void testSearchAccountNumber(){
        Account expectAcct = new Account(
            Name = 'TestAccount0077',
            Phone ='090-1111-0077',
            AccountNumber = 'A0077',
            Site = '部門 0077',
            BillingState = '都道府県 0077');
        
        Test.startTest();
        List<Account> actualAcct = AccountController.findAccounts('', '', expectAcct.AccountNumber, '', '');
        Test.stopTest();

		assertAccount(expectAcct, actualAcct[0]);
    }
    
    // 検索値部門のみ
    @IsTest
    static void testSearchSite(){
        Account expectAcct = new Account(
            Name = 'TestAccount0066',
            Phone ='090-1111-0066',
            AccountNumber = 'A0066',
            Site = '部門 0066',
            BillingState = '都道府県 0066');
        
        Test.startTest();
        List<Account> actualAcct = AccountController.findAccounts('', '', '', expectAcct.Site, '');
        Test.stopTest();

		assertAccount(expectAcct, actualAcct[0]);
    }
    
    // 検索値都道府県のみ
    @IsTest
    static void testSearchBillingState(){
        Account expectAcct = new Account(
            Name = 'TestAccount0055',
            Phone ='090-1111-0055',
            AccountNumber = 'A0055',
            Site = '部門 0055',
            BillingState = '都道府県 0055');
        
        Test.startTest();
        List<Account> actualAcct = AccountController.findAccounts('', '', '', '', expectAcct.BillingState);
        Test.stopTest();

		assertAccount(expectAcct, actualAcct[0]);
    }
    
    // 想定結果と実行結果の比較
    private static void assertAccount(Account expectAcct, Account actualAcct){
        Assert.areEqual(expectAcct.Name, actualAcct.Name);
        Assert.areEqual(expectAcct.Phone, actualAcct.Phone);
        Assert.areEqual(expectAcct.AccountNumber, actualAcct.AccountNumber);
        Assert.areEqual(expectAcct.Site, actualAcct.Site);
        Assert.areEqual(expectAcct.BillingState, actualAcct.BillingState);
    }
}