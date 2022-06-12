//
//  LoginViewController.swift
//  CryptoWatch
//
//  Created by Ömer Faruk Kılıçaslan on 12.06.2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LOGIN PAGE"
        warningLabel.isHidden = true
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
    }
    
  
    
    func validateFields(){
        
        // Check that all fields are filled in
        
        if emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            warningLabel.text = "Missing fields..."
            warningLabel.isHidden = false
        }
  
        
    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        
        
        let email = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            //Signing the user
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if error != nil { // IF AN ERROR OCCURS
                //Couldnt sign in
                
                self.warningLabel.text = error!.localizedDescription
                self.warningLabel.isHidden = false
            }
            
            else { //IF NO ERROR OCCURS
                
                self.performSegue(withIdentifier: "loginToHome", sender: nil)
                
            }
        }
    }
    
    

}
