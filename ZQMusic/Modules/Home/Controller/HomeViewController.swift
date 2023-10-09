//
//  HomeViewController.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import MJRefresh
import SafariServices
import MBProgressHUD

class HomeViewController: UIViewController {

    let vmodel = HomeViewModel()
    var hud: MBProgressHUD?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        setupUI()
        rxbind()
        self.fetchDatas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    lazy var searchBar: HomeSearchBar = {
        let bar = HomeSearchBar.init(frame: .zero)
        return bar
    }()
    
    lazy var listView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.estimatedRowHeight = 120
        table.backgroundColor = .white
        table.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        table.separatorColor = UIColor.init(byRed: 234, green: 234, blue: 234)
        table.register(RowViewModel.cellClass(), forCellReuseIdentifier: RowViewModel.identifier)
        table.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            self?.fetchDatas(isLoadMore: true)
        })
        table.mj_footer?.isHidden = true
        return table
    }()
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(searchBar)
        self.view.addSubview(listView)
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        listView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    func rxbind() {
        self.searchBar.searchButton.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(300)).asObservable().subscribe(onNext: {[weak self] in
            guard let `self` = self else { return }
            self.fetchDatas()
        }).disposed(by: self.disposeBag)
        self.searchBar.entitySegmentedControl.rx.controlEvent(.valueChanged).asObservable().subscribe(onNext: {[weak self] in
            guard let `self` = self else { return }
            let index = self.searchBar.entitySegmentedControl.selectedSegmentIndex
            guard let title = self.searchBar.entitySegmentedControl.titleForSegment(at: index),
                  let k = title.findKeyForLocalizedString(),
                  let entity = AllEntityTypes[k] else {
                return
            }
            self.vmodel.entitySubject.onNext(entity)
        }).disposed(by: self.disposeBag)
        self.searchBar.countrySegmentedControl.rx.controlEvent(.valueChanged).asObservable().subscribe(onNext: {[weak self] in
            guard let `self` = self else { return }
            let index = self.searchBar.countrySegmentedControl.selectedSegmentIndex
            guard let title = self.searchBar.countrySegmentedControl.titleForSegment(at: index),
                  let k = title.findKeyForLocalizedString(),
                  let country = AllCountry[k] else {
                return
            }
            self.vmodel.countrySubject.onNext(country)
        }).disposed(by: self.disposeBag)
        self.vmodel.entitySubject.asObservable().subscribe( {[weak self] _ in
            guard let `self` = self else { return }
            self.fetchDatas()
        }).disposed(by: self.disposeBag)
        self.vmodel.countrySubject.asObservable().subscribe( {[weak self] _ in
            guard let `self` = self else { return }
            self.fetchDatas()
        }).disposed(by: self.disposeBag)
        self.vmodel.sectionsSubject.bind(to: listView.rx.items(dataSource: self.vmodel.dataSource))
            .disposed(by: disposeBag)
        self.vmodel.fetchResultSubject.subscribe(onNext: {[weak self] result in
            guard let `self` = self else { return }
            if let _ = self.hud {
                self.hud?.hide(animated: false)
                self.hud = nil
            }
            switch result {
            case .success(let isNoMore):
                self.listView.mj_header?.endRefreshing()
                if isNoMore {
                    self.listView.mj_footer?.endRefreshingWithNoMoreData()
                }else{
                    self.listView.mj_footer?.endRefreshing()
                }
            case .error(let msg):
                self.listView.mj_header?.endRefreshing()
                self.listView.mj_footer?.endRefreshing()
                self.showToast(msg: msg)
            }
            let subject = self.vmodel.sectionsSubject.value
            if subject.isEmpty || subject[0].items.isEmpty  {
                self.listView.mj_footer?.isHidden = true
            }else{
                self.listView.mj_footer?.isHidden = false
            }
        }).disposed(by: self.disposeBag)
        self.listView.rx.modelSelected(RowViewModel.self).subscribe(onNext:  {[weak self] model in
            guard let trackViewUrl = model.data.trackViewUrl, let url = URL(string: trackViewUrl) else {
                return
            }
            let controller = SFSafariViewController(url: url)
            self?.present(controller, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        self.listView.rx.didScroll.subscribe(onNext:  {[weak self] value in
            self?.searchBar.textField.resignFirstResponder()
        }).disposed(by: disposeBag)
    }
    
    func fetchDatas(isLoadMore:Bool = false) {
        let k = self.searchBar.textField.text ?? ""
        let index = self.searchBar.entitySegmentedControl.selectedSegmentIndex
        var entity = "song"
        if let k = self.searchBar.entitySegmentedControl.titleForSegment(at: index), let value = AllEntityTypes[k] {
            entity =  value.findKeyForLocalizedString() ?? value
        }
        var country = "us"
        if let k = self.searchBar.countrySegmentedControl.titleForSegment(at: index), let value = AllCountry[k] {
            country =  value.findKeyForLocalizedString() ?? value
        }
        self.vmodel.fetchDatas(keyword: k,entity: entity,country: country, isLoadMore: isLoadMore)
        if !isLoadMore {
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.hud?.show(animated: true)
        }
        self.searchBar.textField.resignFirstResponder()
    }
}
