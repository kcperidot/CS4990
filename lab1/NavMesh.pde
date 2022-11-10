// Useful to sort lists by a custom key //<>// //<>//
import java.util.Comparator;


/// In this file you will implement your navmesh and pathfinding.

/// This node representation is just a suggestion
class Node
{
  Node(ArrayList<Wall> polygon) {
    this.polygon = polygon;
    neighbors = new ArrayList<Node>();
    connections = new ArrayList<Wall>();
    index = new int[polygon.size()];
    for(int i = 0; i < polygon.size(); i++) {
      index[i] = -1;
    }
  }
  /*Node(int id, ArrayList<Wall> polygon, PVector center) {
    this.id = id;
    this.polygon = polygon;
    this.center = center;
    index = new int[polygon.size()];
  }*/
  Node(ArrayList<Wall> polygon, int[] index) {
    this.polygon = polygon;
    neighbors = new ArrayList<Node>();
    connections = new ArrayList<Wall>();
    this.index = index;
  }
  Node(int id, ArrayList<Wall> polygon, PVector center, ArrayList<Node> neighbors, ArrayList<Wall> connections) {
    this.id = id;
    this.polygon = polygon;
    this.center = center;
    this.neighbors = neighbors;
    this.connections = connections;
    index = new int[polygon.size()];
  }
  int id;
  ArrayList<Wall> polygon;
  PVector center;
  ArrayList<Node> neighbors;
  ArrayList<Wall> connections;
  int[] index; // index of divisionList containing the wall it divides by
}



class NavMesh
{
  //Node[] nodes = {};
  ArrayList<Node> nodes;// = new ArrayList<Node>();

  // DELETE
  //ArrayList<Wall> right = new ArrayList<Wall>(); ArrayList<Wall> left = new ArrayList<Wall>(); ArrayList<PVector> rPoints = new ArrayList<PVector>();
  ArrayList<PVector> hp; // halfway points (idk why they're drawn like eyeballs)
  //ArrayList<PVector> lines;  
  //int counter;
  ArrayList<Wall> divisionLines; // division walls
  int[] polygonIndex; // index of corresponding DL node
  int id;
  void bake(Map map)
  {
    /// generate the graph you need for pathfinding


    nodes = new ArrayList<Node>();
    hp  = new ArrayList<PVector>();
    divisionLines = new ArrayList<Wall>();
    id = 0;
    //counter = 0;
    //lines = new ArrayList<PVector>();
    //breakdown(map.walls);
    breakdown(new Node(map.walls));
    
    //println(nodes.size(), divisionLines.size());
    
    // update neighbor
    polygonIndex = new int[nodes.size()];//divisionLines.size()];
    for(int i = 0; i < polygonIndex.length; i++) {
      polygonIndex[i] = -1;
    }
      //printArray(polygonIndex);
      //print(divisionLines.size());
    
    for(int i = 0; i < nodes.size(); i++) {
      for(int j = 0; j < nodes.get(i).index.length; j++) {
        if(nodes.get(i).index[j] != -1) { // ie has a neighbor
          int curPIndex = nodes.get(i).index[j];
          //if(polygonIndex[nodes.get(i).index[j]] == -1) {
          if(polygonIndex[curPIndex] == -1) { // first to be looking for that entry
            //polygonIndex[nodes.get(i).index[j]] = i;
            polygonIndex[curPIndex] = i;
          } else {
            /*nodes.get(i).neighbors.add(nodes.get(polygonIndex[nodes.get(i).index[j]]));
            nodes.get(i).connections.add(divisionLines.get(i));
            nodes.get(polygonIndex[nodes.get(i).index[j]]).neighbors.add(nodes.get(i));
            nodes.get(polygonIndex[nodes.get(i).index[j]]).connections.add(divisionLines.get(i));// */
            
            // neighbors
            //nodes.get(i).neighbors.add(nodes.get(i));
            nodes.get(i).neighbors.add(nodes.get(polygonIndex[curPIndex]));
            nodes.get(polygonIndex[curPIndex]).neighbors.add(nodes.get(i));
            //print(polygonIndex[curPIndex]);
            //nodes.get(polygonIndex[curPIndex]).neighbors.add(nodes.get(i));
            
            // connections
            //nodes.get(i).connections.add(divisionLines.get(i));
            //nodes.get(polygonIndex[curPIndex]).connections.add(divisionLines.get(i));
            
            //nodes.get(i).connections.add(divisionLines.get(nodes.get(i).index[j]));
            //nodes.get(polygonIndex[curPIndex]).connections.add(divisionLines.get(nodes.get(i).index[j]));
            //println(nodes.get(i).index[j]);
            nodes.get(i).connections.add(divisionLines.get(nodes.get(i).index[j] - 1));
            nodes.get(polygonIndex[curPIndex]).connections.add(divisionLines.get(nodes.get(i).index[j] - 1));
            //nodes.get(i).connections.add(divisionLines.get(0));
            //nodes.get(polygonIndex[curPIndex]).connections.add(divisionLines.get(0));
            //nodes.get(polygonIndex[curPIndex]).connections.add(divisionLines.get(nodes.get(polygonIndex[curPIndex]).index[j]));
          }
        }
      }
      
      /*print("node ", nodes.get(i).id, "   ");
      for(int j = 0; j < nodes.get(i).neighbors.size(); j++) {
        print(nodes.get(i).neighbors.get(j).id, " ");
      } // 
      println();*/
    }
    
    
    if(nodes != null) {
    for(int i = 0; i < nodes.size(); i++) {
       print("node ", nodes.get(i).id, "   ");
      for(int j = 0; j < nodes.get(i).neighbors.size(); j++) {
        print(nodes.get(i).neighbors.get(j).id, " ");
      } // 
      println();
    }
    }
    
    
  }

