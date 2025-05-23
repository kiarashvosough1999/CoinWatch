//
//  WithDepedencies.swift
//  CoinWatch
//
//  Created by Kiarash Vosough on 23.05.25.
//

import SwiftUI
import Resolver

struct WithDepedencies<C: View>: View {

    private let content: () -> C

    init(register: () -> Void, content: @escaping () -> C) {
        register()
        self.content = content
    }

    var body: some View {
        content()
    }
}
