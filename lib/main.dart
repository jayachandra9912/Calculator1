import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';

// Events
abstract class CalculatorEvent {}

class NumberPressed extends CalculatorEvent {
  final String number;

  NumberPressed(this.number);
}

class OperationPressed extends CalculatorEvent {
  final String operation;

  OperationPressed(this.operation);
}

class ClearPressed extends CalculatorEvent {}

class EqualPressed extends CalculatorEvent {}

// State
class CalculatorState {
  final String display;

  CalculatorState(this.display);
}

// Bloc
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(CalculatorState(''));

  @override
  Stream<CalculatorState> mapEventToState(CalculatorEvent event) async* {
    if (event is NumberPressed) {
      yield CalculatorState(state.display + event.number);
    } else if (event is OperationPressed) {
      yield CalculatorState(state.display + event.operation);
    } else if (event is ClearPressed) {
      yield CalculatorState('');
    } else if (event is EqualPressed) {
      yield CalculatorState(_evaluate(state.display));
    }
  }

  String _evaluate(String expression) {
    try {
      // Create an Expression object from the expression string
      Parser p = Parser();
      Expression exp = p.parse(expression);

      // Evaluate the expression
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Return the evaluated result
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  // String _evaluate(String expression) {
  //   try {
  //     // You can use your own expression evaluation logic here
  //     // For simplicity, I'm just using eval from 'dart:math' package
  //     return eval(expression).toString();
  //   } catch (e) {
  //     return 'Error';
  //   }
  // }
}

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CalculatorBloc(),
        child: CalculatorScreen(),
      ),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CalculatorBloc calculatorBloc =
        BlocProvider.of<CalculatorBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<CalculatorBloc, CalculatorState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  state.display,
                  style: TextStyle(fontSize: 32.0),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(context, '1'),
              _buildButton(context, '2'),
              _buildButton(context, '3'),
              _buildButton(context, '+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(context, '4'),
              _buildButton(context, '5'),
              _buildButton(context, '6'),
              _buildButton(context, '-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(context, '7'),
              _buildButton(context, '8'),
              _buildButton(context, '9'),
              _buildButton(context, '*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(context, 'C'),
              _buildButton(context, '0'),
              _buildButton(context, '='),
              _buildButton(context, '/'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    final CalculatorBloc calculatorBloc =
        BlocProvider.of<CalculatorBloc>(context);

    return ElevatedButton(
      onPressed: () {
        if (text == 'C') {
          calculatorBloc.add(ClearPressed());
        } else if (text == '=') {
          calculatorBloc.add(EqualPressed());
        } else {
          calculatorBloc.add(NumberPressed(text));
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
