//
//  ShoppingItemCell.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class ShoppingItemCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    func bindDate(item: ShoppingItem) {
        
        let currentDateFormatter = dateFormatter()
        currentDateFormatter.dateFormat = "dd/MM/YYYY"
        
        nameLabel.text = item.name
        extraInfoLabel.text = item.info
        priceLabel.text = String(format: "$ %.2f", item.price)
        quantityLabel.text = item.quantity
        itemImageView.image = #imageLiteral(resourceName: "ShoppingCartFilled")
        
        
    }

}
