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
	let id: String?
	let text: String?
	let publicMetric : TweetMetric?
	let authorId : String?
	let attachments: TweetAttachment?
    let dateStr: String?
	
	//media
	let media: [TweetMedia]?
	let urls: [TweetURL]?
	let user: TweetUser?
	let cashTags: [TweetTags]?
	let hashTags: [TweetTags]?
	let opinions: TweetOpinion?
	let reactions: TweetReaction?

	enum CodingKeys: String, CodingKey {
		case id
		case text
		case publicMetric = "publicMetric"
		case authorId = "author_id"
		case attachments
		case media
        case urls
        case user, cashTags, hashTags, opinions, reactions
        case dateStr = "date"
	}
}

extension TweetModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TweetModel: Equatable {
    static func == (lhs: TweetModel, rhs: TweetModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension TweetModel: Tickers {
    var tickers: [String] {
        get { [] } //hashTags?.compactMap { $0.tag} ?? [] }
        set {}
    }
}

extension TweetModel {
    var date: Date? {
        guard let dateStr = dateStr else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStr)
        return date
    }
}

extension Date {
    
    static func convertStringToDate(_ dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateStr)
        return date
    }
    
    var timestamp: String? {
        let format = "d MMM YY, hh:mm a"
        let formatter = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

//MARK: - TweetAttachment
struct TweetAttachment: Codable {
	let mediaKeys: [String]
	
	enum CodingKeys: String, CodingKey {
		case mediaKeys = "media_keys"
	}
}

//MARK: - TweetMetric
struct TweetMetric: Codable {
	
	let retweetCount: Int?
	let replyCount: Int?
	let likeCount: Int?
	let qouteCount: Int?
	
	enum CodingKeys: String, CodingKey {
		case retweetCount = "retweet_count"
		case replyCount = "reply_count"
		case likeCount = "like_count"
		case qouteCount = "quote_count"
	}
	
}

//MARK: - TweetMedia
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

//MARK: - TweetMediaVariant
struct TweetMediaVariant: Codable {
	let contentType: String
	let url: String?
	
	enum CodingKeys: String, CodingKey {
		case contentType = "content_type"
		case url
	}
}

//MARK: - TweetUser
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

//MARK: - TweetIncludeData
struct TweetIncludeData: Codable {
	let media: [TweetMedia]?
	let users: [TweetUser]?
}

//MARK: - TweetUrl
struct TweetURL: Codable {
	let start: Int?
	let end: Int?
	let url: String
	let expandedUrl: String?
	let displayUrl: String?
	let title: String?
	let description: String?
	let unwoundUrl: String?
	let images: [TweetImage]?
	
	enum CodingKeys: String, CodingKey {
		case start
		case end
		case url
		case expandedUrl = "expanded_url"
		case displayUrl = "display_url"
		case title
		case description
		case unwoundUrl = "unwound_url"
		case images
	}
}

struct TweetImage: Codable {
	let url: String
}

//MARK: - Tags
struct TweetTags: Codable {
	let tag: String
}


//MARK: - Twitter Opinion
struct TweetOpinion: Codable {
	let bullish: Int
	let bearish: Int
}

//MARK: - Twitter Reactions
struct TweetReaction: Codable {
	let fakeNews: Int
	let trustedNews: Int
	let qualityAnalysis: Int
	let badAnalysis: Int
	let overReaction: Int
	
	enum CodingKeys: String, CodingKey {
		case fakeNews = "fake_news"
		case trustedNews = "trusted_news"
		case qualityAnalysis = "quality_analysis"
		case badAnalysis = "bad_analysis"
		case overReaction = "overreaction"
	}
}
