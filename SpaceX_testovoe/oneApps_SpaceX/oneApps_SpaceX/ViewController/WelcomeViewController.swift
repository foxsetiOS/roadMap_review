import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    private let viewModel: WelcomeViewModel
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: String.AssetName.spacex) ?? UIImage(named: String.UI.spacexLogo)
        return imageView
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
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubviews(backgroundImageView, startButton)
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(Constants.buttonHeight)
        }
    }
    
    @objc private func startButtonTapped() {
        viewModel.didTapStartButton()
    }
}
