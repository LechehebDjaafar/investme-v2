import 'package:flutter/material.dart';
import 'investor_profile.dart'; // استيراد صفحة البروفايل

class UnifiedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // عدد الأقسام
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F0FE), // خلفية عامة
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E), // أزرق داكن غني
          title: Text(
            'Admin & Resources',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFF42A5F5), // أزرق متوسط فاتح (لون المؤشر)
            unselectedLabelColor: const Color(0xFFBBDEFB), // أزرق فاتح جدًا (للعناصر غير النشطة)
            labelColor: const Color(0xFF42A5F5), // أزرق متوسط فاتح (للعناصر النشطة)
            tabs: [
              Tab(text: 'Contact Admins'), // التواصل مع المسؤولين
              Tab(text: 'Educational Resources'), // المواد التعليمية
              Tab(text: 'Podcasts'), // البودكاست
              Tab(text: 'Profile'), // صفحة البروفايل
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ContactAdminsSection(), // قسم التواصل مع المسؤولين
            EducationalResourcesSection(), // قسم المواد التعليمية
            PodcastsSection(), // قسم البودكاست
            InvestorProfile(), // صفحة البروفايل
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A237E), // أزرق داكن غني
            ),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Your Message',
              labelStyle: TextStyle(color: const Color(0xFF42A5F5)), // أزرق متوسط فاتح
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: const Color(0xFF2196F3)), // أزرق مشرق
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            maxLines: 5,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // إرسال الرسالة
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color(0xFF2196F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A237E), // أزرق داكن غني
          ),
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A237E), // أزرق داكن غني
          ),
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
        title: Text(title, style: TextStyle(color: const Color(0xFF1A237E))), // أزرق داكن غني
        subtitle: Text(type, style: TextStyle(color: const Color(0xFF42A5F5))), // أزرق متوسط فاتح
        trailing: Icon(Icons.arrow_forward, color: const Color(0xFF42A5F5)), // أزرق متوسط فاتح
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
        title: Text(title, style: TextStyle(color: const Color(0xFF1A237E))), // أزرق داكن غني
        subtitle: Text('Guest: $guestName', style: TextStyle(color: const Color(0xFF42A5F5))), // أزرق متوسط فاتح
        trailing: Icon(Icons.play_arrow, color: const Color(0xFF42A5F5)), // أزرق متوسط فاتح
        onTap: onTap,
      ),
    );
  }
}