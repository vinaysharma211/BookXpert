//
//  CoreDataFeatureVC.swift
//  BookXpert
//
//  Created by APPLE on 23/04/25.
//

import UIKit
import CoreData

class CoreDataFeatureVC: UIViewController {

    let tableView = UITableView()
    let refreshButton = UIButton(type: .system)
    let activityIndicator = UIActivityIndicatorView(style: .large)

    var items: [Item] = []
    var expandedIndexSet: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Data Items"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Refresh",
            style: .plain,
            target: self,
            action: #selector(fetchAndStoreItems)
        )
        
        setupUI()
        
        if !CoreDataManager.shared.hasStoredData() {
            fetchAndStoreItems()
        } else {
            fetchItemsFromCoreData()
        }
    }

    func setupUI() {
        // Table View
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)

        // Loader
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    @objc func fetchAndStoreItems() {
        activityIndicator.startAnimating()
        CoreDataManager.shared.saveItems(from: "https://api.restful-api.dev/objects") {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.fetchItemsFromCoreData()
            }
        }
    }

    func fetchItemsFromCoreData() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            // Fetch sorted data
            items = try CoreDataManager.shared.context.fetch(request)
            items.sort { (item1, item2) in
                guard let id1 = Int(item1.id ?? "0"), let id2 = Int(item2.id ?? "0") else {
                    return false
                }
                return id1 < id2
            }
            tableView.reloadData()
        } catch {
            print("Core Data Fetch Error:", error)
        }
    }

}

extension CoreDataFeatureVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Swipe actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = items[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            
            self.sendLocalNotification(item: item)
            
            // Delete item from Core Data
            CoreDataManager.shared.deleteItem(item)
            
            // Refresh the items
            self.fetchItemsFromCoreData()
            
            completion(true)
        }

        let updateAction = UIContextualAction(style: .normal, title: "Update") { _, _, completion in
            let alert = UIAlertController(title: "Update Item", message: "Edit the details below", preferredStyle: .alert)

            // Add text fields for available properties with values
            if let name = item.name {
                alert.addTextField { textField in
                    textField.text = name
                    textField.placeholder = "Name"

                    // Make the text bold
                    textField.font = UIFont.boldSystemFont(ofSize: 16) // Set font to bold
                    
                    // Optional: Add blue border if needed
                    textField.borderStyle = .roundedRect
                    textField.tintColor = .systemBlue
                }
            }
            
            if let color = item.color {
                alert.addTextField { textField in
                    textField.text = color
                    textField.placeholder = "Color"
                }
            }
            
            if let capacity = item.capacity {
                alert.addTextField { textField in
                    textField.text = capacity
                    textField.placeholder = "Capacity"
                }
            }
            
            if item.price != 0 {
                alert.addTextField { textField in
                    textField.text = "\(item.price)"
                    textField.placeholder = "Price"
                    textField.keyboardType = .decimalPad
                }
            }
            
            if item.year != 0 {
                alert.addTextField { textField in
                    textField.text = "\(item.year)"
                    textField.placeholder = "Year"
                    textField.keyboardType = .numberPad
                }
            }
            
            if let cpuModel = item.cpuModel {
                alert.addTextField { textField in
                    textField.text = cpuModel
                    textField.placeholder = "CPU Model"
                }
            }
            
            if let hardDiskSize = item.hardDiskSize {
                alert.addTextField { textField in
                    textField.text = hardDiskSize
                    textField.placeholder = "Hard Disk Size"
                }
            }
            
            if let strapColor = item.strapColor {
                alert.addTextField { textField in
                    textField.text = strapColor
                    textField.placeholder = "Strap Colour"
                }
            }
            
            if let caseSize = item.caseSize {
                alert.addTextField { textField in
                    textField.text = caseSize
                    textField.placeholder = "Case Size"
                }
            }
            
            if let description = item.descriptionText {
                alert.addTextField { textField in
                    textField.text = description
                    textField.placeholder = "Description"
                }
            }
            
            if item.screenSize != 0 {
                alert.addTextField { textField in
                    textField.text = "\(item.screenSize)"
                    textField.placeholder = "Screen Size"
                    textField.keyboardType = .decimalPad
                }
            }
            
            if let generation = item.generation {
                alert.addTextField { textField in
                    textField.text = generation
                    textField.placeholder = "Generation"
                }
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(false)
            }))
            
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
                let fields = alert.textFields ?? []
                
                guard let name = fields.first?.text, !name.isEmpty else {
                    completion(false)
                    return
                }

                // Helper function to extract optional field values from textFields
                func getValue<T>(_ index: Int, conversion: (String) -> T?) -> T? {
                    guard let text = fields[safe: index]?.text, !text.isEmpty else { return nil }
                    return conversion(text)
                }
                
                // Extract values from text fields with appropriate conversions
                let color = getValue(1, conversion: { $0 })
                let capacity = getValue(2, conversion: { $0 })
                let price = getValue(3, conversion: { Double($0) })
                let year = getValue(4, conversion: { Int16($0) })
                let cpuModel = getValue(5, conversion: { $0 })
                let hardDiskSize = getValue(6, conversion: { $0 })
                let strapColor = getValue(7, conversion: { $0 })
                let caseSize = getValue(8, conversion: { $0 })
                let description = getValue(9, conversion: { $0 })
                let screenSize = getValue(10, conversion: { Double($0) })
                let generation = getValue(11, conversion: { $0 })
                
                // Call updateItem with the new values
                CoreDataManager.shared.updateItem(
                    item,
                    with: name,
                    color: color,
                    capacity: capacity,
                    generation: generation,
                    price: price,
                    year: year,
                    cpuModel: cpuModel,
                    hardDiskSize: hardDiskSize,
                    strapColor: strapColor,
                    caseSize: caseSize,
                    description: description,
                    screenSize: screenSize
                )
                
                self.fetchItemsFromCoreData()
                completion(true)
            }))
            
            self.present(alert, animated: true)
        }

        updateAction.backgroundColor = .systemTeal
        return UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
    }

    func sendLocalNotification(item: Item) {
        let content = UNMutableNotificationContent()
        content.title = "Item Deleted"
        content.body = "The item \(item.name ?? "Unknown") has been deleted."
        content.sound = UNNotificationSound.default

        // Trigger the notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "itemDeleted", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

