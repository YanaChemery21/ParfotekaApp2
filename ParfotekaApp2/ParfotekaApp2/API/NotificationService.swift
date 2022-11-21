//
//  NotificationService.swift
//  ParfotekaApp2
//
//  Created by air on 21.11.22.
//

import Firebase

struct NotificationService {
    static func uploadNotification(toUid uid: String,fromUser: User,
                                   type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": fromUser.uid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "userProfileImageUrl": fromUser.profileImageUrl,
                                   "username": fromUser.username]
        
        if let post = post {
            data["postId"] = post.postID
            data["postImageUrl"] = post.imageUrl
        }
        
        
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping([Notification])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            let notifications = documents.map({ Notification(dictionary: $0.data())  })
            completion(notifications)
        }
    }
    
    
}
