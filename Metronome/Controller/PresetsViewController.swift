//
//  PresetsViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 09.07.2021.
//

import UIKit

class PresetsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PresetCell", bundle: nil), forCellReuseIdentifier: "presetCell")
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onRightNavButtonPress))

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func onRightNavButtonPress()
    {
        let id = "presetEditVC"
        guard let presetsEditVC = storyboard?.instantiateViewController(identifier: id) else {
            print("Error - Can't find VC with id = \(id)")
            return
        }
        
        presetsEditVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(presetsEditVC, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetCell", for: indexPath)
        //cell.textLabel?.text = String(activeData[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Pressed - \(indexPath.row)")
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
