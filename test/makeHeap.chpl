use Sort;
use List;
use Heap;
use UnitTest;

proc mainTest(test: borrowed Test) throws {
  var x = makeHeap(1..5, DefaultComparator);
  test.assertTrue(x.top() == 5);
  test.assertTrue(x.size == 5);

  var l:list(int) = 1..10;
  var y = makeHeap(l, ReverseComparator);
  test.assertTrue(y.top() == 1);
  test.assertTrue(y.size == 10);

  var a:[1..3] int = [32141, 5134, 1234];
  var z = makeHeap(a);
  test.assertTrue(z.top() == 32141);
  test.assertTrue(z.size == 3);
}

UnitTest.main();
