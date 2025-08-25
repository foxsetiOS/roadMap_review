final class WelcomeViewModel {
    
    var onStartButtonTapped: (() -> Void)?
    
    func didTapStartButton() {
        onStartButtonTapped?()
    }
    
    func startButtonTapped() {
        onStartButtonTapped?()
    }
}
