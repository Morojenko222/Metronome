//
//  sizeViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 30.06.2021.
//

import UIKit

class SizeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let dataContainer = DataContainer.Instance
    var activeData = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        print("DidLoad")
        activeData = dataContainer.sizeData_1
    }
}

extension SizeViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell name = \(dataContainer.sizeData_1[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SizeViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SizeCell", for: indexPath)
        cell.textLabel?.text = String(activeData[indexPath.row])
        return cell
        
    }
}
