//
//  SeachViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/12/2022.
//

import Foundation
import Combine
import UIKit

protocol SearchResultSharer {
    init(result: CurrentValueSubject<String?, Never>)
}

typealias SearchResultViewController = UISearchResultsUpdating & UIViewController & SearchResultSharer

class SearchViewController: UIViewController {
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .surfaceBackground.withAlphaComponent(0.3)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSearch)))
        return view
    }()
    
    private var searchPlaceholder: String
    var searchController: UISearchController?
    fileprivate var searchText: CurrentValueSubject<String?, Never> = .init(nil)
    var bag: Set<AnyCancellable> = .init()
    
    init<T:SearchResultViewController>(placeHolder: String = "Explore", resultController: T.Type) {
        self.searchPlaceholder = placeHolder
        super.init(nibName: nil, bundle: nil)
        self.searchController = .init(searchResultsController: resultController.init(result: searchText))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        bind()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = self.searchController
        searchController?.searchResultsUpdater = searchController?.searchResultsController as? SearchResultViewController
        searchController?.standardStyling(placeholder: searchPlaceholder)
    }
    
    private func showDimmingView(addDimming: Bool) {
        if addDimming {
            view.addSubview(dimmingView)
            view.setFittingConstraints(childView: dimmingView, insets: .zero)
        } else {
            dimmingView.removeFromSuperview()
        }
    }
    
    private func bind() {
        searchController?
            .searchBar
            .searchTextField
            .didStartEditing
            .sink { [weak self] in
                self?.showDimmingView(addDimming: $0)
            }
            .store(in: &bag)
        
        searchText
            .compactMap { $0 == nil }
            .sink { [weak self] _ in
                self?.dismissSearch()
            }
            .store(in: &bag)
        
    }
    @objc
    func dismissSearch() {
        guard let searchController = self.searchController else { return }
        searchController.isActive = false
        showDimmingView(addDimming: searchController.searchBar.searchTextField.resignFirstResponder())
    }
    
    @objc
    func removeSearch() {
        searchText.send(nil)
    }
    
    public func accessoryDisplay(search: String) -> UIView {
        let headerView = UIStackView.VStack(spacing: 10, alignment: .leading)
        headerView.addArrangedSubview("Selected currency".body1Regular().generateLabel)
        let xmark = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.textColorInverse).resized(withAspect: .init(squared: 12))
        let ticketText = search.styled(font: .bold, color: .textColorInverse, size: 14) + xmark
        let tickerView = ticketText.generateLabel.blobify(backgroundColor: .surfaceBackgroundInverse,
                                                          edgeInset: .init(top: 5, left: 12, bottom: 5, right: 6),
                                                          borderColor: .clear,
                                                          borderWidth: 0,
                                                          cornerRadius: 12)
        tickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeSearch)))
        
        headerView.addArrangedSubview(tickerView)
        return headerView.embedInView(insets: .init(top: 16, left: 16, bottom: 0, right: 16))
    }
    
    var search: AnyPublisher<String?, Never> {
        searchText
            .share()
            .eraseToAnyPublisher()
    }
}
