// Useful to sort lists by a custom key
import java.util.Comparator;


/// In this file you will implement your navmesh and pathfinding. 

/// This node representation is just a suggestion
class Node
{
   int id;
   ArrayList<Wall> polygon;
   PVector center;
   ArrayList<Node> neighbors;
   ArrayList<Wall> connections;
}



class NavMesh
{   
  Node[] nodes = {};
  
   void bake(Map map)
   {
       /// generate the graph you need for pathfinding
       breakdown(map.walls);
   }
   
   ArrayList<PVector> findPath(PVector start, PVector destination)
   {
      /// implement A* to find a path
      ArrayList<PVector> result = null;
      return result;
   }
   
   ArrayList<PVector> lines = new ArrayList<PVector>(); // put me somewhere appropriate!!
   
   void breakdown(ArrayList<Wall> polygon) {
     int len = polygon.size();
      for(int i = 0; i < len; i++) {
        //println("loop ", i);
        if(polygon.get(i).normal.dot(polygon.get((i+1)%len).direction) > 0) { // if reflex
         println("REFLEX ", i);
         circle(polygon.get((i)%len).end.x, polygon.get((i)%len).end.y, 10);
         
         for(int j = 2; j < len-1; j++) { // check all nodes
           // here
           println(i, (i+j)%len, "iterating");
           if(map.collides(polygon.get(i).end, polygon.get((i+j)%len).start) && map.isReachable(PVector.mult(PVector.add(polygon.get((i+j)%len).start, polygon.get(i).end), 0.5))) {
             println("found a line");
             //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
             lines.add(polygon.get(i).end);
             lines.add(polygon.get((i+j)%len).end);
             break;
           }
         }
        }
      }//*/
     
   }
   
   
   void update(float dt)
   {
      draw();
   }
   
   void draw()
   {
     stroke(0,255,0);
     
      /// use this to draw the nav mesh graph
      
      if(lines != null) {
        //line(polygon.get(i).end.x, polygon.get(i).end.y, polygon.get((i+j)%len).end.x, polygon.get((i+j)%len).end.y);
        for(int i = 0; i < lines.size()/2; i++) {
          line(lines.get(i).x, lines.get(i).y, lines.get(i+1).x, lines.get(i+1).y);
        }
        //println("draw");
      }
      
      /*int len = map.walls.size();
      for(int i = 0; i < len; i++) {
        //println("loop ", i);
        if(map.walls.get(i).normal.dot(map.walls.get((i+1)%len).direction) > 0) { // if reflex
         println("REFLEX ", i);
         circle(map.walls.get((i)%len).end.x, map.walls.get((i)%len).end.y, 10);
         
         for(int j = 2; j < len-1; j++) { // check all nodes
           // here
           println(i, (i+j)%len, "iterating");
           if(map.collides(map.walls.get(i).end, map.walls.get((i+j)%len).start) && map.isReachable(PVector.mult(PVector.add(map.walls.get((i+j)%len).start, map.walls.get(i).end), 0.5))) {
             println("found a line");
             line(map.walls.get(i).end.x, map.walls.get(i).end.y, map.walls.get((i+j)%len).end.x, map.walls.get((i+j)%len).end.y);
             break;
           }
         }
        }
      }//*/
   }
}
