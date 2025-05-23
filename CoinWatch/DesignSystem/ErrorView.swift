//
//  ErrorView.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import SwiftUI

enum ErrorViewState: Equatable {
    case generic(canRetry: Bool = false)
    case custom(String, canRetry: Bool = false)
    
    static func from(_ error: LocalizedError, canRetry: Bool = false) -> ErrorViewState {
        if let failureReason = error.failureReason {
            .custom(failureReason, canRetry: canRetry)
        } else {
            .generic(canRetry: canRetry)
        }
    }
}

struct ErrorView: View {

    let state: ErrorViewState
    let onTapRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle")
            switch state {
            case .generic:
                Text("Something Went Wrong")
            case .custom(let errorText, _):
                Text(errorText)
            }
            switch state {
            case .generic(let canRetry), .custom(_, let canRetry):
                if canRetry {
                    retryButton
                }
            }
        }
        .foregroundStyle(.red)
    }

    private var retryButton: some View {
        Button(action: onTapRetry) {
            Text("Tap To Retry")
                .bold()
        }
        .buttonStyle(.bordered)
        .tint(.red)
    }
}

#Preview {
    ErrorView(state: .generic()) {
        
    }
}
