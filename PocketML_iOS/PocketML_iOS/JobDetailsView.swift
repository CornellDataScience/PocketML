//
//  JobDetailsView.swift
//  TunerML
//
//  Created by Anya Yerramilli on 3/23/24.
//

import SwiftUI

struct JobDetailsView: View {
    var selectedJob : Job
    var body: some View {
        VStack{
            ScrollView{
                VStack(spacing:20){
                    JobTitle(selectedJob.jobTitle)
                    HStack{
                        ScriptWidget("<Script Title>")
                        WandbWidget()
                    }
                    .frame(width: 320)
                    // temporary points for graph
                    // will have to make a binding or attribute of a job
                    let dataPoints: [CGFloat] = [0.92424, 0.82897, 0.67572894, 0.4280957984, 0.2438574, 0.188435794, 0.1348573, 0.067584938, 0.04423, 0.01423]
                    GraphWidget(data:dataPoints)
                        .padding(.leading)
                        .padding(.trailing)
                    MilestonesWidget()

                }
            }
            ActionsWidget()
            Divider().background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
    }
}

func JobTitle(_ text:String) -> some View {
    Text(text)
        .foregroundStyle(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
        .padding(EdgeInsets(top:10,leading:100, bottom:10, trailing: 100 ))
        .background(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.top, 10)
        .monospaced()
        .font(.largeTitle)
}


func ScriptWidget(_ script: String) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 25)
            .frame(width: 200, height: 100)
            .foregroundStyle((Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941)))
            .padding()
        VStack{
            Text(script)
                .bold()
                .monospaced()
                .foregroundStyle(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
            Text("<description>")
                .font(.subheadline)
                .foregroundStyle(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
        }
        .frame(width: 200, height: 100)
    }
}

func WandbWidget() -> some View {
    ZStack(alignment: .center, content: {
        Rectangle()
            .frame(width: 150, height: 50)
            .foregroundStyle(Color(red: 0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
        Text("View on WandB >")
            .frame(width: 150, height: 50)
            .foregroundStyle(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
    })
    .padding(.trailing)
}

func Graph(dataPoints: [CGFloat]) -> some View {
    // have to figure out how to customize graph more
    // adding axis labels + dealing with scale...
    GeometryReader { geometry in
        Path { path in
            let xScale = geometry.size.width / CGFloat(dataPoints.count - 1)
            let yScale = geometry.size.height / CGFloat(dataPoints.max() ?? 1)

            path.move(to: CGPoint(x: 0, y: dataPoints[0] * yScale))
            print(dataPoints[0] * yScale)

            for index in 1..<dataPoints.count {
                let x = CGFloat(index) * xScale
                let y =  (dataPoints[index] * yScale)
                print(y)
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        .stroke(Color.purple, lineWidth: 3)
        .background(Color.white)
    }
    .frame(width: 320, height: 200)
}

func GraphWidget(data: [CGFloat]) -> some View {
    Section() {
        VStack{
            Text("Training Loss")
                .monospaced()
                .font(.title3)
                .bold()
                .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
            Graph(dataPoints: data)
        }
        .padding()
    }
    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941)))
    .scrollContentBackground(.hidden)
}

func MilestoneTable() -> some View{
    Text("<Milestone Table>")
    // something like this, take input of milestone data
//    var body: some View {
//            Table(people) {
//                TableColumn("Name", value: \.name)
//                TableColumn("Last Name", value: \.lastName)
//                TableColumn("Ranking") {
//                    people in
//                    Text(String(people.ranking))
//                }
//            }
}

func MilestonesWidget() -> some View {
    Section() {
        VStack{
            Text("Milestones")
                .monospaced()
                .font(.title3)
                .bold()
                .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
            MilestoneTable()
        }
        .frame(width: 320)
        .padding()
    }
    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941)))
    .padding(.leading)
    .padding(.trailing)
    .scrollContentBackground(.hidden)
    
}

func ActionButton(action:String) -> some View{
    ZStack{
        RoundedRectangle(cornerRadius: 25)
            .frame(width: 100, height: 50)
            .foregroundStyle(Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0))
            .padding()
        Text(action)
            .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
    }
}

func ActionsWidget() -> some View{
    Section(){
        VStack{
            Text("Actions")
                .monospaced()
                .font(.title)
                .foregroundColor(Color(red:0.32941176470588235, green:0.16470588235294117, blue:0.4588235294117647))
                .padding(.top)
                .padding(.bottom, -10)
            HStack(spacing:1){
                ActionButton(action:"Start")
                    .padding(.leading)
                ActionButton(action:"Stop")
                ActionButton(action:"Pause")
                    .padding(.trailing)
                
            }

        }
    }
    .background(Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941))
}

#Preview {
    JobDetailsView(selectedJob: Job(jobTitle: "Job 1", completedEpochs: 1.25, totalEpochs: 5.0))
}
