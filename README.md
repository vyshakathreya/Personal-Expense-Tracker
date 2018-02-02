# Personal-Expense-Tracker
Personal Expense Tracker is an application which is used to monitor personal expenses in multiple currencies.

Application is designed to run on phones.

Api used to get currency conversion rates: http://fixer.io/
Firebase is used as database. 
Salient features include:

1. App supports 20 popular currencies of the world. User can enter income/expense in any currency. It is requested to register with a base currency other than USD. Even after logging in , the base currency can be updated from the profile tab. Balance is displayed in both home currency as well as in the default currency which is USD.

2. App supports multiple accounts. User has the option to add as well as remove the account. User can select the account used for payment. Account wise balance is made available based on the transactions. All the transactions can be viewed. 

Libraries used are:

Alamofire for networking
FirebaseAuth for authentication
Firebase as database
SwiftyJSON for JSON parsing

