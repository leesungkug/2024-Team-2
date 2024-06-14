//
//  newCardView.swift
//  13jo
//
//  Created by Shim Hyeonhee on 6/15/24.
//
import SwiftUI
import SwiftData

@available(iOS 17, *)
//@main
struct newCardApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([newCard.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            CardDetailView()
                .modelContainer(modelContainer)
        }
    }
}
