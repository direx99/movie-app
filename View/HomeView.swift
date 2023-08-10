//
//  HomeView.swift
//  AWADMOVIES
//
//  Created by Dinith Hasaranga on 2023-08-06.
//


import SwiftUI
import SDWebImageSwiftUI
import Firebase

var MyFilmsData: [FilmInfo] = [] // Array to store film information


struct HomeView: View {

    @StateObject var viewModel: HomeModelView
    @State private var showingMyFilms = false
    // State to control the presentation of MyFilms view
    
    var body: some View {
        NavigationStack{
            VStack {
                ScrollView {
                    HStack{
                        Text("Now Showing")
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                        Spacer()
                        
                        
                        
                    }
                    // Show the movie results
                    CardView(viewModel: viewModel, redditPost:Result(id: 0, backdropPath: "", genreIDS: [0], originalLanguage:"en",  originalTitle: "", overview: "", popularity: 0, posterPath: "", releaseDate: "", title: "", video: true, voteAverage: 0, voteCount: 10) )
                    
                }
                
                
            }
            .padding()
            
            
        }
        
    }
}


struct CardView : View{
    // Add a property to hold the base URL for images from TMDB
    let tmdbImageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    // fetch homemodelview for fetch api get results
    @StateObject var viewModel: HomeModelView
    
    // Define fetched results in Result in the Model
    var redditPost : Result
    
    
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                
                ForEach(viewModel.movieResult) { results in
                    NavigationLink(destination: DetailView(results: results)) { //
                        VStack(){
                            WebImage(url: URL(string: "\(tmdbImageBaseURL)\(results.posterPath)"))
                                .resizable()
                                .placeholder(Image(systemName: "photo")) // Placeholder image while loading
                                .indicator(.activity) // Activity indicator while loading
                                .transition(.fade(duration: 0.5)) // Fade-in animation
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .frame(width: 100)
                            
                            Text(results.title)
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Text(results.releaseDate)
                                .frame(height: 20)
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .padding(.top,-12)
                                .opacity(0.7)
                            
                        }
                        .padding(.top)
                        
                    }
                }
            }
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView( viewModel: HomeModelView())
    }
}


struct DetailView: View {
    
