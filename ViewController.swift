//
//  ViewController.swift
//  CameraFilter
//
//  Created by Erbay, Yagiz on 1.02.2023.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        applyFilterButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController
        else {
            fatalError("Segue destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }.disposed(by: disposeBag)
    }
    
    
    @IBAction func applyFilterButtonPressed(_ sender: UIButton) {
        
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FiltersService.shared.sendFilter(to: sourceImage).subscribe { filteredImage in
            
            self.photoImageView.image = filteredImage
            self.applyFilterButton.isEnabled = false
            
        }.disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
        self.applyFilterButton.isEnabled = true
    }
}

