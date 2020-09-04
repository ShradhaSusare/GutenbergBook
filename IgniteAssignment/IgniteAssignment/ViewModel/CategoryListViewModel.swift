//
//  CategoryListViewModel.swift
//  IgniteAssignment
//
//  Created by Shraddha on 9/3/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import Foundation
import UIKit

class CategoryListViewModel {
    init() {
    }
    
    func getCategoryData() -> [Category] {
        var categoryList = [Category]()
        categoryList.append(Category(categoryName: "FICTION", categoryImage: "Fiction"))
        categoryList.append(Category(categoryName: "DRAMA", categoryImage: "Drama"))
        categoryList.append(Category(categoryName: "HUMOR", categoryImage: "Humor"))
        categoryList.append(Category(categoryName: "POLITICS", categoryImage: "Politics"))
        categoryList.append(Category(categoryName: "PHILOSOPHY", categoryImage: "Philosophy"))
        categoryList.append(Category(categoryName: "HISTORY", categoryImage: "History"))
        categoryList.append(Category(categoryName: "ADVENTURE", categoryImage: "Adventure"))

        return categoryList
    }
}

class Category {
    var categoryName: String?
    var categoryImage: String?
    
    init(categoryName: String,categoryImage: String) {
        self.categoryName = categoryName
        self.categoryImage = categoryImage
    }
}
