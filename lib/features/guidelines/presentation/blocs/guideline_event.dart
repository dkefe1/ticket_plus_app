import 'package:ticketing_app/features/guidelines/data/models/feedback.dart';

abstract class TermsAndConditionsEvent {}

class GetTermsAndConditionsEvent extends TermsAndConditionsEvent {}

abstract class PrivacyPolicyEvent {}

class GetPrivacyPolicyEvent extends PrivacyPolicyEvent {}

abstract class FeedbackEvent {}

class GetFeedbackTitleEvent extends FeedbackEvent {}

class SubmitFeedbackEvent extends FeedbackEvent {
  final FeedbackModel feedback;
  SubmitFeedbackEvent(this.feedback);
}
