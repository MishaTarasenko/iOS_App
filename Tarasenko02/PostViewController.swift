//
//  PostViewController.swift
//  Tarasenko02
//
//  Created by Михаил Тарасенко on 10.03.2025.
//
import UIKit
import Foundation
import SDWebImage

class PostViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            let redditPost = Post(post: try await RedditAPIClient.shared.fetchPosts(subreddit: "ios", limit: 1, after: nil), saved: isSaved())
            let data = redditPost.post
            guard let post = data.data.children.first else { return }
            
            usernameLabel.text = "\(post.data.author) • \(timeAgo(from: Date(timeIntervalSince1970: TimeInterval(post.data.created_utc)))) • \(post.data.domain)"
            
            titleLabel.text = post.data.title
            
            let url = post.data.thumbnail.replacingOccurrences(of: "&amp;", with: "&")
            image.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "white.jpeg"))
            
            ratingButton.titleLabel?.text = printRating(rating: post.data.score)
            
            commentsButton.titleLabel?.text = "\(post.data.num_comments)"
            
            if redditPost.saved {
                bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        }
    }

    func timeAgo(from date: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let years = components.year, years > 0 {
            return "\(years) years ago"
        } else if let months = components.month, months > 0 {
            return "\(months) month ago"
        } else if let days = components.day, days > 0 {
            return "\(days) day ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hr. ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) min. ago"
        } else {
            return "now"
        }
    }
    
    func printRating(rating: Int) -> String {
        let ratingStr = String(rating)
        
        if ratingStr.count <= 4 {
            return ratingStr
        }
        
        if rating < 1_000_000 {
            let thousands = rating / 1000
            return "\(thousands)K"
        } else {
            let millions = rating / 1_000_000
            return "\(millions)M"
        }
    }
    
    func isSaved() -> Bool {
        let randomNumber = Int.random(in: 0...1)
        return randomNumber != 0
    }
}
