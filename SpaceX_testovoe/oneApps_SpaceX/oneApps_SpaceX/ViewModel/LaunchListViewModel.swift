import Foundation

final class LaunchListViewModel {
    
    private let rocketId: String
    private let networkService: NetworkServiceProtocol
    let launches = Observable<[Launch]>([])
    let isLoading = Observable<Bool>(false)
    
    init(rocketId: String) {
        self.rocketId = rocketId
        self.networkService = NetworkService()
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
    
    func launch(at index: Int) -> Launch? {
        guard
            index >= 0 && index < launches.value.count
        else {
            return nil
        }
        return launches.value[index]
    }
    
    func launchCount() -> Int {
        launches.value.count
    }
    
    func hasLaunchDate(_ launch: Launch) -> Bool {
        launch.dateUtc != nil
    }
    
    func getLaunchForCell(at indexPath: IndexPath) -> Launch? {
        launch(at: indexPath.row)
    }
}
