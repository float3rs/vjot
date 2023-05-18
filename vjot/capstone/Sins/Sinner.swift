//
//  Sinner.swift
//  Saridakis-vjot
//
//  Created by Nikolaos Saridakis on 14/4/23.
//

import Foundation

func err(statusCode: Int) -> LocalizedError? {
    switch statusCode {
    case 400:
        return VJotError.badRequest400
    case 401:
        return VJotError.unauthorized401
    case 402:
        return VJotError.paymentRequired402
    case 403:
        return VJotError.forbidden403
    case 404:
        return VJotError.notFound404
    case 405:
        return VJotError.methodNotAllowed405
    case 406:
        return VJotError.notAcceptable406
    case 407:
        return VJotError.proxyAuthenticationRequired407
    case 408:
        return VJotError.requestTimeout408
    case 409:
        return VJotError.conflict409
    case 410:
        return VJotError.gone410
    case 411:
        return VJotError.lengthRequired411
    case 412:
        return VJotError.preconditionFailed412
    case 413:
        return VJotError.contentTooLarge413
    case 414:
        return VJotError.uriTooLong414
    case 415:
        return VJotError.unsupportedMediaType415
    case 416:
        return VJotError.rangeNotSatisfiable416
    case 417:
        return VJotError.expectationFailed417
    case 418:
        return VJotError.iMATeapot418
    case 421:
        return VJotError.misdirectedRequest421
    case 422:
        return VJotError.unprocessableContent422
    case 426:
        return VJotError.upgradeRequired426
    case 428:
        return VJotError.preconditionRequired428
    case 429:
        return VJotError.tooManyRequests429                 // CUSTOM
    case 431:
        return VJotError.requestHeaderFieldsTooLarge431
    case 451:
        return VJotError.unavailableForLegalReasons451
    case 501:
        return VJotError.notImplemented501
    case 502:
        return VJotError.badGateway502
    case 503:
        return VJotError.serviceUnaivalable503
    case 504:
        return VJotError.gatewayTimout504
    case 505:
        return VJotError.httpVersionNotSupported505
    default:
        return nil
    }
}
