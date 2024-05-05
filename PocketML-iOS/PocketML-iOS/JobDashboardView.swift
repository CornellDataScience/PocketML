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
    @StateObject private var vm = JobDashboardViewModel()
    

    var body: some View {
        NavigationStack{
            VStack{
                Text("Your Projects")
                    .modifier(MainTitleModifier())
                Spacer()
                
                JobListSection("Current Projects", vm, jobs: vm.currentJobs)
                JobListSection("Past Projects", vm, jobs: vm.pastJobs)
                Divider().background(Color.background)
            
            }
            .modifier(MainVStackModifier())
            .onAppear {
                vm.refresh()
            }
        }
    }
}

func JobListSection(_ sectionTitle: String, _ vm: JobDashboardViewModel, jobs: [Int: PrimitiveJob]) -> some View {
    return VStack{
        Section() {
            VStack{
                JobSectionTitle(sectionTitle)
                JobsList(vm, jobs: jobs)
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

private func PrimitiveJobRow(job : PrimitiveJob) -> some View {
    HStack{
        VStack(alignment:.leading){
            Text(job.name)
                .modifier(Title3Modifier())
            
            let compEpoch = String(format: "%.2f", Float(job.current_step))
            let totEpoch = String(format: "%.2f", Float(job.total_steps))
            let percent = String(format: "%.1f", (Float(job.current_step) * 100 / Float(job.total_steps)))
//            ProgressView(value:  Float(job.current_step), total: Float(job.total_steps)){
//                HStack{
//                    Text("\(compEpoch) epochs \\ \(totEpoch)")
//                        .modifier(SubheadlineModifier())
//                    Spacer()
//                    Text("\(percent)%")
//                        .modifier(SubheadlineModifier())
//                        .bold()
//                }
//            }
//            .accentColor(Color.main)
        }
    }
}

private func JobsList(_ vm: JobDashboardViewModel, jobs: [Int: PrimitiveJob]) -> some View {
    List
    {
        if jobs.count == 0 {
            Text("No jobs yet!")
        } else {
            ForEach(jobs.sorted(by: { $0.key < $1.key }), id: \.key) { key, job in
                NavigationLink {
                    JobDetailsView(id: key)
                } label: {
                    PrimitiveJobRow(job: job)
                }
                
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
        .refreshable {
            vm.refresh()
        }
        
    }


#Preview {
    JobDashboardView()
}
