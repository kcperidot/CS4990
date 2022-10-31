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
   }
   
   ArrayList<PVector> findPath(PVector start, PVector destination)
   {
      /// implement A* to find a path
      ArrayList<PVector> result = null;
      return result;
   }
   
   
   void update(float dt)
   {
      draw();
   }
   
   void draw()
   {
     stroke(0,255,0);
     
      /// use this to draw the nav mesh graph
      for(int i = 0; i < map.walls.size(); i++) {
        if(map.walls.get(i).normal.dot(map.walls.get((i+1)%map.walls.size()).direction) > 0) {
         circle(map.walls.get((i+1)%map.walls.size()).start.x, map.walls.get((i+1)%map.walls.size()).start.y, 10);
        }
      }
   }
}
