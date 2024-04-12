//
//  ScriptsView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//  Edited by Ella Schneyer on 4/4/24.

import SwiftUI

struct ScriptsView: View {
    
    @State var scriptGroups = [
        ScriptGroup(groupName: "Current", scripts: [Script(scriptTitle: "Example 1", modelType: "SVM", c: 10.0, kernel: "linear", maxiter: 1000), Script(scriptTitle: "Example 2", modelType: "SVM", c: 10.0, kernel: "linear", maxiter: 1000), Script(scriptTitle: "Example 3", modelType: "SVM", c: 10.0, kernel: "linear", maxiter: 1000)]),
        ScriptGroup(groupName: "Archived", scripts: [Script(scriptTitle: "Example 4", modelType: "SVM", c: 10.0, kernel: "linear", maxiter: 1000), Script(scriptTitle: "Example 5", modelType: "SVM", c: 10.0, kernel: "linear", maxiter: 1000), Script(scriptTitle: "Example 6", modelType: "SVM", c: 10.0, kernel: "linear", maxiter: 1000)])
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Scripts")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .monospaced()
                    .foregroundStyle(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                Text("+ Import Script")
                    .foregroundStyle(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
                    .padding(EdgeInsets(top:15,leading:25, bottom:15, trailing: 25 ))
                    .background(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.top, 10)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                Spacer()
                List {
                    ForEach(scriptGroups) {
                        scriptGroup in Section(header: Text(scriptGroup.groupName)) {
                            ForEach(scriptGroup.scripts) { script in
                                NavigationLink(destination: ScriptsDetailsView(script: script)){
                                    HStack{
                                        Text(script.scriptTitle)
                                            .font(.system(.body, design: .monospaced))
                                            .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                                        Spacer()
                                        Text("✎")
                                            .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                                            .font(.system(size: 24))
                                    }
                                }
                            }
                            .listRowBackground(
                                Capsule()
                                    .fill(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
                                    .padding(5)
                            )
                        }
                    }
                }
                .environment(\.defaultMinListRowHeight, 70)
                Button("Add") {
                    scriptGroups[0].scripts.append(Script(scriptTitle: "new example", modelType: "SVM", c: 10.0, kernel: "linear", maxiter: 1000))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ScriptsView()
}
