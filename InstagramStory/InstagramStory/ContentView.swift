//
//  ContentView.swift
//  InstagramStory
//
//  Created by Viennarz Curtiz on 10/17/23.
//

import SwiftUI

//Implementation is based from here https://trailingclosure.com/swiftui-instagram-story-tutorial/

struct ContentView: View {
    var imageNames: [String] = ["image01","image02","image03","image04","image05","image06","image07"]
    @ObservedObject var storyTimer: StoryTimer = StoryTimer(items: 7, interval: 3.0)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                
                //What this does is grab the progress from the StoryTimer and select the corresponding image via its index.
                Image(self.imageNames[Int(self.storyTimer.progress)])
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: nil, alignment: .center)
                    .animation(.none, value: storyTimer.progress)
                
                HStack(alignment: .center, spacing: 4) {
                    ForEach(self.imageNames.indices) { x in
                        
                        //This may look like a lot is going on here, but really it's just some simple math. self.storyTimer.progress values range from 0 to N (Number of photos to display). Wehereas the Loadingrectangle needs a progress value from 0.0 to 1.0. We are doing the conversion based on the index of each LoadingRectangle (x in this case`)
                        
                        LoadingRectangle(progress: min( max( (CGFloat(self.storyTimer.progress) - CGFloat(x)), 0.0) , 1.0) )
                            .frame(width: nil, height: 2, alignment: .leading)
                            .animation(.linear, value: storyTimer.progress)
                    }
                }.padding()
            }
            //When our ContentView appears, we will make a call to the start() function to start receiving values from the TimerPublisher. Each time a new value is received, we update the progress variable that is published by our StoryTimer class. This in turn triggers our ContentView to update our LoadingRectangle with the correct progress and displays the correct image on the screen.
            .onAppear { self.storyTimer.start() }
            .onDisappear {self.storyTimer.cancel() }
            .onTapGesture {
                self.storyTimer.advance(by: 1)
            }
        }
    }
}

#Preview {
    ContentView()
}
