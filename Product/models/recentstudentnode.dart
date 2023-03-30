class RecentStudentNode {
  String? fullName;
  RecentStudentNode? next;
  RecentStudentNode(this.fullName) {
    next = null;
  }
  RecentStudentNode.n(this.fullName, this.next);
}

