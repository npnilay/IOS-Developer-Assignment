import SwiftUI
struct Link: Codable {
    var title: String
    var url: String
}

struct DashboardResponse: Codable {
    var topLinks: [Link]
    var recentLinks: [Link]
}
import Foundation

func fetchDashboardData(completion: @escaping (Result<DashboardResponse, Error>) -> Void) {
    guard let url = URL(string: "https://api.inopenapp.com/api/v1/dashboardNew") else {
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer <your_access_token_here>", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            return
        }
        
        do {
            let responseData = try JSONDecoder().decode(DashboardResponse.self, from: data)
            completion(.success(responseData))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
import SwiftUI

struct DashboardView: View {
    @State private var dashboardData: DashboardResponse?
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Loading...")
            } else if let dashboardData = dashboardData {
                List {
                    Text(greetingMessage())
                        .font(.largeTitle)
                    
                    TabView {
                        ListView(links: dashboardData.topLinks)
                            .tabItem {
                                Text("Top Links")
                            }
                        
                        ListView(links: dashboardData.recentLinks)
                            .tabItem {
                                Text("Recent Links")
                            }
                    }
                }
            } else {
                Text("No data available")
            }
        }
        .onAppear {
            fetchDashboardData { result in
                switch result {
                case .success(let data):
                    self.dashboardData = data
                    self.isLoading = false
                case .failure:
                    self.isLoading = false
                }
            }
        }
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

struct ListView: View {
    var links: [Link]
    
    var body: some View {
        ForEach(links, id: \.url) { link in
            VStack(alignment: .leading) {
                Text(link.title).bold()
                Text(link.url).foregroundColor(.blue)
            }
        }
    }
}

