//
//  SignInViewController.swift
//  Personal Expense Tracker
//
//  Created by Vyshak Athreya B K on 12/20/17.
//  Copyright © 2017 Vyshak Athreya B K. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var userCurrency = " "
    var currencyArray = Array<String>()
    var userRoot :DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userRoot = userRoot.child("users")
        let data:Bundle = Bundle.main
        let currencyPlist:String? = data.path(forResource: "Currency", ofType: "plist")
        if currencyPlist != nil
        {
            currencyArray = NSArray(contentsOfFile: currencyPlist!) as! [String]
        }
        if let user = Auth.auth().currentUser{
            self.nameLabel.text = user.displayName
            userRoot = userRoot.child(user.uid)
        }
        if let email = Auth.auth().currentUser?.email{
            self.emailLabel.text = email
        }
        userRoot.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let curr = value?["currency"] as? String ?? ""
            let phone = value?["phone"] as? String ?? ""
            self.currencyLabel.text = curr
            self.phoneLabel.text = phone
        }) { (error) in
            print(error.localizedDescription)
        }
        //based on https://firebase.google.com/docs/database/ios/read-and-write
    }
    
    @IBAction func changeCurrency(_ sender: Any) {
        currencyPicker.isHidden = false
        cancelButton.isHidden = false
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        currencyPicker.isHidden = true
        cancelButton.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currencyPicker.isHidden == false{
            userRoot.child("currency").setValue(currencyArray[row])
            currencyPicker.isHidden = true
            cancelButton.isHidden = true
            userRoot.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let curr = value?["currency"] as? String ?? ""
                let phone = value?["phone"] as? String ?? ""
                self.currencyLabel.text = curr
                self.phoneLabel.text = phone
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch{
            print("log out error")
        }
        
    }

}
