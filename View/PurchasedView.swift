//
//  PurchasedView.swift
//  AWADMOVIES
//
//  Created by Dinith Hasaranga on 2023-08-10.
//

import SwiftUI

struct PurchasedView: View {
    @ObservedObject var viewModel = FilmViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.films) { film in
                NavigationLink(destination: FilmDetail(film: film)) {
                    Text(film.name)
                    
                }
            }
            .navigationBarTitle("Film List")
        }
    }
}

struct FilmDetail: View {
    var film: Film

    var body: some View {
        VStack {
            Text(film.name)
            Text("Number of Tickets: \(film.numOfTickets)")
            Text("Total Price: \(film.totalPrice)")
        }
        .navigationBarTitle(film.name)
    }
}



struct PurchasedView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasedView()
    }
}
