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
            let redditPostsResponse = try await RedditAPIClient.shared.fetchPosts(subreddit: "ios", limit: 1, after: nil)
            guard let firstChildPost = redditPostsResponse.data.children.first else { return }
            let currentPost = Post(post: firstChildPost, saved: isPostSaved())

            usernameLabel.text = "\(currentPost.post.data.author) • \(timeAgo(from: Date(timeIntervalSince1970: TimeInterval(currentPost.post.data.created_utc)))) • \(currentPost.post.data.domain)"
            titleLabel.text = currentPost.post.data.title

            let thumbnailURLString = currentPost.post.data.thumbnail.replacingOccurrences(of: "&amp;", with: "&")
            image.sd_setImage(with: URL(string: thumbnailURLString), placeholderImage: UIImage(named: "white.jpeg"))

            ratingButton.setTitle(formatRating(rating: currentPost.post.data.score), for: .normal)
            commentsButton.setTitle(String(currentPost.post.data.num_comments), for: .normal)

            if currentPost.saved {
                bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }

        }
    }
}
