//
//  OnboardingCollectionViewController.swift
//  Ambasity V1
//
//  Created by Zak on 4/11/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

struct Page {
    
    let imageName: String
    let headerText: String
    let bodyText: String
    let pageNumber: Int
    
}

class OnboardingCollectionViewController: UICollectionViewController {
    
    let pages = [
        
        Page(imageName: "onboarding0", headerText: "Choose Your Brands", bodyText: "Ambassadors receive their own custom link for each brand they choose to endorse.", pageNumber: 0),
        Page(imageName: "onboarding1", headerText: "Share Your Link", bodyText: "You can text, post, or share your customized link with your network as long as the campaign is open.", pageNumber: 1),
        Page(imageName: "onboarding2", headerText: "Get Paid!", bodyText: "For every person who clicks on your link and downloads the mobile app... you get paid!", pageNumber: 2)
        
    ]
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "slateBackground"))
        imageView.alpha = 0.35
        imageView.translatesAutoresizingMaskIntoConstraints = true
        
        return imageView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        
        pc.currentPageIndicatorTintColor = .darkGray
        pc.pageIndicatorTintColor = .gray
        
        pc.translatesAutoresizingMaskIntoConstraints = false

        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(OnboardingCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundView = backgroundImageView
        
        setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! OnboardingCell
        
        let page = pages[indexPath.item]
        cell.page = page
        
        cell.doneButton.addTarget(self, action: #selector(doneButton_TouchUpInside), for: .touchUpInside)
        
        return cell
    }
    
    private func setupLayout() {
        view.addSubview(pageControl)
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    
    @objc private func doneButton_TouchUpInside() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainViewController = storyboard.instantiateViewController(withIdentifier: "mainController")
        self.present(MainViewController, animated: true)
    }
    
}

extension OnboardingCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
