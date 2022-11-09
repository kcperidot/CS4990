// Useful to sort lists by a custom key //<>//
import java.util.Comparator;


/// In this file you will implement your navmesh and pathfinding.

/// This node representation is just a suggestion
class Node
{
  Node(int id, ArrayList<Wall> polygon) {
    this.id = id;
    this.polygon = polygon;
  }
  Node(int id, ArrayList<Wall> polygon, PVector center, ArrayList<Node> neighbors, ArrayList<Wall> connections) {
    this.id = id;
    this.polygon = polygon;
    this.center = center;
    this.neighbors = neighbors;
    this.connections = connections;
  }
  int id;
  ArrayList<Wall> polygon;
  PVector center;
  ArrayList<Node> neighbors;
  ArrayList<Wall> connections;
}



class NavMesh
{
  //Node[] nodes = {};
  ArrayList<Node> nodes;// = new ArrayList<Node>();

  // DELETE
  //ArrayList<Wall> right = new ArrayList<Wall>(); ArrayList<Wall> left = new ArrayList<Wall>(); ArrayList<PVector> rPoints = new ArrayList<PVector>();
  ArrayList<PVector> hp;// = new ArrayList<PVector>();
  ArrayList<PVector> lines;  
  int counter;
  void bake(Map map)
  {
    /// generate the graph you need for pathfinding


    nodes = new ArrayList<Node>();
    hp  = new ArrayList<PVector>();
    counter = 0;
    lines = new ArrayList<PVector>();
    breakdown(map.walls);
    /*int len = map.walls.size();
     for(int i = 0; i < len; i++) {
     if(map.walls.get(i).normal.dot(map.walls.get((i+1)%len).direction) > 0) { // if reflex
     circle(map.walls.get((i)%len).end.x, map.walls.get((i)%len).end.y, 10);
     
     for(int j = 2; j < len-1; j++) { // check all nodes
     if(map.collides(map.walls.get(i).end, map.walls.get((i+j)%len).start) && map.isReachable(PVector.mult(PVector.add(map.walls.get((i+j)%len).start, map.walls.get(i).end), 0.5))) {
     line(map.walls.get(i).end.x, map.walls.get(i).end.y, map.walls.get((i+j)%len).end.x, map.walls.get((i+j)%len).end.y);
     break;
     }
     }//
     }
     }//*/
  }

  ArrayList<PVector> findPath(PVector start, PVector destination)
  {
    /// implement A* to find a path
    ArrayList<PVector> result = null;
    return result;
  }

  boolean placeable(PVector start, PVector end) {
    //if(map.collides(polygon.get(i).end, polygon.get((i+j)%len).start) && map.isReachable(PVector.mult(PVector.add(polygon.get((i+j)%len).start, polygon.get(i).end), 0.5)))
    PVector total = PVector.add(start, end);
    PVector newStart = PVector.add(start, PVector.mult(PVector.sub(end, start), 0.01));
    PVector newEnd = PVector.add(end, PVector.mult(PVector.sub(end, start), -0.01));
    for (int i = 0; i < map.walls.size(); i++) {
      if (map.walls.get(i).crosses(newEnd, newStart)) {
        //print("no");
        return false;
      }
    }

    //return map.collides(end, start) && map.isReachable(PVector.mult(total, 0.5)) && map.isReachable(PVector.mult(total, 0.25)) && map.isReachable(PVector.mult(total, 0.75));
    PVector point = PVector.mult(total, 0.5);
    if (map.isReachable(point)) {
      hp.add(point);
      return true;
    }
    return false;//*/
  }
  int id = 0;
  void breakdown(ArrayList<Wall> bdpolygon) {
    println(bdpolygon.size());
    //if(counter <5) {
      counter++;
    boolean isBrokenDown = false;
    int len = bdpolygon.size();

    if (len > 3) { // polygons with 3 walls are always convex
      for (int i = 0; i < len; i++) { // for each wall in polygon
        //println("loop ", i);
        if (bdpolygon.get(i).normal.dot(bdpolygon.get((i+1)%len).direction) > 0) { // if reflex

          isBrokenDown = true; // break down polygon, ie DO NOT ADD TO LIST (not convex)

          for (int j = 2; j < len-1; j++) { // check all nodes; 0 ----- start ----- end ----- len
            // check all points except neighbors

            int start = i;
            int end = (i+j)%len;
            if (start > end) {
              int temp = start;
              start = end;
              end = temp;
            }
            //println(i, j);

            //if (placeable(bdpolygon.get(end).start, bdpolygon.get(start).end)) { //if legal line exists dep.
            //if (placeable(bdpolygon.get(i).end, bdpolygon.get((i+j)%len).start)) { //if legal line exists
            if (placeable(bdpolygon.get(i).end, bdpolygon.get((i+j)%len).end)) { //if legal line exists
            //lines.add(bdpolygon.get(end).start);
            //lines.add(bdpolygon.get(end).end);
            //lines.add(bdpolygon.get(start).end);
            //println("HERE");

              // LOCAL VARIABLES ARE FREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

              // left: 0:i-1, newLine(st, end), j:len
              print("left ");
              ArrayList<Wall> left = new ArrayList<Wall>();
              for (int l = 0; l <= start; l++) { // 0:i-1
                left.add(bdpolygon.get(l));
                //print(l, " ");
              }
              left.add(new Wall(bdpolygon.get(start).end, bdpolygon.get(end).end)); //newLine(st, end)
              for (int l = end+1; l < len; l++) { // j:len
                left.add(bdpolygon.get(l));
                //print(l, " ");
              }
              println();
      nodes.add(new Node(id, left));
              breakdown(left);

              // right: i:j, newLine(end, st)
              print("right ");
              ArrayList<Wall> right = new ArrayList<Wall>();
              for (int r = start+1; r <= end; r++) { // i:j
                right.add(bdpolygon.get(r%len));
                //print(r, " ");
              }
              right.add(new Wall(bdpolygon.get(end).end, bdpolygon.get(start).end)); //newLine(end, st)
      //nodes.add(new Node(id, right));
              //println();
              breakdown(right);

              if (left.size() + right.size() != bdpolygon.size()+2) {
                print("critical failure"); // never triggered!!
              }

              //println();
              return;
              
            }
          }
        }
      }//*/
    }

    if (!isBrokenDown) {
      // add polygon to list
      id++;

      nodes.add(new Node(id, bdpolygon));
      //println(polygon.size());
      //draw();
      return;
    }
  } //}


