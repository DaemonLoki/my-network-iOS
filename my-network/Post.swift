//
//  Post.swift
//  my-network
//
//  Created by Stefan Blos on 11.02.16.
//  Copyright © 2016 Stefan Blos. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _userName: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: Firebase!
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var userName: String {
        return _userName
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(postDescription: String, imageUrl: String, userName: String) {
        self._postDescription = postDescription
        self._imageUrl = imageUrl
        self._userName = userName
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let postDesc = dictionary["description"] as? String {
            self._postDescription = postDesc
        }
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let url = dictionary["imageUrl"] as? String {
            self._imageUrl = url
        }
        
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(_postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        self._postRef.childByAppendingPath("likes").setValue(_likes)
    }
}