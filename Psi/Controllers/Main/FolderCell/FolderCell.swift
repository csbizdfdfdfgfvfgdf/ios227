//
//  FolderCell.swift
//  Psi
//
//  Created by Tayyab Ali on 12/21/20.
//

import UIKit

class FolderCell: UITableViewCell, ConfigurableCell {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrawIV: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - ConfigurableCell
    func configure(_ item: Any, at indexPath: IndexPath) {
        
        if let item = item as? FolderViewModel {
            titleLabel.text = item.menuName
            arrawIV.isHidden = false
        }
        
        if let item = item as? NoteViewModel {
            titleLabel.text = item.content
            arrawIV.isHidden = true
        }
    }
}

// MARK: - Dynamic Loaded Cell
extension FolderCell: NibLoadableView {}
