//
//  RegisterViewController.swift
//  Postie
//
//  Created by shahrukh on 8/12/17.
//  Copyright © 2017 shahrukh. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var fNameField: HoshiTextField!
    @IBOutlet weak var lNameField: HoshiTextField!
    @IBOutlet weak var mailField: HoshiTextField!
    @IBOutlet weak var userField: HoshiTextField!
    @IBOutlet weak var pswdField: HoshiTextField!
    @IBOutlet weak var conPswdField: HoshiTextField!
    
    var success : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        
        if (fNameField.hasText == false) {
            let alert = UIAlertController.init(title: "Postie", message: "firstname is missing!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else if (lNameField.hasText == false) {
            let alert = UIAlertController.init(title: "Postie", message: "lastname is missing!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else if (mailField.hasText == false) {
            let alert = UIAlertController.init(title: "Postie", message: "email is missing!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else if (userField.hasText == false) {
            let alert = UIAlertController.init(title: "Postie", message: "username is missing!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else if (pswdField.hasText == false) {
            let alert = UIAlertController.init(title: "Postie", message: "password is missing!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else if (conPswdField.hasText == false) {
            let alert = UIAlertController.init(title: "Postie", message: "confirm password is missing!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else {
            if (pswdField.text == conPswdField.text) {
                let firstName = fNameField.text
                let lastName = lNameField.text
                let eMail = mailField.text
                let userName = userField.text
                let password = pswdField.text
                
                //db operation
                let fileManager = FileManager.default
                
                let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask)
                let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("postieDB.db")
                
                guard let db = FMDatabase(path: finalDatabaseURL.path), db.open()
                    else {print("Ooooops"); return}
                
                do {
                    try db.executeUpdate("INSERT INTO users (FName, LName, Email, userName, Password) VALUES (?, ?, ?, ?, ?)", values: [firstName!, lastName!, eMail!, userName!, password!])
                    print("Records added Successful")
                    
                    self.performSegue(withIdentifier: "register", sender: self)
                    
                } catch {
                    print(error.localizedDescription)
                }
                db.close()
            }else {
                let alert = UIAlertController.init(title: "Postie", message: "passwords don't match!", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }

}









