// The model for any feedback being made/received

import Foundation

struct FeedbackItem {
    let userID: Int
    let taskID: Int
    let difficulty: Int
    let timeAccuracy: String
    let challenges: String
}
