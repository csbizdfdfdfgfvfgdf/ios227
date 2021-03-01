//
//  FolderAndNotesDataSource.swift
//  Psi
//
//  Created by Tayyab Ali on 12/21/20.
//

import UIKit

class FolderAndNotesDataSource: TableViewArrayDataSource<Any, FolderCell> {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
//
//        // Image View
//        let iconIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        iconIV.image = UIImage(named: section == 0 ? "folder-ic" : "notes-ic")
//        headerView.addSubview(iconIV)
//
//        let headerTitleLabel = UILabel()
//
//        headerTitleLabel.text = section == 0 ? "Folders" : "Notes"
//        headerTitleLabel.textColor = Theme.primaryTextColor
//        headerTitleLabel.font = UIFont.systemFont(ofSize: 18)
//        headerView.addSubview(headerTitleLabel)
//
//        var constraints:[NSLayoutConstraint] = []
//
//        // Adding Constraint to the Image
//        iconIV.translatesAutoresizingMaskIntoConstraints = false
//        let rightsideAnchor:NSLayoutConstraint = NSLayoutConstraint(item: iconIV, attribute: .leading, relatedBy: .equal, toItem: headerView, attribute: .leading, multiplier: 1, constant: 10)
//        let verticalCenter = NSLayoutConstraint(item: iconIV, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0)
//        constraints.append(rightsideAnchor)
//        constraints.append(verticalCenter)
//
//        // Adding Constraint to the Label
//        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        let rightsideImageAnchor:NSLayoutConstraint = NSLayoutConstraint(item: headerTitleLabel, attribute: .leading, relatedBy: .equal, toItem: iconIV, attribute: .trailing, multiplier: 1, constant: 10)
//        let verticalToImageCenter = NSLayoutConstraint(item: headerTitleLabel, attribute: .centerY, relatedBy: .equal, toItem: iconIV, attribute: .centerY, multiplier: 1, constant: 0)
//        constraints.append(rightsideImageAnchor)
//        constraints.append(verticalToImageCenter)
//
//        NSLayoutConstraint.activate(constraints)
//        return headerView
//    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, success) in
            self.actionsProxy.invoke(action: .swipeToDelete, indexPath: indexPath)
        }
        
        let edit = UIContextualAction(style: .normal, title: "") { (action, view, success) in
            self.actionsProxy.invoke(action: .swipeToEdit, indexPath: indexPath)
        }
        
        edit.backgroundColor = Theme.appBackgroundColor
        edit.image = UIImage(named: "edit-ic")
        delete.backgroundColor = Theme.appBackgroundColor
        delete.image = UIImage(named: "delete-ic")
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}
