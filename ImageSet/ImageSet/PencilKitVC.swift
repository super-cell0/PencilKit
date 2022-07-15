//
//  ViewController.swift
//  ImageSet
//
//  Created by Power super on 2022/6/28.
//

import UIKit
import PencilKit
import PhotosUI

class PencilKitVC: UIViewController, PKCanvasViewDelegate {

    @IBOutlet weak var pencilBarButton: UIBarButtonItem!
    @IBOutlet weak var canvasView: PKCanvasView!
    
    let drawing = PKDrawing()
    let toolPicker = PKToolPicker()
    let canvasWidth: CGFloat = 768
    let canvasOverScrollHeight: CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCanvasView()
        updateContentSizeForDrawing()
    }

    @IBAction func saveToCamera(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            } completionHandler: { success, error in
                
            }
        }
        let alterController = UIAlertController(title: "图片已保存", message: "", preferredStyle: .alert)
        let alterAction = UIAlertAction(title: "确认", style: .default)
        alterController.addAction(alterAction)
        self.present(alterController, animated: true, completion: nil)
    }
    
    @IBAction func togglePencil(_ sender: Any) {
        canvasView.drawing = PKDrawing()
    }
    @IBAction func toggleBarButton(_ sender: UIBarButtonItem) {
        if canvasView.isFirstResponder {
            canvasView.resignFirstResponder()
        } else {
            canvasView.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let canvasScale = canvasView.bounds.width  / canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
        
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
    }
    
    private func setupCanvasView() {
        canvasView.delegate = self
        canvasView.drawing = drawing
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
    }
    
    private func updateContentSizeForDrawing() {
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverScrollHeight) * canvasView.zoomScale)
        } else {
            contentHeight  = canvasView.bounds.height
        }
        
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale, height: contentHeight)
    }

}

extension PencilKitVC {
    ///当前绘图的内容发生了变化
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        updateContentSizeForDrawing()
    }
}

