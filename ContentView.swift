//
//  ContentView.swift
//  AWADMOVIES
//
//  Created by Dinith Hasaranga on 2023-08-06.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @StateObject var viewModel: HomeModelView = HomeModelView() // Initialize your view model here
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel) // Your existing HomeView
                .tabItem {
                    Label("Now Showing", systemImage: "house")
                }
            if (isLoggedIn==true){
                PurchasedView() // New MyFilmsView for the "Fav" tab
                    .tabItem {
                        Label("Purchased", systemImage: "film")
                    
                        
                    }
            }
           
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

