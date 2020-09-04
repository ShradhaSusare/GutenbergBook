//
//  ViewController.swift
//  IgniteAssignment
//
//  Created by Shraddha on 9/2/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var categoryListTableView: UITableView!
    var categoryArray = [Category]()
    let categoryListVM = CategoryListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryArray = categoryListVM.getCategoryData();
        self.categoryListTableView.reloadData()
        self.categoryListTableView.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CategoryTableViewCell;
        cell?.configureCell(categoryData: categoryArray[indexPath.section]);
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !(categoryArray.isEmpty) {
            tableView.backgroundView = nil
            return categoryArray.count
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //categoryArray[indexPath.section].categoryName
        
        let vc = self.storyboard?.instantiateViewController(identifier: "BookCardsViewController") as? BookCardsViewController
        vc?.titleCategory = categoryArray[indexPath.section].categoryName
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil);
        
    }
    
    
}

