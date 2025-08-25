import UIKit

final class SettingsViewController: UITableViewController {
    
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserInterface()
        bindViewModel()
    }
    
    private func configureUserInterface() {
        title = "settings_title".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "close".localized,
            style: .plain,
            target: self,
            action: #selector(handleCloseTap)
        )
        
        tableView.backgroundColor = Theme.Color.colorCollection
        tableView.separatorStyle = .none
        tableView.register(SettingSegmentCell.self, forCellReuseIdentifier: SettingSegmentCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.settingsChanged.bind { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func handleCloseTap() {
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        SettingType.allCases.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        // Заголовки разделов скипаем заголовок в самой ячейке!
        return nil
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        // Одна строка на тип настройки
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingSegmentCell.identifier, for: indexPath) as! SettingSegmentCell
        let settingType = SettingType.allCases[indexPath.section]
        let currentUnit = viewModel.settings.value.first { $0.type == settingType }?.unit
        let options = viewModel.unitOptions(for: settingType)
        cell.configure(
            title: settingType.title,
            options: options.map { $0.symbol },
            selected: options.firstIndex(of: currentUnit ?? options[0]) ?? 0) { [weak self] selectedIndex in
            let unit = options[selectedIndex]
            self?.viewModel.updateSetting(for: settingType, unit: unit)
        }
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat { 40 }
    
    override func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat { 20 }
}

