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
        v.addSubview(moreFilter)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.top)
            make.trailing.equalTo(-20)
            make.height.equalTo(textField.snp.height)
            make.width.equalTo(searchButton.width)
        }
        moreFilter.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview().offset(-24)
        }
        return v
    }()
    lazy var textField: UISearchTextField = {
        let v = UISearchTextField()
        v.tintColor = .white
        v.textColor = .white
        return v
    }()
    lazy var moreLabel: UILabel = {
        let label = UILabel()
        label.text = "more criteria".localizedValue
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor.white//.withAlphaComponent(0.6)
        let tap = UITapGestureRecognizer()
        tap.rx.event.asDriver().throttle(.milliseconds(300)).asObservable().subscribe {[weak self] t in
            guard let `self` = self else {
                return
            }
            self.didMoreClick()
        }.disposed(by: self.disposeBag)
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage.init(named: "icon_home_morefilter"), for: .normal)
        btn.rx.tap.asDriver().throttle(.milliseconds(300)).asObservable().subscribe(onNext: {[weak self] in
            guard let `self` = self else {
                return
            }
            self.didMoreClick()
        }).disposed(by: self.disposeBag)
        return btn
    }()
    
    lazy var moreContainer: UIView = {
        let container = UIView()
        container.addSubview(moreLabel)
        container.addSubview(moreButton)
        moreLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(24)
            make.trailing.equalTo(moreButton.snp.leading).offset(-4)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        return container
    }()
    
    lazy var moreFilter: UIView = {
        let container = UIView()
        container.clipsToBounds = true
        let content = UIView()
        container.addSubview(content)
        content.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(115)
        }
        let l1 = UILabel.init()
        l1.text = "result type".localizedValue
        l1.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        l1.textColor = .white
        content.addSubview(l1)
        content.addSubview(entitySegmentedControl)
        l1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
        entitySegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(l1.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(24)
        }
        let l2 = UILabel.init()
        l2.text = "country".localizedValue
        l2.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        l2.textColor = .white
        content.addSubview(l2)
        content.addSubview(countrySegmentedControl)
        l2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(entitySegmentedControl.snp.bottom).offset(10)
        }
        countrySegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(l2.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(24)
        }
        return container
    }()
    
    lazy var entitySegmentedControl: UISegmentedControl = {
        let items = AllEntityTypes.map { (key: String, value: String) in
            return key.localizedValue
        }
        let segmented = UISegmentedControl.init(items: items)
        segmented.selectedSegmentIndex = 0
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        let titleColor = UIColor.init(byRed: 30, green: 170, blue: 240).withAlphaComponent(0.8)
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : titleColor], for: .selected)
        return segmented
    }()
    
    lazy var countrySegmentedControl: UISegmentedControl = {
        let items = AllCountry.map { (key: String, value: String) in
            return key.localizedValue
        }
        let segmented = UISegmentedControl.init(items: items )
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        let titleColor = UIColor.init(byRed: 30, green: 170, blue: 240).withAlphaComponent(0.8)
        segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : titleColor], for: .selected)
        segmented.selectedSegmentIndex = 0
        return segmented
        
    }()
    
    lazy var searchButton: UIButton = {
        let btn = UIButton()
        let title = "search".localizedValue
        let font = UIFont.systemFont(ofSize: 15)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = font
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.width = title.boundingRect(with: CGSize.init(width: 300, height: 100), font: font).width + 6
        let bgcolor = UIColor.randomColor
        let bg = UIImage.init(color: bgcolor, size: CGSize.init(width: btn.width, height: 60))
        let bgh = UIImage.init(color: bgcolor.withAlphaComponent(0.7), size: CGSize.init(width: btn.width, height: 60))
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
        self.backgroundColor = UIColor.init(byRed: 30, green: 170, blue: 240).withAlphaComponent(0.8)
        self.clipsToBounds = true
        self.layer.cornerRadius = 34
        self.addSubview(content)
        self.addSubview(moreContainer)
        content.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(self.safeTop)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        moreContainer.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func didMoreClick() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            let transform = CGAffineTransformRotate(self.moreButton.transform, Double.pi)
            self.moreFilter.snp.updateConstraints { make in
                if self.moreButton.isSelected {
                    make.height.equalTo(0)
                }else {
                    make.height.equalTo(115)
                }
                self.moreButton.transform = transform
            }
            self.moreButton.isSelected = !self.moreButton.isSelected
            self.superview?.layoutIfNeeded()
        }
    }
}
