//
//  WebRequests.swift
//  curiouCity
//
//  Created by Mostafa Alaa on 8/12/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class WebRequests{
    static let instance = WebRequests()
    private init(){
        
    }
    private(set) var imageURLArray = [String]()
    private(set) var imageArray = [UIImage]()
    
    private func flickrUrl(forApiKey key:String,WithAnnotation annotation : DroppablePin, addNumberOfPhotos number:Int)->String{
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&per_page=\(number)&format=json&nojsoncallback=1"
    }
    
    func retrieveUrls(forAnnotation annotation:DroppablePin,completionHandler:@escaping COMPLETION_HANDLER){
        
        Alamofire.request(flickrUrl(forApiKey: API_KEY, WithAnnotation: annotation, addNumberOfPhotos: 40)).responseJSON { (response) in
            
            guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
            let photosDict = json["photos"] as! Dictionary<String, AnyObject>
            let photosDictArray = photosDict["photo"] as! [Dictionary<String, AnyObject>]
            for photo in photosDictArray {
                let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_z_d.jpg"
                self.imageURLArray.append(postUrl)
                }
                print(self.imageURLArray)
                completionHandler(true)
            
        }
    }
    func retrieveImages(progressLbl:UILabel?,handler: @escaping (_ status: Bool) -> ()) {
        for url in imageURLArray {
            Alamofire.request(url).responseImage(completionHandler: { (response) in
                guard let image = response.result.value else { return }
                self.imageArray.append(image)
                progressLbl?.text = "\(self.imageArray.count)/40 IMAGES DOWNLOADED"
                
                if self.imageArray.count == self.imageURLArray.count {
                    handler(true)
                }
            })
        }
    }
    func cancelAllSessions(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach({$0.cancel()})
            downloadData.forEach({$0.cancel()})
        }
    }
    func clearArrays(){
        imageArray = []
        imageURLArray = []
    }
}
