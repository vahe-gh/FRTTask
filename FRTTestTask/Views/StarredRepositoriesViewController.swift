//
//  StarredRepositoriesViewController.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import UIKit

class StarredRepositoriesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private lazy var dataSource: StarredRepositoryViewModel = {
        let dataSource = StarredRepositoryViewModel()
        dataSource.reloadUI = reloadDataView(error:)
        return dataSource
    } ()
    private let refreshControl = UIRefreshControl()
    private let detailSegue = "ShowRepositoryDetails"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

extension StarredRepositoriesViewController {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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

extension StarredRepositoriesViewController {
    
    /// Fetch data from remote
    @objc private func retrieveData() {
        refreshControl.beginRefreshing()
        dataSource.getData()
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

extension StarredRepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RepositoryTableViewCell.cellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.reusableId, for: indexPath) as? RepositoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.data = dataSource.data[indexPath.row]
        
        /// Configure the cell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSource.data.indices.contains(indexPath.row) else {
            return
        }
        
        performSegue(withIdentifier: detailSegue, sender: dataSource.data[indexPath.row])
    }

}
