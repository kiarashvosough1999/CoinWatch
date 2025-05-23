//
//  CoinWatchApp.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 21.05.25.
//

import SwiftUI

@main
struct CoinWatchApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CoinListView()
                    .navigationDestination(for: Date.self) { date in
                        CoinDetailsView(date: date)
                    }
            }
        }
    }
}
