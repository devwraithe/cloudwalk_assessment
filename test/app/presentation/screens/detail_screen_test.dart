import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudwalk_assessment/app/core/routes/routes.dart';
import 'package:cloudwalk_assessment/app/domain/entities/image_entity.dart';
import 'package:cloudwalk_assessment/app/presentation/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders DetailScreen widget correctly', (tester) async {
    const image = ImageEntity(
      title: 'Image Title',
      date: '2023-02-01',
      explanation: 'Image Explanation',
      imgUrl: 'https://example.com/image.jpg',
    );

    // render the widget tree
    await tester.pumpWidget(
      ScreenUtilInit(
        builder: (context, child) {
          return MaterialApp(
            home: Builder(
              builder: (context) {
                // create a button that navigates to DetailScreen
                return MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.detail,
                      arguments: image,
                    );
                  },
                  child: const Text('Go to DetailScreen'),
                );
              },
            ),
            routes: {
              Routes.detail: (context) => const DetailScreen(),
            },
          );
        },
      ),
    );

    // Tap the button to navigate to DetailScreen
    await tester.tap(find.text('Go to DetailScreen'));
    await tester.pumpAndSettle();

    // verify that DetailScreen widget is rendered
    expect(find.byType(DetailScreen), findsOneWidget);

    // verify that CachedNetworkImage widget is rendered
    expect(find.byType(CachedNetworkImage), findsOneWidget);

    // verify the presence of image title
    expect(find.text(image.title!), findsOneWidget);

    // verify the presence of image date
    expect(find.text(image.explanation!), findsOneWidget);

    // verify the presence of 'Go Back' text
    expect(find.text('Go Back'), findsOneWidget);
  });
}
