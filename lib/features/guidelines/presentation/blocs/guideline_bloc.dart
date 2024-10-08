import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/features/guidelines/data/models/feedbackTitle.dart';
import 'package:ticketing_app/features/guidelines/data/models/privacyPolicy.dart';
import 'package:ticketing_app/features/guidelines/data/models/termsAndConditions.dart';
import 'package:ticketing_app/features/guidelines/data/repositories/guidelinesRepositories.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_event.dart';
import 'package:ticketing_app/features/guidelines/presentation/blocs/guideline_state.dart';

class TermsAndConditionsBloc
    extends Bloc<TermsAndConditionsEvent, TermsAndConditionsState> {
  GuidelineRepository guidelineRepository;
  TermsAndConditionsBloc(this.guidelineRepository)
      : super(TermsAndConditionsInitialState()) {
    on<GetTermsAndConditionsEvent>(onGetTermsAndConditionsEvent);
  }

  void onGetTermsAndConditionsEvent(
      GetTermsAndConditionsEvent event, Emitter emit) async {
    emit(TermsAndConditionsLoadingState());
    try {
      List<TermsAndConditions> terms =
          await guidelineRepository.getTermsAndConditions();
      emit(TermsAndConditionsSuccessfulState(terms));
    } catch (e) {
      emit(TermsAndConditionsFailureState(e.toString()));
    }
  }
}

class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  GuidelineRepository guidelineRepository;
  PrivacyPolicyBloc(this.guidelineRepository)
      : super(PrivacyPolicyInitialState()) {
    on<GetPrivacyPolicyEvent>(onGetPrivacyPolicyEvent);
  }

  void onGetPrivacyPolicyEvent(
      GetPrivacyPolicyEvent event, Emitter emit) async {
    try {
      List<PrivacyPolicy> privacy =
          await guidelineRepository.getPrivacyPolicy();
      emit(PrivacyPolicySuccessfulState(privacy));
    } catch (e) {
      emit(PrivacyPolicyFailureState(e.toString()));
    }
  }
}

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  GuidelineRepository guidelineRepository;
  FeedbackBloc(this.guidelineRepository) : super(FeedbackInitialState()) {
    on<GetFeedbackTitleEvent>(onGetFeedbackTitleEvent);
    on<SubmitFeedbackEvent>(onSubmitFeedbackEvent);
  }

  void onGetFeedbackTitleEvent(
      GetFeedbackTitleEvent event, Emitter emit) async {
    emit(FeedbackTitleLoadingState());
    try {
      List<FeedbackTitle> title = await guidelineRepository.getFeedbackTitle();
      emit(FeedbackTitleSuccessfulState(title));
    } catch (e) {
      emit(FeedbackTitleFailureState(e.toString()));
    }
  }

  void onSubmitFeedbackEvent(SubmitFeedbackEvent event, Emitter emit) async {
    emit(FeedbackLoadingState());
    try {
      await guidelineRepository.submitFeedback(event.feedback);
      emit(FeedbackSuccessfulState());
    } catch (e) {
      emit(FeedbackFailureState(e.toString()));
    }
  }
}
