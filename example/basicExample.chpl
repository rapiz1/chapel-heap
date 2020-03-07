use Heap;

// Shows how to use a max-heap
writeln("max-heap used");
var maxHeap = new heap(int, comparator=defaultComparator);

for i in 1..5 {
  maxHeap.push(i);
}

maxHeap.push(-1);

writeln("The top element is ", maxHeap.top());
writeln("The size is ", maxHeap.size);

maxHeap.pop();
writeln("The top element is ", maxHeap.top());
writeln("The size is ", maxHeap.size);

// Shows how to use a min-heap
writeln("min-heap used");
var minHeap = new heap(int, comparator=reverseComparator);

for i in 1..5 {
  minHeap.push(i);
}

minHeap.push(-1);

writeln("The top element is ", minHeap.top());
writeln("The size is ", minHeap.size);

minHeap.pop();
writeln("The top element is ", minHeap.top());
writeln("The size is ", minHeap.size);