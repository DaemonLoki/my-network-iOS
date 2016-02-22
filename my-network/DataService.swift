//
//  DataService.swift
//  my-network
//
//  Created by Stefan Blos on 04.02.16.
//  Copyright © 2016 Stefan Blos. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://luminous-inferno-3687.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: Firebase {
        let key = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        return Firebase(url: "\(_REF_USERS)").childByAppendingPath(key)!
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}