//
//  DashBoardVC.swift
//  BookXpert
//
//  Created by APPLE on 23/04/25.
//

import UIKit

class DashBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let features = [
        "Report (PDF Viewer)",
        "Image & Gallery Upload",
        "API + Core Data"
    ]
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BookXpert Dashboard"
        view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        setupTableView()
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = features[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(PDFViewerVC(), animated: true)
        case 1:
            navigationController?.pushViewController(ImageGalleryVC(), animated: true)
        case 2:
            navigationController?.pushViewController(CoreDataFeatureVC(), animated: true)
        default:
            break
        }
    }
}

