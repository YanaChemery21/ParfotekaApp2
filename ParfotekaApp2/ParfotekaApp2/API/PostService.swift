//
//  PostService.swift
//  ParfotekaApp2
//
//  Created by air on 18.11.22.
//

import UIKit
import Firebase


struct PostService{
    
    
    static func uploadPost(caption: String, image: UIImage, user: User,
                           completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl":imageUrl,
                        "ownerUid": uid,
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername":user.username] as [String: Any]
            
            COLLECTION_POSTS.addDocument(data: data,completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post])-> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else{return}
            
             let posts = documents.map({ Post(postID: $0.documentID, dictionary: $0.data()) }) 
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post])-> Void ){
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)

        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else{return}
            
            
             var  posts = documents.map({ Post(postID: $0.documentID, dictionary: $0.data()) })
            
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            completion(posts)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes": post.likes + 1])
            
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).setData([:]) { _ in
            
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0  else { return }
        
        COLLECTION_POSTS.document(post.postID).updateData(["likes": post.likes - 1])
        
        COLLECTION_POSTS.document(post.postID).collection("post-likes").document(uid).delete { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool)-> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }

        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postID).getDocument { (snapshot, _) in
            guard let didLike = snapshot?.exists else{return}
            completion(didLike)
        }
    }
}
