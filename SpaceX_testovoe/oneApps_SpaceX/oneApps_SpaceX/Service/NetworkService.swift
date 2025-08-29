import Foundation
import Alamofire

protocol NetworkServiceProtocol {

    func fetchRockets() async throws -> [Rocket]
    func fetchLaunches() async throws -> [Launch]
}

final class NetworkService: NetworkServiceProtocol {
    
    private let baseApiUrl = String.API.baseUrl
    private let endPointRocket = String.API.rocketsEndpoint
    private let endpointLaunch = String.API.launchesEndpoint
    
    func fetchRockets() async throws -> [Rocket] {
        try await request(endpoint: "\(baseApiUrl)\(endPointRocket)")
    }
    
    func fetchLaunches() async throws -> [Launch] {
        try await request(endpoint: "\(baseApiUrl)\(endpointLaunch)")
    }
    
    private func request<R: Decodable>(endpoint: String) async throws -> R {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint)
                .validate()
                .responseDecodable(of: R.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
