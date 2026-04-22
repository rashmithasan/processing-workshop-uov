int studentMarks [] = new int[5];

void setup() {

  studentMarks[0] = 67;
  studentMarks[1] = 98;
  studentMarks[2] = 47;
  studentMarks[3] = 65;
  studentMarks[4] = 72;
  
  println(
  
  "Marks 1 = " + studentMarks[0] + "\n" + 
  "Marks 2 = " + studentMarks[1] + "\n" + 
  "Marks 3 = " + studentMarks[2] + "\n" + 
  "Marks 4 = " + studentMarks[3] + "\n" + 
  "Marks 5 = " + studentMarks[4]
  
  );
 
 println("Sum is = " + (studentMarks[0] + studentMarks[1] + studentMarks[2] + studentMarks[3] + studentMarks[4]));
}
