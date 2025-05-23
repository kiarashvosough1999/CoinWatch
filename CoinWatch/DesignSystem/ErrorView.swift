//
//  ErrorView.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import SwiftUI

struct ErrorView: View {

    let errorText: String?
    let onTapRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle")
            Text(errorText ?? "Something Went Wrong")
            Button(action: onTapRetry) {
                VStack(spacing: 8) {

                    Text("Tap To Retry")
                        .bold()
                }
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
        .foregroundStyle(.red)
    }
}

#Preview {
    ErrorView(errorText: nil) {
        
    }
}
