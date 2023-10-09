//
//  HomeViewModel.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import Foundation
import RxDataSources
import MJRefresh

enum MediaType {
    case movie
    case podcast
    case music
    case musicVideo
    case audiobook
    case shortFilm
    case tvShow
    case software
    case ebook
    case all
}

let AllEntityTypes:[String:String] = [
    "song" : "song",
    "album" : "album",
    "artist" : "musicArtist"
]

let AllCountry:[String:String] = [
    "us" : "us",
    "jp" : "jp",
    "kr" : "kr",
    "cn" : "cn"
]

enum FetchResult {
    case success(isNoMore:Bool = false)
    case error(msg:String)
}

extension Collection where Element == RowViewModel {
    internal func isContainModel(_ input: RowViewModel) -> Bool {
        for model in self {
            if model.modelId == input.modelId {
                return true
            }
        }
        return false
    }
}

class HomeViewModel {
    var disposeBag = DisposeBag()
    var dataSource = RxTableViewSectionedReloadDataSource<SectionViewModel> { dataSource, table, idxPath, item in
        let cell = table.dequeueReusableCell(withIdentifier: item.identifier, for: idxPath)
        item.bind(cell: cell)
        return cell
    }
    var page = 0
    let sectionsSubject = BehaviorRelay<[SectionViewModel]>(value: [])
    let fetchResultSubject = PublishSubject<FetchResult>.init()
    let countrySubject = PublishSubject<String>.init()
    let entitySubject = PublishSubject<String>.init()
    
    func fetchDatas(keyword: String,
                    entity:String = "song",
                    country: String = DeviceInfo.countryCode,
                    language: String = DeviceInfo.languageCode,
                    isLoadMore:Bool = false)
    {
        let offset = isLoadMore ? page + 1 : 0
        let k = keyword.isEmpty ? "Jhon" : keyword
        Service.Home.search(keyword: k, entity: entity,country: country,language: language, offset: offset).request()
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: {[weak self] (response:HomeSearchResponseModel) in
            Logger.debug(.Search, message: "search success")
            guard let `self` = self else { return }
            self.page = isLoadMore ? self.page + 1 : 0
            let items = response.results.map { data in
                RowViewModel.init(data: data)
            }
            var subject = self.sectionsSubject.value
            if !subject.isEmpty {
                if isLoadMore {
                    let result = items.filter { model in
                        !subject[0].items.isContainModel(model)
                    }
                    subject[0].items.append(contentsOf: result)
                }else{
                    subject[0].items = items
                }
                self.sectionsSubject.accept(subject)
            }else{
                let sec = [SectionViewModel.init(header: "", items: items)]
                self.sectionsSubject.accept(sec)
            }
            if response.resultCount < 20 || self.page >= 5 {
                self.fetchResultSubject.onNext(.success(isNoMore: true))
            }else{
                self.fetchResultSubject.onNext(.success())
            }
        }) { error in
            Logger.debug(.Search, message: "search fail\(error)")
            self.fetchResultSubject.onNext(.error(msg: "\(error)"))
        }.disposed(by: self.disposeBag)
    }
}





