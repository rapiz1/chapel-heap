use UnitTest;
use Heap;
use Sort;
use Random only;

config const testParam:int = 100;


proc rangeTest(test: borrowed Test) throws{
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

proc randomTest(test: borrowed Test) throws {
  var rands: [1..testParam] int;
  var myHeap = new heap(int);
  Random.fillRandom(rands);
  for e in rands {
    myHeap.push(e);
  }
  sort(rands, comparator=reverseComparator);
  for e in rands {
    test.assertTrue(e == myHeap.top());
    myHeap.pop();
  }
}

UnitTest.main();