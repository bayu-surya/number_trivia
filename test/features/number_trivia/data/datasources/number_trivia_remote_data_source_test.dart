import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;
  MockHttpClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void setUpMockHttpClientSuccess200(String str) {
    var url = Uri.parse(str);
    when(mockHttpClient?.get(url, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }
  void setUpMockHttpClientFailure404(String str) {
    var url = Uri.parse(str);
    when(mockHttpClient!.get(url, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  // void setUpMockHttpClientSuccess200() {
  //   when(mockHttpClient?.get(any, headers: anyNamed('headers')))
  //       .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  // }

  // void setUpMockHttpClientFailure404() {
  //   when(mockHttpClient!.get(any, headers: anyNamed('headers')))
  //       .thenAnswer((_) async => http.Response('Something went wrong', 404));
  // }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // arrange
        // setUpMockHttpClientSuccess200();
        setUpMockHttpClientSuccess200('http://numbersapi.com/$tNumber');
        // act
        dataSource?.getConcreteNumberTrivia(tNumber);
        // assert
        var url = Uri.parse('http://numbersapi.com/$tNumber');
        verify(mockHttpClient?.get(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        // setUpMockHttpClientSuccess200();
        setUpMockHttpClientSuccess200('http://numbersapi.com/$tNumber');
        // act
        final result = await dataSource?.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        // setUpMockHttpClientFailure404();
        setUpMockHttpClientFailure404('http://numbersapi.com/$tNumber');
        // act
        final call = dataSource?.getConcreteNumberTrivia;
        // assert
        expect(() => call!(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // arrange
        // setUpMockHttpClientSuccess200();
        setUpMockHttpClientSuccess200('http://numbersapi.com/random');
        // act
        dataSource?.getRandomNumberTrivia();
        // assert
        var url = Uri.parse( 'http://numbersapi.com/random');
        verify(mockHttpClient?.get(
         url,
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        // setUpMockHttpClientSuccess200();
        setUpMockHttpClientSuccess200('http://numbersapi.com/random');
        // act
        final result = await dataSource?.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        // setUpMockHttpClientFailure404();
        setUpMockHttpClientFailure404('http://numbersapi.com/random');
        // act
        final call = dataSource?.getRandomNumberTrivia;
        // assert
        expect(() => call!(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
