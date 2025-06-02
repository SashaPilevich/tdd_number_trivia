import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_number_trivia/features/number_trivia/presentation/widgets/trivia_controls.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Number Trivia')),
      body: BlocProvider(
        create: (_) => appLocator<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (BuildContext context, NumberTriviaState state) {
                      if (state is Empty) {
                        return MessageDisplay(message: 'Start searching!');
                      } else if (state is Loading) {
                        return LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(numberTrivia: state.trivia);
                      } else if (state is Error) {
                        return MessageDisplay(message: state.message);
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 20),
                  TriviaControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
