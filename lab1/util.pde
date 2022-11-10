// Normalize an angle to be between 0 and TAU (= 2 PI)
float normalize_angle(float angle)
{
    while (angle < 0) angle += TAU;
    while (angle > TAU) angle -= TAU;
    return angle;
}

// Normalize an angle to be between -PI and PI
float normalize_angle_left_right(float angle)
{
    while (angle < -PI) angle += TAU;
    while (angle > PI) angle -= TAU;
    return angle;
}

class FrontierCompare implements Comparator<FrontierEntry>
{
  int compare(FrontierEntry a, FrontierEntry b)
  {
     /// return -1 if a < b, 1 if a > b, 0 otherwise
     if(a.total() < b.total()) return -1;
     else return 0;
  }
}

class FrontierEntry{
  Node current;
  Node from;
  double cost;
  double heuristic;
  //double total;
  FrontierEntry(Node current, Node from, PVector cost, PVector heuristic){
    this.current = current;
    this.from = from;
    this.cost = Math.pow(Math.pow(cost.x, 2) + Math.pow(cost.y, 2), 0.5);
    this.heuristic = Math.pow(Math.pow(heuristic.x, 2) + Math.pow(heuristic.y, 2), 0.5);
    //this.total = this.cost + this.heuristic;
  }
  double total() {
    return this.cost + this.heuristic;
  }
}
