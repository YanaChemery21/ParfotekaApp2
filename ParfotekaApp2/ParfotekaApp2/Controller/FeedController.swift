//
//  FeedController.swift
//  ParfotekaApp2
//
//  Created by air on 12.11.22.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"


class FeedController: UICollectionViewController{
    
    private let refresher = UIRefreshControl()
    
    //MARK: - Lifecycle
    
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    var post: Post? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
        if post != nil {
            checkIfUserLikedPost()
        }
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh(){
        posts.removeAll()
        fetchPosts()
       refresher.endRefreshing()

    }
    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    //MARK: - API
    func fetchPosts() {
        guard post == nil else { return }
        
        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPost()
        self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedPost() {
        if let post = post {
            PostService.checkIfUserLikedPost(post: post) { didLike in
                self.post?.didLike = didLike
            }
        } else {
            posts.forEach { post in
                PostService.checkIfUserLikedPost(post: post) { didLike in
                    if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                        self.posts[index].didLike = didLike
        }
        
                }
            }
        }
    }
    
    
    
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        navigationItem.title = "Feed"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}

//MARK: -UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell

        cell.delegate = self


        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        }else {
                cell.viewModel = PostViewModel(post:posts[indexPath.row])
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        
        return CGSize(width: width, height: height)
    }
}
//MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            PostService.unlikePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
            
        }else {

            PostService.likePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.ownerUid,fromUser: user, type: .like, post: post)

            }
        }
    }
}
