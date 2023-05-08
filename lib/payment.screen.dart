import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaymentView(),
    );
  }
}

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String get applicationId => Bootpay().applicationId(
        "64566178755e27001b376046",
        "64566178755e27001b376047",
        "64566178755e27001b376048",
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Center(
            child: TextButton(
              onPressed: () {
                bootpayTest(context);
              },
              child: const Text('Bootpay Go!'),
            ),
          );
        },
      ),
    );
  }

  void bootpayTest(BuildContext context) {
    Payload payload = getPayload();
    if (kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onError: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        //TODO - 원하시는 라우터로 페이지 이동
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        print('------- onConfirm: $data');
        /**
            1. 바로 승인하고자 할 때
            return true;
         **/
        /***
            2. 비동기 승인 하고자 할 때
            checkQtyFromServer(data);
            return false;
         ***/
        /***
            3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
            return false; 후에 서버에서 결제승인 수행
         */
        // checkQtyFromServer(data);
        return true;
      },
      onDone: (String data) {
        print('------- onDone: $data');
      },
    );
  }

  Payload getPayload() {
    Payload payload = Payload();

    Item item1 = Item();
    item1.name = "Ptry T-shirts";
    item1.qty = 1;
    item1.id = 'P-T-SHIRTS-01';
    item1.price = 100;

    payload.webApplicationId = "64566178755e27001b376046";
    payload.androidApplicationId = "64566178755e27001b376047";
    payload.iosApplicationId = "64566178755e27001b376048";

    payload.pg = "kcp";
    payload.orderName = 'Ptry';

    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
    payload.items = [item1];
    payload.price = 100;

    User user = User(); // 구매자 정보
    user.username = "사용자 이름";
    user.email = "user1234@gmail.com";
    user.area = "서울";
    user.phone = "010-4033-4678";
    user.addr = '서울시 동작구 상도로 222';

    payload.user = user;

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme =
        'com.example.bootpayTest2'; // 이걸 꼭 넣어야 결제 끝나고 다시 앱으로 리다이렉트 잘 되더라

    payload.extra = extra;

    return payload;
  }
}
