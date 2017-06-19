//
//  ShoppingItemCell.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import SwipeCellKit

class ShoppingItemCell: SwipeTableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var quantityBackgroundView: UIView!
    
    func bindDate(item: ShoppingItem) {
        
        let currentDateFormatter = dateFormatter()
        currentDateFormatter.dateFormat = "dd/MM/YYYY"
        
        nameLabel.text = item.name
        extraInfoLabel.text = item.info
        
        priceLabel.text = String(format: "$ %.2f", item.price)
        quantityLabel.text = item.quantity
        
        quantityBackgroundView.layer.cornerRadius = quantityBackgroundView.frame.width / 2.0
        
        if item.image != "" {
            
            if let image = imageFromData(pictureData: item.image) {
                let scaledImage = image.scaleImageToSize(newSize: itemImageView.frame.size)
                itemImageView.image = scaledImage.circleMasked
            }
            
        } else {
            let newImage = UIImage(named: "ShoppingCartEmpty")!.scaleImageToSize(newSize: itemImageView.frame.size)
            
            itemImageView.image = newImage.circleMasked
        }
        
    }
    
    func bindGroceryItem(item: GroceryItem) {
        
        nameLabel.text = item.name
        extraInfoLabel.text = item.info
        
        priceLabel.text = String(format: "$ %.2f", item.price)
        
        if item.image != "" {
            if let image = imageFromData(pictureData: item.image) {
                let scaledImage = image.scaleImageToSize(newSize: itemImageView.frame.size)
                itemImageView.image = scaledImage.circleMasked
            }
        } else {
            let newImage = UIImage(named: "ShoppingCartEmpty")!.scaleImageToSize(newSize: itemImageView.frame.size)
            
            itemImageView.image = newImage.circleMasked
        }
        
    }

}






