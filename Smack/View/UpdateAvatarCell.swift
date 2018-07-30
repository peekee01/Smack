//
//  UpdateAvatarCell.swift
//  Smack
//
//  Created by Pieter Kuijsten on 26/07/2018.
//  Copyright © 2018 Pieter Kuijsten. All rights reserved.
//

import UIKit

//enum AvatarType {
//    case dark
//    case light
//}

class UpdateAvatarCell: UICollectionViewCell {

    //Outlets
    @IBOutlet weak var avatarImg: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        
    }
    
    func configureCell(index: Int, type:AvatarType) {
        if type == AvatarType.dark {
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
            
        } else {
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
    }
    
    func setUpView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
}

