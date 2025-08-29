import Foundation
import Swinject

final class DIContainer {

    static let shared = DIContainer()
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
        guard
            let service = container.resolve(NetworkServiceProtocol.self)
        else {
            fatalError(String.FatalError.containerDIContainer)
        }
        return service
    }
}
