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
  ArrayList<Node> nodes;// = new ArrayList<Node>();
  
  // DELETE
  //ArrayList<Wall> right = new ArrayList<Wall>(); ArrayList<Wall> left = new ArrayList<Wall>(); ArrayList<PVector> rPoints = new ArrayList<PVector>();
  ArrayList<PVector> hp;// = new ArrayList<PVector>();
   void bake(Map map)
   {
       /// generate the graph you need for pathfinding
       
       
       nodes = new ArrayList<Node>();
       hp  = new ArrayList<PVector>();
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
     for(int i = 0; i < map.walls.size(); i++) {
       if(map.walls.get(i).crosses(newEnd, newStart)) {
         //print("no");
         return false;
       }
     }
     
     //return map.collides(end, start) && map.isReachable(PVector.mult(total, 0.5)) && map.isReachable(PVector.mult(total, 0.25)) && map.isReachable(PVector.mult(total, 0.75));
     PVector point = PVector.mult(total, 0.5);
     if(map.isReachable(point)) {
       hp.add(point);
       return true;
     }
     return false;//*/
   }
   
   //ArrayList<PVector> lines = new ArrayList<PVector>(); // put me somewhere appropriate!!
   
   //int counter = 0;
   void breakdown(ArrayList<Wall> polygon) {
     boolean isBrokenDown = false;
     int len = polygon.size();
     
     //if(counter < 8) {
       //println(counter, len);
       //counter++;
     if(len > 3) { // polygons with 3 walls are always convex
      for(int i = 0; i < len; i++) { // for each wall in polygon
        //println("loop ", i);
        if(polygon.get(i).normal.dot(polygon.get((i+1)%len).direction) > 0) { // if reflex
         //println("REFLEX ", i);
         //rPoints.add(polygon.get(i).end);
         
         isBrokenDown = true; // break down polygon, ie DO NOT ADD TO LIST (not convex)
         
         for(int j = 2; j < len-1; j++) { // check all nodes; 0 ----- i ----- i+j ----- len
           // check all points except neighbors
           // here
           
             int start = i;
             int end = (i+j)%len;
             if (start > end) {
               int temp = start;
               start = end;
               end = temp;
             }            
           
           //if(map.collides(polygon.get(i).end, polygon.get((i+j)%len).start) && map.isReachable(PVector.mult(PVector.add(polygon.get((i+j)%len).start, polygon.get(i).end), 0.5))) {
           if(placeable(polygon.get(end).start, polygon.get(start).end)) { //if legal line exists
             //println((i+j)%len);
             //lines.add(polygon.get(i).end);
             //lines.add(polygon.get((i+j)%len).start);
                
             // LOCAL VARIABLES ARE FREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
             /*// right: i:j, newLine(end, st)
             ArrayList<Wall> left = new ArrayList<Wall>();
             for(int l = start+1; l <= end; l++){ // i:j
               left.add(polygon.get(l%len));
             }
             left.add(new Wall(polygon.get(end).start, polygon.get(start).end)); //newLine(end, st)
             breakdown(left);
             
             // left: 0:i-1, newLine(st, end), j:len
             ArrayList<Wall> right = new ArrayList<Wall>();
             for(int r = 0; r <= start; r++){ // 0:i-1
               right.add(polygon.get(r));
             }
             right.add(new Wall(polygon.get(start).end, polygon.get(end).start)); //newLine(st, end)
             for(int r = end+1; r < len; r++){ // j:len
               right.add(polygon.get(r));
             }
             breakdown(right);*/
             
             // left: 0:i-1, newLine(st, end), j:len
             ArrayList<Wall> left = new ArrayList<Wall>();
             for(int l = 0; l <= start; l++){ // 0:i-1
               left.add(polygon.get(l));
             }
             left.add(new Wall(polygon.get(start).end, polygon.get(end).start)); //newLine(st, end)
             for(int l = end+1; l < len; l++){ // j:len
               left.add(polygon.get(l));
             }
             breakdown(left);
                            
             // right: i:j, newLine(end, st)
             ArrayList<Wall> right = new ArrayList<Wall>();
             for(int r = start+1; r <= end; r++){ // i:j
               right.add(polygon.get(r%len));
             }
             right.add(new Wall(polygon.get(end).start, polygon.get(start).end)); //newLine(end, st)
             breakdown(right);
             
             return;
             
             /*if(i < (i+j)%len) {
               
               // left: 0:i-1, newLine(st, end), j:len
               ArrayList<Wall> left = new ArrayList<Wall>();
               for(int l = 0; l <= i; l++){ // 0:i-1
                 left.add(polygon.get(l));
               }
               left.add(new Wall(polygon.get(i).end, polygon.get((i+j)%len).start)); //newLine(st, end)
               for(int l = i+j+1; l < len; l++){ // j:len
                 left.add(polygon.get(l));
               }
               //print("left");
               //nodes.add(new Node(left)); // maybe add new nodes on the bottom, for neighbors??
               //println("left", left.size());
               breakdown(left);
                              
               // right: i:j, newLine(end, st)
               ArrayList<Wall> right = new ArrayList<Wall>();
               for(int r = i+1; r <= i+j; r++){ // i:j
                 right.add(polygon.get(r%len));
               }
               right.add(new Wall(polygon.get((i+j)%len).start, polygon.get(i).end)); //newLine(end, st)
               //print("right");
               //nodes.add(new Node(right));
               //println("right", right.size());
               breakdown(right);
               
               //println("found a line");
               //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
               
               //lines.add(polygon.get(i).end);
               //lines.add(polygon.get((i+j)%len).end);
               //break;
               
               return;
               
             } else { // 0 ----- i+j ------ i ----- len
             
               // left: 0:i-1, newLine(st, end), j:len
               ArrayList<Wall> left = new ArrayList<Wall>();
               //println(i+j);
               for(int l = 0; l < (i+j)%len; l++){ // 0:i-1
                 left.add(polygon.get(l));
               }
               left.add(new Wall(polygon.get(i).end, polygon.get((i+j)%len).start)); //newLine(st, end)
               for(int l = i+1; l < len; l++){ // idk if +1 goes here
                 left.add(polygon.get(l));
               }
               //print("left");
               //nodes.add(new Node(left));
               breakdown(left);
                              
               // right: i:j, newLine(end, st)
               ArrayList<Wall> right = new ArrayList<Wall>();
               //for(int r = (i+j)%len; r <= i; r++){ // i:j
               for(int r = (i+j)%len + 1; r <= i; r++){ // i:j
               print("here");
                 //println("", i+j, i);
                 //println(r, i, j);
                 right.add(polygon.get(r));
               }
               right.add(new Wall(polygon.get((i+j)%len).start, polygon.get(i).end)); //newLine(end, st)
               //print("right");
               //nodes.add(new Node(right));
               //println(right.size());
               breakdown(right);
               
               return;
             }*/
           }
         }
        }
      }//*/
     }
     
     if(!isBrokenDown) {
       // add polygon to list
       nodes.add(new Node(polygon));
       //println(polygon.size());
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
      stroke(255,0,255);
      if(hp != null) {
        for(int i = 0; i < hp.size(); i++) {
          circle(hp.get(i).x, hp.get(i).y, 10);
        }
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
