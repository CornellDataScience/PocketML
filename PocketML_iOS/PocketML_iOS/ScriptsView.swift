//
//  ScriptsView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct ScriptsView: View {
    var body: some View {
        VStack{
            Text("Your Scripts")
                .font(.largeTitle)
                .monospaced()
                .foregroundStyle(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
    }
}

#Preview {
    ScriptsView()
}
