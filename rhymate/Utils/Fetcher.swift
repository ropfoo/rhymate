import Foundation

struct Fetcher {
    private let session: URLSession
    init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default
    ) {
        self.session = URLSession(configuration: configuration)
    }
    
    func get<T:Decodable>(_ url: URL) async throws -> T? {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error while decoding json: \(error)")
            return nil
        }
    }
}
