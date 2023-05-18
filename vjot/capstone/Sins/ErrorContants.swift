//
//  ErrorContants.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 12/4/23.
//

import Foundation

// <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
// <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>< MARK: ERRORS
// <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
// https://stackoverflow.com/questions/74303070/swiftui-custom-error-with-additional-detail-for-support-tracking
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses
// https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
// https://www.advancedswift.com/custom-errors-in-swift/
// https://www.rfc-editor.org/rfc/rfc9110.html
// https://datatracker.ietf.org/doc/html/rfc6585
// https://www.rfc-editor.org/rfc/rfc7725.html

// 1xx: Informational - Request received, continuing process
// 2xx: Success - The action was successfully received, understood, and accepted
// 3xx: Redirection - Further action must be taken in order to complete the request
// 4xx: Client Error - The request contains bad syntax or cannot be fulfilled
// 5xx: Server Error - The server failed to fulfill an apparently valid request

enum VJotError : Error {
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case error(Error)        // CONVERT
    // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case badRequest400
    case unauthorized401
    case paymentRequired402
    case forbidden403
    case notFound404
    case methodNotAllowed405
    case notAcceptable406
    case proxyAuthenticationRequired407
    case requestTimeout408
    case conflict409
    case gone410
    case lengthRequired411
    case preconditionFailed412
    case contentTooLarge413
    case uriTooLong414
    case unsupportedMediaType415
    case rangeNotSatisfiable416
    case expectationFailed417
    case iMATeapot418
    case misdirectedRequest421
    case unprocessableContent422
    case upgradeRequired426
    case preconditionRequired428
    // ////////////////////////////////////////////////////////////////
    // ////////////////////////////////////////////////////////////////
    // ////////////////////////////////////////////////////////////////
    case tooManyRequests429                                   // CUSTOM
    // ////////////////////////////////////////////////////////////////
    // ////////////////////////////////////////////////////////////////
    // ////////////////////////////////////////////////////////////////
    case requestHeaderFieldsTooLarge431
    case unavailableForLegalReasons451
    // --------------------------------
    case notImplemented501
    case badGateway502
    case serviceUnaivalable503
    case gatewayTimout504
    case httpVersionNotSupported505
    // --------------------------------
    // ++++++++++++++++++++++++++++++++
    case unexpected(code: Int) // OTHER
    // ++++++++++++++++++++++++++++++++
    case id
}

extension VJotError {
    var isFatal: Bool {
        if case VJotError.unexpected = self { return true }
        else { return false }
    }
}

extension VJotError: CustomStringConvertible {
    var description: String {
        switch self {
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .error(let error):
            return error.localizedDescription
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .badRequest400:
            return "Bad Request"
        case .unauthorized401:
            return "Unauthorized"
        case .paymentRequired402:
            return "Payment Required"
        case .forbidden403:
            return "Forbidden"
        case .notFound404:
            return "Not Found"
        case .methodNotAllowed405:
            return "Method Not Allowed"
        case .notAcceptable406:
            return "Not Acceptable"
        case .proxyAuthenticationRequired407:
            return "Proxy Authentication Required"
        case .requestTimeout408:
            return "Request Timeout"
        case .conflict409:
            return "Conflict"
        case .gone410:
            return "Gone"
        case .lengthRequired411:
            return "Length Required"
        case .preconditionFailed412:
            return "Precondition Failed"
        case .contentTooLarge413:
            return "Content Too Large"
        case .uriTooLong414:
            return "URI Too Long"
        case .unsupportedMediaType415:
            return "Unsupported Media Type"
        case .rangeNotSatisfiable416:
            return "Range Not Satisfiable"
        case .expectationFailed417:
            return "Expectation Failed"
        case .iMATeapot418:
            return "I'm a teapot"
        case .misdirectedRequest421:
            return "Misdirected Request"
        case .unprocessableContent422:
            return "Unprocessable Content"
        case .upgradeRequired426:
            return "Upgrade Required"
        case .preconditionRequired428:
            return "Precondition Required"
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
        case .tooManyRequests429:
            return "Too Many Requests"
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
        case .requestHeaderFieldsTooLarge431:
            return "Request Header Fields Too Large"
        case .unavailableForLegalReasons451:
            return "Unavailable For Legal Reasons"
            // --------------------------------
        case .notImplemented501:
            return "Not Implemented"
        case .badGateway502:
            return "Bad Gateway"
        case .serviceUnaivalable503:
            return "Service Unaivailable"
        case .gatewayTimout504:
            return "Gateway Timout"
        case .httpVersionNotSupported505:
            return "HTTP Version Not Supported"
            // --------------------------------
            // ++++++++++++++++++++++++++++++++
        case .unexpected(_):
            return "An Unexpected Error Occurred"
            // ++++++++++++++++++++++++++++++++
        case .id:
            return #"¯\_(ツ)_/¯"#
        }
    }
}


