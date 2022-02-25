//
//  ViewController.swift
//  EU
//
//  Created by Pace Williams on 2/16/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
//    var members = ["Austria",
//                   "Belgium",
//                   "Bulgaria",
//                   "Croatia",
//                   "Cyprus",
//                   "Czechia",
//                   "Denmark",
//                   "Estonia",
//                   "Finland",
//                   "France",
//                   "Germany",
//                   "Greece",
//                   "Hungary",
//                   "Ireland",
//                   "Italy",
//                   "Latvia",
//                   "Lithuania",
//                   "Luxembourg",
//                   "Malta",
//                   "Netherlands",
//                   "Poland",
//                   "Portugal",
//                   "Romania",
//                   "Slovakia",
//                   "Slovenia",
//                   "Spain",
//                   "Sweden",
//                   "United Kingdom"]
//
//    var capitals = ["Vienna",
//                    "Brussels",
//                    "Sofia",
//                    "Zagreb",
//                    "Nicosia",
//                    "Prague",
//                    "Copenhagen",
//                    "Tallinn",
//                    "Helsinki",
//                    "Paris",
//                    "Berlin",
//                    "Athens",
//                    "Budapest",
//                    "Dublin",
//                    "Rome",
//                    "Riga",
//                    "Vilnius",
//                    "Luxembourg (city)",
//                    "Valetta",
//                    "Amsterdam",
//                    "Warsaw",
//                    "Lisbon",
//                    "Bucharest",
//                    "Bratislava",
//                    "Ljubljana",
//                    "Madrid",
//                    "Stockholm",
//                    "London"]
//    var usesEuro = [true,
//                    true,
//                    false,
//                    false,
//                    true,
//                    false,
//                    false,
//                    true,
//                    true,
//                    true,
//                    true,
//                    true,
//                    false,
//                    true,
//                    true,
//                    true,
//                    true,
//                    true,
//                    true,
//                    true,
//                    false,
//                    true,
//                    false,
//                    true,
//                    true,
//                    true,
//                    false,
//                    false]
        
    var nations: [Nation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
//        for index in 0..<members.count {
//            let newNation = Nation(country: members[index], capital: capitals[index], usesEuro: usesEuro[index])
//            nations.append(newNation)
        loadData()
    
    }
        func loadData() {
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentURL = directoryURL.appendingPathComponent("nations").appendingPathExtension("json")
            
            guard let data = try? Data(contentsOf: documentURL) else {return}
            
            let jsonDecoder = JSONDecoder()
            do {
                nations = try jsonDecoder.decode(Array<Nation>.self, from: data)
                tableView.reloadData()
            } catch {
                print("ERROR: Could not load data \(error.localizedDescription)")
            }
            
        }
        
        func saveData() {
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentURL = directoryURL.appendingPathComponent("nations").appendingPathExtension("json")
            
            let jsonEncoder = JSONEncoder()
            let data = try? jsonEncoder.encode(nations)
            do {
                try data?.write(to: documentURL, options: .noFileProtection)
            } catch {
                print("ERROR: Could not save data \(error.localizedDescription)")
            }
        }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.nation = nations[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            nations[selectedIndexPath.row] = source.nation
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: nations.count, section: 0)
            nations.append(source.nation)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveData()
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate {
    func euroButtonToggled(sender: ListTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            nations[selectedIndexPath.row].usesEuro =             !nations[selectedIndexPath.row].usesEuro
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.nation = nations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return nations.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            nations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = nations[sourceIndexPath.row]
        nations.remove(at: sourceIndexPath.row)
        nations.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 
    }
}
