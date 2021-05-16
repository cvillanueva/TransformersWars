//
//  TransformersListViewController.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// swiftlint:disable force_cast

class TransformersListViewController: UIViewController {

    // MARK: - Widgets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var fightButton: UIButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var transformersTableView: UITableView!

    // MARK: - Class variables
    var viewModel: TransformersListViewModel
    let disposeBag = DisposeBag()

    init(
        viewModel: TransformersListViewModel = TransformersListViewModel()
    ) {
        self.viewModel = viewModel
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

        self.viewModel.fillTableWithMockData()
    }

    // MARK: - UI

    func setupUI() {
        self.title = AppConstants.TransformersListViewController.title

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.optimus(size: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        self.navigationController?.navigationBar.barTintColor = .red
        self.bottomStackView.backgroundColor = .red

        self.addButton.titleLabel?.font = .optimus(size: 24)
        self.fightButton.titleLabel?.font = .optimus(size: 24)
    }
}

extension TransformersListViewController {
    // MARK: - Rx functions

    /// To set table view properties
    func setupTableView() {
        transformersTableView.rx.setDelegate(self).disposed(by: disposeBag)

        transformersTableView.register(
            UINib(nibName: AppConstants.TransformersListViewController.autobotCellName, bundle: nil),
            forCellReuseIdentifier: AppConstants.TransformersListViewController.autobotCellName
        )

        transformersTableView.register(
            UINib(nibName: AppConstants.TransformersListViewController.decepticonCellName, bundle: nil),
            forCellReuseIdentifier: AppConstants.TransformersListViewController.decepticonCellName
        )
    }

    /// To listen changes in the viewmodel
    func setupBinding() {
        viewModel.output.newsItems
            .drive(transformersTableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }

    func dataSource() -> RxTableViewSectionedReloadDataSource<NewsListSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<NewsListSectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ -> UITableViewCell in
                switch dataSource[indexPath] {
                case .newsItem(model: let model):
//                    self.loadingAlert.dismiss(animated: true)
//                    self.fetchingData = false

                    let cell: AutobotTableViewCell = tableView.dequeueReusableCell(
                        withIdentifier: AppConstants.TransformersListViewController.autobotCellName,
                        for: indexPath
                    ) as! AutobotTableViewCell

                    cell.setup(model: model)

                    return cell
                }
            }
        )
        return dataSource
    }
}

extension TransformersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstants.TransformersListViewController.transformerCellHeight
    }
}
