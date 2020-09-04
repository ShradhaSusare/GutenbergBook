//
//  BookCardViewModel.swift
//  IgniteAssignment
//
//  Created by Shraddha on 9/4/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import Foundation
import UIKit

enum BookFields: String {
    case Id = "id"
    case Authors = "authors"
    case Bookshelves = "bookshelves"
    case DownloadCount = "download_count"
    case Formats = "formats"
    case Languages = "languages"
    case MediaType = "media_type"
    case Subjects = "subjects"
    case Title = "title"
}

class BooksWrapper {
    var results: [BookModel]?
    var count: Int?
    var next: String?
    var previous: String?
}

class BookModel {
    var id: Int?
    var authors:[[String: Any]]?
    var bookshelves: [String]?
    var download_count: Int?
    var formats: [String:String]?
    var languages: [String]?
    var media_type: String?
    var subjects:[String]?
    var title:String?
    
    required init(json: [String: Any]) {
        self.id = json[BookFields.Id.rawValue] as? Int
        self.authors = json[BookFields.Authors.rawValue] as? [[String: Any]]
        self.bookshelves = json[BookFields.Bookshelves.rawValue] as? [String]
        self.download_count = json[BookFields.DownloadCount.rawValue] as? Int
        self.formats = json[BookFields.Formats.rawValue] as? [String:String]
        self.languages = json[BookFields.Languages.rawValue] as? [String]
        self.media_type = json[BookFields.MediaType.rawValue] as? String
        self.subjects = json[BookFields.Subjects.rawValue] as? [String]
        self.title = json[BookFields.Title.rawValue] as? String
    }
    
    class func endpointForBooks(query: [String:String]) -> String {
        return "http://skunkworks.ignitesol.com:8000/books/";
    }
    
    private class func booksArrayFromResponse(response: [String: Any]?) -> BooksWrapper? {
        if response == nil {
            return nil
        }
        
        let wrapper: BooksWrapper = BooksWrapper()
        wrapper.next = response!["next"] as? String
        wrapper.previous = response!["previous"] as? String
        wrapper.count = response!["count"] as? Int
        
        var allBooks : [BookModel] = []
        if let results = response!["results"] as? [[String: Any]] {
            for jsonBook in results {
                let book = BookModel(json: jsonBook);
                allBooks.append(book)
            }
        }
        wrapper.results = allBooks;
        return wrapper
    }
    
    fileprivate class func getBooksAtPath(path: String, query: [String:String], completionHandler: @escaping (BooksWrapper?) -> Void) {
        let utils = Utils()
        utils.dataTaskWith(url: path, param: query) { (isSuccess, data, err) in
            if isSuccess {
                let bookWrapperResult = BookModel.booksArrayFromResponse(response: data)
                completionHandler(bookWrapperResult)
            } else {
                completionHandler(nil)
            }
        }
        
    }
    
    class func getBooks(query: [String: String], _ completionHandler: @escaping (BooksWrapper?) -> Void) {
        getBooksAtPath(path: BookModel.endpointForBooks(query: query), query: query, completionHandler: completionHandler)
    }
    
    class func getMoreBooks(_ wrapper: BooksWrapper?, completionHandler: @escaping (BooksWrapper?) -> Void) {
        let query = [String:String]()
        guard let nextURL = wrapper?.next else {
            completionHandler(nil)
            return
        }
        getBooksAtPath(path: nextURL, query: query,completionHandler: completionHandler)
    }
    
    private class func bookFromResponse(response: [String: Any]?) -> BookModel? {
        if response == nil {
            return nil
        }
        
        let books = BookModel(json: response!)
        return books
    }
    
    
}
