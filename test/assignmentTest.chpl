use UnitTest;
use List;
use Heap;

/*
 Convert heap to a sorted list.
*/
proc flattenHeap(ref x: heap(?t)) {
  var l = new list(t);
  while (!x.isEmpty()) {
    l.append(x.top());
    x.pop();
  }
  return l;
}
/*
//FIXME: This will fail for now
proc heapAssignment(test: borrowed Test) throws{
  var h1:heap(int) = 1..10;
  var h2:heap(int) = h1;
  test.assertTrue(flattenHeap(h1) == flattenHeap(h2));
}
*/
proc listAssignment(test: borrowed Test) throws{
  var l:list(int) = 1..10 by -1;
  var h:heap(int) = l;
  test.assertTrue(flattenHeap(h) ==l);
}
proc rangeAssignment(test: borrowed Test) throws{
  var l:list(int) = 1..10 by -1;
  var h:heap(int) = 1..10;
  test.assertTrue(flattenHeap(h) ==l);
}
UnitTest.main();