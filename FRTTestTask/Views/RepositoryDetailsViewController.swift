//
//  RepositoryDetailsViewController.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 17.04.22.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var manageStarredButton: UIButton!
    
    // MARK: - Properties
    
    var parentData: RepositoryItemViewModel?
    private lazy var dataSource: RepositoryDetailsViewModel = {
        let dataSource = RepositoryDetailsViewModel()
        dataSource.reloadUI = reloadDataView(error:)
        return dataSource
    }()
    private lazy var starredDataSource: StarredRepositoryViewModel = {
        let dataSource = StarredRepositoryViewModel()
        dataSource.reloadUI = reloadDataView(error:)
        return dataSource
    }()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        retrieveData()
    }
    
    // MARK: - User interaction
    
    @IBAction func openWebButtonTapped(_ sender: Any) {
        guard let url = dataSource.data?.repositoryURL else {
            showOkAlert(title: "", message: AppError.invalidURL.localizedDescription)
            return
        }
        
        openWebView(withURL: url)
    }
    
    @IBAction func manageStarredButtonTapped(_ sender: Any) {
        guard let data = dataSource.data else {
            showOkAlert(title: "", message: AppError.blankRepository.localizedDescription)
            return
        }
        
        if data.isStarred {
            removeFromLocal()
        } else {
            addToLocal()
        }
    }
    
    private func openWebView(withURL url: URL) {
        let webViewVC = WebViewWithHeaderViewController()
        webViewVC.url = url
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Data management

extension RepositoryDetailsViewController {
    
    /// Fetch data from remote
    @objc private func retrieveData() {
        guard let userName = parentData?.userName, !userName.isEmpty else {
            showOkAlert(title: "", message: AppError.blankUsername.localizedDescription)
            return
        }
        
        guard let repositoryName = parentData?.repositoryName, !repositoryName.isEmpty else {
            showOkAlert(title: "", message: AppError.blankRepository.localizedDescription)
            return
        }

        refreshControl.beginRefreshing()
        dataSource.getData(userName: userName, repositoryName: repositoryName)
    }
    
    /// Update local data after fetching from remote
    private func reloadDataView(error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            if let error = error {
                self?.showOkAlert(title: "", message: error.localizedDescription)
                return
            }
        
            self?.reloadData()
        }
    }
    
    /// Update UI after fetching data
    private func reloadData() {
        guard let data = dataSource.data else {
            showOkAlert(title: "", message: AppError.blankRepository.localizedDescription)
            return
        }
        
        descriptionLabel.text = data.description
        languageLabel.text = data.language
        creationDateLabel.text = data.creationDate?.formattedLocally()
        setStarredButtonText(for: data.isStarred)
    }
    
    private func setStarredButtonText(for isStarred: Bool) {
        let starredButtonText = isStarred ? "Remove from starred" : "Add to starred"
        manageStarredButton.setTitle(starredButtonText, for: .normal)
    }
    
}

// MARK: - Local database operations

extension RepositoryDetailsViewController {

    private func addToLocal() {
        guard let data = parentData else {
            return
        }
        
        if starredDataSource.save(data: data) {
            setStarredButtonText(for: true)
        }
    }
    
    private func removeFromLocal() {
        
    }
    
}
