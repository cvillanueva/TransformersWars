//
//  TransformersBattleViewController.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 18-05-21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// swiftlint:disable force_cast

class TransformersBattleViewController: UIViewController {

    // MARK: - Widgets

    @IBOutlet weak var battleTableView: UITableView!

    // MARK: - Class variables
    var viewModel: TransformersBattleViewModel
    let disposeBag = DisposeBag()

    init(transformersList: [Transformer]) {
        self.viewModel = TransformersBattleViewModel(
            transformersList: transformersList
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
        self.setupBinding()
//        self.viewModel.fillTableWithMockData()
        self.viewModel.startBattle()
    }

    // MARK: - UI

    func setupUI() {
        self.title = AppConstants.TransformersBattleViewController.title
    }
}

extension TransformersBattleViewController {
    // MARK: - Rx functions

    /// To set table view properties
    func setupTableView() {
        battleTableView.rx.setDelegate(self).disposed(by: disposeBag)

        battleTableView.register(
            UINib(nibName: AppConstants.TransformersBattleViewController.battleCellName, bundle: nil),
            forCellReuseIdentifier: AppConstants.TransformersBattleViewController.battleCellName
        )
    }

    /// To listen changes in the viewmodel
    func setupBinding() {
        self.viewModel.output.battleItems
            .drive(battleTableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }

    func dataSource() -> RxTableViewSectionedReloadDataSource<BattlesListSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<BattlesListSectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ -> UITableViewCell in
                switch dataSource[indexPath] {
                case .battleItem(model: let model):
                    let cell: BattleTableViewCell = tableView.dequeueReusableCell(
                        withIdentifier: AppConstants.TransformersBattleViewController.battleCellName,
                        for: indexPath
                    ) as! BattleTableViewCell

                    cell.setup(model: model)

                    return cell
                }
            }
        )
        return dataSource
    }
}

extension TransformersBattleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.TransformersBattleViewController.battleCellHeight
    }
}
