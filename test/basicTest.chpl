use UnitTest;
use Heap;

config const testParam:int = 10;


proc myTest(test: borrowed Test) throws{
  var myHeap = new heap(int);

  for i in 1..testParam {
    myHeap.push(i);
    test.assertTrue(myHeap.size == i);
  }
  for i in 1..testParam by -1 {
    test.assertTrue(i == myHeap.top());
    myHeap.pop();
    test.assertTrue(myHeap.size == i-1);
  }
}

UnitTest.main();