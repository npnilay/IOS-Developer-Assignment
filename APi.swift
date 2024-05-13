struct Link: Codable, Identifiable {
    var id: String
    var title: String
    var clickCount: Int
}
import SwiftUI
import SwiftUICharts

struct LinksChartView: View {
    @ObservedObject var viewModel: LinksViewModel  // Assume this view model fetches and stores the links data

    var body: some View {
        VStack {
            if viewModel.links.isEmpty {
                Text("No data available")
            } else {
                BarChartView(data: ChartData(values: viewModel.links.map { ($0.title, $0.clickCount) }),
                             title: "Link Clicks",
                             style: Styles.barChartStyleOrangeLight,
                             form: CGSize(width: 400, height: 300),
                             dropShadow: false)
            }
        }
        .onAppear {
            viewModel.fetchLinks()
        }
    }
}
import Foundation

class LinksViewModel: ObservableObject {
    @Published var links: [Link] = []

    func fetchLinks() {
        // Simulated API fetch
        // Replace this with your actual API call setup
        self.links = [
            Link(id: "1", title: "Homepage", clickCount: 150),
            Link(id: "2", title: "About Us", clickCount: 80),
            Link(id: "3", title: "Contact", clickCount: 45)
        ]
    }
}
