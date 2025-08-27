import UIKit
import SnapKit

final class LaunchCell: UITableViewCell {
    static let identifier = "LaunchCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Color.colorCollection
        view.layer.cornerRadius = Theme.Radius.card
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.LabGrotesqueFont(style: .medium, size: .medium)
        label.textColor = Theme.Color.colorText
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.LabGrotesqueFont(style: .medium, size: .medium)
        label.textColor = Theme.Color.secondColorText
        return label
    }()
    
    private let dateContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let rocketIconView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let rocketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rocketRide")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Theme.Color.secondColorText
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let statusIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupViews()
        setupConstraints()
        setupCellAppearance()
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(dateContainerView)
        dateContainerView.addSubview(dateLabel)
        cardView.addSubview(rocketIconView)
        rocketIconView.addSubview(rocketImageView)
        rocketIconView.addSubview(statusIndicator)
        statusIndicator.addSubview(statusIconImageView)
    }
    
    private func setupConstraints() {
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.cardViewInsets)
        }
        
        rocketIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(40)
        }
        
        rocketImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        statusIndicator.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()

            $0.size.equalTo(12)
        }
        
        statusIconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(8)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(rocketIconView.snp.leading).offset(-16)
        }
        
        dateContainerView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualTo(rocketIconView.snp.leading).offset(-16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.dateLabelInsets)
        }
    }
    
    private func setupCellAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configure(with launch: Launch, dateFormatter: (String) -> String) {
        nameLabel.text = launch.name
        if let dateStr = launch.dateUtc {
            dateLabel.text = dateFormatter(dateStr)
        } else {
            dateLabel.text = ""
        }
        
        // индикатор статуса с иконкой
        if let success = launch.success {
            statusIndicator.backgroundColor = success ? Theme.Color.colorSuccess : Theme.Color.colorFailer
            let symbolName = success ? "rocketRide" : "rocketFail"
            statusIconImageView.image = UIImage(systemName: symbolName)
        } else {
            statusIndicator.backgroundColor = Theme.Color.colorFailer
            statusIconImageView.image = UIImage(systemName: "questionmark")
        }
    }
}
