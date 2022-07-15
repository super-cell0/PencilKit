//
//  KeyboardVC.swift
//  ImageSet
//
//  Created by Power super on 2022/6/30.
//

import UIKit


class KeyboardVC: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "手势操作"
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 10
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        titleLabel.center = view.center
        
        setPanGesture()
        setPinchGesture()
        setRotationGesture()
    }
    
    ///拖拽移动
    private func setPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(panGesture)

    }
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(titleLabel)
        let translation = sender.translation(in: self.view)
        titleLabel.center = CGPoint(x: titleLabel.center.x + translation.x, y: titleLabel.center.y + translation.y)
        sender.setTranslation(.zero, in: self.view)
    }
    ///缩放
    private func setPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction))
        titleLabel.addGestureRecognizer(pinchGesture)
    }
    @objc private func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
//        if sender.state == .changed {
//            let scale = sender.scale
//            //let frame = titleLabel.frame
//            titleLabel.frame = CGRect(x: 0, y: 0, width: titleLabel.frame.width * scale, height: titleLabel.frame.height * scale)
//            titleLabel.center = view.center
//        }
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
    
    ///旋转
    private func setRotationGesture() {
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureAction))
        titleLabel.addGestureRecognizer(rotationGesture)
    }
    
    @objc private func rotationGestureAction(_ sender: UIRotationGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.rotated(by: sender.rotation))!
        sender.rotation = 0
    }
    
}

