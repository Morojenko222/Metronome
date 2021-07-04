//
//  sizeViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 30.06.2021.
//

import UIKit

class SizeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //self.preferredContentSize = CGSize(width: 250, height: 250)
    }
}

extension SizeViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell name = \(data[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SizeViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SizeCell", for: indexPath)
        cell.textLabel?.text = String(data[indexPath.row])
        return cell
        
    }
}
