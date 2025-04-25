import Foundation
import Combine

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    private let baseURL = "http://127.0.0.1:5000/api"
    
    func fetchData<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func markNotificationAsRead(id: Int) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/notifications/\(id)/read") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return true
    }
}
