//
//  LoadingTableViewCell.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 17.04.22.
//

import UIKit

protocol ManageActivityDelegate: AnyObject {
    var isActive: Bool { get set }
}

class LoadingTableViewCell: UITableViewCell, ManageActivityDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var isActive: Bool = false {
        willSet {
            if newValue == isActive { return }
            
            DispatchQueue.main.async {
                self.isActive ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        activityIndicator.hidesWhenStopped = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
