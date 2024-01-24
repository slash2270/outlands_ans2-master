import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outlands_ans2/util/constants.dart';
import 'package:outlands_ans2/view/no_data_view.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T> Function() getData;
  final Widget Function(T?) widget;
  const CustomFutureBuilder({Key? key, required this.getData, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
                child: InkWell(
                  onTap: getData,
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_tree,
                          size: 30.w,
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Text(
                          '網路異常, 請點擊重試',
                          style: Constants.textHelperFail,
                        ),
                      ],
                    ),
                  ),
                )
            );
          } else {
            if (snapshot.hasData) {
              return widget(snapshot.data);
            } else {
              return const NoDataView();
            }
          }
        } else {
          return Center(
              child: SizedBox(
                height: 30.w,
                width: 30.w,
                child: const CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 2,
              ),
            ),
          );
        }
      },
    );
  }
}