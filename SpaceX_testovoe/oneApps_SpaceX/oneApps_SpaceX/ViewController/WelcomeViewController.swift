import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    private let viewModel: WelcomeViewModel
    
    private let backgroundImageView: UIImageView = {
        let imagaView = UIImageView()
        imagaView.contentMode = .scaleAspectFill
        
        imagaView.image = UIImage(named: String.AssetName.spacex) ?? UIImage(named: String.UI.spacexLogo)
        return imagaView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.UI.letsGo, for: .normal)
        button.titleLabel?.font = UIFont.LabGrotesqueFont(style: .bold, size: .medium)
        button.backgroundColor = Theme.Color.colorCollection
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.FatalError.initCoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubviews(backgroundImageView, startButton)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(Constants.buttonHeight)
        }
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        viewModel.startButtonTapped()
    }
}
