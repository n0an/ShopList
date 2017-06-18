//
//  ListCell.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func bindDate(item: ShoppingList) {
        
        let currentDateFormatter = dateFormatter()
        currentDateFormatter.dateFormat = "dd/MM/YYYY"
        
        nameLabel.text = item.name
        totalItemsLabel.text = "\(item.totalItems) items"
        let totalPriceString = String(format: "%.2f", item.totalPrice)
        totalPriceLabel.text = "Total $ \(totalPriceString)"
        dateLabel.text = currentDateFormatter.string(from: item.date)
        
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
