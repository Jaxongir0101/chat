import 'package:flutter/material.dart';

import 'chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("chanels"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GroupItems(
                        id: 171,
                        slug: "d4ef5da4-e7f0-47b3-a84f-571d7c656adc",
                      ),
                    ),
                  );
                },
                child: const Text("Chanel 1")),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GroupItems(
                        id: 122,
                        slug: "60993633-03f8-4f14-9f07-f8dbea4b3f19",
                      )));
                },
                child: const Text("Chanel 2")),
          ],
        ),
      ),
    );
  }
}
