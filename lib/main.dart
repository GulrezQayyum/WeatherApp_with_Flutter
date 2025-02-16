import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  final List<String> bookCovers = [
    "assets/r45104.jpg",
    "assets/9781250289698.jpg",
    "assets/81NMoMc9eeL._SL1500_.jpg",
    "assets/res2.jpg"
  ];

  final List<Map<String, String>> books = [
    {"title": "Man of my dreams", "image": "assets/new1.jpg", "category": "New"},
    {"title": "Wings of star light", "image": "assets/new2.jpeg", "category": "New"},
    {"title": "Too good to be true", "image": "assets/new3.jpeg", "category": "New"},
    {"title": "Other people's magic", "image": "assets/trendy1.jpg", "category": "Trending"},
    {"title": "The blue princess", "image": "assets/trendy2.jpg", "category": "Trending"},
    {"title": "Prince of thorns", "image": "assets/trendy3.jpeg", "category": "Trending"},
    {"title": "The light of streets", "image": "assets/trendy4.jpg", "category": "Trending"},
    {"title": "Tell me everything", "image": "assets/Bs1.jpg", "category": "Best Sellers"},
    {"title": "Think again", "image": "assets/Bs2.jpg", "category": "Best Sellers"},
    {"title": "It's starts with us", "image": "assets/Bs3.jpg", "category": "Best Sellers"},
    {"title": "It's ends with us", "image": "assets/Bs4.jpeg", "category": "Best Sellers"},
    {"title": "Ikigai", "image": "assets/Bs5.jpg", "category": "Best Sellers"}
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  Widget _buildBookList(String category) {
    List<Map<String, String>> filteredBooks =
        books.where((book) => book["category"] == category).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredBooks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: Image.asset(
              filteredBooks[index]["image"]!,
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              filteredBooks[index]["title"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(category),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Top App Bar**
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, size: 30),
                  const Text(
                    "Trendy Books",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.search, size: 30),
                      SizedBox(width: 16),
                      Icon(Icons.notifications, size: 30),
                    ],
                  ),
                ],
              ),
            ),

            // **Book Carousel**
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.8),
                itemCount: 4,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(bookCovers[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // **Tabs and Book Lists**
            Expanded(
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.white,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: Container(
                          color: Colors.white,
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: Colors.black,
                            indicatorColor: Colors.blue,
                            tabs: const [
                              Tab(text: "New"),
                              Tab(text: "Trending"),
                              Tab(text: "Best Sellers"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookList("New"),
                    _buildBookList("Trending"),
                    _buildBookList("Best Sellers"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 