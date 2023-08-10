//
//  FilmModelView.swift
//  AWADMOVIES
//
//  Created by Dinith Hasaranga on 2023-08-10.
//

import FirebaseFirestore
import Combine

// Define attributes in purchased films in Firestore
struct Film: Identifiable {
    var id: String
    var name: String
    var numOfTickets: Int
    var totalPrice: Int
}



class FilmViewModel: ObservableObject {
    
    @Published var films: [Film] = []

    private var cancellables: Set<AnyCancellable> = []
    private var listener: ListenerRegistration?
    
    private var timer: Timer?

    init() {
        setupTimer()
        fetchFilms()
    }
    
    
    // Timer is used for fetch new data always
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.fetchFilms()
        }
    }

    // Fetch firestore data
    private func fetchFilms() {
        
        // Define db
        let db = Firestore.firestore()
        
        // Define Collecetion (Name : "films")
        let filmCollection = db.collection("films")
        
        listener?.remove() // Remove previous listener

        listener = filmCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                return
            }
            
            self.films = documents.compactMap { document in
                let id = document.documentID

                guard
                    // Bind firebase data with Film Model
                    let name = document["name"] as? String,
                    let numOfTickets = document["numOfTickets"] as? Int,
                    let totalPrice = document["totalPrice"] as? Int
                else {
                    return nil
                }
                
                // resturn film data (purchased)
                return Film(id: id, name: name, numOfTickets: numOfTickets, totalPrice: totalPrice)
            }
        }
    }

    deinit {
        timer?.invalidate()
        listener?.remove()
    }
}
