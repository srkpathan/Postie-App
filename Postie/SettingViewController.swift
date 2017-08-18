//
//  SettingViewController.swift
//  Postie
//
//  Created by shahrukh on 8/13/17.
//  Copyright © 2017 shahrukh. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTable: UITableView!
    
    var items = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = ["Share App", "Themes", "Logout", "About"]
    }


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingTableViewCell = myTable.dequeueReusableCell(withIdentifier: "setting") as! SettingTableViewCell
        
        cell.selectionStyle = .none
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.row) {
        case 0:
            break
        case 1:
            break
        case 2:
            let alert = UIAlertController.init(title: "Postie", message: "Do you want to logout?", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Yes", style: .default, handler: { _ in
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            let cancel = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
        case 3:
            break
        default:
            break
        }
        
    }

}
















