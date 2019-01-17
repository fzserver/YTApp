import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void dispose() {
    super.dispose();
  }

  String history1 =
      'The tenth King Sri Guru Gobind Singh Sahib Ji was at Sri Anandpur Sahib delivering His Sikhs to Sachkhand. A Gursikh who would complete his daily prayer of the Panj Granthi (a collection of prayers from Sri Guru Granth Sahib Ji) with love and respect made a mistake. The Gursikh was made to realise that Gurbani is an ang (limb) of Guru Ji, and making a mistake while reciting Gurbani is like hurting Guru Ji. Following this Pyare Bhai Daya Singh, along with other respected Gursikhs requested the following to Guru Ji. “Oh keeper of the poor! Bless us with the understanding of Gurbani. Without an understanding we don’t whether what we do is correct or incorrect.”';

  String history2 =
      'Satguru Ji would never return the request of a Gursikh. After all the battles where He sacrificed all His family. Upon leaving Muktsar Sahib and arriving at Sabo ki Talwandi. Guru Ji gave the following command to his Gursikhs. “Go to Dhir Mal (he was the elder brother of Sri Guru Har Rai Sahib Ji and grandson to Sri Guru Hargobind Sahib Ji) who is at Kartarpur Sahib.';

  String h1 = 'Sri Guru Granth Sahib Jee';
  String history3 = 'The Guru Granth Sahib contains the scriptures of the Sikhs. It is an anthology of prayers and hymms which contain the actual words and verses as uttered by the Sikh Gurus. The Guru Granth Sahib, also known as the Adi Granth, consists of 1430 pages and has 5864 verses. Its contents are referred to as bani or gurbani. An individual hymm is a shabad.';
  String h2 = 'Sri Dasam Guru Granth Sahib Jee';
  String history4 = 'The collected writings of Guru Gobind Singh are known as Dasam Granth (“Scripture of the Tenth Guru”). The writings of the poets in his court comprise a different scripture, known as Vidiya Sar (“Pool of Knowledge”). According to a famous history of the Sikhs written in 1843, Suraj Prakash (“Rising of the Sun”), 52 scholar-poets and 7 pandits always lived in the court of Guru Gobind Singh Ji. The writings of the poets were written on paper in fine script, and according to Suraj Prakash, the weight of this Vidiya Sar was “9 maunds.”';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'HISTORY OVERVIEW',
                          style: TextStyle(
                              color: Color.fromRGBO(17, 28, 59, 1.0),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Card(
              elevation: 0.0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('$history1'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Card(
              elevation: 0.0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('$history2'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Card(
              elevation: 0.0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('$h1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Card(
              elevation: 0.0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('$history3'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Card(
              elevation: 0.0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('$h2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Card(
              elevation: 0.0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('$history4'),
                ),
              ),
            ),
          ],
        ),
      );
}
