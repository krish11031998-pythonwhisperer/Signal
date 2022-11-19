//
//  TopMentionDetail.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 02/11/2022.
//

import Foundation
import UIKit

extension UITableView {
    
    static func standardTableView() -> UITableView {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .surfaceBackground
        table.separatorStyle = .none
        return table
    }
    
}

class TopMentionDetailView: UIViewController {

    private lazy var headerView: UIView = {
        let view = UIView(circular: .init(origin: .zero, size: .init(squared: 32)), background: .gray)
        view.addShape(shape: .circle(color: .white, width: 1))
        view.setFrame(.init(squared: 32))
        return view
    }()
    private lazy var headerLabel = { UILabel() }()
    private lazy var symbolLabel: UILabel = { .init() }()
    private lazy var tableView: UITableView = { .standardTableView() }()
    private lazy var viewModel: TopMentionDetailViewModel = {
        let vm = TopMentionDetailViewModel()
        vm.tableView = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransparentNavBar()
        standardNavBar()
        setupView()
        viewModel.fetchData()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
        addHeaderView()
    }
    
    private func addHeaderView() {
        let infoStack: UIView = .HStack(subViews:[headerView, headerLabel, .spacer(), symbolLabel], spacing: 10, alignment: .center).embedInView(insets: .init(vertical: 10, horizontal: 15))
        MentionStorage.selectedMention?.name.heading3().render(target: headerLabel)
        MentionStorage.selectedMention?.ticker.body1Bold().render(target: symbolLabel)
        
        let chart = RatingChart(timeFrame: 50, frame: .zero).embedInView(insets: .init(by: 10))
        chart.setFrame(width: .totalWidth, height: 175)
        
        let headerView: UIView = .VStack(subViews: [infoStack, chart], spacing: 10)
        headerView.setFrame(width: .totalWidth, height: headerView.compressedSize.height)
        tableView.headerView = headerView
    }
    
    private var selectorRow: TableCellProvider {
        let tableSectionNames: [CollectionCellProvider] = ["News", "Tweets", "Videos From Youtube"].reversed().map {
            let view = $0.body3Medium().generateLabel
            let blob = view.blobify(backgroundColor: .clear, edgeInset: .init(by: 7.5), borderColor: .surfaceBackgroundInverse, borderWidth: 2, cornerRadius: 8)
            return CollectionItem<CustomCollectionCell>(.init(view: blob))
        }

    
        return TableRow<CollectionTableCell>(.init(cells: tableSectionNames, size: .init(width: .totalWidth, height: 70), inset: .init(by: 10), cellSize: .zero, automaticDimension: true, interspacing: 0))
    }
    
}


//MARK: - TopMentionDetail Extension

extension TopMentionDetailView: AnyTableView {

    func reloadTableWithDataSource(_ dataSource: TableViewDataSource) {
        tableView.reloadData(dataSource)
    }
    
    func reloadSection(_ section: TableSection, at sectionIdx: Int?) {
        tableView.reloadSection(section, at: sectionIdx)
    }
}
