import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aurafit/core/theme/app_theme.dart';
import 'package:aurafit/features/ai_chat/ai_chat_screen.dart';
import 'package:aurafit/features/ai_chat/widgets/ai_chat_drawer.dart';
import 'package:aurafit/features/auth/auth_success_screen.dart';
import 'package:aurafit/features/auth/auth_welcome_screen.dart';
import 'package:aurafit/features/auth/forgot_password_screen.dart';
import 'package:aurafit/features/auth/login_screen.dart';
import 'package:aurafit/features/auth/otp_verification_screen.dart';
import 'package:aurafit/features/auth/register_screen.dart';
import 'package:aurafit/features/auth/reset_password_screen.dart';
import 'package:aurafit/features/bookmark/created_programs_screen.dart';
import 'package:aurafit/features/bookmark/my_bookmark_screen.dart';
import 'package:aurafit/features/goals/goals_screen.dart';
import 'package:aurafit/features/home/main_shell_screen.dart';
import 'package:aurafit/features/home/notifications/notification_screen.dart';
import 'package:aurafit/features/home/notifications/notification_settings_screen.dart';
import 'package:aurafit/features/home/search/filter_bottom_sheet.dart';
import 'package:aurafit/features/home/search/search_modal_sheet.dart';
import 'package:aurafit/features/home/search/search_results_screen.dart';
import 'package:aurafit/features/onboarding/onboarding_screen.dart';
import 'package:aurafit/features/personalize/personalize_flow_screen.dart';
import 'package:aurafit/features/personalize/personalize_intro_screen.dart';
import 'package:aurafit/features/personalize/reminders_screen.dart';
import 'package:aurafit/features/profile/personal_info_screen.dart';
import 'package:aurafit/features/profile/profile_screen.dart';
import 'package:aurafit/features/profile/settings_screen.dart';
import 'package:aurafit/features/programs/add_workouts_to_program_screen.dart';
import 'package:aurafit/features/programs/detail_programs_screen.dart';
import 'package:aurafit/features/programs/edit_program_list_screen.dart';
import 'package:aurafit/features/splash/splash_screen.dart';
import 'package:aurafit/features/statistics/statistics_screen.dart';
import 'package:aurafit/features/workout/sheets/add_to_programs_sheet.dart';
import 'package:aurafit/features/workout/sheets/share_workout_sheet.dart';
import 'package:aurafit/features/workout/sheets/workout_detail_sheet.dart';
import 'package:aurafit/features/workout/workout_screen.dart';
import 'package:aurafit/features/workout_session/active_workout_screen.dart';
import 'package:aurafit/features/workout_session/ai_form_check_flow.dart';
import 'package:aurafit/features/workout_session/exercise_intro_screen.dart';
import 'package:aurafit/features/workout_session/workout_complete_screen.dart';
import 'package:aurafit/main.dart';

