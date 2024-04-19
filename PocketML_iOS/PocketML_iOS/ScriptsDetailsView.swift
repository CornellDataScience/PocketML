//
//  ScriptsDetailsView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct ScriptsDetailsView: View {
    let script : Script
    var body: some View {
        VStack{
            Text(script.scriptTitle)
                .foregroundStyle(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
                .padding(EdgeInsets(top:10,leading:100, bottom:10, trailing: 100 ))
                .background(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.top, 10)
                .padding(.bottom, 50)
                .monospaced()
                .font(.largeTitle)
            VStack{
                Text("Model Parameters")
                    .padding(.bottom, 20)
                    .padding(.top, 15)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                Text("model type: "+script.modelType)
                    .padding(.bottom, 10)
                Text("C: \(script.c)")
                    .padding(.bottom, 10)
                Text("kernel: "+script.kernel)
                    .padding(.bottom, 10)
                Text("maxiter: \(script.maxiter)")
                    .padding(.bottom, 20)
                Text("...more parameters")
                    .padding(.bottom, 15)
            }
            .foregroundStyle(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
            .bold()
            .background(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
    }
}

#Preview {
    ScriptsDetailsView(script: Script(scriptTitle: "Example", modelType: "SVM", c: 10.0, kernel: "linear", maxiter: 1000))
}
