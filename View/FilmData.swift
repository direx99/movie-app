import SwiftUI

class FilmData: ObservableObject {
    @Published var films: [FilmInfo] = []
}
