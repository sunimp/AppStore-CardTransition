//
//  TodayViewController.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/18.
//

import UIKit

import SnapKit

final class TodayViewController: ViewController,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
    
    let navigationBar = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Util.margin
        layout.minimumLineSpacing = Util.margin
        layout.sectionInset = .only(
            top: Util.spacingLarge,
            left: Util.marginLarge,
            bottom: Util.marginLarge,
            right: Util.marginLarge
        )
        let width = Util.screenWidth - layout.sectionInset.horizontal
        let height = Util.screenHeight / 2
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    let today = Bundle.main.decode(Today.self, from: "today.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TodayCoverCell.self, forCellWithReuseIdentifier: "cover")
        collectionView.register(TodayListCell.self, forCellWithReuseIdentifier: "list")
        collectionView.register(TodayRollCell.self, forCellWithReuseIdentifier: "roll")
        collectionView.register(TodaySupplyView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "supply")
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(Util.statusBarHeight)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.1) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

extension TodayViewController {
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return today?.events.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let event = today?.events[indexPath.item] else {
            return .init()
        }
        switch event.type {
        case .cover:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cover", for: indexPath) as? TodayCoverCell else {
                return .init()
            }
            cell.configure(event)
            cell.didTapAction = { [weak self] in
                guard let self else { return }
                
                self.handleCoverDetailAction(cell, event: event)
            }
            return cell
            
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as? TodayListCell else {
                return .init()
            }
            cell.configure(event)
            cell.didTapAction = { [weak self] in
                guard let self else { return }
                
                self.handleListDetailAction(cell, event: event)
            }
            return cell
        case .roll:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roll", for: indexPath) as? TodayRollCell else {
                return .init()
            }
            cell.configure(event)
            cell.didTapAction = { [weak self] in
                guard let self else { return }
                
                self.handleRollDetailAction(cell, event: event)
            }
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "supply",
            for: indexPath
        ) as? TodaySupplyView else {
            return UICollectionReusableView()
        }
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 48)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.adjustedContentInset.top + scrollView.contentOffset.y
        let delta = max(min(offsetY / 5.0, 1), 0)
        navigationBar.alpha = delta
    }
}

extension TodayViewController {
    // MARK: - Actions
    
    private func handleCoverDetailAction(_ cell: TodayCoverCell, event: Event) {
        let vc = CoverDetailViewController(event)
        let nav = NavigationController(rootViewController: vc)
        let delegate = CardCoverTransition.shared
        delegate.sourceView = cell
        nav.modalPresentationStyle = .fullScreen
        nav.transitioningDelegate = delegate
        self.present(nav, animated: true)
    }
    
    private func handleListDetailAction(_ cell: TodayListCell, event: Event) {
        let vc = ListDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleRollDetailAction(_ cell: TodayRollCell, event: Event) {
        
    }
}
