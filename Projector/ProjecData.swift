//
//  ProjecData.swift
//  RedmineProject-3.0
//
//  Created by Volodymyr Tymofiychuk on 15.01.15.
//  Copyright (c) 2015 Volodymyr Tymofiychuk. All rights reserved.
//

import Foundation

class ProjectData {
    
    class var sharedInstance: ProjectData {
        struct Static {
            static var instance: ProjectData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ProjectData()
        }
        
        return Static.instance!
    }
    
    var progectId: Int = 0
}