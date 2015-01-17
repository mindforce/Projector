//
//  LoginViewController.swift
//  RedmineProject-3.0
//
//  Created by Volodymyr Tymofiychuk on 14.01.15.
//  Copyright (c) 2015 Volodymyr Tymofiychuk. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var txtLink: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var switchRememberMe: UISwitch!
    
    @IBAction func btnLogin(sender: UIButton) {
        var username = txtUsername.text
        var password = txtPassword.text
        
        var defaultData : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (username != "" && password != "") {
            var baseUrl = txtLink.text
            
            defaultData.setObject(baseUrl, forKey: "BASE_URL")
            
            var urlPath = baseUrl + "/users/current.json"
            urlPath = urlPath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            var url: NSURL = NSURL(string: urlPath)!
            
            println("Start login '\(username)'")
            Alamofire.request(.GET, url)
                .authenticate(user: username, password: password)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (request, response, json, error) in
                    if error == nil {
                        var json = JSON(json!)
                        var api_key = json["user"]["api_key"]
                        
                        defaultData.setObject(username, forKey: "USERNAME")
                        defaultData.setObject(api_key.stringValue, forKey: "API_KEY")
                    
                        if self.switchRememberMe.on {
                            defaultData.setBool(true, forKey: "REMEMBER_ME")
                        } else {
                            defaultData.setBool(false, forKey: "REMEMBER_ME")
                        }
                        defaultData.synchronize()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
