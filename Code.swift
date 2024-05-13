import SwiftUI

@main
struct YourAppName: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
import SwiftUI

struct ContentView: View {
    @StateObject var linksViewModel = LinksViewModel()  // ViewModel for managing links data

    var body: some View {
        NavigationView {
            VStack {
                GreetingView()  // Displaying the greeting based on local time
                LinksChartView(viewModel: linksViewModel)  // Chart for links click counts
                LinksTabsView(viewModel: linksViewModel)  // Tabs for top and recent links
            }
            .navigationTitle("Dashboard")
        }
        .onAppear {
            linksViewModel.fetchLinks()  // Fetch links data when the view appears
        }
    }
}

struct GreetingView: View {
    var body: some View {
        Text(greetingMessage())
            .font(.largeTitle)
            .padding()
    }
    
    private func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
}

struct LinksTabsView: View {
    @ObservedObject var viewModel: LinksViewModel
    
    var body: some View {
        TabView {
            ListView(links: viewModel.links)  // Assume viewModel.links is an array of top links
                .tabItem {
                    Label("Top Links", systemImage: "link")
                }

            ListView(links: viewModel.links)  // Assume viewModel.links is an array of recent links
                .tabItem {
                    Label("Recent Links", systemImage: "clock.arrow.circlepath")
                }
        }
    }
}

struct ListView: View {
    var links: [Link]
    
    var body: some View {
        List(links, id: \.id) { link in
            VStack(alignment: .leading) {
                Text(link.title).bold()
                Text("\(link.clickCount) clicks").foregroundColor(.gray)
            }
        }
    }
}
