//
//  CoinDetailUseCaseProtocol.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Combine
import Foundation

protocol CoinDetailUseCaseProtocol {

    var statePublisher: AnyPublisher<CoinDetailStates, Never> { get }

    func initialize(date: Date)
}
