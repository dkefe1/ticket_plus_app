import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ticketing_app/core/constants.dart';
import 'package:ticketing_app/core/globals.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_event.dart';
import 'package:ticketing_app/features/home/presentation/screens/eventDetailScreen.dart';
import 'package:ticketing_app/features/home/presentation/screens/successDialog.dart';

class ChapaPayment extends StatefulWidget {
  String checkoutUrl;
  ChapaPayment({super.key, required this.checkoutUrl});

  @override
  State<ChapaPayment> createState() => _ChapaPaymentState();
}

class _ChapaPaymentState extends State<ChapaPayment> {
  InAppWebViewController? webViewController;

  double _progress = 0;

  bool isComplete = false;

  @override
  void initState() {
    updateStatus();
    super.initState();
  }

  Future updateStatus() async {
    await Future.delayed(Duration(seconds: 10));
    isComplete = true;
  }

  @override
  Widget build(BuildContext context) {
    return buildInitialInput();
  }

  Widget buildInitialInput() {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.checkoutUrl)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
              ),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
            onLoadStop: (controller, url) async {
              if (url.toString() == "${baseUrl}/eventticket/credit/success") {
                await webViewController?.stopLoading();
                BlocProvider.of<TicketBloc>(context).add(GetTicketEvent());
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => EventDetailScreen()));
                showDialog(
                    context: context,
                    builder: (context) {
                      return SuccessDialog();
                    });
              }

              if (url == "${baseUrl}/eventticket/credit/error") {
                Navigator.pop(context);
              }
            },
          ),
          _progress < 1
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
