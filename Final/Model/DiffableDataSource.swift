//
//  DiffableDataSource.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/8.
//

import UIKit

enum Section {  //type of the table section
    case all  //one case for one section
}

class DiffableDataSource: UITableViewDiffableDataSource<Section, Scene> {
    
    //enable editable table cells for supporting swipe actions
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
