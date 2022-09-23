//
//  Tweetmodel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation

struct TweetSearchResult: Codable {
	let data: [TweetModel]?
	let includes: TweetIncludeData?
}
		
struct TweetModel:Codable {
	let id: String
	let text: String
	let publicMetric : TweetMetric?
	let authorId : String?
	let attachments: TweetAttachment?

	enum CodingKeys: String, CodingKey {
		case id
		case text
		case publicMetric = "public_metrics"
		case authorId = "author_id"
		case attachments
	}
}

struct TweetAttachment: Codable {
	let mediaKeys: [String]
	
	enum CodingKeys: String, CodingKey {
		case mediaKeys = "media_keys"
	}
}

struct TweetMetric: Codable {
	
	let retweetCount: Int
	let replyCount: Int
	let likeCount: Int
	let qouteCount: Int
	
	enum CodingKeys: String, CodingKey {
		case retweetCount = "retweet_count"
		case replyCount = "reply_count"
		case likeCount = "like_count"
		case qouteCount = "quote_count"
	}
	
}


struct TweetMedia: Codable {
	let type: String
	let mediaKey: String
	let width: Int
	let height: Int
	let url: String?
	let previewImageUrl: String?
	let variants: [TweetMediaVariant]?
	
	enum CodingKeys: String, CodingKey {
		case mediaKey = "media_key"
		case url
		case previewImageUrl = "preview_image_url"
		case type
		case variants
		case width
		case height
	}
}

struct TweetMediaVariant: Codable {
	let contentType: String
	let url: String?
	
	enum CodingKeys: String, CodingKey {
		case contentType = "content_type"
		case url
	}
}

struct TweetUser: Codable {
	let username: String
	let profileImageUrl: String
	let name: String
	let id: String
	
	enum CodingKeys: String, CodingKey {
		case username
		case profileImageUrl = "profile_image_url"
		case name
		case id
	}
}

struct TweetIncludeData: Codable {
	let media: [TweetMedia]?
	let users: [TweetUser]?
}
