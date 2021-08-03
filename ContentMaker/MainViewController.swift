//
//  ViewController.swift
//  ContentMaker
//
//  Created by Ali Maher on 11/30/19.
//  Copyright © 2019 Ali Maher. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SVProgressHUD

class MainViewController: UIViewController {


    @IBOutlet weak var begVid: UIButton!
    @IBOutlet weak var waterMark: UIButton!
    @IBOutlet weak var titleVid: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var endingVid: UIButton!
    @IBOutlet weak var realEnding: UIButton!
    @IBOutlet weak var mergingOutlit: UIButton!
    
    var waterMarkImage  = UIImage()
    var contentVidURL : URL! = nil
    var firsttVidURL : URL! = nil
    var endingVidURL : URL! = nil

    
    var framesArray = [String]()
    var mockUpImage  = UIImage()

    var videoSize : CGSize = CGSize()
    var videoPlace : CGPoint = CGPoint()
    var layerString = ""
    
    
    let pickerImage = UIImagePickerController()
    let pickerFirstVideo = UIImagePickerController()
    let pickerContentVideo = UIImagePickerController()
    let pickerEndingVideo = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        
        begVid.layer.cornerRadius = 5
        endingVid.layer.cornerRadius = 5
        realEnding.layer.cornerRadius = 5
        waterMark.layer.cornerRadius = 10
        titleVid.layer.cornerRadius = 10
        mergingOutlit.layer.cornerRadius = 5
        



        framesArray = ["iPhoneXS/iPhoneX/iPhone11Pro" ,"iPhone XR/iPhone 11","iPhone XS Max/iPhone 11 Pro Max", "I Phone 6/7/8 plus" , "I Phone 6/7/8"]
        
           self.pickerView.dataSource = self
           self.pickerView.delegate = self
           
