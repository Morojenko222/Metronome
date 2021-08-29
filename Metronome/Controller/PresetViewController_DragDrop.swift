//
//  PresetViewController_DragDrop.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 29.08.2021.
//

import Foundation
import UIKit

extension PresetsViewController : UITableViewDragDelegate
{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        return dragItems(for: indexPath)
        
    }
}

extension PresetsViewController : UITableViewDropDelegate
{
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        if let indexPath = coordinator.destinationIndexPath
        {
            let destinationIndexPath : IndexPath
            destinationIndexPath = indexPath
        
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath
                {
                    moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
                    DispatchQueue.main.async {
                        tableView.beginUpdates()
                        tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
                        tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                        tableView.endUpdates()
                    }
                    
                    tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if (tableView.hasActiveDrag)
        {
            if session.items.count > 1
            {
                return UITableViewDropProposal(operation: .cancel)
            }
            else
            {
                return UITableViewDropProposal(operation: .move)
            }
        }
        
        return UITableViewDropProposal(operation: .cancel)
    }
    
}
