//
//  CoreDataCustomMigrationApp.swift
//  CoreDataCustomMigration
//
//  Created by Praveen on 2024-05-10.
//

import SwiftUI

@main
struct CoreDataCustomMigrationApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
        .onChange(of: scenePhase, initial: false) { o, newScenePhase in
            switch newScenePhase {
            case .background:
                try? persistenceController.save()
                print("App is in background")
            default: break
            }
        }
    }
}

struct AppTabView: View {

    var body: some View {
        TabView {
            StudentsScreen()
                .tabItem {
                    Label(AppLocalization.students, systemImage: "person")
                }
            CoursesScreen()
                .tabItem {
                    Label(AppLocalization.courses, systemImage: "figure")
                }
        }
    }
}
