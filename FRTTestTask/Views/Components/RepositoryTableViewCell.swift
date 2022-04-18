//
//  RepositoryTableViewCell.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 17.04.22.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    
    // MARK: - Properties
    
    static var cellHeight: CGFloat = 60
    var data: RepositoryItemViewModel? {
        didSet {
            if let data = data {
                updateUI(withData: data)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        usernameLabel.text = ""
        repositoryNameLabel.text = ""
    }
    
    // MARK: - UI
    
    private func updateUI(withData data: RepositoryItemViewModel) {
        avatarImageView.load(fromURL: data.avatar, placeholder: "AvatarPlaceholder")
        usernameLabel.text = data.userName
        repositoryNameLabel.text = data.repositoryName
    }
    
}
