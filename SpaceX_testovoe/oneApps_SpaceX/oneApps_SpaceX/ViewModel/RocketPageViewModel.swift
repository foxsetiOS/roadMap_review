import Foundation

final class RocketPageViewModel {
    
    private let networkService: NetworkServiceProtocol
    let rockets = Observable<[Rocket]>([])
    let currentIndex = Observable<Int>(0)
    let isLoading = Observable<Bool>(false)
    let errorMessage = Observable<String?>(nil)

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func loadRockets() {
        isLoading.value = true
        Task { @MainActor in
            do {
                rockets.value = try await networkService.fetchRockets()
            } catch {
                errorMessage.value = "rocket_loading_error".localized + ": \(error.localizedDescription)"
            }
            isLoading.value = false
        }
    }
    
    func rocket(at index: Int) -> Rocket? {
        guard
            index >= 0 && index < rockets.value.count
        else {
            return nil
        }
        return rockets.value[index]
    }
}
