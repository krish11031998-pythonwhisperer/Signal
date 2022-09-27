//
//  TableRow.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

typealias ConfigurableCell = Configurable & UITableViewCell

protocol TableCellProvider {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath)
	func didSelect(_ tableView: UITableView, indexPath: IndexPath)
}

class TableRow<Cell: ConfigurableCell>: TableCellProvider {
	
	var model: Cell.Model
	
	init(_ model: Cell.Model) {
		self.model = model
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: Cell = tableView.dequeueCell()
		cell.configure(with: model)
		return cell
	}
	
	func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as? Cell
		cell?.configure(with: model)
	}
	
	func didSelect(_ tableView: UITableView, indexPath: IndexPath) {
		if let actionProvider = model as? ActionProvider {
			actionProvider.action?()
		}
	}
	
}

