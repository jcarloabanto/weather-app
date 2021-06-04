//
//  WeatherTableViewCell.swift
//  weather app
//
//  Created by jcarloabanto on 5/25/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var condImage: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    
    var weatherViewModel: WeatherViewModel! {
        didSet {
            cityLabel.text = weatherViewModel.cityName
            tempLabel.text = weatherViewModel.temp
            condImage.image = weatherViewModel.conditionImage
            condImage.alpha = 1
            self.makeViewRound()
        }
    }
    
    func makeViewRound() {
        bubbleView.layer.cornerRadius = 8
        bubbleView.layer.borderColor = UIColor.black.cgColor
        bubbleView.layer.borderWidth = 1
    }
}
