//
//  String+ext.swift
//  Dinter
//
//  Created by Luis Segoviano on 17/08/21.
//

import Foundation

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
}
