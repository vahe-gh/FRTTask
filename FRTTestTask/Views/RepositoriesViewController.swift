//
//  RepositoriesViewController.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 16.04.22.
//

import UIKit

class RepositoriesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Properties
    
    private lazy var dataSource: RepositoryViewModel = {
        let dataSource = RepositoryViewModel()
        dataSource.reloadUI = reloadDataView(error:)
        return dataSource
    } ()
    private let refreshControl = UIRefreshControl()
    private var startingPageNumber = 1
    private let itemsPerPage = 20
    private var isLoading = false
    private let detailSegue = "ShowRepositoryDetails"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - User interaction
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        retrieveData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegue, let data = sender as? RepositoryItemViewModel, let destinationVC = segue.destination as? RepositoryDetailsViewController {
            destinationVC.parentData = data
        }
    }
    
}

// MARK: - Setup controls

extension RepositoriesViewController {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.addSubview(refreshControl)
        
        // Register table view cells
        tableView.register(UINib(nibName: RepositoryTableViewCell.reusableId, bundle: nil), forCellReuseIdentifier: RepositoryTableViewCell.reusableId)
        tableView.register(UINib(nibName: LoadingTableViewCell.reusableId, bundle: nil), forCellReuseIdentifier: LoadingTableViewCell.reusableId)

        refreshControl.addTarget(self, action: #selector(retrieveData), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Repositories"
    }
    
}

// MARK: - Data management

extension RepositoriesViewController {
    
    /// Fetch data from remote
    @objc private func retrieveData() {
        guard let userName = searchTextField.text, !userName.isEmpty else {
            showOkAlert(title: "", message: AppError.blankUsername.localizedDescription)
            return
        }
        
        refreshControl.beginRefreshing()
        dataSource.getData(userName: userName, pageNumber: nil, itemsPerPage: itemsPerPage)
    }
    
    /// Update local data after fetching from remote
    private func reloadDataView(error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            if let error = error {
                self?.showOkAlert(title: "", message: error.localizedDescription)
                return
            }
        
            self?.tableView.reloadData()
        }
    }
    
}

// MARK: - TableView delegates

extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RepositoryTableViewCell.cellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.reusableId, for: indexPath) as? RepositoryTableViewCell else {
                return UITableViewCell()
            }
            
            if isLoadingCell(for: indexPath) {
                
            } else {
                cell.data = dataSource.data[indexPath.row]
            }

            /// Configure the cell
            cell.selectionStyle = .none
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reusableId, for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }

            cell.isActive = isLoading
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSource.data.indices.contains(indexPath.row) else {
            return
        }
        
        performSegue(withIdentifier: detailSegue, sender: dataSource.data[indexPath.row])
    }
    
}

// MARK: - Infinite scrolling

extension RepositoriesViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("Prefetch indexPaths are \(indexPaths)")
        if indexPaths.contains(where: isLoadingCell) {
            retrieveData()
        }
    }
    
}

private extension RepositoriesViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= dataSource.data.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
}
