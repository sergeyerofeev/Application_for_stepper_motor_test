import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget customButton() => Consumer(
      builder: (_, ref, child) => Container(
        height: 48.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(2.0),
          onTap: () {},
          child: Center(
            child: child,
          ),
        ),
      ),
      child: Text(
        'Один\nоборот',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
