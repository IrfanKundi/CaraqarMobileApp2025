import 'package:flutter/material.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with RouteAware {
  @override
  void didPush() {
    debugPrint('Page pushed: MyPage');
  }

  @override
  void didPop() {
    debugPrint('Page popped: MyPage');
  }

  @override
  void didPushNext() {
    debugPrint('Next page pushed from: MyPage');
  }

  @override
  void didPopNext() {
    debugPrint('Returned to: MyPage');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // ✅ Required build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Center(
        child: Text('This is MyPage. Check console for navigation logs.'),
      ),
    );
  }
}
