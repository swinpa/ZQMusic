//
//  HomeViewModel.swift
//  ZQMusic
//
//  Created by wp on 9/29/23.
//

import Foundation
import RxDataSources
import MJRefresh

class FavoritesViewModel {
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
    
    func fetchDatas() {
        ZQCoreDataManager.shared.getAllFavorite { array in
            let items = array.map { data in
                RowViewModel.init(data: data)
            }
            var subject = self.sectionsSubject.value
            if !subject.isEmpty {
                subject[0].items = items
                self.sectionsSubject.accept(subject)
            }else{
                let sec = [SectionViewModel.init(header: "", items: items)]
                self.sectionsSubject.accept(sec)
            }
        }
    }
}





