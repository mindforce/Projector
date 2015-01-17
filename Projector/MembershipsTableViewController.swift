//
//  MembershipsTableViewController.swift
//  Projector
//
//  Created by Volodymyr Tymofiychuk on 17.01.15.
//  Copyright (c) 2015 Volodymyr Tymofiychuk. All rights reserved.
//

import UIKit
import Alamofire

class MembershipsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblMemberships: UITableView!
    
    var tableData: NSArray = NSArray()
    var projectData = ProjectData.sharedInstance
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MembershipsCell") as MembershipsTableViewCell
        
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        var rowData2: NSDictionary = rowData["user"] as NSDictionary
        cell.lblTitle?.text = rowData2["name"] as? String
        
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var base_url: String = dataDefault.valueForKey("BASE_URL")! as String
        var api_key: AnyObject = dataDefault.valueForKey("API_KEY")!
        var projects: AnyObject? = dataDefault.valueForKey("PROJECTS")
        
        
        var url = base_url + "/projects/\(projectData.progectId)/memberships.json"
        
        Alamofire.request(.GET, url, parameters: ["key": api_key])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (request, response, json, error) in
                if error == nil {
                    var json = JSON(json!)
                    if var results: AnyObject? = json["memberships"].arrayObject {
                        var res_array: NSArray = results as NSArray
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableData = res_array
                            self.tblMemberships.reloadData()
                        })
                    }
                }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
