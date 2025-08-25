import Foundation
import Swinject

final class DiContainer {

    static let shared = DiContainer()
    private let container = Container()
    
    private init() {
        setupDependencies()
    }

    private func setupDependencies() {
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }.inObjectScope(.container)
    }
    
    var networkService: NetworkServiceProtocol {
        container.resolve(NetworkServiceProtocol.self)!
    }
}
