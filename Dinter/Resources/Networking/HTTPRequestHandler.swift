//
//  HTTPRequestHandler.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import Foundation


/*
 * Class: HTTPRequestHandler
 *
 *
 * timeoutIntervalForRequest - The timeout interval to use when waiting for additional data. The timer associated with this value is reset whenever new data arrives. When the request timer reaches the specified interval without receiving any new data, it triggers a timeout.
 *
 * timeoutIntervalForResource - The maximum amount of time that a resource request should be allowed to take. This value controls how long to wait for an entire resource to transfer before giving up. The resource timer starts when the request is initiated and counts until either the request completes or this timeout interval is reached, whichever comes first.
 *
 */
final class HTTPRequestHandler {
    
    private init() {}
    
    static let sharedInstance = HTTPRequestHandler()
    
    let timeOut: TimeInterval = TimeInterval(30)
    
    lazy var urlSessionConfiguration: URLSessionConfiguration = {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.httpCookieStorage = nil
        urlSessionConfiguration.timeoutIntervalForRequest = timeOut
        urlSessionConfiguration.timeoutIntervalForResource = timeOut
        return urlSessionConfiguration
    }()
    
    /*
     * Ejecuta la peticion solicitada.
     *
     * Retorna un error o un resultado de tipo Data
     *
     */
    func fetchDataRequest(url: URL, method: HTTPMethod, paramsURL: [String: String] = [:],
                          paramsBody: [String: Any] = [:],
                          reference viewController: UIViewController,
                          completion: @escaping (Result<Data, Error>) -> ()) {
        print(" url ", url)
        
        var request: URLRequest  = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeOut
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json; charset=utf-8"
        request.allHTTPHeaderFields = headers
        
        let session: URLSession = URLSession(configuration: urlSessionConfiguration)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(.failure(ErrorHandler.getErrorByCode(code: httpStatus.statusCode)))
                return
            }
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    
    /*
     * FORMATEA UNA URL CON PARAMETROS A ENVIAR POR GET.
     *
     */
    static func buildQueryString(fromDictionary parameters: [String: String]) -> String {
        var urlVars:[String] = []
        for (k,value) in parameters {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) {
                urlVars.append(k + "=" + encodedValue)
            }
        }
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
    
}


enum UnknowError: Error {
    case unknowError(String)
}
