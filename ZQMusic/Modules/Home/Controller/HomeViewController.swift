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

class HomeViewController: UIViewController {

    let vmodel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        setupUI()
        rxbind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.backgroundColor = .randomColor.withAlphaComponent(0.7)
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
        let v = UITableView.init(frame: .zero, style: .plain)
        return v
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
            self?.vmodel.fetchDatas()
        }).disposed(by: self.disposeBag)
    }
}
