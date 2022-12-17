//
//  TodoViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 16/12/2022.
//

import Foundation
import UIKit
import Combine

class TodoViewController: UIViewController {
    
    private lazy var tableView: UITableView = { .standardTableView() }()
    private lazy var addTaskButton: UILabel = { .init() }()
    private lazy var addTask: UIButton = { .init() }()
    private let viewModel: TodoViewModel
    private var bag: Set<AnyCancellable>
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = .init()
        self.bag = .init()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservers()
        setupNotification()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: CGFloat.safeAreaInsets)
        
        view.addSubview(addTask)
        view.setFittingConstraints(childView: addTask, leading: 10, trailing: 10, bottom: .safeAreaInsets.bottom + 70, height: 50)
        
        addTask.backgroundColor = .green
        addTask.clippedCornerRadius = 20
        "Add Task".body1Bold(color: .white).render(target: addTask)
        addTask.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    private func setupObservers() {
        viewModel.sections
            .sink { [unowned self] in
                tableView.reloadData($0)
            }
            .store(in: &bag)
    }
    
    @objc
    private func tapAction() {
        print("(DEBUG) clicked on Tap!")
        presentView(style: .sheet(), target: AddTaskViewController(model: viewModel), onDimissal: nil)
    }
    
    private func setupNotification() {
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { permissionGranted, err in
            guard permissionGranted else { return }
        }
    }
}


//MARK: - TodoCell
class TodoCell: ConfigurableCell {
    
    private lazy var label: UILabel = { .init() }()
    private lazy var subLabel: UILabel = { .init() }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stack = UIStackView.HStack(subViews: [label, .spacer(), subLabel], spacing: 8, alignment: .center).embedInView(insets: .init(by: 10))
        stack.clippedCornerRadius = 8
        stack.backgroundColor = .surfaceBackgroundInverse
        
        contentView.addSubview(stack)
        contentView.setFittingConstraints(childView: stack, insets: .init(by: 10))
        backgroundColor = .surfaceBackground
    }
    
    func configure(with model: TodoModel) {
        model.title.body1Bold(color: .textColorInverse).render(target: label)
        model.priority.body2Regular(color: .textColorInverse).render(target: subLabel)
    }
}
