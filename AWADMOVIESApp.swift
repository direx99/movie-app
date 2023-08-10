//
//  AWADMOVIESApp.swift
//  AWADMOVIES
//
//  Created by Dinith Hasaranga on 2023-08-06.
//

import SwiftUI
import Firebase

@main

// Define your FilmInfo and FilmData classes here

// ...

struct YourApp: App {
    init() {
            FirebaseApp.configure() // Initialize Firebase
        }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


// ...

// The rest of your code remains unchanged

