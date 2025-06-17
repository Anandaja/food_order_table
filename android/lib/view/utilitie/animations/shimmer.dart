// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Bounceable(
                onTap: () {
                  //
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.27),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.grey.shade300,
                  ),
                  height: MediaQuery.of(context).size.height / 10,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                          color: Colors.grey.shade300,
                        ),
                        width: MediaQuery.of(context).size.width / 6,
                        height: MediaQuery.of(context).size.height / 10,
                        child: const ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                          child: Image(
                            image: NetworkImage(''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class imageLoading extends StatelessWidget {
  const imageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      child: Container(
        width: double.infinity,
        height: 200, // Adjust the height as needed
        decoration: BoxDecoration(
          color: Colors.grey[300],
          // borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
