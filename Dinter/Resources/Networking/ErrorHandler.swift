//
//  ErrorHandler.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import Foundation

class ErrorHandler {
    class func getErrorByCode(code errorCode: Int) -> RequestErrors {
        switch errorCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 415:
            return .unsuppotedURLOrMediaType
        case 500:
            return .serverError
        case 501:
            return .notImplemented
        case 502:
            return .badGateway
        case 503:
            return .serviceUnavailable
        case 504:
            return .gatewayTimeout
        case 505:
            return .versionNotSupported
        case -1009:
            return .connectionError
        case -1001:
            return .timeOutError
        default:
            return .unknownError
        }
    }
}
