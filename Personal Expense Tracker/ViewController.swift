//
//  ViewController.swift
//  Personal Expense Tracker
//
//  Created by Vyshak Athreya B K on 12/20/17.
//  Copyright © 2017 Vyshak Athreya B K. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var entryview: UIScrollView!
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        if let eMail = userDefaults.string(forKey: "email"), let pass = userDefaults.string(forKey: "password"){
            emailTextField.text = eMail
            passwordTextField.text = pass
        }
        if (emailTextField.text?.isEmpty)!{
            
        }else{
            actionSignIn("")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.loginView.endEditing(true)
        self.entryview.endEditing(true)
    }
    
    @IBAction func back(unwindSegue:UIStoryboardSegue) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField{
            textField.resignFirstResponder()
            actionSignIn(" ")
            self.loginView.endEditing(true)
            self.entryview.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        entryview.setContentOffset(CGPoint(x: 0, y: 125), animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
            entryview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        if let mail = emailTextField.text , let pass = passwordTextField.text
        {
            userDefaults.set(mail, forKey: "email")
            userDefaults.set(pass, forKey:"password")
            Auth.auth().signIn(withEmail: mail, password: pass, completion: {
               (user,error) in
                if user != nil{
                    self.messageLabel.isHidden = true
                    self.performSegue(withIdentifier: "MainScreen", sender: self)
                }
                else
                {
                    if let myerr = error?.localizedDescription{
                        print(myerr)
                        self.messageLabel.isHidden = false
                        self.messageLabel.text = "Username or password is wrong"
                    }else{
                        self.messageLabel.isHidden = true
                    }
                }
            })
        }
    }
}

