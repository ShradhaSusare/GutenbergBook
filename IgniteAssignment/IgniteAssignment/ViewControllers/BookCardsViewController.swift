//
//  BookCardsViewController.swift
//  IgniteAssignment
//
//  Created by Shraddha on 9/3/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import UIKit
import SDWebImage
class BookCardsViewController: UIViewController {

    @IBOutlet weak var lblBookCategory: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bookCardCollectionView: UICollectionView!
    @IBOutlet weak var imgViewBackBtn: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var books: [BookModel]?
    var booksWrapper: BooksWrapper? // holds the last wrapper that we've loaded
    var isLoadingBooks = false
    var utils = Utils()
    var titleCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup()  {
        self.lblBookCategory.text = titleCategory!
        self.activityIndicator.isHidden = false;
        self.loadFirstBooks()
        searchBar.delegate = self

        let backGesture = UITapGestureRecognizer(target: self, action: #selector(btnBackAction(sender:)))
        backGesture.numberOfTapsRequired = 1;
        imgViewBackBtn.isUserInteractionEnabled = true
        self.imgViewBackBtn.addGestureRecognizer(backGesture)
    }
    
    // MARK: Loading Books from API
    func loadFirstBooks() {
      isLoadingBooks = true
        var query = [String: String]()
        query["topic"] = self.titleCategory!
        BookModel.getBooks(query: query) { wrapper in
            if let wrapper = wrapper {
                self.addBooksFromWrapper(wrapper)
                self.isLoadingBooks = false
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true;
                    self.bookCardCollectionView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not load first Books", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loadMoreBooks() {
      self.isLoadingBooks = true
      if let books = self.books,
        let wrapper = self.booksWrapper,
        let totalBooksCount = wrapper.count,
        books.count < totalBooksCount {
        // there are more books out there!
        BookModel.getMoreBooks(wrapper) { result in
            if result == nil {
                self.isLoadingBooks = false
                let alert = UIAlertController(title: "Error", message: "Could not load more Books", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let moreWrapper = result
                self.addBooksFromWrapper(moreWrapper)
                self.isLoadingBooks = false
                DispatchQueue.main.async {
                                    self.bookCardCollectionView.reloadData()

                }
            }
        }
        
    }
    }

    func addBooksFromWrapper(_ wrapper: BooksWrapper?) {
      self.booksWrapper = wrapper
      if self.books == nil {
        self.books = self.booksWrapper?.results
      } else if self.booksWrapper != nil && self.booksWrapper!.results != nil {
        self.books = self.books! + self.booksWrapper!.results!;
      }
    }
    @objc func btnBackAction( sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BookCardsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.books == nil {
          return 0
        }
        return self.books!.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BookCardCollectionViewCell
        
        if self.books != nil && self.books!.count >= indexPath.row {
          let book = self.books![indexPath.row]
            cell?.lblBookTitle.text = book.title
            if book.authors!.count > 0 {
            cell?.lblBookAuthor.text = book.authors![0]["name"] as? String;
            }
            cell?.imgViewBook.layer.cornerRadius = 8;
            cell?.imgViewBook.layer.masksToBounds = true
            let imgURL = book.formats!["image/jpeg"] as String?
            
            cell?.imgViewBook.sd_setImage(with: URL(string: imgURL!), placeholderImage: UIImage(named: "pattern"), options: SDWebImageOptions.continueInBackground, context: nil)
            
          // See if we need to load more books
          let rowsToLoadFromBottom = 5;
          let rowsLoaded = self.books!.count
          if (!self.isLoadingBooks && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom))) {
            let totalRows = self.booksWrapper!.count!
            let remainingBooksToLoad = totalRows - rowsLoaded;
            if (remainingBooksToLoad > 0) {
              self.loadMoreBooks()
            }
          }
        }
        
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let bookAtIndex = books![indexPath.row]
        let formats = bookAtIndex.formats!
        if let htmlURL = formats["text/html; charset=utf-8"]{
            let url = URL(string: htmlURL)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let pdfURL = formats["application/pdf"]{
            let url = URL(string: pdfURL)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else if let txtURL = formats["text/plain; charset=utf-8"]{
            let url = URL(string: txtURL)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            let alert = UIAlertController(title: "Can not open this Book", message: "Could not load this Book", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
}

extension BookCardsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            getBooks(searchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            getBooks(searchString: searchBar.text!)
            searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    @objc func getBooks(searchString: String?) {
        
        self.books = []
        self.activityIndicator.isHidden = false
        self.bookCardCollectionView.reloadData()
        var query = [String: String]()

        if searchString!.count > 0 {
            query = ["search":"\(searchString!)"]
        } else if searchString!.isEmpty {
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            query = ["topic" : "\(self.titleCategory!)"]
        }

            BookModel.getBooks(query: query) { wrapper in
                if let wrapper = wrapper {
                    self.addBooksFromWrapper(wrapper)
                    self.isLoadingBooks = false
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.bookCardCollectionView.reloadData()
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Could not load first Books", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        
        print(searchString!)
    }
    
    
    func applyTheme()  {
    let alert = UIAlertController(title: "Empty Text", message: "Could not load Empty Books", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    }

}
