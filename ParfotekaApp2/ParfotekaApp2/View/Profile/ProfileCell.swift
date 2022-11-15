//
//  ProfileCell.swift
//  ParfotekaApp2
//
//  Created by air on 15.11.22.
//

import UIKit

class ProfileCell: UICollectionViewCell{
    
    
    //MARK: - Properties
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pngtree-perfume-illustration-perfume-illustration-perfume-hand-drawing-cosmetic-png-image_397715")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
