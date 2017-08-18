//
//  FavoriteViewController.swift
//  Postie
//
//  Created by shahrukh on 8/13/17.
//  Copyright © 2017 shahrukh. All rights reserved.
//

import UIKit
import SwipeCellKit

class favCell: SwipeTableViewCell {
    
    //outlets
    @IBOutlet weak var titleLabel: UILabel!
    
}

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    
    //outlets
    @IBOutlet weak var favTable: UITableView!
    
    //
    var ids = [String]()
    var titles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        //tableview dynamic row
        favTable.estimatedRowHeight = favTable.rowHeight
        favTable.rowHeight = UITableViewAutomaticDimension
        
        fetchIDFromDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchIDFromDB() {
        
        ids.removeAll()
        titles.removeAll()
        
        //db operation
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("postieDB.db")
        
        guard let db = FMDatabase(path: finalDatabaseURL.path), db.open()
            else {print("Ooooops"); return}
        
        if let rs = db.executeQuery("select distinct postID from favorites", withArgumentsIn: nil) {
            while rs.next() {
                let id = rs.string(forColumn: "postID")
                print("Id =",id!)
                self.ids.append(id!)
            }
        }
        db.close()
        
        for i in 0..<ids.count {
            fetchDataFromDB(withIndex: i)
        }
        favTable.reloadData()
    }
    
    func fetchDataFromDB(withIndex: Int) {
        
        let curIndex = ids[withIndex]
        
        //db operation
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("postieDB.db")
        
        guard let db = FMDatabase(path: finalDatabaseURL.path), db.open()
            else {print("Ooooops"); return}
        
        if let rs = db.executeQuery("select distinct title from posts where id = \(curIndex)", withArgumentsIn: nil) {
            while rs.next() {
                let title = rs.string(forColumn: "title")
                print("Title =",title!)
                self.titles.append(title!)
            }
        }
        db.close()
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : favCell = favTable.dequeueReusableCell(withIdentifier: "favs") as! favCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.titleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Remove") { action, indexPath in
            
            let pID = self.ids[indexPath.row]
            //db operation
            let fileManager = FileManager.default
            
            let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask)
            let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("postieDB.db")
            
            guard let db = FMDatabase(path: finalDatabaseURL.path), db.open()
                else {print("Ooooops"); return}
            
            do {
                try db.executeUpdate("DELETE from favorites where postID = \(pID)", withArgumentsIn: nil)
                print("Record remove Successful")
                
                //remove row from tableview
                //self.favTable.beginUpdates()
                //self.favTable.deleteRows(at: [indexPath], with: .automatic)
                //action.fulfill(with: .delete)
                //self.favTable.endUpdates()
                
                self.fetchIDFromDB()
            } catch {
                print(error.localizedDescription)
            }
            db.close()
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.transitionStyle = .reveal
        return options
    }

}

































