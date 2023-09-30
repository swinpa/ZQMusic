//
//  HomeSearchBar.swift
//  ZQMusic
//
//  Created by wp on 9/30/23.
//

import UIKit

class HomeSearchBar: UIView {

    
    
    lazy var content: UIView = {
        let v = UIView()
        v.addSubview(textField)
        v.addSubview(searchButton)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-10)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.top)
            make.trailing.equalTo(-20)
            make.height.equalTo(textField.snp.height)
            make.width.equalTo(searchButton.width)
        }
        
        return v
    }()
    lazy var textField: UISearchTextField = {
        let v = UISearchTextField()
        return v
    }()
    
    lazy var searchButton: UIButton = {
        let btn = UIButton()
        let title = "Search"
        let font = UIFont.systemFont(ofSize: 15)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = font
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.width = title.boundingRect(with: CGSize.init(width: 300, height: 100), font: font).width + 12
        let bgcolor = UIColor.randomColor
        let bg = UIImage.init(color: bgcolor, size: CGSize.init(width: btn.width, height: 60))
        let bgh = UIImage.init(color: bgcolor.withAlphaComponent(0.7), size: CGSize.init(width: btn.width, height: 60))
        btn.setBackgroundImage(bg, for: .normal)
        btn.setBackgroundImage(bgh, for: .highlighted)
        
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        self.addSubview(content)
        content.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(self.safeTop)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
