// Useful to sort lists by a custom key
import java.util.Comparator;


/// In this file you will implement your navmesh and pathfinding. 

/// This node representation is just a suggestion
class Node
{
  Node(ArrayList<Wall> polygon) {
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
  ArrayList<Node> nodes = new ArrayList<Node>();
  
  // DELETE
  //ArrayList<Wall> right = new ArrayList<Wall>(); ArrayList<Wall> left = new ArrayList<Wall>(); ArrayList<PVector> rPoints = new ArrayList<PVector>();
   void bake(Map map)
   {
       /// generate the graph you need for pathfinding
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
   
   boolean placeable() {
     return true;
   }
   
   ArrayList<PVector> lines = new ArrayList<PVector>(); // put me somewhere appropriate!!
   
   int counter = 0;
   void breakdown(ArrayList<Wall> polygon) {
     boolean isBrokenDown = false;
     int len = polygon.size();
     
     //if(counter < 8) {
       //println(counter, len);
       //counter++;
     if(len > 3) { // polygons with 3 walls are always convex
      for(int i = 0; i < len; i++) { // for each wall
        //println("loop ", i);
        if(polygon.get(i).normal.dot(polygon.get((i+1)%len).direction) > 0) { // if reflex
         //println("REFLEX ", i);
         //rPoints.add(polygon.get(i).end);
         
         isBrokenDown = true; // break down polygon, ie DO NOT ADD TO LIST
         
         for(int j = 2; j < len-1; j++) { // check all nodes
           // here
           
           if(map.collides(polygon.get(i).end, polygon.get((i+j)%len).start) && map.isReachable(PVector.mult(PVector.add(polygon.get((i+j)%len).start, polygon.get(i).end), 0.5))) {
             // if legal line exists
             //println((i+j)%len);
             lines.add(polygon.get(i).end);
             lines.add(polygon.get((i+j)%len).start);
             
             // LOCAL VARIABLES ARE FREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
             if(i < (i+j)%len) {
               // left: 0:i-1, newLine(st, end), j:len
               ArrayList<Wall> left = new ArrayList<Wall>();
               for(int l = 0; l <= i; l++){ // 0:i-1
                 left.add(polygon.get(l));
               }
               left.add(new Wall(polygon.get(i).end, polygon.get((i+j)%len).start)); //newLine(st, end)
               for(int l = i+j+1; l < len; l++){ // j:len
                 left.add(polygon.get(l));
               }
               print("left");
               nodes.add(new Node(polygon));
               breakdown(left);
               
               
               // right: i:j, newLine(end, st)
               ArrayList<Wall> right = new ArrayList<Wall>();
               for(int r = i+1; r <= i+j; r++){ // i:j
                 right.add(polygon.get(r));
               }
               right.add(new Wall(polygon.get((i+j)%len).start, polygon.get(i).end)); //newLine(end, st)
               print("right");
               nodes.add(new Node(polygon));
               breakdown(right);
               
               //println("found a line");
               //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
               
               //lines.add(polygon.get(i).end);
               //lines.add(polygon.get((i+j)%len).end);
               //break;
               
               //breakdown L
               //breakdown R
               return;
             } else {
               // left: 0:i-1, newLine(st, end), j:len
               ArrayList<Wall> left = new ArrayList<Wall>();
               for(int l = 0; l < i+j; l++){ // 0:i-1
                 //left.add(polygon.get(l));
               }
               left.add(new Wall(polygon.get(i).end, polygon.get((i+j)%len).start)); //newLine(st, end)
               for(int l = i; l < len; l++){ // j:len
                 left.add(polygon.get(l));
               }
               //print("left");
               //nodes.add(new Node(polygon));
               breakdown(left);
               
               
               // right: i:j, newLine(end, st)
               ArrayList<Wall> right = new ArrayList<Wall>();
               //for(int r = i+1; r <= i+j; r++){ // i:j
               for(int r = 0; r <= j; r++){ // i:j
                 right.add(polygon.get((r+j)%len));
               }
               right.add(new Wall(polygon.get((i+j)%len).start, polygon.get(i).end)); //newLine(end, st)
               print("right");
               nodes.add(new Node(polygon));
               breakdown(right);
               
               //println("found a line");
               //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
               
               //lines.add(polygon.get(i).end);
               //lines.add(polygon.get((i+j)%len).end);
               //break;
               
               //breakdown L
               //breakdown R
               return;
             }
           }
         }
        }
      }//*/
     } //}
     
     if(!isBrokenDown) {
       // add polygon to list
       nodes.add(new Node(polygon));
       return;
     }
     
   }
   
   
   void update(float dt)
   {
      draw();
   }
   
   int nodesAmt = 0;
   void draw()
   {
     stroke(2,255,0);
     
      /// use this to draw the nav mesh graph
      
      /*if(lines != null) {
        //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
        for(int i = 0; i < lines.size()/2; i++) {
          line(lines.get(i).x, lines.get(i).y, lines.get(i+1).x, lines.get(i+1).y);
        }
        //println("draw");
      }*/
      
      if(nodes != null ){//&& nodes.size() > nodesAmt) {
        nodesAmt = nodes.size();
        stroke(255,200,200);
        //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
        for(int i = 0; i < nodes.size(); i++) {
          for(int j = 0; j < nodes.get(i).polygon.size(); j++) {
            line(nodes.get(i).polygon.get(j).start.x, nodes.get(i).polygon.get(j).start.y, nodes.get(i).polygon.get(j).end.x, nodes.get(i).polygon.get(j).end.y);
          }
        }
        //println("draw");
      }//*/
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
