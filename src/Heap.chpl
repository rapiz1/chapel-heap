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

  Push or pop an element of a heap is O(lgN) in the worst case, where N is the size of the heap.
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

    pragma "no doc"
    var _data: list(eltType) = nil;

    /*
      Comparator record that defines how the
      data is compared. The greatest element will be on the top.
    */
    pragma "no doc"
    var _comparator: Comparator = defaultComparator;

    //TODO: not implemented yet
    /* If `true`, this heap will perform parallel safe operations. */
    param parSafe = false;

    /*
      Initializes an empty heap with `eltType`

      :arg eltType: The type of the elements

      :arg comparator: `defaultComparator` makes max-heap and `reverseCompartor` makes a min-heap
      :type comparator: `Comparator`

      :arg parSafe: If `true`, this heap will use parallel safe operations.
      :type parSafe: `param bool`
    */
    proc init(type eltType, comparator=defaultComparator, param parSafe=false) {
      this.eltType = eltType;
      this._data = new list(eltType);
      this._comparator = comparator;
      this.parSafe = parSafe;
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
      Return the greatest element in the heap.

      :return: The greatest element in the heap
      :rtype: `eltType`
    */
    proc top(): eltType {
      if (boundsChecking && isEmpty()) {
        boundsCheckHalt("Called \"heap.top\" on an empty heap.");
      }
      return _data(1);
    }

    /*
      Compare two element, respecting `reverse`
    */
    pragma "no doc"
    proc _greater(x:eltType, y:eltType) {
      if reverse then return y > x;
      else return x > y;
    }

    /*
      helper procs to maintain the Heap
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
