/*
 * Copyright 2004-2020 Hewlett Packard Enterprise Development LP
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* 
  This module contains the implementation of the heap type.

  A heap is a specialized tree-based data structure
  that supports extracting the maximal or the minimal element quickly,
  which can serve as a priority queue.

  * Both `push` and `pop` operations are O(lgN).
  * Querying the top element is O(1).
  * Initialization from an array is O(N).
*/
module Heap {
  private use HaltWrappers;
  private use List;

  public use Sort only defaultComparator, DefaultComparator,
                       reverseComparator, ReverseComparator;
  private use Sort;

  record heap {

    /* The type of the elements contained in this heap. */
    type eltType;

    /*
      Use a list to store elements.
    */
    pragma "no doc"
    var _data: list(eltType) = nil;

    /*
      Comparator record that defines how the
      data is compared. The greatest element will be on the top.
    */
    pragma "no doc"
    var _comparator: record; 

    //TODO: not implemented yet
    /* If `true`, this heap will perform parallel safe operations. */
    param parSafe = false;

    /*
      Build the heap from elements that have been stored, from bottom to top
      in O(N)
    */
    pragma "no doc"
    proc _commonInitFromIterable(iterable) {
      _data = new list(int);
      for x in iterable do
        _data.append(iterable);
      for i in 1 .. _data.size by -1 {
        const parent = i/2;
        if (parent <= 0) then
          break;
        if (_greater(_data[i], _data[parent])) {
          _data[i] <=> _data[parent];
        }
      }
    }

    /*
      Initializes an empty heap.

      :arg eltType: The type of the elements

      :arg comparator: `defaultComparator` makes max-heap and `reverseCompartor` makes a min-heap
      :type comparator: `Comparator`

      :arg parSafe: If `true`, this heap will use parallel safe operations.
      :type parSafe: `param bool`
    */
    proc init(type eltType, comparator:?rec=defaultComparator, param parSafe=false) {
      this.eltType = eltType;
      this._data = new list(eltType);
      this._comparator = comparator;
      this.parSafe = parSafe;
    }

    /*
      Initializes a heap containing elements that are copy initialized from
      the elements contained in another list.

      :arg other: The list to initialize from.
    */
    proc init=(other: list(this.type.eltType, ?p)) {
      if !isCopyableType(this.type.eltType) then
        compilerError("Cannot copy list with element type that cannot be copied");

      this.eltType = this.type.eltType;
      this._comparator = this.type._comparator;
      this.parSafe = this.type.parSafe;
      this.complete();
      _commonInitFromIterable(other);
    }

    /*
      Initializes a heap containing elements that are copy initialized from
      the elements contained in an array.

      :arg other: The array to initialize from.
    */
    proc init=(other: [?d] this.type.eltType) {
      if !isCopyableType(this.type.eltType) then
        compilerError("Cannot copy heap from array with element type that cannot be copied");

      this.eltType = this.type.eltType;
      this._comparator = this.type._comparator;
      this.parSafe = this.type.parSafe;
      this.complete();
      _commonInitFromIterable(other);
    }

    /*
      Initializes a heap containing elements that are copy initialized from
      the elements yielded by a range.

      .. note::

        Attempting to initialize a heap from an unbounded range will trigger
        a compiler error.

      :arg other: The range to initialize from.
      :type other: `range(this.type.eltType)`
    */
    proc init=(other: range(this.type.eltType, ?b, ?d)) {
      this.eltType = this.type.eltType;
      this._comparator = this.type._comparator;
      this.parSafe = this.type.parSafe;

      if !isBoundedRange(other) {
        param e = this.type:string;
        param f = other.type:string;
        param msg = "Cannot init " + e + " from unbounded " + f;
        compilerError(msg);
      }

      this.complete();
      _commonInitFromIterable(other);
    }

    /*
      Return the size of the heap.

      :return: The size of the heap
      :rtype: int
    */
    proc size:int {
      return _data.size;
    }

    /*
      Returns `true` if this heap contains zero elements.

      :return: `true` if this heap is empty.
      :rtype: `bool`
    */
    proc isEmpty():bool {
      return _data.isEmpty();
    }

    /*
      Return the maximal element in the heap.

      :return: The maximal element in the heap
      :rtype: `eltType`

      .. note::
        *Maximal* is defined by ``comparator``. If a ``reverseComparator`` is passed to ``init``,
        the heap will return the minimal element.

    */
    proc top(): eltType {
      if (boundsChecking && isEmpty()) {
        boundsCheckHalt("Called \"heap.top\" on an empty heap.");
      }
      return _data(1);
    }

    /*
      Wrapper of comparing elements
    */
    pragma "no doc"
    proc _greater(x:eltType, y:eltType) {
      return chpl_compare(x, y, _comparator) > 0;
    }

    /*
      helper procs to maintain the heap
    */
    pragma "no doc"
    proc _up(in pos:int) {
      while (pos != 1) {
        var parent = pos / 2;
        if (_greater(_data[pos],_data[parent])) {
          _data[parent] <=> _data[pos];
          pos = parent;
        }
        else break;
      }
    }

    pragma "no doc"
    proc _down(in pos:int) {
      while (pos <= _data.size) {
        // find the child node with greater value
        var greaterChild = pos*2;
        if (greaterChild > _data.size) then break; // reach leaf node, break
        if (greaterChild + 1 <= _data.size) {
          // if the right child node exists
          if (_greater(_data[greaterChild+1],_data[greaterChild])) {
            // if the right child is greater, then update the greaterChild
            greaterChild += 1;
          }
        }
        // if the greaterChild's value is greater than current node, then swap and continue
        if (_greater(_data[greaterChild],_data[pos])) {
          _data[greaterChild] <=> _data[pos];
          pos = greaterChild;
        }
        else break;
      }
    }

    /*
      Push an element into the heap

      :arg element: The element that will be pushed
      :type element: `eltType`
    */
    proc push(element:eltType) {
      _data.append(element);
      _up(_data.size);
    }

    /*
      Pop an element.

        .. note::
          This procedure does not return the element.

    */
    proc pop() {
      if (boundsChecking && isEmpty()) {
        boundsCheckHalt("Called \"heap.pop\" on an empty heap.");
      }
      _data(1) <=> _data(_data.size);
      _data.pop();
      _down(1);
    }
  }
}
