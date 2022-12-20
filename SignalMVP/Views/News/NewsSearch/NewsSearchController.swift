//
//  NewsSearchController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 19/12/2022.
//

import Foundation
import UIKit
import Combine

//MARK: - NewsSearchResultViewController
class NewsSearchResultController: UIViewController {
    
    private var tableView: UITableView = { .standardTableView() }()
    private var viewModel: NewsSearchViewModel = .init()
    private var bag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservers()

    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
        tableView.backgroundColor = .surfaceBackground
    }
    
    private func setupObservers() {
        let output = viewModel.transform()
        
        output.searchResults.sink(receiveCompletion: {
            print("(ERROR) err: ", $0.err?.localizedDescription)
        }, receiveValue: searchResult(_:))
        .store(in: &bag)
    }
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    private func searchResult(_ result: TableSection) {
        tableView.reloadData(.init(sections: [result]))
    }
    
}

//MARK: - NewsFeed
extension NewsSearchResultController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchParam.send(searchController.searchBar.text)
    }
}
