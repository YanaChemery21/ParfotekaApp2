//
//  CommentViewModel.swift
//  ParfotekaApp2
//
//  Created by air on 20.11.22.
//

import UIKit

struct CommentViewModel {
    private let comment: Comment
    
    var profileImageUrl: URL? {
        return URL(string: comment.profileImageUrl)
    }
    
    
    init(comment: Comment){
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString {
        let attributtedString = NSMutableAttributedString(string: "\(comment.username) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributtedString.append(NSAttributedString(string: comment.commentText, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributtedString
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
