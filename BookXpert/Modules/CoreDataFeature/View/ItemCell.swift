//
//  ItemCell.swift
//  BookXpert
//
//  Created by APPLE on 24/04/25.
//

import UIKit

class ItemCell: UITableViewCell {

    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        // Container View Styling
        containerView.backgroundColor = UIColor.systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // Name Label
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0

        // Detail Label
        detailLabel.font = .systemFont(ofSize: 14)
        detailLabel.textColor = .darkGray
        detailLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)
        containerView.addSubview(stackView)

        // Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }

    func configure(with item: Item) {
        nameLabel.text = "\(item.name ?? "Unnamed") (ID: \(item.id ?? "-"))"

        var details = [String]()

        if let color = item.color { details.append("Color: \(color)") }
        if let capacity = item.capacity { details.append("Capacity: \(capacity)") }
        if item.price != 0 { details.append("Price: ₹\(item.price)") }
        if item.year != 0 { details.append("Year: \(item.year)") }
        if let cpuModel = item.cpuModel { details.append("CPU Model: \(cpuModel)") }
        if let hardDiskSize = item.hardDiskSize { details.append("Hard Disk Size: \(hardDiskSize)") }
        if let strapColor = item.strapColor { details.append("Strap Colour: \(strapColor)") }
        if let caseSize = item.caseSize { details.append("Case Size: \(caseSize)") }
        if let description = item.descriptionText { details.append("Description: \(description)") }
        if item.screenSize != 0 { details.append("Screen Size: \(item.screenSize)") }
        if let generation = item.generation { details.append("Generation: \(generation)") }

        detailLabel.text = details.joined(separator: "\n")
    }
}
