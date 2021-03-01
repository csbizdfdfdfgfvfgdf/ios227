//
//  FolderAndListDataSource.swift
//  Psi
//
//  Created by Tayyab Ali on 12/21/20.
//

import UIKit

class FolderAndNotesDataSource: TableViewArrayDataSource<String, FolderCell> {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
