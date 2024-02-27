import 'package:ensemble/core/constants/constants.dart';
import 'package:ensemble/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

// Mock class for MockBuildContext
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  test('createGroup function test', () async {
    // Mock dependencies
    final mockContext = MockBuildContext();
  //   final groupRepository = MockGroupRepository();
  //
  //   // Mock data
  //   final name = 'Test Group';
  //   final inviteCode = '12345';
  //   final description = 'This is a test group';
  //
  //   // Set up mock behavior for group repository
  //   final createdGroup = GroupModel(
  //     id: 'mockGroupId',
  //     inviteCode: inviteCode,
  //     name: name,
  //     description: description,
  //     groupPic: Constants.groupAvatarDefault,
  //     groupBanner: Constants.backgroundDefault,
  //     members: ['mockUid'],
  //     admins: ['mockUid'],
  //   );
  //   when(groupRepository.createGroup(any)).thenAnswer((_) async => Right(createdGroup));
  //
  //   // Call the function
  //   await createGroup(name, inviteCode, description, mockContext, groupRepository: groupRepository);
  //
  //   // Verify that the state is set to false after creating group
  //   expect(createGroup.state, false);
  //
  //   // Verify the function interactions
  //   verify(groupRepository.createGroup(captureAny)).called(1);
  //   verify(mockContext).pop();
  });
}