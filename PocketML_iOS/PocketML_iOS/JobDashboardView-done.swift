//
//  JobDashboardView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct JobDashboardView: View {
//    @State private var isPopoverPresented = false
//    @State private var clusterData = ClusterData(name: "", port: "", publicKey: "")
    @StateObject private var viewModel = JobsViewModel()
//    @State private var currentJobs: [JobInfo] = []
//    @State private var pastJobs: [JobInfo] = []
    

    var body: some View {
        NavigationStack{
            VStack{
                Text("Your Projects")
                    .modifier(MainTitleModifier())
                Spacer()
                
                JobListSection("Current Projects", jobs: viewModel.currentJobs)
                    .onAppear(){
                        // get API data when the page appears and run classification function
                        viewModel.fetchData(url: "http://10.48.85.83:8000/api/v1/jobs")
                    }
                JobListSection("Past Projects", jobs: viewModel.pastJobs)
                    .onAppear(){
                        // get API data when the page appears and run classification function
                        viewModel.fetchData(url: "http://10.48.85.83:8000/api/v1/jobs")
                    }
                Divider().background(Color.background)
            
            }
            .modifier(MainVStackModifier())
            
        }
    }
}





func JobListSection(_ sectionTitle: String, jobs: [String: JobInfo]) -> some View {
    return VStack{
        Section() {
            VStack{
                JobSectionTitle(sectionTitle)
                JobsList(jobsList: jobs)
            }
        }
        .modifier(ListVStackModifier())
    }
}

func JobSectionTitle(_ text: String) -> some View {
    Text(text)
        .modifier(Title2Modifier())
        .bold()
        .padding(.bottom,-40)
}

private func JobInfoRow(job : JobInfo) -> some View {
    HStack{
        VStack(alignment:.leading){
            Text(job.name)
                .modifier(Title3Modifier())
            
            let compEpoch = String(format: "%.2f", Float(job.current_step))
            let totEpoch = String(format: "%.2f", Float(job.total_steps))
            let percent = String(format: "%.1f", (Float(job.current_step) * 100 / Float(job.total_steps)))
            ProgressView(value:  Float(job.current_step), total: Float(job.total_steps)){
                HStack{
                    Text("\(compEpoch) epochs \\ \(totEpoch)")
                        .modifier(SubheadlineModifier())
                    Spacer()
                    Text("\(percent)%")
                        .modifier(SubheadlineModifier())
                        .bold()
                }
            }
            .accentColor(Color.main)
        }
    }
}

private func JobsList(jobsList : [String: JobInfo]) -> some View {
    List
    {
        ForEach(jobsList.sorted(by: { $0.key < $1.key }), id: \.key) { key, jobInfo in
            NavigationLink {
                JobDetailsView(selectedJob: jobInfo, selectedJobId: key)
            } label: {
                JobInfoRow(job:jobInfo)
            }
            
        }
        
        
//        ForEach(jobsList, id: \.self) {
//            job in
//            NavigationLink {
//                JobDetailsView(selectedJob: job, selectedJobId: allJobs.someKey(forValue: job)
//            } label: {
//                JobInfoRow(job:job)
//            }
        }
        .listRowBackground(Color.background)
        .scrollContentBackground(.hidden)
        
    }


#Preview {
    JobDashboardView()
}
