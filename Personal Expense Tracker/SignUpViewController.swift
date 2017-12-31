//
//  SignUpViewController.swift
//  Personal Expense Tracker
//
//  Created by Vyshak Athreya B K on 12/20/17.
//  Copyright © 2017 Vyshak Athreya B K. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate{
    
    let rootRef = Database.database().reference()
    var currencyArray = Array<String>()
    var currencyChosen = "USD($)"
    var problemFlag = true
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneError: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var SignInButton: UIButton!
    
    @IBOutlet weak var formView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let data:Bundle = Bundle.main
        let currencyPlist:String? = data.path(forResource: "Currency", ofType: "plist")
        if currencyPlist != nil
        {
            currencyArray = NSArray(contentsOfFile: currencyPlist!) as! [String]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.formView.endEditing(true)
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        if self.problemFlag == false{
            self.status.isHidden = true
            createNewUser()
        }
        if self.problemFlag == true{
            self.status.isHidden = false
            self.status.text = "All fields are required"
        }
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
        currencyChosen =  currencyArray[row]
    }
    
    func editDidEnd() {
        self.formView.endEditing(true)
    }
    
    @IBAction func passwordDidEnd(_ sender: UITextField) {
        if (sender.text?.count)! < 6{
            self.problemFlag = true
            self.passwordError.isHidden = false
            self.passwordError.text = "\u{26A0} Minimum 6 characters"
            self.problemFlag = true
        }else if (sender.text?.isEmpty)!{
            self.problemFlag = true
            self.passwordError.isHidden = false
            self.passwordError.text = "\u{26A0} Please enter password"
            }
        else{
            self.passwordError.isHidden = true
            self.problemFlag = false
        }
    }
    
    @IBAction func phoneDidEnd(_ sender: UITextField) {
        if (sender.text?.count)! < 10{
            self.problemFlag = true
            self.phoneError.isHidden = false
            self.phoneError.text = "\u{26A0} Number seems incorrect"
            self.problemFlag = true
        }else if (sender.text?.isEmpty)!{
            self.problemFlag = true
            self.phoneError.isHidden = false
            self.phoneError.text = "\u{26A0} Phone number is required"
        }else{
            self.phoneError.isHidden = true
            self.problemFlag = false
        }
    }
    
    @IBAction func nameDidEnd(_ sender: UITextField) {
        if (sender.text?.isEmpty)!{
            self.problemFlag = true
            self.nameError.isHidden = false
            self.nameError.text = "\u{26A0} Name is required"
        }else{
            self.nameError.isHidden = true
            self.problemFlag = false
        }
    }
    
    @IBAction func emailDidEnd(_ sender: UITextField) {
        if (sender.text?.isEmpty)!{
            self.problemFlag = true
            self.emailError.isHidden = false
            self.emailError.text = "\u{26A0} Email id is required"
        }else{
            self.emailError.isHidden = true
            self.problemFlag = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            emailTextField.becomeFirstResponder()
        }
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        if textField == phoneTextField{
            textField.resignFirstResponder()
            self.formView.endEditing(true)
        }
        if textField == passwordTextField{
            phoneTextField.becomeFirstResponder()
        }
        return true
    }
    
    func createNewUser(){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
            (user,error) in
            if let userfound = user{
                let changeRequest = userfound.createProfileChangeRequest()
                changeRequest.displayName = self.nameTextField.text!
                changeRequest.commitChanges { error in
                    if error != nil {
                        self.showAlert()
                        self.status.isHidden = false
                        self.status.text = "please correct errors and try again"
                    } else {
                        self.status.isHidden = true
                        let userRoot = self.rootRef.child("users/" + userfound.uid)
                        userRoot.child("email").setValue(self.emailTextField.text!)
                        userRoot.child("name").setValue(self.nameTextField.text!)
                        userRoot.child("phone").setValue(self.phoneTextField.text)
                        userRoot.child("currency").setValue(self.currencyChosen)
                        userRoot.child("uid").setValue(userfound.uid)
                        self.performSegue(withIdentifier: "NewUser", sender: self)
                    }
                }
            }
            else
            {
                self.showAlert()
                if let myerr = error?.localizedDescription
                {
                    print("This was wrong",myerr)
                }else{
                    print("Error")
                }
            }
        })
    }
    
    @IBAction func showAlert() {
        let alert = UIAlertController(title: "Account Exists!", message: "Please login using email and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
