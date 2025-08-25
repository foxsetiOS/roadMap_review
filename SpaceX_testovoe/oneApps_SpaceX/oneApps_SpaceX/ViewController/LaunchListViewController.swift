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
        fatalError("init(coder:) has not been implemented")
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
        title = "launches".localized
    }
    
    private func configureTableView() {
        
        launchesTableView.backgroundColor = Theme.Color.colorView
        launchesTableView.separatorStyle = .none
        launchesTableView.contentInset = UIEdgeInsets(
            top: 8,
            left: 0,
            bottom: 8,
            right: 0
        )
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
        viewModel.launches.value.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LaunchCell.identifier,
            for: indexPath
        ) as? LaunchCell else {
            return UITableViewCell()
        }
        
        let launch = viewModel.launches.value[indexPath.row]
        if let _ = launch.dateUtc {
            cell.configure(with: launch, dateFormatter: viewModel.formatDate)
        } else {
            cell.configure(with: launch, dateFormatter: { launchDataEmpty in "–" })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100 // Увеличиваем высоту для карточек / не переносим в Константу! 
    }
}
