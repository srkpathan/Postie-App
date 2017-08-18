//
//  ViewController.swift
//  Postie
//
//  Created by shahrukh on 8/12/17.
//  Copyright © 2017 shahrukh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser

class ViewController: UIViewController {
    
    @IBOutlet weak var logoImage: SpringImageView!
    @IBOutlet weak var loginBtn: SpringButton!
    @IBOutlet weak var registerBtn: SpringButton!
    
    //
    var titles = [String]()
    var descriptions = [String]()
    var links = [String]()
    var dates = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //
        loginBtn.layer.cornerRadius = 2
        loginBtn.layer.shadowColor = UIColor.blue.cgColor
        loginBtn.layer.shadowRadius = 1
        loginBtn.layer.shadowOpacity = 0.5
        loginBtn.layer.shadowOffset = CGSize(width: 1, height: 2)
        registerBtn.layer.cornerRadius = 2
        registerBtn.layer.shadowColor = UIColor.red.cgColor
        registerBtn.layer.shadowRadius = 1
        registerBtn.layer.shadowOpacity = 0.5
        registerBtn.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        /*
        networkOperation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.syncDataToDB()
        })*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func networkOperation() {
        
        request("http://timesofindia.indiatimes.com/rssfeeds/1221656.cms").response(completionHandler: { responseData in
            
            print("Request =",responseData.request!)
            print("Response =",responseData.response!)
            print("Data =",responseData.data!)
            
            let xmlData = XML.parse(responseData.data!)
            let items = xmlData["rss", "channel", "item"].all
            print("Total items =",items?.count ?? 0)
            
            for i in 0...19 {
                
                let title = xmlData["rss", "channel", "item", i, "title"].text
                print("Title =",title!)
                self.titles.append(title!)
                
                let desc = xmlData["rss", "channel", "item", i, "description"].text
                print("Description =",desc!)
                self.descriptions.append(desc!)
                
                let link = xmlData["rss", "channel", "item", i, "link"].text
                print("Link =",link!)
                self.links.append(link!)
                
                let pubDate = xmlData["rss", "channel", "item", i, "pubDate"].text
                print("Date =",pubDate!)
                self.dates.append(pubDate!)
            }
        })
    }
    
    func syncDataToDB() {
        
        //db operation
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("postieDB.db")
        
        guard let db = FMDatabase(path: finalDatabaseURL.path), db.open()
            else {print("Ooooops"); return}
        
        for i in 0...19 {
            
            let title = titles[i]
            let desc = descriptions[i]
            let link = links[i]
            let date = dates[i]
            
            do {
                try db.executeUpdate("INSERT INTO posts (title, description, link, pubDate) VALUES (?, ?, ?, ?)", values: [title, desc, link, date])
                print("Record added Successful")
            } catch {
                print(error.localizedDescription)
            }
        }
        db.close()
    }
    

}

















