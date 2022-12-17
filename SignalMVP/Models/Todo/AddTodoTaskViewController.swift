//
//  AddTodoTaskViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 16/12/2022.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    
    var textChange: AnyPublisher<String?,Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
    
}

class AddTaskViewController: UIViewController {
    
    private lazy var textField: UITextField = { .init() }()
    private lazy var addTask: UIButton = { .init() }()
    private var bag: Set<AnyCancellable> = .init()
    private var model: TodoViewModel
    
    init(model: TodoViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservers()
        view.backgroundColor = .surfaceBackground
    }
    
    private func setupView() {
        let textFieldView = textField.embedInView(insets: .init(by: 8))
        textFieldView.border(color: .surfaceBackgroundInverse, borderWidth: 1, cornerRadius: 20)
        let stack: UIStackView = .VStack(subViews: [textFieldView, addTask, .spacer()],spacing: 30)
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, insets: .init(vertical: .safeAreaInsets.top + 10, horizontal: 20))
        
        textField.setHeight(height: 50, priority: .required)
        textField.textColor = .white
        
        addTask.setHeight(height: 50, priority: .required)
        addTask.backgroundColor = .appGreen.withAlphaComponent(0.2)
        addTask.clippedCornerRadius = 20
        "Add Task".body1Bold(color: .white).render(target: addTask)
        addTask.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        addTask.isEnabled = false
    }
    
    private func setupObservers() {
        textField.textChange
            .compactMap { $0 }
            .map { $0.count > 0 }
            .sink{ [unowned self] in
                addTask.isEnabled = $0
                addTask.backgroundColor = UIColor.appGreen.withAlphaComponent($0 ? 1 : 0.2)
            }
            .store(in: &bag)
    }
    
    @objc
    private func tapAction() {
        print("(DEBUG) clicked on Tap!")
        model.newTask.send(.init(title: textField.text ?? "", priority: "High"))
        setupNotification()
        dismiss(animated: true)
    }
    
    private func setupNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard let `self` = self else { return }
            guard settings.authorizationStatus == .authorized  else { return }
            
            DispatchQueue.main.async {
                let content : UNMutableNotificationContent = .init()
                content.title = self.textField.text ?? "No Text"
                content.body = "High Priority Task"
                let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Calendar.current.date(byAdding: .second, value: 3, to: .init()) ?? .distantFuture)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                
                let notification = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                notificationCenter.add(notification) {
                    print($0)
                }
            }
            
        }
    }
}
