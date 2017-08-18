//
//  PostsViewController.swift
//  Postie
//
//  Created by shahrukh on 8/13/17.
//  Copyright © 2017 shahrukh. All rights reserved.
//

import UIKit
import SwipeCellKit

class PostsCell: SwipeTableViewCell {
    
    //outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    //outles
    @IBOutlet weak var postsTable: UITableView!
    
    
    //
    var ids = [String]()
    var titles = [String]()
    var descriptions = [String]()
    var links = [String]()
    var dates = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //tableview dynamic row
        postsTable.estimatedRowHeight = postsTable.rowHeight
        postsTable.rowHeight = UITableViewAutomaticDimension
        
        fetchDataFromDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchDataFromDB() {
        
        //db operation
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("postieDB.db")
        
        guard let db = FMDatabase(path: finalDatabaseURL.path), db.open()
            else {print("Ooooops"); return}
        
        if let rs = db.executeQuery("select id, title, description, link, pubDate from posts", withArgumentsIn: nil) {
            while rs.next() {
                let id = rs.string(forColumn: "id")
                print("Id =",id!)
                self.ids.append(id!)
                
                let title = rs.string(forColumn: "title")
                print("Title =",title!)
                self.titles.append(title!)
                
                let desc = rs.string(forColumn: "description")
                print("Description =",desc!)
                self.descriptions.append(desc!)
                
                let link = rs.string(forColumn: "link")
                print("Link =",link!)
                self.links.append(link!)
                
                let date = rs.string(forColumn: "pubDate")
                print("Date =",date!)
                self.dates.append(date!)
            }
        }
        db.close()
        postsTable.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PostsCell = postsTable.dequeueReusableCell(withIdentifier: "posts") as! PostsCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.titleLabel.text = titles[indexPath.row]
        cell.descLabel.text = descriptions[indexPath.row]
        cell.dateLabel.text = dates[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //open post link in browser
        
        let link = links[indexPath.row]
        print("Link = ",link)
        
        let webVC = SwiftWebVC(urlString: link)
        show(webVC, sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let favAction = SwipeAction(style: .destructive, title: "Add to Favotires") { action, indexPath in
            
            let pID = self.ids[indexPath.row]
            //db operation
            let fileManager = FileManager.default
            
            let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask)
            let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("postieDB.db")
            
            guard let db = FMDatabase(path: finalDatabaseURL.path), db.open()
                else {print("Ooooops"); return}
            
            do {
                try db.executeUpdate("INSERT INTO favorites (postID) VALUES (?)", values: [pID])
                print("Record added Successful")
            } catch {
                print(error.localizedDescription)
            }
            db.close()
        }
        return [favAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.transitionStyle = .reveal
        return options
    }
    
    

}

















