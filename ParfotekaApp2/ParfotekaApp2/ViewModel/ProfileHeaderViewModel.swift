//
//  ProfileHeaderViewModel.swift
//  ParfotekaApp2
//
//  Created by air on 16.11.22.
//

import Foundation


struct ProfileHeaderViewModel{
    let user: User
    
    var fullname: String{
        return user.fullname
    }
    
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    
    init(user: User){
        self.user = user
    }
}
