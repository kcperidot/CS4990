class Wall
{
   PVector start;
   PVector end;
   PVector normal;
   PVector direction;
   float len;
   
   Wall(PVector start, PVector end)
   {
      this.start = start;
      this.end = end;
      direction = PVector.sub(this.end, this.start);
      len = direction.mag();
      direction.normalize();
      normal = new PVector(-direction.y, direction.x);
   }
   
   // Return the mid-point of this wall
   PVector center()
   {
      return PVector.mult(PVector.add(start, end), 0.5);
   }
   
   void draw()
   {
       strokeWeight(3);
       line(start.x, start.y, end.x, end.y);
       if (SHOW_WALL_DIRECTION)
       {
          PVector marker = PVector.add(PVector.mult(start, 0.2), PVector.mult(end, 0.8));
          circle(marker.x, marker.y, 5);
       }
   }
}


class Map
{
   ArrayList<Wall> walls;
   ArrayList<ArrayList<MazeCell>> mazecells; // ArrayList of ArrayLists to easier sort MazeCells
   ArrayList<MazeCell> frontier;
   ArrayList <MazeCell> done;
   
   Map()
   {
      walls = new ArrayList<Wall>();
   }
  
   
   
   //void generate(int which)
   void generate(int size)
   {
      walls.clear();
      mazecells = new ArrayList<ArrayList<MazeCell>>();
      int rows = 800/size;
      int cols = 600/size;
      
      
      // CREATE MAZE CELLS
      for(int i = 0; i < rows; i++) { // width
      ArrayList<MazeCell> mazecellrow = new ArrayList<MazeCell>();
      
        for(int j = 0; j < cols; j++) { // height
          mazecellrow.add(new MazeCell(i, j, new PVector(size*(i+0.5), size*(j+0.5)), size ) );
          
          // it was art and it was beautiful
          // POINT1------POINT2
          //   |           |
          // POINT3------POINT4
            // POINT1 = nw, nh
            // POINT2 = n(w+1), nh
            // POINT3 = nw, n(h+1)
            // POINT4 = n(w+1), n(h+1)
          
          //    * WALL1 *
          // WALL4     WALL2
          //    * WALL3 *
          //walls.add(new Wall(new PVector(size*i, size*j),         new PVector(size*(i+1), size*j)));     // WALL1
          //walls.add(new Wall(new PVector(size*(i+1), size*j),     new PVector(size*(i+1), size*(j+1)))); // WALL2
          //walls.add(new Wall(new PVector(size*(i+1), size*(j+1)), new PVector(size*i, size*(j+1))));     // WALL3
          //walls.add(new Wall(new PVector(size*i, size*(j+1)),     new PVector(size*i, size*j)));         // WALL4
        }
        
        mazecells.add(mazecellrow);
      }
      
      
      // GENERATE GRAPH
      frontier = new ArrayList<MazeCell>();
      done = new ArrayList<MazeCell>();
      
      // 1. pick a random point
      MazeCell curCel = mazecells.get(int(random(rows))).get(int(random(cols)));
      frontier.add(curCel);
      
      // 2. add point to maze
      curCel.visited = true;
      done.add(curCel);
      
      // 3. add neighbors to frontier
      int r = curCel.row;
      int c = curCel.col;
      if(r-1 >= 0) // add top neighbor (if exists + unvisited)
      {
        MazeCell newCel = mazecells.get(r-1).get(c);
        if(!newCel.visited) {
          frontier.add(newCel);
        }
      }      
      if(c-1 >= 0) // add left neighbot (if exists + unvisited)
      {
        MazeCell newCel = mazecells.get(r).get(c-1);
        if(!newCel.visited) {
          frontier.add(newCel);
        }
      }
      if(c+1 < cols) // add right neighbot (if exists + unvisited)
      {
        MazeCell newCel = mazecells.get(r).get(c+1);
        if(!newCel.visited) {
          frontier.add(newCel);
        }
      }
      if(r+1 < rows) // add bottom neighbor (if exists + unvisited)
      {
        MazeCell newCel = mazecells.get(r+1).get(c);
        if(!newCel.visited) {
          frontier.add(newCel);
        }
      }
    
    while(frontier.size() > 0) {
      // 4. pick random frontier cell
      int frontierNo = (int) random(frontier.size());
      MazeCell randFrontier = frontier.get(frontierNo);
      
      if(!randFrontier.visited) {
                
        // 5. Connect to adjacent cell in maze OR
        // 6. Add neighbors to frontier
        r = randFrontier.row;
        c = randFrontier.col;
        boolean needsNeighbor = true;
        
        if(r-1 >= 0) // check top neighbor (if exists + unvisited)
        {
          MazeCell neighborCell = mazecells.get(r-1).get(c);
          
          if(mazecells.get(r-1).get(c).visited) {
            randFrontier.neighbors.add(neighborCell);
            neighborCell.neighbors.add(randFrontier);
            neighborCell.bottom = null;
            needsNeighbor = false;
          } else {
            frontier.add(neighborCell);
          }
        }      
        if(c-1 >= 0) // add left neighbot (if exists + unvisited)
        {
          MazeCell neighborCell = mazecells.get(r).get(c-1);
          
          if(needsNeighbor && neighborCell.visited) {
            randFrontier.neighbors.add(neighborCell);
            neighborCell.neighbors.add(randFrontier);
            neighborCell.right = null;
            needsNeighbor = false;
          } else {
            frontier.add(neighborCell);
          }
        }
        if(c+1 < cols) // add right neighbor (if exists + unvisited)
        {
          MazeCell neighborCell = mazecells.get(r).get(c+1);
          
          if(needsNeighbor && neighborCell.visited) {
            randFrontier.neighbors.add(neighborCell);
            neighborCell.neighbors.add(randFrontier);
            randFrontier.right = null;
            needsNeighbor = false;
          } else {
            frontier.add(neighborCell);
          }
        }
        if(r+1 < rows) // add bottom neighbor (if exists + unvisited)
        {
          MazeCell neighborCell = mazecells.get(r+1).get(c);
          
          if(needsNeighbor && neighborCell.visited) {
            randFrontier.neighbors.add(neighborCell);
            neighborCell.neighbors.add(randFrontier);
            randFrontier.bottom = null;
            needsNeighbor = false;
          } else {
            frontier.add(neighborCell);
          }
        }
        
        // 7. Add random node to tree
        randFrontier.visited = true;
        done.add(randFrontier);
      }
      frontier.remove(frontierNo);
    }
   }
   