                mockUpImage = #imageLiteral(resourceName: "iPhoneXS-iPhoneX-iPhone11Pro")
                videoSize = CGSize(width: 1125, height: 2436)
                videoPlace = CGPoint(x: 185, y: 365)

        
    }

    
    
    @IBAction func startingVid(_ sender: Any) {
        
        
        firstVideoGallery()
        
        
    }
    
    
    @IBAction func contentVidButton(_ sender: Any) {
        
        
        contentVideoGallery()
        
        
    }
    
    
    
    @IBAction func endingVid(_ sender: Any) {
        
        
        endingVideoGallery()
        
    }
    
    @IBAction func titleButton(_ sender: Any) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "العنوان", message: "عنوان الفيديو", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "العنوان"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "تم", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.layerString = textField?.text ?? ""
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func waterMarkButton(_ sender: Any) {
        
        openImageGallery()
    }
    
    
    
    @IBAction func MergingButton(_ sender: Any) {
        
        


        
        

        processVideoWithWatermark( mockUpImage: mockUpImage, WaterMark: waterMarkImage) { (Bool) in
            
            print(Bool)
        }
    }
    

        
        
        
        
        
        
            func processVideoWithWatermark(mockUpImage: UIImage, WaterMark: UIImage, completion: @escaping (Bool) -> Void) {
        
                let composition = AVMutableComposition()
                
                
                if firsttVidURL == nil {
                    
                    self.makeAlertDialouge(title: "خطأ", message: "لم يتم تحميل البداية")
                    return

                }
                
                
                if contentVidURL == nil {
                    
                    self.makeAlertDialouge(title: "خطأ", message: "لم يتم تحميل المحتوي")
                    return

                }
                

                
                if endingVidURL == nil {
                    
                    self.makeAlertDialouge(title: "خطأ", message: "لم يتم تحميل النهاية")
                    return

                }
                
                SVProgressHUD.show()

                
                
                 let contentAsset = AVURLAsset(url: contentVidURL, options: nil)
                

        
                

                
                let contentAssetTrackVid =  contentAsset.tracks(withMediaType: AVMediaType.video)
                let contentAssetTrackAud = contentAsset.tracks(withMediaType: AVMediaType.audio)
                

                
                let contentVidTrack:AVAssetTrack = contentAssetTrackVid[0] as AVAssetTrack
                let contentAudTrack:AVAssetTrack = contentAssetTrackAud[0]  as AVAssetTrack
                

                
                
                let contentTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: contentAsset.duration)

                
                let contentCompositionVideoTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: CMPersistentTrackID())!
                let contentCompositionAudioTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID())!

                

                do {
                    
                    

                    
                    try contentCompositionVideoTrack.insertTimeRange(contentTimeRange, of: contentVidTrack, at: .zero)
                    try contentCompositionAudioTrack.insertTimeRange(contentTimeRange, of: contentAudTrack, at: .zero)


                    
                } catch {
                    print(error)
                }
        

                

                
                
                let contentSize = contentVidTrack.naturalSize
                let imageSize = mockUpImage.size
                
                print("this is width \(contentSize.width)")
                print("this is highet \(contentSize.height)")
                print("this is width \(imageSize.width)")
                print("this is highet \(imageSize.height)")

                let parentlayer = CALayer()
                parentlayer.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                
                
                let titleLayer = CATextLayer()
                titleLayer.string = layerString
                titleLayer.foregroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
                titleLayer.fontSize = 70
                titleLayer.alignmentMode = CATextLayerAlignmentMode.center
                titleLayer.frame = CGRect(x: 0, y: imageSize.height - 200  , width: imageSize.width, height: 100)

                let MockupImage = mockUpImage.cgImage
                let MockUpLayer = CALayer()
                MockUpLayer.contents = MockupImage
                MockUpLayer.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                
                
                let waterMark = WaterMark.cgImage
                let waterMarkLayer = CALayer()
                waterMarkLayer.contents = waterMark
                waterMarkLayer.frame = CGRect(x: imageSize.width/2 - 100, y: 5, width: 200, height: 200)
                
        
                let videolayer = CALayer()
                videolayer.frame = CGRect(x: videoPlace.x , y: videoPlace.y , width: videoSize.width, height: videoSize.height)

                
                
                
                parentlayer.addSublayer(videolayer)
                parentlayer.addSublayer(MockUpLayer)
                parentlayer.addSublayer(waterMarkLayer)
                parentlayer.addSublayer(titleLayer)

                
                
                
                
                let layercomposition = AVMutableVideoComposition()
                layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
                layercomposition.renderSize = CGSize(width: imageSize.width, height: imageSize.height)
                layercomposition.renderScale = 1.0
                layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)
        
                
                print(composition.duration)
                print(composition.duration)
                let contentInstruction = AVMutableVideoCompositionInstruction()
                contentInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
                let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
                let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
                let t2 = CGAffineTransform.init(scaleX: imageSize.width/contentSize.width, y: imageSize.height/contentSize.height)
                layerinstruction.setTransform(t2, at: CMTime.zero)
                contentInstruction.layerInstructions = [layerinstruction]
                
  
                
                
                layercomposition.instructions = [contentInstruction]


                
                
                
                // 4 - Get path
                guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                       in: .userDomainMask).first else {
                  return
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .short
                let date = dateFormatter.string(from: Date())
                let url = documentDirectory.appendingPathComponent("mergeVide-\(date).mp4")

                // 5 - Create Exporter
                guard let exporter = AVAssetExportSession(asset: composition,
                                                          presetName: AVAssetExportPresetHighestQuality)

                    else {
                  return
                }
                exporter.videoComposition = layercomposition

                exporter.outputURL = url
                exporter.outputFileType = AVFileType.mp4
//                exporter.shouldOptimizeForNetworkUse = true


                
                



                
                
                exporter.exportAsynchronously(completionHandler: {
        
                    switch exporter.status {
                    case .completed:
                        print("success")

                        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                        
                        let mixComposition = AVMutableComposition()
                        
                         let firstAsset : AVURLAsset = AVURLAsset(url: self.firsttVidURL, options: nil)
           
                        let editedAsset = AVURLAsset(url: exporter.outputURL!, options: nil)
                        
                        
                         let endingAsset : AVURLAsset = AVURLAsset(url: self.endingVidURL, options: nil)

                        
                        let firstAssetTrackVid = firstAsset.tracks(withMediaType: .video)[0]
                        let firstAssetTrackAud = firstAsset.tracks(withMediaType: .audio)[0]
                        
                        let editedAssetTrackVid = editedAsset.tracks(withMediaType: .video)[0]
                        let editedAssetTrackAud = editedAsset.tracks(withMediaType: .audio)[0]
                        
                        let endingAssetTrackVid = endingAsset.tracks(withMediaType: .video)[0]
                        let endingAssetTrackAud = endingAsset.tracks(withMediaType: .audio)[0]

                        let editTrack = editedAsset.tracks(withMediaType: .video)[0]
                        
                        
                        
                        
                        
                        
                        guard let firstTrackVid = mixComposition.addMutableTrack(withMediaType: .video,
                                                                                 preferredTrackID: CMPersistentTrackID()) ,
                        let firstTrackAud = mixComposition.addMutableTrack(withMediaType: .audio,preferredTrackID: CMPersistentTrackID())
                            
                            else { return }
                        
                        
                        do {
                            try firstTrackVid.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: firstAsset.duration),
                                                         of: firstAssetTrackVid,
                                                         at: CMTime.zero)
                            try firstTrackAud.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: firstAsset.duration),
                                                         of: firstAssetTrackAud,
                                                         at: CMTime.zero)
                            
                            try firstTrackVid.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: editedAsset.duration),
                                                         of: editedAssetTrackVid,
                                                         at: firstAsset.duration)
                            try firstTrackAud.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: editedAsset.duration),
                                                         of: editedAssetTrackAud,
                                                         at: firstAsset.duration)
                            
                            try firstTrackVid.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: endingAsset.duration),
                                                         of: endingAssetTrackVid,
                                                         at: firstAsset.duration + editedAsset.duration)
                            try firstTrackAud.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: endingAsset.duration),
                                                         of: endingAssetTrackAud,
                                                         at: firstAsset.duration + editedAsset.duration)
                            
                            

                            
                        } catch {
                          print("Failed to load first track")
                          return
                        }
                        
                        
                        let layercomposition = AVMutableVideoComposition()
                        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
                        layercomposition.renderSize = CGSize(width: imageSize.width, height: imageSize.height)
                        layercomposition.renderScale = 1.0
                        
                        
                        
                        let contentInstruction = AVMutableVideoCompositionInstruction()
                        contentInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: mixComposition.duration)
                        let videotrack = mixComposition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
                        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
                        let t1 = CGAffineTransform.init(scaleX: imageSize.width/firstAssetTrackVid.naturalSize.width, y: imageSize.height/firstAssetTrackVid.naturalSize.height)
                        let t2 = CGAffineTransform.init(scaleX: imageSize.width/editTrack.naturalSize.width, y: imageSize.height/editTrack.naturalSize.height)
                        let t3 = CGAffineTransform.init(scaleX: imageSize.width/endingAssetTrackVid.naturalSize.width, y: imageSize.height/endingAssetTrackVid.naturalSize.height)

                        layerinstruction.setTransform(t1, at: CMTime.zero)
                        layerinstruction.setTransform(t2, at: firstAsset.duration)
                        layerinstruction.setTransform(t3, at: firstAsset.duration + editedAsset.duration)
                        contentInstruction.layerInstructions = [layerinstruction]
                        layercomposition.instructions = [contentInstruction]

                        
                        
                        
                        
                                        // 4 - Get path
                                        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                                               in: .userDomainMask).first else {
                                          return
                                        }
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateStyle = .long
                                        dateFormatter.timeStyle = .short
                                        let date = dateFormatter.string(from: Date())
                                        let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mp4")

                                        // 5 - Create Exporter
                                        guard let exporter = AVAssetExportSession(asset: mixComposition,
                                                                                  presetName: AVAssetExportPresetHighestQuality)

                                            else {
                                          return
                                        }
                                        exporter.videoComposition = layercomposition

                                        exporter.outputURL = url
                                        exporter.outputFileType = AVFileType.mp4
                        //                exporter.shouldOptimizeForNetworkUse = true


                                        
                                        



                                        
                                        
                                        exporter.exportAsynchronously(completionHandler: {
                                            SVProgressHUD.dismiss()
                                
                                            switch exporter.status {
                                            case .completed:
                                                print("success")

                                                self.exportDidFinish(exporter)
                                                
                                                
                                            case .cancelled:
                                                print("cancelled")
                                                break
                                            case .exporting:
                                                print("exporting")
                                                break
                                            case .failed:
                                                print(url)
                                                print("failed Second: \(exporter.error!)")
                                                break
                                            case .unknown:
                                                print("unknown")
                                                break
                                            case .waiting:
                                                print("waiting")
                                                break
                                            @unknown default:
                                                fatalError()
                                            }
                                            
                        })

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                        break
                    case .cancelled:
                        print("cancelled")
                        break
                    case .exporting:
                        print("exporting")
                        break
                    case .failed:
                        print(self.contentVidURL)
                        print("failed: \(exporter.error!)")
                        break
                    case .unknown:
                        print("unknown")
                        break
                    case .waiting:
                        print("waiting")
                        break
                    @unknown default:
                        fatalError()
                    }
                })
        
            }
    

    
    
    
    
    
    func exportDidFinish(_ session: AVAssetExportSession) {
      
        
        
      guard
        session.status == AVAssetExportSession.Status.completed,
        let outputURL = session.outputURL
        else {
          return
      }
      
      let saveVideoToPhotos = {
        PHPhotoLibrary.shared().performChanges({
          PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
        }) { saved, error in
          let success = saved && (error == nil)
          let title = success ? "تم" : "خطأ"
          let message = success ? "تم الحفظ" : "لم يتم الحفظ"
          
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.cancel, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
      }
      
      // Ensure permission to access Photo Library
      if PHPhotoLibrary.authorizationStatus() != .authorized {
        PHPhotoLibrary.requestAuthorization { status in
          if status == .authorized {
            saveVideoToPhotos()
          }
        }
      } else {
        saveVideoToPhotos()
      }
    }
        
        
    
    

    

}


