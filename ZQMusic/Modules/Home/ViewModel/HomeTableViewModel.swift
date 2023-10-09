//
//  HomeTableViewModel.swift
//  ZQMusic
//
//  Created by wp on 9/30/23.
//

import Foundation
import RxDataSources
import Kingfisher

class RowViewModel: TableRowViewModelProtocol{

    var modelId: String {
        return "\(data.artistId ?? 0)\(data.artistName ?? "123")".md5
    }
    var data: ItemModel
    var disposeBag: DisposeBag?
    var Id: Int64 {
        if let id = data.trackId {
            return id
        }
        return 0
    }
    
    func bind(cell: UIView) {
        guard let cell = cell as? HomeMusicCell else { return }
        disposeBag = DisposeBag()
        cell.Id = self.Id
        cell.nameLabel.text = data.trackName
        cell.artistLabel.text = data.artistName
        if data.longDescription != ""{
            cell.desLabel.isHidden = false
            cell.desLabel.text = data.longDescription
        }else{
            cell.desLabel.isHidden = true
        }
        if let urlstring = data.artworkUrl100, let url = URL(string: urlstring) {
            let resource   = ImageResource.init(downloadURL:url)
            let cache      = KingfisherManager.shared.cache
            
            let processor = ResizingImageProcessor(referenceSize: CGSize.init(width: 67, height: 100),mode: .aspectFill).append(another: RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize.init(width: 67, height: 100)))
            let options = [
                KingfisherOptionsInfoItem.transition(ImageTransition.fade(1)),
                KingfisherOptionsInfoItem.targetCache(cache),
                .processor(processor)
            ]
            cell.cover.kf.setImage(with: resource,
                                  placeholder: nil,
                                  options: options,
                                  progressBlock: nil,
                                  completionHandler: nil)
        }
        
        cell.favoritesButton.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(300)).asObservable().subscribe(onNext: {[weak self,weak cell] in
            guard let `self` = self else { return }
            guard let cell = cell else { return }
            cell.favoritesButton.isSelected = !cell.favoritesButton.isSelected
            ZQCoreDataManager.shared.updateFavorite(self.data,
                                                    isFavorite: cell.favoritesButton.isSelected)
            
        }).disposed(by: self.disposeBag!)
        ZQCoreDataManager.shared.getFavoriteStatus(self.data) { isFavorite in
            if cell.Id == self.Id {
                cell.favoritesButton.isSelected = isFavorite
            }
        }
        
    }
    static func cellClass() -> AnyClass {
        return HomeMusicCell.self
    }
    init(data:ItemModel) {
        self.data = data
    }
}

struct SectionViewModel {
  var header: String
  var items: [Item]
}

extension SectionViewModel: SectionModelType {
  typealias Item = RowViewModel

   init(original: SectionViewModel, items: [Item]) {
    self = original
    self.items = items
  }
}