   void update(float dt)
   {
      draw();
   }
   
   void draw()
   {
      stroke(255);
      strokeWeight(3);
      // draw maze walls
      for (Wall w : walls)
      {
         w.draw();
      }
      
      // draw borders of canvas
      if(mazecells != null) {
        line(0,0,0,GRID_SIZE*mazecells.get(0).size()); //top
        line(0,GRID_SIZE*mazecells.get(0).size(),GRID_SIZE*mazecells.size(),GRID_SIZE*mazecells.get(0).size()); //right
        line(GRID_SIZE*mazecells.size(),0,GRID_SIZE*mazecells.size(),GRID_SIZE*mazecells.get(0).size()); //bpttom
        line(0,0,GRID_SIZE*mazecells.size(),0); //left
      }
      
      /*for(MazeCell m : frontier) {
        m.draw();
      }*/
      
      stroke(255, 150, 150);
      for(MazeCell m : done) {
        // draw walls
        if(m.bottom != null){
          walls.add(m.bottom);
        }
        if(m.right != null){
          walls.add(m.right);
        }
        
        // draw tree
        for(MazeCell n : m.neighbors) {
          line(m.center.x, m.center.y, n.center.x, n.center.y);
        }
      }
   }
}

class MazeCell
{
  boolean visited = false;
  ArrayList<MazeCell> neighbors = new ArrayList<MazeCell>();
  int row;
  int col;
  Wall bottom;
  Wall right;
  PVector center;
  
  MazeCell() {   
  }
  
  MazeCell(int row, int col, PVector center, int size) {
    this.row = row;
    this.col = col;
    this.center = center; 
    right =  new Wall(new PVector(size*(row+1), size*col),     new PVector(size*(row+1), size*(col+1))); // WALL2
    bottom = new Wall(new PVector(size*(row+1), size*(col+1)), new PVector(size*row, size*(col+1)));     // WALL3
  }
  
  // idk
  void draw() {
    stroke(23, 255, 23);
    circle(center.x, center.y, 5);
  }
}
