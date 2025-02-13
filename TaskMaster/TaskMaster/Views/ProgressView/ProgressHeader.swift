//
//  ProgressHeader.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/14/25.
//

import SwiftUI

struct ProgressHeader: View {
    var body: some View {
        ZStack{
            Color(red: 204 / 255, green: 229 / 255, blue: 255 / 255)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 80)
            
            Text("Progress")
                .font(.system(size: 70))
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .multilineTextAlignment(.center)
        }
    }
}

struct ProgressHeader_Preview: PreviewProvider {
    static var previews: some View {
        TasksHeader()
    }
}
