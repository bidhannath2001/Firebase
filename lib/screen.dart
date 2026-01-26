import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    vote(String docId) {
      FirebaseFirestore.instance.collection('participants').doc(docId).update({
        'votes': FieldValue.increment(1),
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Voting App')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('participants')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return const Center(child: Text('No Data Found'));
          }
          final participant = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.6,
            ),
            itemCount: 2,
            itemBuilder: (context, index) {
              final doc = participant[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                child: Column(
                  children: [
                    Image.network(
                      data['imageUrl'] ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['name'] ?? 'No Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Votes: ${data['votes'] ?? 0}',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          vote(doc.id);
                        },
                        child: Text('Vote'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
