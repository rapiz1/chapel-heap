use Heap;
var myHeap = new heap(int);
for i in 1..5 {
  myHeap.push(i);
}
myHeap.push(-1);
writeln("The top element is ", myHeap.top());
writeln("The size is ", myHeap.size);
