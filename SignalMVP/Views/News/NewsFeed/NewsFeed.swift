//
//  NewsViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

class NewsFeed: UIViewController {
	
	private lazy var tableView: UITableView = { .init(frame: .zero, style: .grouped) }()
    private var cancellable: Set<AnyCancellable> = .init()
    private let viewModel: NewsViewModel = .init()
    private let selectedCurrency: CurrentValueSubject<String? ,Never> = .init(nil)
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .surfaceBackground.withAlphaComponent(0.3)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSearch)))
        return view
    }()
    private lazy var searchController: UISearchController = { .init(searchResultsController: NewsSearchResultController(viewModel: .init(selectedCurrency: selectedCurrency))) }()
	//MARK: - Overriden Methods
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupNavbar()
        setupSearchbarViewController()
		bind()
	}

	//MARK: - ProtectedMethods
	
	private func setupViews(){
		view.backgroundColor = .surfaceBackground
		view.addSubview(tableView)
		tableView.backgroundColor = .surfaceBackground
		tableView.separatorStyle = .none
		view.setFittingConstraints(childView: tableView, insets: .zero)
        
	}
	
	private func setupNavbar() {
        standardNavBar(leftBarButton: .init(customView: "News".heading2().generateLabel))
	}
	
    private func setupSearchbarViewController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = (searchController.searchResultsController as? NewsSearchResultController)
        
        searchController.searchBar.searchTextField.font = CustomFonts.medium.fontBuilder(size: 16)
        searchController.searchBar.searchTextField.attributedPlaceholder = "Explore".body1Medium() as? NSAttributedString
        searchController.searchBar.searchTextField.backgroundColor = .surfaceBackgroundInverse.withAlphaComponent(0.25)
        searchController.searchBar.searchTextField.leftView = nil
        searchController.automaticallyShowsCancelButton = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    private func showDimmingView(addDimming: Bool) {
        if addDimming {
            view.addSubview(dimmingView)
            view.setFittingConstraints(childView: dimmingView, insets: .zero)
        } else {
            dimmingView.removeFromSuperview()
        }
    }
    
    private func bind () {
        viewModel.selectedNews
            .compactMap { $0 }
            .sink { [weak self] in
                guard let nav = self?.navigationController else { return }
                nav.pushViewController(NewsDetailView(news: $0), animated: true)
            }
            .store(in: &cancellable)

        
        let output = viewModel.transform(input: .init(searchParam: selectedCurrency))
        
        output
            .tableSection
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print("(ERROR) err: ", completion.err?.localizedDescription)
            }, receiveValue: { [weak self] section in
                self?.tableView.reloadData(.init(sections: [section]))
            })
            .store(in: &cancellable)
        
        output.dismissSearch
            .sink { [weak self] _ in
                self?.dismissSearch()
            }
            .store(in: &cancellable)
    
    }
    
    @objc
    private func dismissSearch() {
        self.searchController.isActive = false
        showDimmingView(addDimming: self.searchController.searchBar.searchTextField.resignFirstResponder())
    }
}

//MARK: - NewsFeed - UISerachBarDelegate
extension NewsFeed: UISearchControllerDelegate, UISearchBarDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("(DEBUG) isActive: ", searchController.isActive)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("(DEBUG) searchBar.isEditing: ", searchBar.searchTextField.isEditing)
        self.showDimmingView(addDimming: searchBar.searchTextField.isFirstResponder)
    }
    
}