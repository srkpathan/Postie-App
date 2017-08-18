//
//  LoginViewController.swift
//  Postie
//
//  Created by shahrukh on 8/12/17.
//  Copyright © 2017 shahrukh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var userField: HoshiTextField!
    @IBOutlet weak var pswdField: HoshiTextField!
    
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
    
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        if (userField.hasText == false) {
            let alert = UIAlertController.init(title: "Postie", message: "username is missing!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else if (pswdField.hasText == false) {
            let alert = UIAlertController.init(title: "Postie", message: "password is missing!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else {
            let user = userField.text
            let pswd = pswdField.text
            
            //db operation
            let fileManager = FileManager.default
            
            let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask)
            let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("postieDB.db")
            
            guard let db = FMDatabase(path: finalDatabaseURL.path), db.open()
                else {print("Ooooops"); return}
            
            if let rs = db.executeQuery("select userName, Password from users", withArgumentsIn: nil) {
                while rs.next() {
                    let userName = rs.string(forColumn: "userName")
                    let pass = rs.string(forColumn: "Password")
                    
                    print("UserName = \(userName!) ** Password = \(pass!)")
                    
                    if (userName == user && pass == pswd) {
                        success = true
                    }
                }
            }
            if (success == true) {
                self.performSegue(withIdentifier: "login", sender: self)
            }else {
                let alert = UIAlertController.init(title: "Login Failed", message: "Username or Password does not match", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "Ok", style: .default, handler: {_ in
                    self.userField.text = ""
                    self.pswdField.text = ""
                })
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
            db.close()
        }
    }
    
    
    

}









