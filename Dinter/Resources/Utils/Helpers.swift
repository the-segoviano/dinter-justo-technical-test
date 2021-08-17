//
//  Helpers.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import UIKit

struct CustomGothamRoundedFont {
    
    static func getRegularFont(withSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "GothamRounded-Book", size: size)!
    }
    
    static func getLightFont(withSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "GothamRounded-Light", size: size)!
    }
    
    static func getBoldFont(withSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "GothamRounded-Bold", size: size)!
    }
    
    static func getLightFontItalic(withSize size: CGFloat = 16) -> UIFont {
        return UIFont(name: "GothamRounded-LightItalic", size: size)!
    }
    
}



extension UIImageView {
    
    func setImageFor(url :URL, completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image!)
                }
            }
        }
    }
    
}



class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError(" Error to initialize ")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}




class CustomHeader: UITableViewHeaderFooterView {
    
    let title = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)

        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            title.heightAnchor.constraint(equalToConstant: 30),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}



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
    
    func setUpView(urlImage: String) {
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
        
        if !urlImage.isEmpty, self.imageView?.image == nil
        {
            self.imageView?.setImageFor(url: URL(string: urlImage)!) { [self] image in
                self.avatar.image = image
            }
        }
    }
    
    
}
