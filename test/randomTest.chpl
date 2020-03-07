use UnitTest;
use Sort;
use Random only;
use Heap;

config const testParam:int = 100;

proc randomTest(comparator, test: borrowed Test) throws {
  var rands: [1..testParam] int;
  Random.fillRandom(rands);

  var myHeap = new heap(int, comparator=comparator);

  for i in 1..testParam {
    myHeap.push(rands[i]);
    test.assertTrue(myHeap.size == i);
  }
  /*
    `defaultComparator` makes a max-heap
    A reverseComparator is needed to sort myArr in descending order
    Then we can compare the elements one by one.
  */
  sort(rands, new ReverseComparator(comparator));

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
  randomTest(defaultComparator, test);
  /*
    Test for min-heap
  */
  randomTest(reverseComparator, test);
}

UnitTest.main();
