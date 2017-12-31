//
//  TransactionViewController.swift
//  Personal Expense Tracker
//
//  Created by Vyshak Athreya B K on 12/21/17.
//  Copyright © 2017 Vyshak Athreya B K. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class TransactionViewController: UIViewController , UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var accountPicker: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addTransaction: UIButton!
    @IBOutlet weak var transactionSegment: UISegmentedControl!
    @IBOutlet weak var expenseCategory: UILabel!
    @IBOutlet weak var incomeAccount: UILabel!
    @IBOutlet weak var expenseAccount: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var addView: UIView!
    
    var accountChosen:String!
    var categoryChosen:String = "Income"
    var userRoot:DatabaseReference!
    var uid:String!
    var timeNow:NSDate!
    var timeInterval:Int!
    var accountsArray = Array<String>()
    var categoriesArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeScreen(transactionSegment)
        getAccounts()
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        timeNow = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        timeInterval = Int(myTimeInterval)
        //referred from https://stackoverflow.com/questions/46376823/ios-swift-get-the-current-local-time-and-date-timestamp
        
        let data:Bundle = Bundle.main
        let budgetPlist:String? = data.path(forResource: "BudgetCategories", ofType: "plist")
        if budgetPlist != nil
        {
            categoriesArray = NSArray(contentsOfFile: budgetPlist!) as! [String]
        }
        uid = Auth.auth().currentUser?.uid
        userRoot = Database.database().reference().child("transactions/"+uid)
    }

    @IBAction func changeScreen(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            expenseAccount.isHidden = true
            categoryPicker.isHidden = true
            incomeAccount.isHidden = false
            expenseCategory.isHidden = true
            categoryChosen = "Income"
        }else{
            expenseAccount.isHidden = false
            categoryPicker.isHidden = false
            incomeAccount.isHidden = true
            expenseCategory.isHidden = false
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == accountPicker{
            return accountsArray.count
        }else{
            return categoriesArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == accountPicker{
            return accountsArray[row]
        }else{
            return categoriesArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == accountPicker{
            accountChosen = accountsArray[row]
        }else{
            categoryChosen = categoriesArray[row]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == amountTextField{
            scrollview.setContentOffset(CGPoint(x: 0, y: 125), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTextField{
            scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == descriptionTextField{
            amountTextField.becomeFirstResponder()
        }
        if textField == amountTextField{
            self.addView.endEditing(true)
            self.scrollview.endEditing(true)
        }
        return true
    }
    
    func editDidEnd() {
        self.addView.endEditing(true)
        self.scrollview.endEditing(true)
    }

    @IBAction func addTransaction(_ sender: UIButton) {
        userRoot = userRoot.child(String(timeInterval!))
        userRoot.child("account").setValue(accountChosen)
        if (amountTextField.text?.isEmpty)!{
            errorLabel.isHidden = false
            errorLabel.text = "\u{26A0} transaction amount is required"
        }else if let amount = amountTextField.text{
            
            userRoot.child("amount").setValue(amount)
            userRoot.child("category").setValue(categoryChosen)
            userRoot.child("currency").setValue("USD($)")
            userRoot.child("date").setValue(ServerValue.timestamp())
            if let desc = descriptionTextField.text{
                userRoot.child("desc").setValue(desc)
            }else{
                userRoot.child("desc").setValue("No Description")
            }
            userRoot.child("transtype").setValue(categoryChosen)
            userRoot.child("userId").setValue(uid)
            errorLabel.isHidden = false
            errorLabel.text = "Transaction saved."
        }else{
            alertUser()
        }
        addView.endEditing(true)
    }
    
    func getAccounts(){
        let user = Auth.auth().currentUser?.displayName
        let accountRoot = Database.database().reference().child("accounts/"+user!)
        accountRoot.observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                self.accountPicker.isHidden = false
                self.errorLabel.isHidden = true
                self.accountsArray.removeAll()
                    for (key,_) in value{
                    self.accountsArray.append(key as! String)
                        self.accountPicker.reloadAllComponents()
                        self.accountChosen = self.accountsArray[0]
                    }
            }else{
                self.accountPicker.isHidden = true
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Please add an account"
            }
            })
    }
    
    @IBAction func alertUser() {
        let alert = UIAlertController(title: "No Data!", message: "Amount is required", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.addView.endEditing(true)
    }
    
}
