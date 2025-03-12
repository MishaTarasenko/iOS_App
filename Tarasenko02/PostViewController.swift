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

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var bookMarkButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var ratingButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            let redditPosts = try await RedditAPIClient.shared.fetchPosts(subreddit: "ios", limit: 1, after: nil)
            guard let firstRedditPost = redditPosts.data.children.first else { return }
            let post = Post(post: firstRedditPost, saved: isSaved())
            
            usernameLabel.text = "\(post.post.data.author) • \(timeAgo(from: Date(timeIntervalSince1970: TimeInterval(post.post.data.created_utc)))) • \(post.post.data.domain)"
            
            titleLabel.text = post.post.data.title
            
            let url = post.post.data.thumbnail.replacingOccurrences(of: "&amp;", with: "&")
            image.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "white.jpeg"))
            
            ratingButton.setTitle(printRating(rating: post.post.data.score), for: .normal)
            
            commentsButton.setTitle(String(post.post.data.num_comments), for: .normal)
            
            if post.saved {
                bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        }
    }
}
