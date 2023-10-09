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

class FavoritesViewController: UIViewController {

    let vmodel = FavoritesViewModel()
    var hud: MBProgressHUD?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.randomColor
        setupUI()
        rxbind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDatas()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    lazy var listView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.estimatedRowHeight = 120
        table.backgroundColor = .white
        table.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        table.separatorColor = UIColor.init(byRed: 234, green: 234, blue: 234)
        
        table.register(RowViewModel.cellClass(), forCellReuseIdentifier: RowViewModel.identifier)
        return table
    }()
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    func rxbind() {
        self.vmodel.sectionsSubject.bind(to: listView.rx.items(dataSource: self.vmodel.dataSource))
            .disposed(by: disposeBag)
        
        self.listView.rx.modelSelected(RowViewModel.self).subscribe(onNext:  {[weak self] model in
            guard let trackViewUrl = model.data.trackViewUrl, let url = URL(string: trackViewUrl) else {
                return
            }
            let controller = SFSafariViewController(url: url)
            self?.present(controller, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    func fetchDatas() {
        self.vmodel.fetchDatas()
    }
}
