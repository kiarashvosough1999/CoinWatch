//
//  MockError.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import Foundation

enum MockError: LocalizedError {

    case testFailure
    case networkError

    var failureReason: String? { "Test failure" }
}
