//
//  InfoProfileUserCell.swift
//  Dinter
//
//  Created by Luis Segoviano on 17/08/21.
//

import UIKit

class InfoProfileUserCell: BaseTableViewCell {
    
    let info = UILabel()
    
    func setUpView(withInfo information: String) {
        info.translatesAutoresizingMaskIntoConstraints = false
        info.numberOfLines = 0
        info.font = CustomGothamRoundedFont.getRegularFont()
        info.textAlignment = .center
        contentView.addSubview(info)
        
        NSLayoutConstraint.activate([
            info.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            info.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            info.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            info.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        info.text = information
    }
    
    
}
