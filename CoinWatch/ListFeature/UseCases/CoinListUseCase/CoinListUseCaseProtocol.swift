//
//  CoinListUseCaseProtocol.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Combine

protocol CoinListUseCaseProtocol {

    var statePublisher: AnyPublisher<CoinListStates, Never> { get }

    func initialize()
    
    func retry() async throws
}
