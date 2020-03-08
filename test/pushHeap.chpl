use UnitTest;
use Heap;
use List;

proc mainTest(test: borrowed Test) throws{
  var h = new heap(int);
  pushHeap([3,2,4], h);
  test.assertTrue(h.size == 3);
  test.assertTrue(h.top() == 4);

  var l:list(int) = [5,1,0];
  pushHeap(l, h);
  test.assertTrue(h.size == 6);
  test.assertTrue(h.top() == 5);

  var r = -3..#2;
  pushHeap(r, h);
  test.assertTrue(h.size == 8);
  test.assertTrue(h.top() == 5);
}

UnitTest.main();