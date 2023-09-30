//
//  HomeViewModel.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import Foundation
import RxDataSources





class HomeViewModel {
    var disposeBag = DisposeBag()
    func fetchDatas() {
        
        Service.Home.search(keyword: "jhon").request()
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { (response:HomeSearchResponseModel) in
            Logger.debug(.Search, message: "search success")
        }) { error in
                Logger.debug(.Search, message: "search fail\(error)")
                
        }.disposed(by: self.disposeBag)
    }
}





