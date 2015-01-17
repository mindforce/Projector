//
//  ProjectsTableViewController.swift
//  RedmineProject-3.0
//
//  Created by Volodymyr Tymofiychuk on 14.01.15.
//  Copyright (c) 2015 Volodymyr Tymofiychuk. All rights reserved.
//

import UIKit
import Alamofire

class ProjectsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblProjects: UITableView!
    
    var data: NSMutableData = NSMutableData()
    var tableData: NSArray = NSArray()
    // astutemask = 12
    func logout() -> Void {
        let parentController = self.storyboard?.instantiateViewControllerWithIdentifier("MainControllerID") as ViewController
        self.presentViewController(parentController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectsCell") as ProjectsTableViewCell
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        cell.lblTitle?.text = rowData["name"] as? String
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add back button
        var btnLogout : UIBarButtonItem = UIBarButtonItem(title: "Main menu", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        self.navigationItem.rightBarButtonItem = btnLogout
        // ***
        
        var dataDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var base_url: String = dataDefault.valueForKey("BASE_URL")! as String
        var api_key: AnyObject = dataDefault.valueForKey("API_KEY")!
        var projects: AnyObject? = dataDefault.valueForKey("PROJECTS")
        println(api_key)
        if projects == nil {
            println("Load lrojects")
            var url = base_url + "/projects.json?"
            var key = api_key.stringValue
            println(key)
            Alamofire.request(.GET, url, parameters: ["key": api_key])
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (request, response, json, error) in
                    
                    println("Error: ", error)
                    
                    var json = JSON(json!)
                    //println(json)
                    if var results: AnyObject? = json["projects"].arrayObject {
                        var res_array: NSArray = results as NSArray
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableData = res_array
                            self.tblProjects.reloadData()
                            println("***")
                            println(self.tableData.count)
                        })
                        
                        dataDefault.setObject(results, forKey: "PROJECTS")
                        dataDefault.synchronize()
                        
                    }
            }
        } else {
            println("Get projects from cash")
            if var results: AnyObject? = projects {
                var res_array: NSArray = results as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = res_array
                    self.tblProjects.reloadData()
                })
                
                dataDefault.setObject(results, forKey: "PROJECTS")
                dataDefault.synchronize()
                
            }
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "go_to_project_bar" {
            var indexPath = self.tblProjects.indexPathForSelectedRow()
            var row_number: Int! = indexPath?.row
            var projectData = ProjectData.sharedInstance // data from ProjectData class!!
            projectData.progectId = tableData[row_number]["id"] as Int
            let tabBar = segue.destinationViewController as UITabBarController
            tabBar.title = tableData[row_number]["name"] as? String
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
