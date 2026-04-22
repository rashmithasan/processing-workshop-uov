int[] studentMarks = {99, 54, 75, 45, 30};
int sum = 0;

void setup(){

  for(int i = 0; i < studentMarks.length; i++){
    println("Marks "+ i + " = " + studentMarks[i]);
    sum += studentMarks[i];
    
  }
  println("Sum of array is: " + sum);  
}
