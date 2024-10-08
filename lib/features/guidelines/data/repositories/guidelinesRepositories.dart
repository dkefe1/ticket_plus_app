import 'package:ticketing_app/features/guidelines/data/dataSources/remoteDatasource/guidelineDatasources.dart';
import 'package:ticketing_app/features/guidelines/data/models/feedback.dart';
import 'package:ticketing_app/features/guidelines/data/models/feedbackTitle.dart';
import 'package:ticketing_app/features/guidelines/data/models/privacyPolicy.dart';
import 'package:ticketing_app/features/guidelines/data/models/termsAndConditions.dart';

class GuidelineRepository {
  GuidelineRemoteDataSource guidelineRemoteDataSource;
  GuidelineRepository(this.guidelineRemoteDataSource);

  Future<List<TermsAndConditions>> getTermsAndConditions() async {
    try {
      final terms = await guidelineRemoteDataSource.getTermsAndConditions();
      return terms;
    } catch (e) {
      throw e;
    }
  }

  Future<List<PrivacyPolicy>> getPrivacyPolicy() async {
    try {
      final privacy = await guidelineRemoteDataSource.getPrivacyPolicy();
      return privacy;
    } catch (e) {
      throw e;
    }
  }

  Future<List<FeedbackTitle>> getFeedbackTitle() async {
    try {
      final title = await guidelineRemoteDataSource.getFeedbackTitle();
      return title;
    } catch (e) {
      throw e;
    }
  }

  Future submitFeedback(FeedbackModel feedback) async {
    try {
      await guidelineRemoteDataSource.submitFeedback(feedback);
    } catch (e) {
      throw e;
    }
  }
}
