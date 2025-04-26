//
//  CoreDataManager.swift
//  BookXpert
//
//  Created by APPLE on 23/04/25.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Fetch data from the API and save to Core Data with completion handler
    func saveItems(from urlString: String, completion: @escaping () -> Void) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("API Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let items = try JSONDecoder().decode([APIObject].self, from: data)
                
                DispatchQueue.main.async {
                    self.saveToCoreData(items)
                    completion() // Call completion handler after saving
                }
            } catch {
                print("JSON Decode Error:", error)
            }
        }.resume()
    }

    // Save fetched items to Core Data
    func saveToCoreData(_ items: [APIObject]) {
        // 1. Delete all existing entries
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            print("Deleted all existing Core Data entries")
        } catch {
            print("Failed to delete existing data:", error)
            return
        }

        // 2. Add new items from API
        for apiItem in items {
            let newItem = Item(context: context)
            newItem.id = apiItem.id
            newItem.name = apiItem.name
            newItem.color = apiItem.data?.color
            newItem.capacity = apiItem.data?.capacity
            newItem.price = apiItem.data?.price ?? 0
            newItem.year = Int16(apiItem.data?.year ?? 0)
            newItem.cpuModel = apiItem.data?.cpuModel
            newItem.hardDiskSize = apiItem.data?.hardDiskSize
            newItem.strapColor = apiItem.data?.strapColor
            newItem.caseSize = apiItem.data?.caseSize
            newItem.descriptionText = apiItem.data?.description
            newItem.screenSize = apiItem.data?.screenSize ?? 0
            newItem.generation = apiItem.data?.generation
        }

        // 3. Save changes
        do {
            try context.save()
            print("Core Data Saved Successfully with fresh API data")
        } catch {
            print("Core Data Save Error:", error)
        }
    }

    
    func hasStoredData() -> Bool {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }

    func deleteItem(_ item: Item) {
        context.delete(item)
        try? context.save()
    }
    
    func updateItem(_ item: Item, with name: String, color: String?, capacity: String?, generation: String?, price: Double?, year: Int16?, cpuModel: String?, hardDiskSize: String?, strapColor: String?, caseSize: String?, description: String?, screenSize: Double?) {
        item.name = name
        item.color = color
        item.capacity = capacity
        item.generation = generation
        item.price = price ?? 0
        item.year = year ?? 0
        item.cpuModel = cpuModel
        item.hardDiskSize = hardDiskSize
        item.strapColor = strapColor
        item.caseSize = caseSize
        item.descriptionText = description
        item.screenSize = screenSize ?? 0
        do {
            try context.save()
            print("Item updated successfully")
        } catch {
            print("Error updating item:", error)
        }
    }
}