extension MainViewController  : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    func firstVideoGallery()
    {
        pickerFirstVideo.delegate = self
        pickerFirstVideo.sourceType = .savedPhotosAlbum
        pickerFirstVideo.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        pickerFirstVideo.mediaTypes = ["public.movie"]

        pickerFirstVideo.allowsEditing = false
        present(pickerFirstVideo, animated: true, completion: nil)
    }
    
    
    func contentVideoGallery()
    {
        pickerContentVideo.delegate = self
        pickerContentVideo.sourceType = .savedPhotosAlbum
        pickerContentVideo.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        pickerContentVideo.mediaTypes = ["public.movie"]

        pickerContentVideo.allowsEditing = false
        present(pickerContentVideo, animated: true, completion: nil)
    }
    
    func endingVideoGallery()
    {
        pickerEndingVideo.delegate = self
        pickerEndingVideo.sourceType = .savedPhotosAlbum
        pickerEndingVideo.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        pickerEndingVideo.mediaTypes = ["public.movie"]

        pickerEndingVideo.allowsEditing = false
        present(pickerEndingVideo, animated: true, completion: nil)
    }
    
    
    func openImageGallery()
    {
        pickerImage.delegate = self
        pickerImage.sourceType = .savedPhotosAlbum
        pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        pickerImage.mediaTypes = ["public.image"]

        pickerImage.allowsEditing = false
        present(pickerImage, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        
        
        
        if picker == pickerContentVideo {
        guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
          else { return }

            
        contentVidURL = url
            print("Picker 1")
            
        dismiss(animated: true, completion: nil)
            makeAlertDialouge(title: "تم", message: "تم تحميل المحتوي")

        }
            
            
        
        else if picker == pickerFirstVideo {
            guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
          else { return }
            
            print("picker 2")

        firsttVidURL = url
        dismiss(animated: true, completion: nil)
            makeAlertDialouge(title: "تم", message: "تم تحميل البداية")

        }
            
            
            
       else if picker == pickerEndingVideo {
           guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
         else {return }



       endingVidURL = url
       dismiss(animated: true, completion: nil)
            makeAlertDialouge(title: "تم", message: "تم تحميل النهاية")

       }
            
            
            
        else if picker == pickerImage {
            guard let url = info[.originalImage] as? UIImage
          else { return }

        waterMarkImage = url
        dismiss(animated: true, completion: nil)
            makeAlertDialouge(title: "تم", message: "تم تحميل الشعار")

        }
        
        else {
            
            
        }
        
        
        
        
    }
    
    
    
    
}








