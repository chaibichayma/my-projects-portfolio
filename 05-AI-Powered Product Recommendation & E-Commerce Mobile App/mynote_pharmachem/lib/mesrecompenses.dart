import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MesRecompenses extends StatelessWidget {
  final String userId;

  MesRecompenses({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Image.asset(
              'images/rewards.png', 
              height: 180,
            ),
          ),
          SizedBox(height: 50,),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('gagne_recompenses')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Une erreur s\'est produite');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucune récompense trouvée'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var rewardName = doc['rewardName'];
                    var rewardDescription = doc['rewardDescription'];

                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.star,
                          color: Color(0xFFA32CC4),
                        ),
                        title: Text(rewardName),
                        subtitle: Text(rewardDescription),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}