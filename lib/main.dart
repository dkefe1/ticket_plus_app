import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/features/auth/signin/data/dataSources/remoteDatasource/loginDatasource.dart';
import 'package:ticketing_app/features/auth/signin/data/repositories/loginRepository.dart';
import 'package:ticketing_app/features/auth/signin/presentation/blocs/login_bloc.dart';
import 'package:ticketing_app/features/auth/signup/data/dataSources/remoteDatasource/signupDatasource.dart';
import 'package:ticketing_app/features/auth/signup/data/repositories/signupRepository.dart';
import 'package:ticketing_app/features/auth/signup/presentation/screens/blocs/signup_bloc.dart';
import 'package:ticketing_app/features/common/bloc/language_bloc.dart';
import 'package:ticketing_app/features/guidelines/data/dataSources/remoteDatasource/guidelineDatasources.dart';
import 'package:ticketing_app/features/guidelines/data/repositories/guidelinesRepositories.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_bloc.dart';
import 'package:ticketing_app/features/home/data/dataSources/remoteDatasource/homeDataSource.dart';
import 'package:ticketing_app/features/home/data/repositories/homeRepository.dart';
import 'package:ticketing_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:ticketing_app/features/splashScreen.dart';
import 'package:flutter/services.dart';
import 'package:ticketing_app/l10n/l10n.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final signUpRepository = SignUpRepository(SignupRemoteDatasource());
  final loginRepository = LoginRepository(LoginRemoteDataSource());
  final eventRepository = HomeRepository(HomeRemoteDataSource());
  final promotionalEventRepository = HomeRepository(HomeRemoteDataSource());
  final profileRepository = HomeRepository(HomeRemoteDataSource());
  final updateProfileRepository = HomeRepository(HomeRemoteDataSource());
  final buyTicketRepository = HomeRepository(HomeRemoteDataSource());
  final termsAndConditionsRepository =
      GuidelineRepository(GuidelineRemoteDataSource());
  final privacyPolicyRepository =
      GuidelineRepository(GuidelineRemoteDataSource());
  final feedbackRepository = GuidelineRepository(GuidelineRemoteDataSource());
  final bookmarkRepository = HomeRepository(HomeRemoteDataSource());
  final ticketRepository = HomeRepository(HomeRemoteDataSource());
  final requestReturnRepository = HomeRepository(HomeRemoteDataSource());
  final getReturnRequestRepository = HomeRepository(HomeRemoteDataSource());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageBloc()..add(GetLanguage()),
        ),
        BlocProvider(create: (_) => SignupBloc(signUpRepository)),
        BlocProvider(create: (_) => LoginBloc(loginRepository)),
        BlocProvider(create: (_) => EventBloc(eventRepository)),
        BlocProvider(
            create: (_) => PromotionalEventBloc(promotionalEventRepository)),
        BlocProvider(create: (_) => ProfileBloc(profileRepository)),
        BlocProvider(create: (_) => UpdateProfileBloc(updateProfileRepository)),
        BlocProvider(create: (_) => BuyTicketBloc(buyTicketRepository)),
        BlocProvider(
            create: (_) =>
                TermsAndConditionsBloc(termsAndConditionsRepository)),
        BlocProvider(create: (_) => PrivacyPolicyBloc(privacyPolicyRepository)),
        BlocProvider(create: (_) => FeedbackBloc(feedbackRepository)),
        BlocProvider(create: (_) => BookmarkBloc(bookmarkRepository)),
        BlocProvider(create: (_) => TicketBloc(ticketRepository)),
        BlocProvider(
            create: (_) => ReturnRequestBloc(getReturnRequestRepository)),
        BlocProvider(create: (_) => RequestReturnBloc(requestReturnRepository)),
        BlocProvider(create: (_) => CancelRequestBloc(requestReturnRepository)),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        //BuildWhen
        buildWhen: (previous, current) =>
            previous.selectedLanguage != current.selectedLanguage,

        //Builder
        builder: (context, state) {
          return MaterialApp(
            title: 'Ticket Plus',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Montserrat',
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            locale: state.selectedLanguage.value,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
