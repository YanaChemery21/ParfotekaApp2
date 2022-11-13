//
//  AuthenticationViewModel.swift
//  ParfotekaApp2
//
//  Created by air on 13.11.22.
//

import UIKit

protocol FormViewModel{
    func updateForm()
}

protocol AuthenticationViewModel{
    var formIsValid: Bool {get}
    var buttonBackgroundColor: UIColor{get}
    var butttonTitleColor:UIColor{get}
    
}


struct LoginViewModel: AuthenticationViewModel{
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3006576002, green: 0.3999854028, blue: 0.6074874997, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
    }
    
    var butttonTitleColor: UIColor{
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegistrationViewModel: AuthenticationViewModel{
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    var formIsValid: Bool{
        return email?.isEmpty == false && password?.isEmpty == false
        && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor{
        return formIsValid ? #colorLiteral(red: 0.3006576002, green: 0.3999854028, blue: 0.6074874997, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
    }
    
    var butttonTitleColor: UIColor{
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
}
