//
//  Endpoint.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import Foundation

private extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        let url_base = "https://randomuser.me/"
        return URL(string: url_base + endpoint)!
    }
}



enum Endpoint {
    case person
}


extension Endpoint {
    
    var url: URL {
        switch self {
        
        case .person:
            return .makeForEndpoint("api/")
            
        }
    }
    
}



