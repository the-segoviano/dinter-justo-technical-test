//
//  ProfileUserViewController.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import UIKit


enum ProfileSections: CaseIterable {
    case description, location
}


class ProfileUserViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .mercury
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: "BaseTableViewCell")
        tableView.register(AvatarCell.self, forCellReuseIdentifier: "AvatarCell")
        tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "CustomHeader")
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .mercury
        
        setupTableView()
        
        fetchRandomPerson()
        
    }
    
    
    private func setupTableView()
    {
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func fetchRandomPerson()
    {
        RequestManager.fetchRandomPerson(reference: self) { [weak self] result in
            guard let reference = self else {
                return
            }
            switch result {
            case .success(let personResponse):
                DispatchQueue.main.async {
                    
                    if let newPerson = personResponse.results.first {
                        print(" newPerson ", newPerson, "\n")
                    }
                    
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.showErrorRequestAlert(on: reference,
                                                withMessage: error.localizedDescription)
                }
            }
        }
    } // [END] fetchRandomPerson

}


extension ProfileUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return ProfileSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(" indexPath.section ", indexPath.section)
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarCell", for: indexPath)
            if let cell = cell as? AvatarCell {
                cell.setUpView(urlImage: "https://i.pinimg.com/originals/6a/9b/37/6a9b370bc7ea40db36b282c0ec9a6f6e.jpg")
                return cell
            }
        }
        
        if indexPath.section == 1 {
            let section = ProfileSections.allCases[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 240
        }
        
        if indexPath.section == 1 {
            let section = ProfileSections.allCases[indexPath.row]
        }
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! CustomHeader
       return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
}






