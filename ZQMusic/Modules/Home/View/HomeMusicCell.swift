//
//  HomeMusicCell.swift
//  ZQMusic
//
//  Created by wp on 9/30/23.
//

import UIKit

class HomeMusicCell: UITableViewCell {

    var Id: Int64 = 0
    lazy var cover: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textColor = UIColor.black
        return label
    }()
    lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var desLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.init(named: "tabbar_favorites_normal"), for: .normal)
        button.setBackgroundImage(UIImage.init(named: "tabbar_favorites_selected"), for: .selected)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.Id = 0
        self.favoritesButton.isSelected = false
    }
    
    func setupUI() {
        self.backgroundColor = .white
        self.backgroundView = UIView.init()
        self.backgroundView?.backgroundColor = .white
        self.selectedBackgroundView = UIView.init()
        self.selectedBackgroundView?.backgroundColor = .black.withAlphaComponent(0.1)
        self.contentView.addSubview(cover)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(artistLabel)
        self.contentView.addSubview(desLabel)
        self.contentView.addSubview(favoritesButton)
        cover.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(67)
            make.height.equalTo(100).priority(.high)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(cover.snp.trailing).offset(10)
            make.top.equalTo(cover.snp.top)
            make.trailing.equalToSuperview().offset(-10)
        }
        artistLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-10)
        }
        desLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(artistLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-10)
        }
        favoritesButton.snp.makeConstraints { make in
            make.leading.equalTo(cover.snp.trailing).offset(10)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(20)
        }
    }
}
