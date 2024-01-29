import 'package:fpdart/fpdart.dart';

//https://pub.dev/packages/fpdart

//Provide an option for failure and success in functions - means we don't need try catch blocks

//T means any type can be passed in
import 'failure.dart';typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;