import 'package:flutter/material.dart';

class AdminAndResourcesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد الأقسام
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin & Resources'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Contact Admins'), // التواصل مع المسؤولين
              Tab(text: 'Educational Resources'), // المواد التعليمية
              Tab(text: 'Podcasts'), // البودكاست
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ContactAdminsSection(), // قسم التواصل مع المسؤولين
            EducationalResourcesSection(), // قسم المواد التعليمية
            PodcastsSection(), // قسم البودكاست
          ],
        ),
      ),
    );
  }
}

// قسم التواصل مع المسؤولين
class ContactAdminsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Admins',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'Your Message'),
            maxLines: 5,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // إرسال الرسالة
            },
            child: Text('Send Message'),
          ),
        ],
      ),
    );
  }
}

// قسم المواد التعليمية
class EducationalResourcesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Educational Resources',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ResourceCard(
          title: 'How to Pitch Your Idea',
          type: 'Video',
          onTap: () {},
        ),
        ResourceCard(
          title: 'The Art of Fundraising',
          type: 'Article',
          onTap: () {},
        ),
        // ... المزيد من البطاقات
      ],
    );
  }
}

// قسم البودكاست
class PodcastsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Podcasts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        PodcastCard(
          title: 'Episode 1: Startup Success Stories',
          guestName: 'John Doe',
          audioUrl: 'https://example.com/podcast.mp3',
          onTap: () {},
        ),
        PodcastCard(
          title: 'Episode 2: Investment Strategies',
          guestName: 'Jane Smith',
          audioUrl: 'https://example.com/podcast2.mp3',
          onTap: () {},
        ),
        // ... المزيد من الحلقات
      ],
    );
  }
}

// بطاقة المادة التعليمية
class ResourceCard extends StatelessWidget {
  final String title;
  final String type;
  final VoidCallback onTap;

  const ResourceCard({required this.title, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(type),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}

// بطاقة البودكاست
class PodcastCard extends StatelessWidget {
  final String title;
  final String guestName;
  final String audioUrl;
  final VoidCallback onTap;

  const PodcastCard({
    required this.title,
    required this.guestName,
    required this.audioUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text('Guest: $guestName'),
        trailing: Icon(Icons.play_arrow),
        onTap: onTap,
      ),
    );
  }
}