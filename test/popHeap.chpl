use Heap;
use List;
use UnitTest;

proc test(test: borrowed Test) throws{
  var h:heap(int) = 1..10;
  var l:list(int) = 1..10 by -1;
  test.assertTrue(popHeap(h) == l);
}

UnitTest.main();