extension MainViewController :UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    
    
   
     //MARK: - Pickerview method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return framesArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return framesArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            
            // iPhoneXS-iPhoneX-iPhone11Pro
            mockUpImage = #imageLiteral(resourceName: "iPhoneXS-iPhoneX-iPhone11Pro")
             videoSize = CGSize(width: 1125, height: 2436)
             videoPlace = CGPoint(x: 185, y: 365)
            
            
        }
            
        else if row == 1 {
            
            // iPhoneXS-iPhoneX-iPhone11Pro
            mockUpImage = #imageLiteral(resourceName: "iPhone XR-iPhone 11")
             videoSize = CGSize(width: 828, height: 1792)
             videoPlace = CGPoint(x: 185, y: 297)
            
        }
        
            
        else if row == 2 {
            
            // iPhoneXS-iPhoneX-iPhone11Pro
            mockUpImage = #imageLiteral(resourceName: "iPhone XS Max-iPhone 11 Pro Max")
             videoSize = CGSize(width: 1242, height: 2688)
             videoPlace = CGPoint(x: 238, y: 478)
            
        }
        else if row == 3{
            
            
            // I Phone 6/7/8 plus

            mockUpImage = #imageLiteral(resourceName: "iphone8plus")

            videoSize = CGSize(width: 1242, height: 2208)
            videoPlace = CGPoint(x: 176, y: 640)
            
            
        }
        
        else if row == 4 {
            
            // I Phone 6/7/8
            
            mockUpImage = #imageLiteral(resourceName: "iphone6")

            videoSize = CGSize(width: 750, height: 1334)
            videoPlace = CGPoint(x: 150, y: 430)
            
            
            
        }

    }
    
    
    

    
    
    
    
    func makeAlertDialouge(title : String , message : String){
        
        
        let title = title
        let message = message
        
        print("JustSomeTest")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "حسنا", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }

    
    
}

