//
//  WorkersGeneratorApp.swift
//  WorkersGenerator
//
//  Created by Timur Murzakov on 06/09/2023.
//

import SwiftUI

@main
struct WorkersGeneratorApp: App {
    @State private var settingor = Settingor()
    
    var body: some Scene {
        WindowGroup {
            EditorView(settingor: $settingor)
        }
    }
}
