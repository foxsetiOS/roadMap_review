import Foundation

final class LaunchListViewModel {
    
    private let rocketId: String
    private let networkService: NetworkServiceProtocol
    let launches = Observable<[Launch]>([])
    let isLoading = Observable<Bool>(false)
    
    init(
        rocketId: String,
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.rocketId = rocketId
        self.networkService = networkService
    }
    
    func loadLaunches() {
        isLoading.value = true
        Task { @MainActor in
            do {
                let fetchedLaunches = try await networkService.fetchLaunches()
                let launchesForRocket = fetchedLaunches.filter { $0.rocket == rocketId }
                launches.value = launchesForRocket.sorted { leftDate, rightDate in
                    let leftDate = DateFormatting.parseLaunchDate(leftDate.dateUtc)
                    let rightDate = DateFormatting.parseLaunchDate(rightDate.dateUtc)
                    switch (leftDate, rightDate) {
                    case let (leftDate?, rightDate?):
                        return leftDate > rightDate
                    case (nil, _?):
                        return false
                    case (_?, nil):
                        return true
                    default:
                        return false
                    }
                }
            } catch {
                print("Launches loading error: \(error)")
            }
            isLoading.value = false
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        DateFormatting.formatLaunchDate(dateString) ?? "—"
    }
}