extension VJotError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .error(let error):
            return NSLocalizedString(
                error.localizedDescription,
                comment: error.localizedDescription
            )
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .badRequest400:
            return NSLocalizedString(
                "Bad Request",
                comment: "400 Bad Request"
            )
        case .unauthorized401:
            return NSLocalizedString(
                "Unauthorized",
                comment: "401 Unauthorized"
            )
        case .paymentRequired402:
            return NSLocalizedString(
                "Payment Required",
                comment: "402 Payment Required"
            )
        case .forbidden403:
            return NSLocalizedString(
                "Forbidden",
                comment: "403 Forbidden"
            )
        case .notFound404:
            return NSLocalizedString(
                "Not Found",
                comment: "404 Not Found"
            )
        case .methodNotAllowed405:
            return NSLocalizedString(
                "Method Not Allowed",
                comment: "405 Method Not Allowed"
            )
        case .notAcceptable406:
            return NSLocalizedString(
                "Not Acceptable",
                comment: "406 Not Acceptable"
            )
        case .proxyAuthenticationRequired407:
            return NSLocalizedString(
                "Proxy Authentication Required",
                comment: "407 Proxy Authentication Required"
            )
        case .requestTimeout408:
            return NSLocalizedString(
                "Request Timeout",
                comment: "408 Request Timeout"
            )
        case .conflict409:
            return NSLocalizedString(
                "Conflict",
                comment: "409 Conflict"
            )
        case .gone410:
            return NSLocalizedString(
                "Gone",
                comment: "410 Gone"
            )
        case .lengthRequired411:
            return NSLocalizedString(
                "Length Required",
                comment: "411 Length Required"
            )
        case .preconditionFailed412:
            return NSLocalizedString(
                "Precondition Failed",
                comment: "412 Precondition Failed"
            )
        case .contentTooLarge413:
            return NSLocalizedString(
                "Content Too Large",
                comment: "413 Content Too Large"
            )
        case .uriTooLong414:
            return NSLocalizedString(
                "URI Too Long",
                comment: "414 URI Too Long"
            )
        case .unsupportedMediaType415:
            return NSLocalizedString(
                "Unsupported Media Type",
                comment: "415 Unsupported Media Type"
            )
        case .rangeNotSatisfiable416:
            return NSLocalizedString(
                "Range Not Satisfiable",
                comment: "416 Range Not Satisfiable"
            )
        case .expectationFailed417:
            return NSLocalizedString(
                "Expectation Failed",
                comment: "417 Expectation Failed"
            )
        case .iMATeapot418:
            return NSLocalizedString(
                "I'm a teapot",
                comment: "418 I'm a teapot"
            )
        case .misdirectedRequest421:
            return NSLocalizedString(
                "Misdirected Request",
                comment: "421 Misdirected Request"
            )
        case .unprocessableContent422:
            return NSLocalizedString(
                "Unprocessable Content",
                comment: "422 Unprocessable Content"
            )
        case .upgradeRequired426:
            return NSLocalizedString(
                "Upgrade Required",
                comment: "426 Upgrade Required"
            )
        case .preconditionRequired428:
            return NSLocalizedString(
                "Precondition Required",
                comment: "428 Precondition Required"
            )
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
        case .tooManyRequests429:
            return NSLocalizedString(
                "Too Many Requests",
                comment: "429 Too Many Requests"
            )
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
        case .requestHeaderFieldsTooLarge431:
            return NSLocalizedString(
                "Request Header Fields Too Large",
                comment: "431 Request Header Fields Too Large"
            )
        case .unavailableForLegalReasons451:
            return NSLocalizedString(
                "Unavailable For Legal Reasons",
                comment: "451 Unavailable For Legal Reasons"
            )
            // ----------------------------
        case .notImplemented501:
            return NSLocalizedString(
                "Not Implemented",
                comment: "501 Not Implemented"
            )
        case .badGateway502:
            return NSLocalizedString(
                "Bad Gateway",
                comment: "502 Bad Gateway"
            )
        case .serviceUnaivalable503:
            return NSLocalizedString(
                "Service Unaivalable",
                comment: "503 Service Unaivalable"
            )
        case .gatewayTimout504:
            return NSLocalizedString(
                "Gateway Timout",
                comment: "504 Gateway Timout"
            )
        case .httpVersionNotSupported505:
            return NSLocalizedString(
                "HTTP Version Not Supported",
                comment: "505 HTTP Version Not Supported"
            )
            // --------------------------------
            // ++++++++++++++++++++++++++++++++
        case .unexpected(_):
            return NSLocalizedString(
                "An Unexpected Error Occurred",
                comment: "Unexpected Error"
            )
            // ++++++++++++++++++++++++++++++++
        case .id:
            return NSLocalizedString(
                #"¯\_(ツ)_/¯"#,
                comment: "Invalid Id"
            )
        }
    }
    
    
    var failureReason: String? {
        switch self {
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .error(let error):
            let nsError = error as NSError
            return nsError.localizedFailureReason
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .badRequest400:
            return "The server cannot or will not process the request due to something that is perceived to be a client error."
        case .unauthorized401:
            return "The request has not been applied because it lacks valid authentication credentials for the target resource."
        case .paymentRequired402:
            return "Reserved for future use."
        case .forbidden403:
            return "The server understood the request but refuses to fulfill it."
        case .notFound404:
            return "The origin server did not find a current representation for the target resource or is not willing to disclose that one exists."
        case .methodNotAllowed405:
            return "The method received in the request-line is known by the origin server but not supported by the target resource."
        case .notAcceptable406:
            return "The target resource does not have a current representation that would be acceptable to the user agent, according to the proactive negotiation header fields received in the request, and the server is unwilling to supply a default representation."
        case .proxyAuthenticationRequired407:
            return "The client needs to authenticate itself in order to use a proxy for this request."
        case .requestTimeout408:
            return "The server did not receive a complete request message within the time that it was prepared to wait."
        case .conflict409:
            return "The request could not be completed due to a conflict with the current state of the target resource."
        case .gone410:
            return "Access to the target resource is no longer available at the origin server and this condition is likely to be permanent."
        case .lengthRequired411:
            return "The server refuses to accept the request without a defined Content-Length."
        case .preconditionFailed412:
            return "One or more conditions given in the request header fields evaluated to false when tested on the server."
        case .contentTooLarge413:
            return "The server is refusing to process a request because the request content is larger than the server is willing or able to process."
        case .uriTooLong414:
            return "The server is refusing to service the request because the target URI is longer than the server is willing to interpret."
        case .unsupportedMediaType415:
            return "The origin server is refusing to service the request because the content is in a format not supported by this method on the target resource."
        case .rangeNotSatisfiable416:
            return "The set of ranges in the request's Range header field has been rejected either because none of the requested ranges are satisfiable or because the client has requested an excessive number of small or overlapping ranges."
        case .expectationFailed417:
            return "The expectation given in the request's Expect header field could not be met by at least one of the inbound servers."
        case .iMATeapot418:
            return "Attempt to brew coffee with a teapot."
        case .misdirectedRequest421:
            return "The request was directed at a server that is unable or unwilling to produce an authoritative response for the target URI."
        case .unprocessableContent422:
            return "The server understands the content type of the request content, and the syntax of the request content is correct, but it was unable to process the contained instructions."
        case .upgradeRequired426:
            return "The server refuses to perform the request using the current protocol but might be willing to do so after the client upgrades to a different protocol."
        case .preconditionRequired428:
            return "The origin server requires the request to be conditional."
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
        case .tooManyRequests429:
            return "The user has sent too many requests in a given amount of time."
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
        case .requestHeaderFieldsTooLarge431:
            return "The server is unwilling to process the request because its header fields are too large."
        case .unavailableForLegalReasons451:
            return "The server is denying access to the resource as a consequence of a legal demand."
            // --------------------------------
        case .notImplemented501:
            return "The server does not support the functionality required to fulfill the request."
        case .badGateway502:
            return "The server, while acting as a gateway or proxy, received an invalid response from an inbound server it accessed while attempting to fulfill the request."
        case .serviceUnaivalable503:
            return "The server is currently unable to handle the request due to a temporary overload or scheduled maintenance, which will likely be alleviated after some delay."
        case .gatewayTimout504:
            return "The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server it needed to access in order to complete the request."
        case .httpVersionNotSupported505:
            return "The server does not support, or refuses to support, the major version of HTTP that was used in the request message."
            // --------------------------------
            // ++++++++++++++++++++++++++++++++
        case .unexpected(_):
            return "Failure Reason Unknown"
            // ++++++++++++++++++++++++++++++++
        case .id:
            return "Cosmic-ray spallations in the atmosphere produce high energy neutrons, and these neutrons wake up an upset of bits on memory devices."
        }
    }
    
    
    // "Anchors allow you to uniquely identify topics in your help book. When a user follows a link to an anchor, Help Viewer loads the page containing the anchor. ... You can also use anchors to load an anchored page from within your application by calling the the NSHelpManager method openHelpAnchor:inBook: ..."
    
    var helpAnchor: String? {
        switch self {
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .error(let error):
            let nsError = error as NSError
            return nsError.helpAnchor
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .unexpected(_):
            return nil
            // ++++++++++++++++++++++++++++++++
        case .id:
            return nil
        default:
            return nil
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case .error(let error):
            let nsError = error as NSError
            return nsError.localizedRecoverySuggestion
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
        case .tooManyRequests429:
            return "The server is currently unable to handle the request due to a temporary overload or scheduled maintenance, which will likely be alleviated after some delay."
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ////////////////////////////////////////////////////////////////
            // ++++++++++++++++++++++++++++++++
        case .unexpected(_):
            return nil
            // ++++++++++++++++++++++++++++++++
        case .id:
            return nil
        default:
            return nil
        }
    }
}


