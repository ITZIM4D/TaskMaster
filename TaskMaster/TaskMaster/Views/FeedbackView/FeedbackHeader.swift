//
//  FeedbackHeader.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/15/25.
//

import SwiftUI

// Welcoming header
struct FeedbackHeader: View {
    var body: some View {
        ZStack{
            Color(red: 204 / 255, green: 229 / 255, blue: 255 / 255)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 80)
            
            Text("Feedback")
                .font(.system(size: 70))
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .multilineTextAlignment(.center)
        }
    }
}

struct FeedbackHeader_previews: PreviewProvider {
    static var previews: some View {
        FeedbackHeader()
    }
}
