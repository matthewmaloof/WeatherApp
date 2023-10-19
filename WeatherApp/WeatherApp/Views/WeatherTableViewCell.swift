//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Matthew Maloof on 10/19/23.
//

import Foundation
import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(weatherLabel)
        
        NSLayoutConstraint.activate([
            weatherLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            weatherLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
