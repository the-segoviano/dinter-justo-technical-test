//
//  ProfileUserViewController.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import UIKit

class ProfileUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        let label = UILabel()
        label.font = CustomGothamRoundedFont.getRegularFont()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Profile"
        label.textAlignment = .center
        self.view.addSubview(label)
        label.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }

}