    // Retrieve isLoggedIn from UserDefaults
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    let tmdbImageBaseURL = "https://image.tmdb.org/t/p/w500"
    var results : Result
    
    
    @State private var isBottomSheetPresented = false
    
    
    var body: some View {
        VStack{
            ScrollView{
                
                
                
                
                WebImage(url: URL(string: "\(tmdbImageBaseURL)\(results.backdropPath)"))
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .padding(.top,-100)
                VStack(alignment: .leading){
                    
                    
                    
                    Text(results.originalTitle)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(.top)
                        .padding(.bottom,5)
                    Text("Released on \(String(results.releaseDate)) ") // Convert results.voteCount to String
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .padding(.top,-5)
                        .opacity(0.8)
                    HStack{
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                            .fontWeight(.semibold)
                        
                        Text(String(results.voteAverage )) // Convert results.voteCount to String
                            .font(.system(size: 25))
                            .padding(.leading,-3)
                            .fontWeight(.medium)
                        
                        
                        
                        
                        Text("( \(String(results.voteCount ?? 0)) Reviews )") // Convert results.voteCount to String
                            .font(.system(size: 16))
                            .padding(.leading,5)
                            .fontWeight(.medium)
                            .opacity(0.6)
                        
                        
                    }
                    .padding(.top,10)
                    
                    
                    
                    Text(results.overview)
                        .font(.system(size: 13))
                        .opacity(0.7)
                        .padding(.top,10)
                    
                }
                .padding(.horizontal)
                
            }
            
            Spacer()
            if(isLoggedIn==true){
                
                HStack{
                    
                    Button(action: {
                        isBottomSheetPresented.toggle()
                        
                        // Create a FilmInfo object with film name and selected ticket count
                        
                        
                    }) {
                        Text("Buy tickets")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .frame(height: 50)                        .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(100)
                    }
                    .sheet(isPresented: $isBottomSheetPresented, content: {
                        BottomSheetView(dismissAction: {
                            isBottomSheetPresented.toggle() // Dismiss the bottom sheet when the action is called
                        }, results: results)
                        .presentationDetents([.height(400)])
                        
                        
                        
                        
                    }
                           
                           
                    )
                    
                }
                .padding()
            }
            else{
                NavigationLink(destination: LoginView()) {

                    HStack{
                        
                        
                        Text("Login to buy tickets")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .frame(height: 50)                        .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(100)
                        
                        
                        
                        
                    }
                        
                    
                           
                           
                    
                    
                }
            }
        }
        .blur(radius: isBottomSheetPresented ? 20:0)
        // blur when open the sheet
        
        
        
    }
}
struct FilmInfo {
    var name: String
    var numOfTickets: Int
    var totalPrice: Int

}

    struct MyFilms: View {
        var films: [FilmInfo] // Pass the MyFilmsData array to the view

        var body: some View {
            NavigationView {
                List(films, id: \.name) { film in
                    VStack(alignment: .leading) {
                        Text(film.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        HStack {
                            Text("Number of Tickets: \(film.numOfTickets)")
                                .font(.subheadline)
                            Spacer()
                            Text("Amount: \(film.totalPrice)")
                                .font(.subheadline)
                        }
                        .foregroundColor(.gray)
                    }
                }
                .navigationTitle("My Films")
            }
        }
    
}
struct BottomSheetView: View {
    var dismissAction: () -> Void // A closure to dismiss the bottom sheet

    var results : Result
    @State private var numOfTickets = 1
    @State private var tax = 2
    @State private var showAlert = false // State variable to control the alert

    @State private var eachPrice = 20 // Default number of tickets
    private var totalPrice: Int {
        return (eachPrice * numOfTickets) + ( tax * numOfTickets)
    }
    private var totalTax: Int {
        return ( tax * numOfTickets)
    }

    
    @State private var isBottomSheetPresented = false
    
    
    var body: some View {
        VStack {
            Text(results.originalTitle)
                .foregroundColor(.white)
                .padding()
                .font(.system(size: 30))
                .fontWeight(.semibold)
            VStack(spacing: 10){
                HStack{
                    Text("Num Of Tickets")
                        .font(.system(size: 15))

                    Spacer()
                    HStack{
                        Button(action: {
                            if numOfTickets>1{
                                numOfTickets=numOfTickets-1
                            }
                        }, label: {
                            Image(systemName: "arrowtriangle.down.square.fill")
                                .font(.system(size: 15))
                        })
                        
                        Text(String(numOfTickets))
                            .font(.system(size: 15))
                            .frame(width: 20)
                        Button(action: {
                            numOfTickets=numOfTickets+1
                        }, label: {
                            Image(systemName: "arrowtriangle.up.square.fill")
                                .font(.system(size: 15))
                        })
                    }
                    
                    
                }
                HStack{
                    Text("Ticket Price")
                        .font(.system(size: 15))

                    Spacer()
                    
                        
                        Text("$ \(String(eachPrice)).00")
                            .font(.system(size: 15))
                        
                    
                    
                    
                }
                HStack{
                    Text("Tax")
                        .font(.system(size: 15))

                    Spacer()
                    
                        
                        Text("$ \(String(totalTax)).00")
                            .font(.system(size: 15))
                            .foregroundColor(.red)

                        
                    
                    
                    
                }
                HStack{
                    Text("Total Price")
                        .font(.system(size: 15))

                    Spacer()
                    
                    Text("$ \(String(totalPrice)).00")
                            .font(.system(size: 25))
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    
                        
                    
                    
                }
            }
            .padding(.horizontal)
            Spacer()
            Button(action: {
                
                // Create a FilmInfo object with film name and selected ticket count
                let filmInfo = FilmInfo(name: results.title, numOfTickets: numOfTickets,totalPrice: totalPrice)
                MyFilmsData.append(filmInfo) // Add the filmInfo object to MyFilmsData array
                
                
                // Send data to Firestore
                let db = Firestore.firestore()
                let filmCollection = db.collection("films")
                filmCollection.addDocument(data: [
                    "name": filmInfo.name,
                    "numOfTickets": filmInfo.numOfTickets,
                    "totalPrice": filmInfo.totalPrice
                ]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added to Firestore with automatically generated ID")
                    }
                }

                                
                                showAlert = true
                showAlert = true


                
            }) {
                Text("Confim")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .frame(height: 50)                        .padding(.horizontal)
                    .background(Color.blue)
                    .cornerRadius(100)
            }
            .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Sucessful"),
                                message: Text("You have made suceessful purchase. Thank you !"),
                                dismissButton: .default(Text("OK")) {
                                    // Call the dismiss action to dismiss the bottom sheet after the alert is dismissed

                                    dismissAction()
                                }
                            )
                        }
            
        }
        .cornerRadius(10)
        .padding()
    }
    
    private func dismiss() {
        // You can add any dismiss logic you want here
    }
}


struct MyFilmsView: View {
    var films: [FilmInfo]
    
    var body: some View {
        MyFilms(films: MyFilmsData)
    }
    
}