void main() {
  testWidgets('Splash screen transitions to onboarding after delay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AuraFitApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);

    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('STOP WASTING REPS.'), findsOneWidget);
  });

  testWidgets('Onboarding advances through all 3 slides to AuthWelcomeScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const OnboardingScreen(),
      ),
    );

    expect(find.text('STOP WASTING REPS.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('MEET YOUR AI COACH.'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('WHAT’S YOUR GOAL?'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthWelcomeScreen), findsOneWidget);
    expect(find.text('THIS IS YOUR\nNEXT LEVEL'), findsOneWidget);
    expect(find.text('Continue With Email'), findsOneWidget);
  });

  testWidgets('Register flow navigates through OTP to Email verified screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const AuthWelcomeScreen(),
      ),
    );

    await tester.tap(find.text('Continue With Email'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'samporter@gmail.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    expect(find.byType(OtpVerificationScreen), findsOneWidget);
    expect(find.text('Enter OTP Code'), findsOneWidget);
    expect(find.text('samporter@gmail.com'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthSuccessScreen), findsOneWidget);
    expect(find.text('Email verified'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Forgot password flow navigates through OTP and Reset to Password updated', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );

    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'samporter@gmail.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Code'));
    await tester.pumpAndSettle();

    expect(find.byType(OtpVerificationScreen), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm'));
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordScreen), findsOneWidget);
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'PorterBridges2223');
    await tester.enterText(fields.at(1), 'PorterBridges2223');
    await tester.pump();

    expect(find.text('Strong'), findsOneWidget);
    expect(find.text('Password Match'), findsNWidgets(2));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthSuccessScreen), findsOneWidget);
    expect(find.text('Password updated'), findsOneWidget);
    expect(find.text('Explore Now'), findsOneWidget);
  });

  testWidgets('Personalize flow walks through all 7 steps, reminders, and completion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const PersonalizeIntroScreen(),
      ),
    );

    expect(find.text('Let’s build something personal.'), findsOneWidget);
    await tester.tap(find.text('Lets Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(PersonalizeFlowScreen), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('Complete your profile'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('02'), findsOneWidget);
    expect(find.text('What is your weight?'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('03'), findsOneWidget);
    expect(find.text('What is your height?'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('04'), findsOneWidget);
    expect(find.text('What Are You Training For?'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('05'), findsOneWidget);
    expect(find.text('What’s Your Experience Level ?'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('06'), findsOneWidget);
    expect(find.text('Where Do You Train ?'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('07'), findsOneWidget);
    expect(find.text('Ready To Commit?'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(RemindersScreen), findsOneWidget);
    expect(find.text('Would you like gentle reminders?'), findsOneWidget);

    await tester.tap(find.text('Allow Notification'));
    await tester.pumpAndSettle();
    expect(find.byType(AuthSuccessScreen), findsOneWidget);
    expect(find.text('You’re all set'), findsOneWidget);
    expect(find.text('Explore Now'), findsOneWidget);

    await tester.tap(find.text('Explore Now'));
    await tester.pumpAndSettle();
    expect(find.byType(MainShellScreen), findsOneWidget);
    expect(find.text('Sam Porter'), findsOneWidget);
    expect(find.text('Featured Workouts'), findsOneWidget);
  });

  testWidgets('Home screen displays workouts and activates Active Workout banner', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(),
      ),
    );

    expect(find.text('Sam Porter'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('Active Workout'), findsOneWidget);
    expect(find.text('Resume Now'), findsOneWidget);
    expect(find.text('Upper Body Strength'), findsWidgets);
    expect(find.text('Lower Body Power'), findsOneWidget);
    expect(find.text('Push Day'), findsOneWidget);

    await tester.tap(find.text('Lower Body Power'));
    await tester.pumpAndSettle();

    expect(find.text('Active Workout'), findsOneWidget);
    expect(find.text('Active workout: Lower Body Power'), findsOneWidget);
  });

  testWidgets('Home search opens modal, shows suggestions/empty states, and filters results', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(initialHasActiveWorkout: false),
      ),
    );

    await tester.tap(find.text('Search Workouts, Programs etc'));
    await tester.pumpAndSettle();

    expect(find.byType(SearchModalSheet), findsOneWidget);
    expect(find.text('Recent search'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(SearchModalSheet),
        matching: find.text('Upper'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(SearchModalSheet),
        matching: find.text('Chest'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(SearchModalSheet),
        matching: find.text('Legs'),
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), 'Trail');
    await tester.pump();
    expect(find.text('No Result Found'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Ches');
    await tester.pump();
    expect(find.text('Chest Builder Pro'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Push');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.byType(SearchResultsScreen), findsOneWidget);
    expect(find.text('Push Day'), findsOneWidget);
    expect(find.text('Full Body Push'), findsOneWidget);
    expect(find.text('Leg Push'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/home/filter.png'));
    await tester.pumpAndSettle();

    expect(find.byType(FilterBottomSheet), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(FilterBottomSheet),
        matching: find.text('Chest'),
      ),
    );
    await tester.tap(
      find.descendant(
        of: find.byType(FilterBottomSheet),
        matching: find.text('Intermediate'),
      ),
    );
    await tester.tap(
      find.descendant(
        of: find.byType(FilterBottomSheet),
        matching: find.text('Full Equipment'),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
    expect(find.text('Push Day'), findsOneWidget);
    expect(find.text('Push Hyperthropy'), findsOneWidget);
    expect(find.text('Leg Push'), findsNothing);
  });

  testWidgets('Notification screen opens from Home and navigates to settings, plus empty state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(initialHasActiveWorkout: false),
      ),
    );

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName ==
            'assets/home/topbar/notification.png'));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationScreen), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Time to train.'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName ==
            'assets/home/notification/setting.png'));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationSettingsScreen), findsOneWidget);
    expect(find.text('Training Reminders'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('New Programs & Features'),
      200,
    );
    expect(find.text('New Programs & Features'), findsOneWidget);
  });

  testWidgets('Notification screen displays empty state when isEmpty is true', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const NotificationScreen(isEmpty: true),
      ),
    );
    expect(find.text('No notifications yet.'), findsOneWidget);
  });

  testWidgets('Workout tab opens detail sheet, bookmark, add to programs, and share', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(initialHasActiveWorkout: false),
      ),
    );

    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();

    expect(find.byType(WorkoutScreen), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(WorkoutScreen),
        matching: find.text('Upper Body Strength'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WorkoutDetailSheet), findsOneWidget);
    expect(find.text('About This Workout'), findsOneWidget);
    expect(find.text('Bench Press'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName ==
            'assets/workout/bookmark-favorite.png' &&
        tester.widgetList(find.byType(WorkoutDetailSheet)).isNotEmpty).last);
    await tester.pump();
    expect(find.text('Save to Bookmark'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName ==
            'assets/workout/Playlist, Plus.png'));
    await tester.pumpAndSettle();

    expect(find.byType(AddToProgramsSheet), findsOneWidget);
    await tester.tap(find.text('Built Different'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Save to “Built Different”'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/workout/share.png'));
    await tester.pumpAndSettle();

    expect(find.byType(ShareWorkoutSheet), findsOneWidget);
    expect(find.text('Share to'), findsOneWidget);
    expect(find.text('Copy Link'), findsOneWidget);

    // Flush toast timer before test ends.
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('Statistic tab renders overview, charts, and empty state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(initialHasActiveWorkout: false),
      ),
    );

    await tester.tap(find.text('Statistic'));
    await tester.pumpAndSettle();

    expect(find.byType(StatisticsScreen), findsOneWidget);
    expect(find.text('Statistics'), findsOneWidget);
    expect(find.text('Weekly Overview'), findsOneWidget);
    expect(find.text('2h 45m'), findsOneWidget);
    expect(find.text('2230'), findsOneWidget);
    expect(find.text('AI Insight'), findsOneWidget);
    expect(find.text('Performance Index'), findsOneWidget);
    expect(find.text('Training Volume'), findsOneWidget);

    await tester.tap(find.text('3 Weeks Ago'));
    await tester.pumpAndSettle();

    expect(find.text('No Statistics Yet'), findsOneWidget);
    await tester.ensureVisible(find.text('Browse Now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Browse Now'));
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutScreen), findsOneWidget);
  });

  testWidgets('Profile tab renders workouts, badges, settings, and personal info', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(initialHasActiveWorkout: false),
      ),
    );

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Sam Porter'), findsWidgets);
    expect(find.text('48 h 43m'), findsOneWidget);
    expect(find.text('Leg Day'), findsOneWidget);

    await tester.tap(find.text('Badges'));
    await tester.pumpAndSettle();
    expect(find.text('Your Badges'), findsOneWidget);
    expect(find.text('First Rep'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/profile/setting.png'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Unlock Your Full Potential'), findsOneWidget);

    await tester.tap(find.text('Personal Information'));
    await tester.pumpAndSettle();

    expect(find.byType(PersonalInfoScreen), findsOneWidget);
    expect(find.text('Beginner'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/profile/edit1.png'));
    await tester.pumpAndSettle();

    expect(find.text('Save'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/profile/edit.png'));
    await tester.pumpAndSettle();

    expect(find.text('Change Image'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
  });

  testWidgets('AI Assist tab renders chat welcome, sends message, opens attachments and drawer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(initialHasActiveWorkout: false),
      ),
    );

    await tester.tap(find.text('AI Assist'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AiChatScreen), findsOneWidget);
    expect(find.textContaining('Your personal trainer'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/ai/Plus.png'));
    await tester.pump();
    expect(find.text('Capture Image'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byType(AiChatScreen),
        matching: find.byType(TextField),
      ),
      'Can you adjust my weekly program?',
    );
    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/ai/arrow-up-line.png'));
    await tester.pump();

    expect(find.text('Can you adjust my weekly program?'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('I reviewed your last 2 weeks'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/ai/sidebar.png'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AiChatDrawer), findsOneWidget);
    expect(find.text('RECENT CHATS'), findsOneWidget);
    expect(find.text('New Chat'), findsOneWidget);
  });

  testWidgets('Goals screen toggles workout completion and opens Change Program Goals', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(initialHasActiveWorkout: false),
      ),
    );

    await tester.tap(find.text('00'));
    await tester.pumpAndSettle();

    expect(find.byType(GoalsScreen), findsOneWidget);
    expect(find.text('Built Different'), findsOneWidget);
    expect(find.text('00/03'), findsOneWidget);

    await tester.tap(find.text('Leg Day'));
    await tester.pump();
    expect(find.text('01/03'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/goals/menu.png').first);
    await tester.pumpAndSettle();

    expect(find.text('Change Program Goals'), findsOneWidget);
    await tester.tap(find.text('Change Program Goals'));
    await tester.pumpAndSettle();

    expect(find.text('No Goals Set Yet'), findsOneWidget);
    expect(find.text('Build the Basics 💪'), findsOneWidget);
  });

  testWidgets('My Bookmark screen supports Workouts, edit mode, Programs, Created Programs, and empty state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MyBookmarkScreen(),
      ),
    );

    expect(find.text('My Bookmark'), findsOneWidget);
    expect(find.text('Push Day'), findsOneWidget);
    expect(find.text('Lower Body Power'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/bookmark/edit.png'));
    await tester.pump();
    await tester.tap(find.text('Push Day'));
    await tester.pump();
    expect(
      find.byWidgetPredicate((w) =>
          w is Image &&
          w.image is AssetImage &&
          (w.image as AssetImage).assetName == 'assets/bookmark/remove.png'),
      findsOneWidget,
    );

    await tester.tap(find.text('Programs'));
    await tester.pumpAndSettle();
    expect(find.text('Programs created by you'), findsOneWidget);
    expect(find.text('Programs by Pump IT'), findsOneWidget);

    await tester.tap(find.text('See more').first);
    await tester.pumpAndSettle();
    expect(find.byType(CreatedProgramsScreen), findsOneWidget);
    expect(find.text('Easy Training'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        key: UniqueKey(),
        theme: AppTheme.darkTheme,
        home: const MyBookmarkScreen(initialEmpty: true),
      ),
    );
    expect(find.text('No Bookmarks Yet'), findsOneWidget);
  });

  testWidgets('Workout session flow covers Intro, Countdown, Active, AI Form Check, Capture, Share, and Feedback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const ExerciseIntroScreen(),
      ),
    );

    expect(find.text('Dumbbell Shoulder Press'), findsOneWidget);
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.byType(WorkoutCountdownScreen), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    expect(find.byType(ActiveWorkoutScreen), findsOneWidget);
    expect(find.text('AI Form Check'), findsOneWidget);

    await tester.tap(find.text('AI Form Check'));
    await tester.pumpAndSettle();
    expect(find.byType(SetUpPhoneScreen), findsOneWidget);
    expect(find.text('Position Your Phone'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Phone in Portrait'), findsOneWidget);

    await tester.tap(find.text('Start Now'));
    await tester.pumpAndSettle();
    expect(find.byType(LiveFormCheckScreen), findsOneWidget);
    expect(find.text('95%'), findsOneWidget);

    await tester.tap(find.text('Back to Default'));
    await tester.pumpAndSettle();
    expect(find.byType(ActiveWorkoutScreen), findsOneWidget);

    await tester.tap(find.text('End Set'));
    await tester.pump();
    expect(find.text('Rest'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.tap(find.text('End Set'));
    await tester.pump();
    expect(find.text('Workout Done'), findsOneWidget);

    await tester.tap(find.text('Workout Done'));
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutCompleteCaptureScreen), findsOneWidget);

    await tester.tap(find.text('Capture Image'));
    await tester.pump();
    expect(find.text('Change Image'), findsOneWidget);

    await tester.tap(find.text('Share Workout'));
    await tester.pumpAndSettle();
    expect(find.byType(PostWorkoutShareSheet), findsOneWidget);
    expect(find.textContaining('I just crushed my workout'), findsOneWidget);

    await tester.tap(find.text('Copy Link'));
    await tester.pumpAndSettle();

    // Clear the floating SnackBar so Add Comment is unobstructed.
    ScaffoldMessenger.of(
      tester.element(find.byType(WorkoutCompleteCaptureScreen)),
    ).hideCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Comment'));
    await tester.pumpAndSettle();
    expect(find.byType(WorkoutFeedbackScreen), findsOneWidget);
    expect(find.text('You Nailed it !'), findsOneWidget);
  });

  testWidgets('Programs tab creates a program, adds workouts, and sets as training goal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainShellScreen(initialHasActiveWorkout: false),
      ),
    );

    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Programs'));
    await tester.pumpAndSettle();

    expect(find.text('Build the Basics 💪'), findsOneWidget);
    expect(find.text('New Program'), findsOneWidget);

    await tester.tap(find.text('New Program'));
    await tester.pumpAndSettle();

    expect(find.byType(GiveProgramNameScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Easy Training');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailProgramsScreen), findsOneWidget);
    expect(find.text('Easy Training'), findsOneWidget);
    expect(find.text('Add Workouts'), findsOneWidget);

    await tester.tap(find.text('Add Workouts'));
    await tester.pumpAndSettle();

    expect(find.byType(AddWorkoutsToProgramScreen), findsOneWidget);
    await tester.tap(find.text('Leg Day'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Chest Day'),
      200,
      scrollable: find.descendant(
        of: find.byType(AddWorkoutsToProgramScreen),
        matching: find.byType(Scrollable),
      ).last,
    );
    await tester.tap(find.text('Chest Day'));
    await tester.pump();
    expect(find.text('2 / 7'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailProgramsScreen), findsOneWidget);
    expect(find.text('2 Workouts'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/goals/menu.png').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Set program to your training goals'));
    await tester.pumpAndSettle();

    expect(find.text('Set to your training goals'), findsOneWidget);
    expect(find.text('0 / 2 Completed'), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/goals/menu.png').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit Details Programs'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Image'), findsOneWidget);
    expect(find.text('Program name'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.byWidgetPredicate((w) =>
        w is Image &&
        w.image is AssetImage &&
        (w.image as AssetImage).assetName == 'assets/goals/menu.png').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Program List'));
    await tester.pumpAndSettle();

    expect(find.byType(EditProgramListScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
    await tester.pumpAndSettle();
    expect(find.text('Delete Workout?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('1 Workouts'), findsOneWidget);
  });
}
