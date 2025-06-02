import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String? inputString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onTapOutside: (_) {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
            }
          },
          focusNode: focusNode,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).hintColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: dispatchConcrete,
                child: Text('Search'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                child: Text('Get random trivia'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    if (inputString != null && inputString!.isNotEmpty) {
      controller.clear();
      context.read<NumberTriviaBloc>().add(
        GetTriviaForConcreteNumber(inputString!),
      );
    }
  }

  void dispatchRandom() {
    controller.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }
}
