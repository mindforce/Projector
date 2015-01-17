//
//  ViewController.swift
//  RedmineProject-3.0
//
//  Created by Volodymyr Tymofiychuk on 13.01.15.
//  Copyright (c) 2015 Volodymyr Tymofiychuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    
    @IBAction func btnLogout(sender: UIButton) {
        var defaultData : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaultData.setObject(nil, forKey: "API_KEY")
        defaultData.synchronize()
        self.performSegueWithIdentifier("go_to_login", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        var defaultData : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var api_key: AnyObject? = defaultData.valueForKey("API_KEY")
        if api_key == nil {
            self.performSegueWithIdentifier("go_to_login", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

