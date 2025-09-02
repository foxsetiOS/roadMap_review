import UIKit
import SnapKit

final class LaunchListViewController: UIViewController {
    
    private let viewModel: LaunchListViewModel
    private let launchesTableView = UITableView()
    
    init(viewModel: LaunchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.FatalError.initCoder)
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
       
        configureUserInterface()
        configureTableView()
        bindViewModel()
        viewModel.loadLaunches()
    }
    
   private func configureUserInterface() {
        view.backgroundColor = Theme.Color.colorCollection
        title = String.LocalizationKey.launches.localized
    }
    
    private func configureTableView() {
        launchesTableView.backgroundColor = Theme.Color.colorView
        launchesTableView.separatorStyle = .none
        launchesTableView.contentInset = Constants.tableViewContentInsets
        launchesTableView.register(LaunchCell.self, forCellReuseIdentifier: LaunchCell.identifier)
        launchesTableView.delegate = self
        launchesTableView.dataSource = self
        view.addSubview(launchesTableView)
        launchesTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
   private func bindViewModel() {
        viewModel.launches.bind { [weak self] _ in
            self?.launchesTableView.reloadData()
        }
    }
}


extension LaunchListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.launchCount()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
            withIdentifier: LaunchCell.identifier,
            for: indexPath
        ) as? LaunchCell else {
            let errorCell = LaunchCell()
            errorCell.configure(
                with: Launch(id: "Ошибка",
                             name: "Ошибка загрузки",
                             dateUtc: nil,
                             success: false,
                             rocket: "ошибка загрузки Ракеты"
                            ), dateFormatter: { _ in "Ошибка" })
            return errorCell
        }
        
        guard
            let launch = viewModel.getLaunchForCell(at: indexPath)
        else {
            let errorCell = LaunchCell()
            errorCell.configure(
                with: Launch(id: String.ErrorMessage.error,
                             name: String.ErrorMessage.errorName,
                             dateUtc: nil,
                             success: false,
                             rocket: String.ErrorMessage.errorRocket
                            ), dateFormatter: { _ in String.ErrorMessage.errorDate })
            return errorCell
        }
        
        if viewModel.hasLaunchDate(launch) {
            cell.configure(with: launch, dateFormatter: viewModel.formatDate)
        } else {
            cell.configure(with: launch, dateFormatter: { _ in String.LocalizationKey.noDate.localized })
        }
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        Constants.tableRowHeight
    }
}
