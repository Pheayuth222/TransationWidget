//
//  PaymentWidget.swift
//  PaymentWidget
//
//  Created by Pheayuit.Yen    on 3/2/25.
//

//
//  MyCustomWidget.swift
//  MyCustomWidget
//
//  Created by Pheayuit.Yen    on 27/1/25.
//

import WidgetKit
import SwiftUI

struct Post: Decodable {
  let id: Int
  let title: String
  let body: String
}

struct TrialWidgetEntryView: View {
  
  var entry: Provider.Entry
  var storeAmount = UserDefaultsManager.shared.stringValue(forKey: "totalAmount") ?? "0.0"
  
  var qrText = "00020101021129390016wbkhkhppxxx@wbkh0108304778120203WBC5204599953038405802KH5912YEN PHEAYUIT6010Phnom Penh6304D5B2"
  
  var storeDate = UserDefaultsManager.shared.stringValue(forKey: "syncDate")
  var isLoggedIn = UserDefaultsManager.shared.boolValue(forKey: "isLoggedIn")
  
  @Environment (\.widgetFamily) var widgetFamily
  
  var body: some View {
    
    switch widgetFamily {
    case .systemSmall:
      VStack(spacing: 5) {
        Text("Woori QR")
          .font(.system(size: 14))
          .foregroundStyle(.blue)
        ZStack {
          Image(uiImage: UIImage(data: GenerateQR.share.getQRCodeDate(text: qrText)!)!)
            .resizable()
            .frame(width: 120, height: 120,alignment: .leading)
          Image("wooriLogo")
            .resizable()
            .frame(width: 24, height: 24, alignment: .center)
        }
      }
      .widgetURL(URL(string: "myapp://ShowMyQRVC/\(storeAmount)"))
      .padding()
      
    case .systemMedium:
      if isLoggedIn ?? false {
        MediumView(storeAmount: storeAmount, qrText: qrText, storeDate: storeDate)
      } else {
        RegisterButton {
          print("Register button tapped")
        }
      }
      
    case .systemLarge:
      VStack(alignment: .leading, spacing: 10) {
        Text("Amount $\(storeAmount)")
        ForEach(entry.posts, id: \.id) { post in
          
          let uniqueIdentifier = "\(storeAmount)-\(post.title)"
          
          PostEntryView(post: post, totalAmountString: storeAmount)
            .widgetURL(URL(string: "myapp://PostSummaryVC/\(uniqueIdentifier.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"))
        }
      }
      .padding()
      .activityBackgroundTint(Color(uiColor: UIColor.red))
    default:
      Text("")
    }
  }
  
  
}

struct RegisterButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Register")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 200, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MediumView: View {
  
  @State var storeAmount: String = ""
  @State var qrText: String = ""
  
  @State var storeDate: String?
  
  var body: some View {
    HStack(spacing: 10) {
      VStack {
        Text("Woori QR")
          .font(.headline)
          .foregroundStyle(.blue)
        Link(destination: URL(string: "myapp://PostSummaryVC/\(storeAmount)")!, label: {
          
          ZStack {
            Image(uiImage: UIImage(data: GenerateQR.share.getQRCodeDate(text: qrText)!)!)
              .resizable()
              .frame(width: 100, height: 100,alignment: .leading)
            Image("wooriLogo")
              .resizable()
              .frame(width: 24, height: 24, alignment: .center)
          }
          //                        .widgetURL(URL(string: "myapp://PostSummaryVC/\(storeAmount)"))
        })
      }
      
      VStack(alignment: .leading, spacing: 0) {
        Text("Updated: \(storeDate ?? "")")
          .font(.system(size: 10))
          .fontWeight(.regular)
          .foregroundStyle(.gray)
        Spacer(minLength: 5)
        Text("Available Balance")
        
        Spacer()
        HStack {
          Text("Total: ")
            .font(.headline)
            .foregroundStyle(.blue)
          Text(CurrencyFormatter.basicCurrencyFormat(Double(storeAmount) ?? 0.0))
        }
        Spacer()
        /// Button Action
        HStack{
          Link(destination: URL(string: "myapp://ShowMyQRVC/\(storeAmount)")!, label: {
            Button(action: {
              // Action
              print("Scanning....")
              
            }) {
              Label("Scan", systemImage: "barcode.viewfinder")
            }
          })
          Spacer()
          Link(destination: URL(string: "myapp://PostSummaryVC/\(storeAmount)")!, label: {
            Button(action: {
              print("Sharing...")
            }) {
              Label("Share", systemImage: "square.and.arrow.up")
            }
          })
        }
      }
    }
  }
}

struct PostEntryView: View {
  
  let post: Post?
  let totalAmountString: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(post?.title ?? "")
        .font(.headline)
      Text(post?.body ?? "")
        .font(.subheadline)
        .lineLimit(3) // Adjust based on the size
      Divider().padding(16)
      Image("myQR")
        .resizable()
        .scaledToFit()
        .frame(height: 100)
        .cornerRadius(8)
    }
    .padding()
  }
}

func encodePost(_ post: Post) -> String {
  // Use a suitable encoding method, e.g., JSON encoding
  guard let encodedData = try? JSONEncoder().encode(post.title) else {
    return ""
  }
  return Data(encodedData).base64EncodedString()
}

struct Provider: TimelineProvider {
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(),amount: loadAmount(), posts: [])
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), amount: loadAmount(),  posts: [])
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    fetchData { posts in
      let currentDate = Date()
      let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
      
      let entries = posts.prefix(5).enumerated().map { index, post in
        SimpleEntry(
          date: Calendar.current.date(byAdding: .minute, value: index * 1, to: Date())!,
          amount: loadAmount(),
          posts: Array(posts.prefix(1))
        )
      }
      
      let timeline = Timeline(entries: entries, policy: .after(refreshDate))
      completion(timeline)
    }
  }
  
  func loadAmount() -> Double {
    let defaults = UserDefaults.standard
    print("Refresh Amount \(defaults.double(forKey: "RefreshAmount"))")
    return defaults.double(forKey: "RefreshAmount")
  }
  
  //URL:
  private func fetchData(completion: @escaping ([Post]) -> Void) {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else {
        print("Failed to fetch data")
        return
      }
      let posts = try? JSONDecoder().decode([Post].self, from: data)
      completion(posts ?? [])
      print("Post!!!")
    }
    task.resume()
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let amount: Double
  let posts: [Post] // Array of posts
}

@main
struct TrialWidget: Widget {
  
  let kind: String = "MyCustomWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      TrialWidgetEntryView(entry: entry)
        .containerBackground(.background, for: .widget)
    }
    .configurationDisplayName("Post Data Widget")
    .description("Displays data from an API.")
    .supportedFamilies([
      .systemSmall,
      .systemMedium,
      .systemExtraLarge
    ])
    
  }
  
}

#Preview(as: .systemMedium) {
  TrialWidget()
} timeline: {
  SimpleEntry(date: Date(),amount: 340, posts: [])
}
