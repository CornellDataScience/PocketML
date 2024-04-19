//
//  ClustersView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//
import SwiftUI

struct ClustersView: View {
    @State private var isPopoverPresented = false
    @State private var clusterData = ClusterData(name: "", port: "", publicKey: "")
    @State private var runningClusters: [ClusterData] = [
        ClusterData(name: "Cluster1", port: "8080", publicKey: "abc123"),
        ClusterData(name: "Cluster2", port: "9090", publicKey: "def456"),
        ClusterData(name: "Cluster3", port: "7070", publicKey: "ghi789")
    ]
    @State private var coldClusters: [ClusterData] = [
        ClusterData(name: "Cluster4", port: "6060", publicKey: "jkl012"),
        ClusterData(name: "Cluster5", port: "5050", publicKey: "mno345")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TitleText("Your Clusters")
            AddClusterButton(action: {
                isPopoverPresented.toggle()
            })

            List {
                Section(header: Text("Running")) {
                    ForEach(runningClusters) { cluster in
                        Text("\(cluster.name), port \(cluster.port)")
                            .listRowBackground(ListBackground())
                            .monospaced()
                            .foregroundStyle(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                    }
                }
                Section(header: Text("Cold")) {
                    ForEach(coldClusters) { cluster in
                        Text("\(cluster.name), port \(cluster.port)")
                            .listRowBackground(ListBackground())
                            .monospaced()
                            .foregroundStyle(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                    }
                }
            }
        }
        .padding()
        .background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
        .popover(isPresented: $isPopoverPresented, content: {
            ClusterPopoverView(clusterData: $clusterData, isPopoverPresented: $isPopoverPresented, saveAction: {
                if !clusterData.name.isEmpty && !clusterData.port.isEmpty && !clusterData.publicKey.isEmpty {
                    coldClusters.insert(clusterData, at: 0)
                    clusterData = ClusterData(name: "", port: "", publicKey: "")
                    isPopoverPresented.toggle()
                }
            })
        })
    }
}

struct ClusterPopoverView: View {
    @Binding var clusterData: ClusterData
    @Binding var isPopoverPresented: Bool
    var saveAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            TitleText("Add New Cluster")
            TextField("Name", text: $clusterData.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Port", text: $clusterData.port)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Public Key", text: $clusterData.publicKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                saveAction()
                isPopoverPresented.toggle() // Close the popover
            }) {
                ButtonText("Save")
            }
        }
        .padding()
    }
}

// Helper functions for formatting and styling

func TitleText(_ text: String) -> some View {
    Text(text)
        .font(.largeTitle)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
        .monospaced()
        .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
}

func ButtonText(_ text: String) -> some View {
    Text(text)
        .foregroundStyle(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
        .padding(EdgeInsets(top:15,leading:25, bottom:15, trailing: 25 ))
        .background(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.top, 10)
        .padding(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .bold()
}

func AddClusterButton(action: @escaping () -> Void) -> some View {
    Button(action: action) {
        ButtonText(_:"+ Add Cluster")
    }
}

func ListBackground() -> some View {
    Capsule()
        .fill(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
        .padding(5)
}

struct AddClusterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top:15,leading:25, bottom:15, trailing: 25 ))
            .background(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.top, 10)
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .bold()
            .foregroundColor(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
    }
}

struct SaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}


#Preview {
    ClustersView()
}
