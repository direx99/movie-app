import SwiftUI
import Foundation

class HomeModelView: ObservableObject {
   
    // Get Results as movieResult from Movieresilt in Model Group
    @Published var movieResult = [Result]()
   
    // The provided api url to fetch data
    let urlString = "https://api.themoviedb.org/3/movie/now_playing?language=en-US"
    
    init() {
        // run fetch data func
        fetchRedditPostData()
    }
    
    // Define fetch data func
    func fetchRedditPostData() {
        
        // Define headers of http request
        let headers = [
            "accept": "application/json",
            
            // API Access key
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZTRiYWQ5NTgxNjQ2YjZmZWNiNDVkMDgzMzBmOGI4NiIsInN1YiI6IjY0Y2Y0M2Q1NmQ0Yzk3MDBlYzU3Y2I3ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nX1vTgK02QJAUn1ZdOHZkH52rOPk6UEulGUq2JJWOZ8"
        ]

        guard let url = URL(string: urlString) else { return }
        
        // Define http req
        var request = URLRequest(url: url)
        
        // Define Method of http request (GET method)
        request.httpMethod = "GET"
        
        // Define headers of http request
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Debug: Error \(error.localizedDescription)")
                return
            }

            if let response = response as? HTTPURLResponse {
                print("Debug: Response code \(response.statusCode)")
            }

            guard let data = data else { return }

            // Print the raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Debug: Raw JSON Response:")
                print(jsonString)
            }

            do {
                let jsonData = try JSONDecoder().decode(Movies.self, from: data)
                let movieResults = jsonData.results
                DispatchQueue.main.async {
                    self.movieResult = movieResults
                    print("Debug: Fetched Reddit posts successfully.")
                }
            } catch let error {
                print("Debug: Error \(error)")
            }
        }.resume()
    }

   
    

}
