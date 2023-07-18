import 'package:flutter/material.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'نیاز به بروزرسانی ',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '  ورژن جدید اپلیکیشن قابل دسرس است لطفا برای ادامه بروزرسانی کنید',
                style: TextStyle(color: Colors.black, fontSize: 25.0),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 150.0),
              ),
              onPressed: () {
                
              },
              icon: const Icon(Icons.system_update_sharp, size:30.0,),
              label: const Text(
                'اپدیت',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
