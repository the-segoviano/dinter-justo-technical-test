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

/*
class Person: NSObject {
    
    let Name: NSString
    let Image: UIImage!
    let Age: NSNumber
    let NumberOfSharedFriends: NSNumber?
    let NumberOfSharedInterests: NSNumber
    let NumberOfPhotos: NSNumber
    
    override var description: String {
        return "Name: \(Name), \n Image: \(Image), \n Age: \(Age) \n NumberOfSharedFriends: \(NumberOfSharedFriends) \n NumberOfSharedInterests: \(NumberOfSharedInterests) \n NumberOfPhotos/: \(NumberOfPhotos)"
    }
    
    init(name: NSString?, image: UIImage?, age: NSNumber?, sharedFriends: NSNumber?, sharedInterest: NSNumber?, photos:NSNumber?) {
        self.Name = name ?? ""
        self.Image = image
        self.Age = age ?? 0
        self.NumberOfSharedFriends = sharedFriends ?? 0
        self.NumberOfSharedInterests = sharedInterest ?? 0
        self.NumberOfPhotos = photos ?? 0
    }
}*/

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

