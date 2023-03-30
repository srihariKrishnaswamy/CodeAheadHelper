import 'package:cshliaiii/models/recentstudentnode.dart';
class RecentStudentNodeList {
  RecentStudentNode? front;
  RecentStudentNodeList() {
    front = null;
  }

  void add(String fullName) {
    if (front == null) {
      front = RecentStudentNode(fullName);
    } else {
      bool noRepeats = true;
      RecentStudentNode? curr = front;
      if (curr?.fullName == fullName) {
        noRepeats = false;
      }
      while (curr?.next != null) {
        curr = curr?.next;
        if (curr?.fullName == fullName) {
          noRepeats = false;
        }
      }
      if (noRepeats == true) {
        curr?.next = RecentStudentNode(fullName);
      }
    }
    print(toList().toString());
  }

  void deleteElement(String fullName) {
      if (front != null) {
        RecentStudentNode? curr = front;
        if(recursiveTraverse(fullName, curr!).next != null) {
          recursiveTraverse(fullName, curr).next = recursiveTraverse(fullName, curr).next!.next;
        } else if (fullName == front!.fullName) {
          front = front?.next;
        }
      }
  }
  RecentStudentNode recursiveTraverse(String target, RecentStudentNode curr) {   // returns the curr which we will reroute to a diff node | gonna plug in front as the initial second arg
    if(curr.next?.fullName == target || curr.next == null) {
      print(curr.fullName);
      return curr;
    } else {
      curr = curr.next!;
      return recursiveTraverse(target, curr);
    }
  }
  int size() {
    int counter = 0;
    if (front == null) {
      return counter;
    } else {
      RecentStudentNode? curr = front;
      counter ++;
      while (curr?.next != null) {
        curr = curr?.next;
        counter++;
      }
      return counter;
    }
  }
  List toList() {
   List retVal = [];
   if(front != null) {
     RecentStudentNode? curr = front;
     retVal.add(curr);
     while (curr?.next != null) {
       curr = curr?.next;
       retVal.add(curr);
     }
   }
   return retVal;
  }
}
  // ------------------------------------------------------------------
  // bool contains(String fullName) {
  //   bool contains = false;
  //   if (front != null) {
  //     RecentStudentNode? curr = front;
  //     for (int i = 0; i < size() - 1; i++) {
  //       if(curr?.fullName == fullName) {
  //         contains = true;
  //       }
  //       curr = curr?.next;
  //     }
  //   }
  //   return contains;
  // }
  // bool isEmpty() {
  //   if (front != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  //
  // void clear() {
  //   front = null;
  // }
  //
  // int indexOf(String fullName) {
  //   if (front == null) {
  //     return -1; // null saftey
  //   } else {
  //     int index = 0;
  //     RecentStudentNode? curr = front;
  //     while (curr?.fullName != fullName) {
  //       // maybe write this recursively for complexity
  //       index++;
  //       curr = curr?.next;
  //     }
  //     return index;
  //   }
  // }
  // void replace(String oldFN, String newFN) {
  //   if (front == null) {
  //     print("empty list");
  //   } else {
  //     RecentStudentNode? curr = front;
  //     while (curr?.fullName != oldFN) {
  //       // maybe write this recursively for complexity
  //       curr = curr?.next;
  //     }
  //     curr?.fullName = newFN;
  //   }
  // }
  // RecentStudentNode? get(String fullName) {
  //   if (front == null) {
  //     print("Empty List");
  //     return null;
  //   } else {
  //     RecentStudentNode? curr = front;
  //     while (curr?.fullName != fullName) {
  //       // maybe write this recursively for complexity
  //       curr = curr?.next;
  //     }
  //     return curr;
  //   }
  // }
  //
  // void removeFromEnd() {
  //   if(front != null) {
  //     RecentStudentNode? curr = front;
  //     int counter = 0;
  //     while (curr != null) {
  //       // maybe write this recursively for complexity
  //       curr = curr.next;
  //       counter ++;
  //     }
  //     RecentStudentNode? curr2 = front;
  //     for(int i = 0; i < counter - 1; i++) {
  //       curr2 = curr2!.next;
  //     }
  //     curr2!.next = null;
  //   }
  //   // ask pierson if i even need this
  // }
  // void addToFront(String fullName) {
  //   // dk if this works
  //   if (front == null) {
  //     front = RecentStudentNode(fullName);
  //   } else {
  //     RecentStudentNode? temp = front;
  //     front = RecentStudentNode.n(fullName, temp);
  //   }
  // }
  //
  // void removeFromFront() {
  //   if (front == null) {
  //     print("No such element");
  //   } else {
  //     front = front?.next;
  //   }
  // }

