use UnitTest;
use Sort;
use Heap;

param testParam:int = 10;

proc randomTest(type comparator, test: borrowed Test) throws {
  var rands: [1..testParam] int = [4235, 3452, 1221, 346, 2345, 457, 65, 657, 1234, 345];

  var myHeap = new heap(int, comparator);

  for i in 1..testParam {
    myHeap.push(rands[i]);
    test.assertTrue(myHeap.size == i);
  }
  /*
    `defaultComparator` makes a max-heap
    A reverseComparator is needed to sort myArr in descending order
    Then we can compare the elements one by one.
  */
  sort(rands, new ReverseComparator(new comparator()));

  for i in 1 .. testParam {
    test.assertTrue(rands[i] == myHeap.top());
    myHeap.pop();
    test.assertTrue(myHeap.size == testParam - i);
  }
}

proc testRunner(test: borrowed Test) throws{
  /*
    Test for max-heap
  */
  randomTest(DefaultComparator, test);
  /*
    Test for min-heap
  */
  randomTest(ReverseComparator, test);
}

UnitTest.main();
