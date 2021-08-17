//
//  UIImageView+ext.swift
//  Dinter
//
//  Created by Luis Segoviano on 17/08/21.
//

import UIKit

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