  void update(float dt)
  {
    draw();
  }

  int nodesAmt = 0;
  void draw()
  {
    stroke(2, 255, 0);

    /// use this to draw the nav mesh graph

    if (nodes != null ) {//&& nodes.size() > nodesAmt) {
      nodesAmt = nodes.size();
      stroke(255, 200, 200);
      //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
      for (int i = 0; i < nodes.size(); i++) {
        for (int j = 0; j < nodes.get(i).polygon.size(); j++) {

          //textFont(createFont("Arial", 16, true), 16);
          //PVector center = nodes.get(i).polygon.get(j).center();
          //text(nodes.get(i).id, center.x, center.y);

          line(nodes.get(i).polygon.get(j).start.x, nodes.get(i).polygon.get(j).start.y, nodes.get(i).polygon.get(j).end.x, nodes.get(i).polygon.get(j).end.y);
        }
      }
      //println("draw");
    }//*/
    stroke(255, 0, 255);
    if (hp != null) {
      for (int i = 0; i < hp.size(); i++) {
        circle(hp.get(i).x, hp.get(i).y, 10);
      }
    }
    
    

    if(lines != null) {
     //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
    stroke(2, 255, 0);
     for(int i = 0; i < lines.size()-1; i+=2) {
     line(lines.get(i).x, lines.get(i).y, lines.get(i+1).x, lines.get(i+1).y);
     }
     //println("draw");
     }
     
     
    /*if(rPoints != null) {
     for(int i = 0; i < rPoints.size(); i++) {
     circle(rPoints.get(i).x, rPoints.get(i).y, 10);
     }
     }
     stroke(0,0,150);
     if(lines != null && lines.size() > 0) {
     //for(int i = 0; i < lines.size(); i++) {
     //  circle(rPoints.get(i).x, rPoints.get(i).y, 10);
     //}
     line(lines.get(0).x,lines.get(0).y,lines.get(1).x, lines.get(1).y);
     }
     
     stroke(0,255,0);
     
     if(right != null) {
     //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
     for(int i = 0; i < right.size(); i++) {
     line(right.get(i).start.x, right.get(i).start.y, right.get(i).end.x, right.get(i).end.y);
     }
     //println("draw");
     }
     
     stroke(255,150,150);
     if(left != null) {
     //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
     for(int i = 0; i < left.size(); i++) {
     line(left.get(i).start.x, left.get(i).start.y, left.get(i).end.x, left.get(i).end.y);
     }
     }//*/

    /*int len = map.walls.size();
     for(int i = 0; i < len; i++) {
     //println("loop ", i);
     if(map.walls.get(i).normal.dot(map.walls.get((i+1)%len).direction) > 0) { // if reflex
     //println("REFLEX ", i);
     circle(map.walls.get((i)%len).end.x, map.walls.get((i)%len).end.y, 10);
     
     for(int j = 2; j < len-1; j++) { // check all nodes
     // here
     //println(i, (i+j)%len, "iterating");
     if(map.collides(map.walls.get(i).end, map.walls.get((i+j)%len).start) && map.isReachable(PVector.mult(PVector.add(map.walls.get(i).end,map.walls.get((i+j)%len).start), 0.5))) {
     //println("found a line");
     line(map.walls.get(i).end.x, map.walls.get(i).end.y, map.walls.get((i+j)%len).end.x, map.walls.get((i+j)%len).end.y);
     break;
     }
     }//
     }
     }//*/
  }
}
