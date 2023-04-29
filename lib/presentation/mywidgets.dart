
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String caption;
  final IconData icon;
  final mykey = GlobalKey<FormState>();
  final TextEditingController textEditingController;
  final List<TextInputFormatter> inputFormat;
  final TextInputType keyboardFormat;
  final  Function(String value) onChanged;
  final Function() onPress;
  MyTextField({super.key, 
    required this.caption,
    required this.textEditingController,
    required this.icon,
    required this.inputFormat,
    required this.keyboardFormat,
    required this.onChanged,
    required this.onPress
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.black12, border: Border.all(color: Colors.grey)),
      child: Center(
        child:
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: keyboardFormat,
                    inputFormatters: inputFormat,
                    onChanged: onChanged,
                    controller: textEditingController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        labelText: caption,
                        labelStyle: const TextStyle(color: Colors.white),
                        icon: Icon(
                          icon,
                          color: Colors.white,
                        ),
                        // prefix: Icon(icon),
                        border: InputBorder.none),
                  ),
                ),
               const  SizedBox(width: 30,height: 20,),
                IconButton(onPressed:onPress, icon: const Icon(Icons.search
                ))
              ],
            ),
          
        ),
      );
    
  }
}