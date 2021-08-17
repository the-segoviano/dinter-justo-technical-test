//
//  ProfileUserViewController.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import UIKit


enum ProfileSections: CaseIterable {
    case name, birthday, email, phoneNumber, address
}


class ProfileUserViewController: UIViewController {
    
    var person: Persona?
    
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
        tableView.register(InfoProfileUserCell.self, forCellReuseIdentifier: "InfoProfileUserCell")
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mercury
        
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
                        reference.setupTableView()
                        reference.person = newPerson
                        reference.tableView.reloadData()
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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarCell", for: indexPath)
            if let cell = cell as? AvatarCell {
                if let person = person {
                    cell.setUpView(person: person)
                    return cell
                }
            }
        }
        
        if indexPath.section == 1 {
            let sectionProfile = ProfileSections.allCases[indexPath.row]
            
            if sectionProfile == .name{
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoProfileUserCell", for: indexPath)
                if let cell = cell as? InfoProfileUserCell {
                    if let person = person {
                        let fullName = "\(person.name.first!) \(person.name.last!)"
                        cell.setUpView(withInfo: fullName)
                        cell.info.font = CustomGothamRoundedFont.getBoldFont()
                        return cell
                    }
                }
            }
            
            if sectionProfile == .birthday {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoProfileUserCell", for: indexPath)
                if let cell = cell as? InfoProfileUserCell {
                    if let person = person {
                        if let currentDate: Date = person.dob.date.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ") {
                            let dateFormat = DateFormatter()
                            dateFormat.dateFormat = "EEEE dd MMMM, yyyy"
                            dateFormat.locale = Locale(identifier: "es_MX")
                            dateFormat.timeZone = TimeZone(identifier: "UTC")! //TimeZone.current
                            let date = dateFormat.string(from: currentDate)
                            let birthday = "\(person.dob.age), \(date) "
                            cell.setUpView(withInfo: birthday)
                            return cell
                        }
                    }
                }
            }
            
            if sectionProfile == .email {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoProfileUserCell", for: indexPath)
                if let cell = cell as? InfoProfileUserCell {
                    if let person = person {
                        cell.setUpView(withInfo: person.email)
                        return cell
                    }
                }
            }
            
            if sectionProfile == .phoneNumber {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoProfileUserCell", for: indexPath)
                if let cell = cell as? InfoProfileUserCell {
                    if let person = person {
                        cell.setUpView(withInfo: "cel. \(person.phone)")
                        return cell
                    }
                }
            }
            
            
            if sectionProfile == .address {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoProfileUserCell", for: indexPath)
                if let cell = cell as? InfoProfileUserCell {
                    if let person = person {
                        let fullAddress = "\(person.location.street.name), \(person.location.city), \(person.location.country)"
                        cell.setUpView(withInfo: fullAddress)
                        return cell
                    }
                }
            }
            
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
            return 45
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






