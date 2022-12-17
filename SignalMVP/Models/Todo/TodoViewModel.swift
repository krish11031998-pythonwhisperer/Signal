//
//  TodoViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 16/12/2022.
//

import Foundation
import Combine

struct TodoModel {
    let title: String
    let priority: String
}

class TodoViewModel {
    private var tableSections: CurrentValueSubject<[TodoModel], Never> = .init([.init(title: "Test", priority: "High")])
    var sections: AnyPublisher<TableViewDataSource, Never>
    var newTask: PassthroughSubject<TodoModel, Never> = .init()
    var cancellable: Set<AnyCancellable> = .init()
    
    init() {
        self.sections = tableSections
            .map { todo -> [TableCellProvider] in  todo.map { TableRow<TodoCell>($0) } }
            .map{ rows -> TableSection in .init(rows: rows) }
            .map{ sections -> TableViewDataSource in .init(sections: [sections]) }.eraseToAnyPublisher()
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        self.newTask
            .sink { [unowned self] task in
                tableSections.send(tableSections.value + [task])
            }
            .store(in: &cancellable)
    }
}
