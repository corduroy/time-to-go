//
//  Time_To_GoApp.swift
//  Time To Go
//
//  Created by Joshua McKinnon on 2/7/2022.
//

import SwiftUI

@main
struct Time_To_GoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
