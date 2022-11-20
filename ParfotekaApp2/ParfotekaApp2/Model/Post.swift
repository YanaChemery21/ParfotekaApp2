//
//  Post.swift
//  ParfotekaApp2
//
//  Created by air on 18.11.22.
//

import Firebase


struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let postID: String
    let ownerImageUrl: String
    let ownerUsername: String
    var didLike = false 
    
    
    init(postID: String, dictionary: [String:Any]) {
        self.postID = postID
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""

        
    }
}
