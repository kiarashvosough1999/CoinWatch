//
//  CoinWatchApp.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import SwiftUI

@main
struct CoinWatchApp: App {
    
    private var isNonTestEnvironMent: Bool {
        NSClassFromString("XCTestCase") == nil
    }

    var body: some Scene {
        WindowGroup {
            if isNonTestEnvironMent {
                NavigationStack {
                    CoinListView()
                        .navigationDestination(for: Date.self) { date in
                            CoinDetailsView(date: date)
                        }
                }
            }
        }
    }
}
