import 'dart:io';

void main(){
  performTasks();
}

Future<void> performTasks() async {
  task1();
  String task2Data = await task2();
  task3(task2Data);
}

void task1(){
  String result = 'Task 1 data';
  print('Task 1 completed');
}

Future<String> task2() async {
  Duration threeSeconds = Duration(seconds: 3);
  //sleep(threeSeconds);
  String? result;
  await Future.delayed(threeSeconds, (){
    result = 'Task 2 data';
    print('Task 2 completed');
  });
  return result!;

}

void task3(String task2Data){
  String result = 'Task 3 data';
  print('$task2Data ');
  print('Task 3 completed');
}