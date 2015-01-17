//
//  IssuesTableViewController.swift
//  RedmineProject-3.0
//
//  Created by Volodymyr Tymofiychuk on 14.01.15.
//  Copyright (c) 2015 Volodymyr Tymofiychuk. All rights reserved.
//

import UIKit
import Alamofire

class IssuesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblIssues: UITableView!
    
    var tableData: NSArray = NSArray()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IssuesCell") as IssuesTableViewCell
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        cell.lblTitle?.text = rowData["subject"] as? String
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var dataDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var base_url: String = dataDefault.valueForKey("BASE_URL")! as String
        var api_key: AnyObject = dataDefault.valueForKey("API_KEY")!
        var projects: AnyObject? = dataDefault.valueForKey("PROJECTS")
        
        
        var projectData = ProjectData.sharedInstance // data from ProjectData class!!
        
        
        var url = base_url + "/issues.json"
        println("id = '\(projectData.progectId)'")
        Alamofire.request(.GET, url, parameters: ["key": api_key, "project_id" : projectData.progectId])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (request, response, json, error) in
                println(json)
                if json != nil {
                    var json = JSON(json!)
                    println(json["total_count"])
                    if var results: AnyObject? = json["issues"].arrayObject {
                        var res_array: NSArray = results as NSArray
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableData = res_array
                            self.tblIssues.reloadData()
                            println("***")
                            println(self.tableData.count)
                        })
                    }
                } else {
                    self.tblIssues.hidden = true
                    var lblNotification = UILabel(frame: CGRectMake(0, 0, 200, 21))
                    lblNotification.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
                    
                    lblNotification.center = self.view.center //CGPointMake(160, 284)
                    lblNotification.textAlignment = NSTextAlignment.Center
                    lblNotification.text = "Project does not contain tasks"
                    self.view.addSubview(lblNotification)
                    
                    //var alert = UIAlertController(title: "", message: "Project does not contain tasks", preferredStyle: UIAlertControllerStyle.Alert)
                    //alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
                    
                    //let parentController = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectsTableIdentity") as ProjectsTableViewController
                    
                    
                    //self.presentViewController(alert, animated: true, completion: nil)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "go_to_issue" {
            var segueView = segue.destinationViewController as IssueViewController
            var indexPath = self.tblIssues.indexPathForSelectedRow()
            var row_number: Int! = indexPath?.row
            segueView.issueID = tableData[row_number]["id"] as Int
            //var
            if var issueTitle: NSArray = tableData[row_number]["tracker"] as? NSArray {
            segueView.navigationController?.title = "asdfasd" // issueTitle["name"].stringValue
                //tableData[row_number]["tracker"]["name"].stringValue
            }
        }
    }

}
