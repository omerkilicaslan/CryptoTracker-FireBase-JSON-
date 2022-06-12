//
//  SignUpViewController.swift
//  CryptoWatch
//
//  Created by Ömer Faruk Kılıçaslan on 12.06.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SIGN UP PAGE"
        signupButton.layer.cornerRadius = signupButton.frame.size.height / 2
        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let HomeVC = segue.destination as! LoginViewController
//
//    }
    
    func validateFields(){
        
        // Check that all fields are filled in
        
        if  nameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            surnameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            let alert = UIAlertController(title: "Warning", message: "Missing Fields", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        

        
    }
    

    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        //validate the fields
        
        validateFields()
        
        //Create cleaned versions of the data
        let name = nameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let surname = surnameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Create the user
        
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            
            if err != nil {
                print(err)
            }
            
            else {
                
                //No error found
                //User created successfully, now store the name and surname
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["name":name, "surname": surname, "uid": result!.user.uid]) { error in
                    
                    if error != nil {
                        print(error)
                    }
                }
                
//                let alert = UIAlertController(title: "Success", message: "Registered Successfully", preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//
//
                self.transitionToLogin()
                
            }
        }
    }
    
    func transitionToLogin() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}
