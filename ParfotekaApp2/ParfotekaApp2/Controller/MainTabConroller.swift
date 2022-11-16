//
//  MainTabConroller.swift
//  ParfotekaApp2
//
//  Created by air on 12.11.22.
//

import UIKit
import Firebase
class MainTabController: UITabBarController {
    
//MARK: - Lifecycle
    
    private var user:User? {
        didSet {
            guard let user = user else{return}
            configureViewControllers(withUser: user)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
 
    }
    
    //MARK: - API
    
    
    func fetchUser(){
        UserService.fetchUser { user in
            self.user = user
        }
    }
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async{
                let controller = LoginController()
                controller.delegate = self 
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    //MARK: - Helpers
    
    func configureViewControllers(withUser user: User){
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let feed = templeteNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected") , rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templeteNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected") , rootViewController: SearchController())
        
        let imageSelector = templeteNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected") , rootViewController: ImageSelectorController())
        
        let notifications = templeteNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected") , rootViewController: NotificationsController())
        
        let profileController = ProfileController(user: user)
        
        
        let profile = templeteNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected") , rootViewController: profileController)
        
        
        viewControllers = [feed, search, imageSelector, notifications, profile]
        
        tabBar.tintColor = .black
    }
    func templeteNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
         let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}

//MARK: -AuthenticationDelegate

extension MainTabController: AuthenticationDelegate{
    func authenticationDidComplete() {
    fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
