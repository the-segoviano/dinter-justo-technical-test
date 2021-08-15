//
//  RequestManager.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import Foundation

class RequestManager {
    
    class func fetchRandomPerson(reference: UIViewController,
                                  completion: @escaping (Result<RandomPerson, Error>) -> ()
    ){
        HTTPRequestHandler.sharedInstance.fetchDataRequest(url: Endpoint.person.url,
                                                           method: HTTPMethod.GET,
                                                           reference: reference)
        { result in
            switch result {
            case .success(let dataPerson):
                do {
                    let jsonDecoder = JSONDecoder()
                    let personResponse = try jsonDecoder.decode(RandomPerson.self, from: dataPerson)
                    completion(.success(personResponse))
                }
                catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
