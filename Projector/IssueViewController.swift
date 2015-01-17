//
//  IssueViewController.swift
//  RedmineProject-3.0
//
//  Created by Volodymyr Tymofiychuk on 15.01.15.
//  Copyright (c) 2015 Volodymyr Tymofiychuk. All rights reserved.
//

import UIKit
import Alamofire

class IssueViewController: UIViewController {

    @IBOutlet weak var IssueView: UIView!
    
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblPerformer: UILabel!
    @IBOutlet weak var lblCreatedOn: UILabel!
    @IBOutlet weak var lblUpdatedOn: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDoneRatio: UILabel!
    @IBOutlet weak var lblEstimatedHours: UILabel!
    @IBOutlet weak var lblSpentHours: UILabel!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var lblPriority: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var tableData: NSArray = NSArray()
    
    var issueID: Int = Int()
    var projectID = ProjectData.sharedInstance.progectId // data from ProjectData class!!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var width:CGFloat = bounds.size.width
        var height:CGFloat = bounds.size.height
        println(width)
        println(height)
        
        if height < 600 {
            self.scrollView.contentSize = CGSizeMake(width, 600)
            self.IssueView.frame.size.height = 600
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var dataDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var base_url: String = dataDefault.valueForKey("BASE_URL")! as String
        var api_key: AnyObject = dataDefault.valueForKey("API_KEY")!
        
        var url = base_url + "/issues/\(issueID).json?"
        var key = api_key.stringValue
        Alamofire.request(.GET, url, parameters: ["key": api_key, "project_id": projectID])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (request, response, json, error) in
                if(error == nil) {
                    var json = JSON(json!)
                    var id: Int = json["issue"]["id"].int!
                    var tracker: String = json["issue"]["tracker"]["name"].string!
                    self.navigationItem.title = "\(tracker) #\(id)"
                    
                    self.lblSubject.text = json["issue"]["subject"].string!
                    self.lblStatus.text = json["issue"]["status"]["name"].string!
                    self.lblPriority.text = json["issue"]["priority"]["name"].string!
                    
                    self.lblAuthor.text = json["issue"]["author"]["name"].string!
                    self.lblPerformer.text = json["issue"]["assigned_to"]["name"].string!
                    
                    self.lblCreatedOn.text = json["issue"]["created_on"].string!
                    self.lblUpdatedOn.text = json["issue"]["updated_on"].string!
                    
                    println(json["issue"]["spent_hours"].double)
                    
                    var ratio = json["issue"]["done_ratio"].int
                    var spentHours = json["issue"]["spent_hours"].double
                    var estimatedHours = json["issue"]["estimated_hours"].double
                    
                    self.lblDoneRatio.text = "\(ratio)"
                    self.lblSpentHours.text = "\(spentHours)"
                    self.lblEstimatedHours.text = "\(estimatedHours)"
                    
                    
                    self.txtViewDescription.text = json["issue"]["description"].string
                    
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
