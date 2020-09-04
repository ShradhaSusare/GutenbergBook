//
//  CategoryTableViewCell.swift
//  IgniteAssignment
//
//  Created by Shraddha on 9/2/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import Foundation
import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(categoryData: Category)  {
        self.categoryLabel.text = categoryData.categoryName
        self.categoryImageView.image = UIImage(named: categoryData.categoryImage!);
    }
}

