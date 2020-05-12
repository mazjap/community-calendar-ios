//
//  EventCollectionViewCell.swift
//  Community Calendar
//
//  Created by Jordan Christensen on 12/16/19.
//  Copyright © 2019 Lambda School All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var event: FetchDateRangedEventsQuery.Data.Event? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var districtNameLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
        setupSubViews()
    }
    
    func updateViews() {
        guard
            let event = event,
            let urlString = event.eventImages?.first?.url,
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url),
            let city = event.locations?.first?.city,
            let state = event.locations?.first?.state,
            let date = backendDateFormatter.date(from: event.start)
            else { return }
        
//        let time = getEventTime(date: date)
        
        DispatchQueue.main.async {
            self.eventTitleLabel.text = event.title
            self.eventImageView.image = UIImage(data: data)
            self.districtNameLabel.text = "\(city), \(state)"
            self.timeLabel.text = dateFormatter.string(from: date)
        }
    }
    
    func setupSubViews() {
//        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
//        contentView.dropShadow()
        eventImageView.layer.masksToBounds = true
//        eventImageView.layer.cornerRadius = 8
//        eventImageView.layer.shadowRadius = 10
    
//        self.layer.cornerRadius = 8
//        self.layer.masksToBounds = true
        eventImageView.contentMode = .scaleToFill
    }
//    private func setImage() {
//        if let imageURL = event?.images.first, !imageURL.isEmpty {
//            if controller?.cache.fetch(key: imageURL) == nil {
//                eventImageView.image = nil
//            }
//            controller?.fetchImage(for: imageURL)
//        } else {
//            if let indexPath = indexPath {
//                eventImageView.image = UIImage(named: "placeholder\(indexPath.row % 6)")
//            } else {
//                eventImageView.image = UIImage(named: "lambda")
//            }
//        }
//    }
    
//    @objc
//    func receiveImage(_ notification: Notification) {
//        guard let imageNot = notification.object as? ImageNotification else {
//            assertionFailure("Object type could not be inferred: \(notification.object as Any)")
//            return
//        }
//        if let eventImageUrl = event?.images.first, imageNot.url == eventImageUrl {
//            DispatchQueue.main.async {
//                self.eventImageView.image = imageNot.image
//            }
//
//        }
//    }
    
//    private func setDate() {
//        guard let startDate = event?.startDate else {
//            NSLog("\(#file):L\(#line): startDate: \(String(describing: event?.startDate)) is nil! Check \(#function)")
//            return
//        }
//        timeLabel.text = featuredEventDateFormatter.string(from: startDate)
//
//        if let endDate = event?.endDate {
//            timeLabel.text = "\(cellDateFormatter.string(from: startDate).lowercased()) - \(cellDateFormatter.string(from: endDate).lowercased())"
//        } else {
//            timeLabel.text = cellDateFormatter.string(from: startDate).lowercased()
//        }
//    }
    
//    func observeImage() {
//        NotificationCenter.default.addObserver(self, selector: #selector(receiveImage), name: .imageWasLoaded, object: nil)
//        // Notification pattern used because there are 3 different cells trying to access the same image, so when one of them finishes getting the image, the other 2 are notified with the same image.
//    }
}
