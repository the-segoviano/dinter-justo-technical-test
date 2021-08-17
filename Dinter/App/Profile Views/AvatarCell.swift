//
//  AvatarCell.swift
//  Dinter
//
//  Created by Luis Segoviano on 17/08/21.
//

import UIKit

class AvatarCell: BaseTableViewCell {
    
    let avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFit
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 120/2
        avatar.image = UIImage(named: "profile")
        return avatar
    }()
    
    let containerAvatar: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        container.layer.cornerRadius = 120/2
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: -1, height: 1)
        container.layer.shadowRadius = 5
        return container
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CustomGothamRoundedFont.getLightFont()
        label.textAlignment = .center
        return label
    }()
    
    func setUpView(person: Persona) {
        selectionStyle = .none
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        addSubview(containerAvatar)
        containerAvatar.isUserInteractionEnabled = true
        containerAvatar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerAvatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerAvatar.widthAnchor.constraint(equalToConstant: 120).isActive = true
        containerAvatar.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        containerAvatar.addSubview(avatar)
        avatar.centerXAnchor.constraint(equalTo: containerAvatar.centerXAnchor).isActive = true
        avatar.centerYAnchor.constraint(equalTo: containerAvatar.centerYAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 120).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 120).isActive = true
        avatar.layer.cornerRadius = 120/2
        
        addSubview(username)
        username.widthAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        username.heightAnchor.constraint(equalToConstant: 30).isActive = true
        username.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        
        let urlImage = person.picture.large!
        
        if !urlImage.isEmpty, self.imageView?.image == nil
        {
            self.imageView?.setImageFor(url: URL(string: urlImage)!) { [self] image in
                self.avatar.image = image
            }
        }
        
        username.text = "@\(person.login.username)"
        
    }
        
}
