import SwiftUI

class TabModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var webViewModel: WebViewModel
    @Published var urlString: String

    init(urlString: String) {
        self.urlString = urlString
        self.webViewModel = WebViewModel()
        self.webViewModel.load(urlString: urlString)
    }
}