  ArrayList<PVector> findPath(PVector start, PVector destination)
  {
    /// implement A* to find a path
    ArrayList<FrontierEntry> frontier = new ArrayList<FrontierEntry>();
    Node currentn;
    int startnode = 0;
    int destnode = 0;
    ArrayList<PVector> result = new ArrayList<PVector>();
    
    //find which polygon the boid is in
    for(int i = 0; i < nodes.size(); i++){
      if(isPointInPolygon(start, nodes.get(i).polygon)){
        startnode = i;
      }
      if(isPointInPolygon(destination, nodes.get(i).polygon)){
        destnode = i;
      }
    } 
    //add entry to frontier
    frontier.add(new FrontierEntry(nodes.get(startnode), null, PVector.sub(nodes.get(startnode).center, start), PVector.sub(destination, nodes.get(startnode).center)));
        
    while(frontier.get(0).current.id != destnode){
      currentn = frontier.get(0).current;
      //add neighbors to frontier
      for(int i = 0; i < currentn.neighbors.size(); i++){
        frontier.add(new FrontierEntry(currentn.neighbors.get(i), frontier.get(0).current, PVector.sub(currentn.neighbors.get(i).center, start), PVector.sub(destination, currentn.neighbors.get(i).center)));
      }
      //add to result
      result.add(currentn.neighbors.get(0).connections.get(0).center());
      //remove highest priority
      frontier.remove(0);
      //sort accordign to priority
      frontier.sort(new FrontierCompare());
    }
    //println(startnode);
    
    return result;
  }

  boolean placeable(PVector start, PVector end) {
    PVector total = PVector.add(start, end);
    PVector newStart = PVector.add(start, PVector.mult(PVector.sub(end, start), 0.01));
    PVector newEnd = PVector.add(end, PVector.mult(PVector.sub(end, start), -0.01));
    for (int i = 0; i < map.walls.size(); i++) {
      if (map.walls.get(i).crosses(newEnd, newStart)) {
        return false;
      }
    }

    PVector point = PVector.mult(total, 0.5);
    if (map.isReachable(point)) {
      //hp.add(point);
      return true;
    }
    return false;
  }
  
  void breakdown(Node node) {
    boolean isBrokenDown = false;
    int len = node.polygon.size();

    if (len > 3) { // polygons with 3 walls are always convex
      for (int i = 0; i < len; i++) { // for each wall in polygon
        //println("loop ", i);
        if (node.polygon.get(i).normal.dot(node.polygon.get((i+1)%len).direction) > 0) { // if reflex

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

            if (placeable(node.polygon.get(i).end, node.polygon.get((i+j)%len).end)) { //if legal line exists
            //lines.add(bdpolygon.get(end).end);
            //lines.add(bdpolygon.get(start).end);

              // LOCAL VARIABLES ARE FREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

              // left: 0:i-1, newLine(st, end), j:len
              //print("left ");
              ArrayList<Wall> left = new ArrayList<Wall>();
              //Node leftNode = new Node();
              int[] leftDL = new int[node.polygon.size() - (end - start) +1];
              //int[] leftDL = new int[node.polygon.size()];
              for(int z = 0; z < leftDL.length; z++) {
                leftDL[z] = 600;
              }
              for (int l = 0; l <= start; l++) { // 0:i-1
                left.add(node.polygon.get(l));
                //leftNode.index[l] = node.index[l];
                //leftDL[l] = node.index[l];
                leftDL[left.size()-1] = node.index[l];
                //print(l, " ");
              }
              divisionLines.add(new Wall(node.polygon.get(start).end, node.polygon.get(end).end));
              int currentDl = divisionLines.size();
              //leftNode.index[left.size()] = currentDl;
              left.add(new Wall(node.polygon.get(start).end, node.polygon.get(end).end)); //newLine(st, end)
              leftDL[left.size()-1] = currentDl;
              for (int l = end+1; l < len; l++) { // j:len
                left.add(node.polygon.get(l));
                //leftNode.index[l] = node.index[l];
                //leftDL[l] = node.index[l];
                 leftDL[left.size()-1] = node.index[l];
                //print(l, " ");
              }
              //leftNode.polygon = left;
              //breakdown(leftNode);
              breakdown(new Node(left, leftDL));

              // right: i:j, newLine(end, st)
              //print("right ");
              ArrayList<Wall> right = new ArrayList<Wall>();
              int[] rightDL = new int[end-start +1];
              //int[] rightDL = new int[node.polygon.size()];
              for(int z = 0; z < rightDL.length; z++) {
                rightDL[z] = 600;
              }
              //Node rightNode = new Node();
              for (int r = start+1; r <= end; r++) { // i:j
                right.add(node.polygon.get(r%len));
                //rightNode.index[r] = node.index[r];
                //rightDL[r] = node.index[r];
                rightDL[right.size()-1] = node.index[r];
                //print(r, " ");
              }
              right.add(new Wall(node.polygon.get(end).end, node.polygon.get(start).end)); //newLine(end, st)
              //rightNode.index[right.size()] = currentDl;
              rightDL[right.size()-1] = currentDl;
              //rightNode.polygon = right;
              //breakdown(rightNode);
              breakdown(new Node(right, rightDL));

              if (left.size() + right.size() != node.polygon.size()+2) {
                print("critical failure");
              }

              return;
              
            }
          }
        }
      }//*/
    }

