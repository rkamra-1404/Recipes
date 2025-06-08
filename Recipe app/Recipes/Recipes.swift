//
//  Recipe_appApp.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/1/25.
//

import SwiftUI

@main
struct RecipeListApp: App {
    var body: some Scene {
        WindowGroup {
            if isProduction {
                ContentView()
            }
        }
    }

    private var isProduction: Bool {
            NSClassFromString("XCTestCase") == nil
        }
}
