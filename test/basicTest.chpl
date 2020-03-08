use UnitTest;
use Heap;
use Sort;

config const testParam:int = 100;


proc rangeTest(type comparator, test: borrowed Test) throws{
  var myHeap = new heap(int, comparator);
  var myArr: [1..testParam] int;

  for i in 1..testParam {
    myHeap.push(i);
    myArr[i] = i;
    test.assertTrue(myHeap.size == i);
  }
  /*
    `defaultComparator` makes a max-heap
    A reverseComparator is needed to sort myArr in descending order
    Then we can compare the elements one by one.
  */
  sort(myArr, new ReverseComparator(new comparator()));

  for i in 1..testParam {
    test.assertTrue(myArr[i] == myHeap.top());
    myHeap.pop();
    test.assertTrue(myHeap.size == testParam - i);
  }
}

proc testRunner(test: borrowed Test) throws{
  /*
    Test for max-heap
  */
  rangeTest(DefaultComparator, test);
  /*
    Test for min-heap
  */
  rangeTest(ReverseComparator, test);
}

UnitTest.main();