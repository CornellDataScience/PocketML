//
//  ClustersView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//
import SwiftUI

struct ClustersView: View {
    @State private var isPopoverPresented = false
    @State private var clusterData = ClusterData(name: "", port: 0, publicKey: "")
    @State private var runningClusters: [ClusterData] = [
        ClusterData(name: "Cluster1", port: 8080, publicKey: "abc123"),
        ClusterData(name: "Cluster2", port: 9090, publicKey: "def456"),
        ClusterData(name: "Cluster3", port: 7070, publicKey: "ghi789"),
        ClusterData(name: "Cluster4", port: 6060, publicKey: "jkl012"),
        ClusterData(name: "Cluster5", port: 5050, publicKey: "mno345")
    ]
    @State private var coldClusters: [ClusterData] = [
        ClusterData(name: "Cluster6", port: 8080, publicKey: "abc123"),
        ClusterData(name: "Cluster7", port: 9090, publicKey: "def456"),
        ClusterData(name: "Cluster8", port: 7070, publicKey: "ghi789"),
        ClusterData(name: "Cluster9", port: 6060, publicKey: "jkl012"),
        ClusterData(name: "Cluster10", port: 5050, publicKey: "mno345")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your Clusters")
                .modifier(MainTitleModifier())
            AddClusterButton(action: {
                isPopoverPresented.toggle()
            })
            
            ClusterListSection("Running", clusters: runningClusters)
            ClusterListSection("Cold", clusters: coldClusters)
            
            Divider().background(Color.background)
        }
        .modifier(MainVStackModifier())
        .popover(isPresented: $isPopoverPresented, content: {
            ClusterPopoverView(clusterData: $clusterData, isPopoverPresented: $isPopoverPresented, saveAction: {
                if !clusterData.name.isEmpty && !clusterData.publicKey.isEmpty {
                    coldClusters.insert(clusterData, at: 0)
                    clusterData = ClusterData(name: "", port: 0, publicKey: "")
                    isPopoverPresented.toggle()
                }
            })
        })
    }
}

func ClusterListSection(_ sectionTitle: String, clusters: [ClusterData]) -> some View {
    VStack{
        Section() {
            VStack{
                Text(sectionTitle)
                    .modifier(Title2Modifier())
                    .bold()
                    .padding(.bottom,-40)
                ClusterList(clusterList: clusters)
            }
        }
        .modifier(ListVStackModifier())
    }
}

private func ClusterList(clusterList : [ClusterData]) -> some View {
    List
    {
        ForEach(clusterList) {
            cluster in
//            NavigationLink {
//                JobDetailsView(selectedJob: job)
//            } label: {
            ClusterInfoRow(cluster:cluster)
//            }
        }
        .listRowBackground(Color.background)
        .scrollContentBackground(.hidden)
        
    }
}

private func ClusterInfoRow(cluster : ClusterData) -> some View {
    HStack{
        VStack(alignment:.leading){
            Text(cluster.name)
                .modifier(Title3Modifier())
            
            let port = String(format: "%d", cluster.port)
            HStack{
                Text("Port \(port)")
                    .modifier(SubheadlineModifier())
            }
        }
    }
}

struct ClusterPopoverView: View {
    @Binding var clusterData: ClusterData
    @Binding var isPopoverPresented: Bool
    @State private var portInput: String = ""
    var saveAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Cluster")
                .modifier(TitleModifier())
            TextField("Name", text: $clusterData.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Port", text: $portInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Public Key", text: $clusterData.publicKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                if let port = Int(portInput) {
                   clusterData.port = port
                   saveAction()
                   isPopoverPresented.toggle() // Close the popover
               } else {
                   // Handle invalid port input
                   print("Invalid port input")
               }
            }) {
                ButtonText("Save")
            }
        }
        .padding()
    }
}

// Helper functions for formatting and styling

func ButtonText(_ text: String) -> some View {
    Text(text)
        .foregroundStyle(Color.background)
        .bold()
        .padding(EdgeInsets(top:10,leading:25, bottom:10, trailing: 25 ))
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(Color.main))
        .padding(.leading)
}

func AddClusterButton(action: @escaping () -> Void) -> some View {
    Button(action: action) {
        ButtonText(_:"+ Add Cluster")
    }
}





#Preview {
    ClustersView()
}
