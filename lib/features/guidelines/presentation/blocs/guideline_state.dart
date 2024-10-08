import 'package:ticketing_app/features/guidelines/data/models/feedbackTitle.dart';
import 'package:ticketing_app/features/guidelines/data/models/privacyPolicy.dart';
import 'package:ticketing_app/features/guidelines/data/models/termsAndConditions.dart';

abstract class TermsAndConditionsState {}

class TermsAndConditionsInitialState extends TermsAndConditionsState {}

class TermsAndConditionsLoadingState extends TermsAndConditionsState {}

class TermsAndConditionsSuccessfulState extends TermsAndConditionsState {
  final List<TermsAndConditions> terms;
  TermsAndConditionsSuccessfulState(this.terms);
}

class TermsAndConditionsFailureState extends TermsAndConditionsState {
  final String error;
  TermsAndConditionsFailureState(this.error);
}

abstract class PrivacyPolicyState {}

class PrivacyPolicyInitialState extends PrivacyPolicyState {}

class PrivacyPolicyLoadingState extends PrivacyPolicyState {}

class PrivacyPolicySuccessfulState extends PrivacyPolicyState {
  final List<PrivacyPolicy> privacy;
  PrivacyPolicySuccessfulState(this.privacy);
}

class PrivacyPolicyFailureState extends PrivacyPolicyState {
  final String error;
  PrivacyPolicyFailureState(this.error);
}

abstract class FeedbackState {}

class FeedbackInitialState extends FeedbackState {}

class FeedbackTitleLoadingState extends FeedbackState {}

class FeedbackTitleSuccessfulState extends FeedbackState {
  final List<FeedbackTitle> title;
  FeedbackTitleSuccessfulState(this.title);
}

class FeedbackTitleFailureState extends FeedbackState {
  final String error;
  FeedbackTitleFailureState(this.error);
}

class FeedbackLoadingState extends FeedbackState {}

class FeedbackSuccessfulState extends FeedbackState {}

class FeedbackFailureState extends FeedbackState {
  final String error;
  FeedbackFailureState(this.error);
}
