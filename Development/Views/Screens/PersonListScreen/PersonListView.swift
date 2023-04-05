import UIKit

internal protocol PersonListViewInterface: AnyObject {
    func setupTableView()
    func setupRefleshControl()
    func beginRefleshing()
    func endRefleshing()
    func reloadData()
    func noDataView(shouldShow: Bool)
}

final class PersonListView: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    // MARK: - Properties
    private lazy var viewModel = PersonListViewModel()
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad(initialRequest: true)
    }
    // MARK: - Selectors
    @objc private func pulledDownReflesh(_ sender: UIRefreshControl) {
        viewModel.pulledDownReflesh(initialRequest: true)
     }
}

// MARK: - UITableViewDelegate && UITableViewDelegate
extension PersonListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.numberOfRows() else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
        let data = viewModel.cellForItem(at: indexPath)
        cell.configure(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        let tableViewHeight = tableView.contentSize.height
        let scroolHeight = scrollView.frame.size.height
//        DebugManager.shared.debugScrollView(position: position, tableViewHeight: tableViewHeight, scroolHeight: scroolHeight)
        if position + scroolHeight > tableViewHeight - 400 {
            viewModel.scrolledToEnd(initialRequest: false)
        }
    }
}
// MARK: - PersonListViewInterface
extension PersonListView: PersonListViewInterface {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: PersonTableViewCell.self)
        tableView.allowsSelection = false
        tableView.reloadData()
    }
    
    func setupRefleshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledDownReflesh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func beginRefleshing() {
        tableView.refreshControl?.beginRefreshing()
    }
    
    func endRefleshing() {
        guard let refreshControl = tableView.refreshControl, refreshControl.isRefreshing else { return }
        tableView.refreshControl?.endRefreshing()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func noDataView(shouldShow: Bool) {
        let noDataLabel = UILabel()
        noDataLabel.textAlignment = .center
        noDataLabel.numberOfLines = 0

        if shouldShow {
            noDataLabel.text = "No one here :) \n If you wanna continue, you can pull down the screen."
        } else {
            noDataLabel.text = String()
        }
        noDataLabel.sizeToFit()
        
        let containerView = UIView()
        containerView.addSubview(noDataLabel)

        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDataLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            noDataLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            noDataLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        tableView.backgroundView = containerView
        tableView.reloadData()
    }
}
