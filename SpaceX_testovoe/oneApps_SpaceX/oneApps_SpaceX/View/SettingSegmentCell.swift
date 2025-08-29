import UIKit
import SnapKit

final class SettingSegmentCell: UITableViewCell {
    static let identifier = String.CellIdentifier.settingSegmentCell
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.LabGrotesqueFont(style: .regular, size: .medium)
        label.textColor = Theme.Color.colorText
        return label
    }()
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private var onSelectionChanged: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUserInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.FatalError.initCoder)
    }
    
    private func configureUserInterface() {
        backgroundColor = .clear
        contentView.addSubviews(titleLabel, segmentControl)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(120)
        }
        
        segmentControl.addTarget(self, action: #selector(handleSegmentChanged), for: .valueChanged)
        selectionStyle = .none
    }
    
    func configure(title: String,
                   options: [String],
                   selected: Int,
                   onChange: @escaping (Int) -> Void
    )
    {
        titleLabel.text = title
        segmentControl.removeAllSegments()
        options.enumerated().forEach { index, title in
            segmentControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentControl.selectedSegmentIndex = selected
        onSelectionChanged = onChange
    }
    
    @objc private func handleSegmentChanged() {
        onSelectionChanged?(segmentControl.selectedSegmentIndex)
    }
}


