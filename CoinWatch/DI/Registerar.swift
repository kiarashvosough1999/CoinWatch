//
//  Registerar.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import Resolver

extension Resolver: @retroactive ResolverRegistering {
    
    public static func registerAllServices() {
        register(CoinDetailUseCaseProtocol.self) { (resolver: Resolver, args: Resolver.Args) in
            CoinDetailUseCaseStub(state: args())
        }

        register(CoinListUseCaseProtocol.self) { (resolver: Resolver, args: Resolver.Args) in
            CoinListUseCaseStub(state: args())
        }
    }
}