    if (!isBrokenDown) {
      // add polygon to list
      
      PVector center = new PVector(0,0,0);
      for(int i = 0; i < node.polygon.size(); i++) {
        center = PVector.add(center, node.polygon.get(i).center());
      }
      //print(center);
      center = PVector.div(center, (float) node.polygon.size());
      node.id = id;
      id++;
      node.center = center;
      nodes.add(node);
      //print(node.index.toString());
      //printArray(node.index);
      /*print("node ", node.id, "   ");
      for(int i = 0; i < node.index.length; i++) {
        print(node.index[i], " ");
      }*/
      println();
      return;
    }
  } //}
  /*void breakdown(ArrayList<Wall> bdpolygon) {
    //if(counter <5) {
      //counter++;
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

            if (placeable(bdpolygon.get(i).end, bdpolygon.get((i+j)%len).end)) { //if legal line exists
            //lines.add(bdpolygon.get(end).end);
            //lines.add(bdpolygon.get(start).end);

              // LOCAL VARIABLES ARE FREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

              // left: 0:i-1, newLine(st, end), j:len
              //print("left ");
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
              breakdown(left);

              // right: i:j, newLine(end, st)
              //print("right ");
              ArrayList<Wall> right = new ArrayList<Wall>();
              for (int r = start+1; r <= end; r++) { // i:j
                right.add(bdpolygon.get(r%len));
                //print(r, " ");
              }
              right.add(new Wall(bdpolygon.get(end).end, bdpolygon.get(start).end)); //newLine(end, st)
              breakdown(right);

              if (left.size() + right.size() != bdpolygon.size()+2) {
                print("critical failure");
              }

              return;
              
            }
          }
        }
      }//
    }

    if (!isBrokenDown) {
      // add polygon to list
      
      PVector center = new PVector(0,0,0);
      for(int i = 0; i < bdpolygon.size(); i++) {
        center = PVector.add(center, bdpolygon.get(i).center());
      }
      print(center);
      center = PVector.div(center, (float) bdpolygon.size());
      nodes.add(new Node(id, bdpolygon, center));
      //println(id);
      id++;
      //println(bdpolygon.size());
      return;
    }
  } //}*/


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
      //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
      for (int i = 0; i < nodes.size(); i++) {
        stroke(255, 200, 200);
        for (int j = 0; j < nodes.get(i).polygon.size(); j++) {

          //textFont(createFont("Arial", 16, true), 16);
          //PVector center = nodes.get(i).polygon.get(j).center();
          //text(nodes.get(i).id, center.x, center.y);

          line(nodes.get(i).polygon.get(j).start.x, nodes.get(i).polygon.get(j).start.y, nodes.get(i).polygon.get(j).end.x, nodes.get(i).polygon.get(j).end.y);
        }
        stroke(255, 100, 100);
        circle(nodes.get(i).center.x, nodes.get(i).center.y, 3); // centers
        textFont(createFont("Arial",16,true),16);
        text(nodes.get(i).id,nodes.get(i).center.x,nodes.get(i).center.y);
        //println(nodes.get(i).index);
      }
      //println("draw");
    }//*/
    stroke(255, 0, 255);
    if (hp != null) {
      for (int i = 0; i < hp.size(); i++) {
        circle(hp.get(i).x, hp.get(i).y, 10);
      }
    }
    
    

    /*if(lines != null && lines.size() > 0) {
     //for(int i = 0; i < lines.size(); i++) {
     //  circle(rPoints.get(i).x, rPoints.get(i).y, 10);
     //}
     line(lines.get(0).x,lines.get(0).y,lines.get(1).x, lines.get(1).y);
     }
     
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
