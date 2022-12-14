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
      //walls.add(new Wall(new PVector(size*curCel.row, size*curCel.col),         new PVector(size*(curCel.row+1), size*curCel.col)));     // WALL1
      //walls.add(new Wall(new PVector(size*(curCel.row+1), size*curCel.col),     new PVector(size*(curCel.row+1), size*(curCel.col+1)))); // WALL2
      //walls.add(new Wall(new PVector(size*(curCel.row+1), size*(curCel.col+1)), new PVector(size*curCel.row, size*(curCel.col+1))));     // WALL3
      //walls.add(new Wall(new PVector(size*curCel.row, size*(curCel.col+1)),     new PVector(size*curCel.row, size*curCel.col)));         // WALL4
      
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
            MazeCell newCel = neighborCell;
            frontier.add(newCel);
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
            MazeCell newCel = neighborCell;
            frontier.add(newCel);
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
            MazeCell newCel = neighborCell;
            frontier.add(newCel);
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
            MazeCell newCel = neighborCell;
            frontier.add(newCel);
          }
        }
        
        // 7. Add random node to tree
        randFrontier.visited = true;
        done.add(randFrontier);
      }
      frontier.remove(frontierNo);
    }
      for(int i = 0; i < rows; i++) {
        for(int j = 1; j < cols; j++){
          //mazecells.get(i).get(j).neighbors.size();
          r = mazecells.get(i).get(j).row;
          c = mazecells.get(i).get(j).col;
          int nrow = mazecells.get(i).get(j).neighbors.get(0).row;
          int ncol = mazecells.get(i).get(j).neighbors.get(0).col;
          
          /*if(ncol - c == -1 && nrow - r == 0){
            walls.add(new Wall(new PVector(size*(r+1), size*c),     new PVector(size*(r+1), size*(c+1)))); // WALL2
            walls.add(new Wall(new PVector(size*(r+1), size*(c+1)), new PVector(size*r, size*(c+1))));     // WALL3
          }
          else if(ncol - c == 0 && nrow - r == 1){
            //walls.add(new Wall(new PVector(size*(r+1), size*c),     new PVector(size*(r+1), size*(c+1)))); // WALL2
          }
          else if(ncol - c == 1){
            //walls.add(new Wall(new PVector(size*(r+1), size*(c+1)), new PVector(size*r, size*(c+1))));     // WALL3
          }
          else{
            //walls.add(new Wall(new PVector(size*(r+1), size*c),     new PVector(size*(r+1), size*(c+1)))); // WALL2
            //walls.add(new Wall(new PVector(size*(r+1), size*(c+1)), new PVector(size*r, size*(c+1))));     // WALL3
          }*/
          
        }      
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
      for (Wall w : walls)
      {
         w.draw();
      }
      if(mazecells != null) {
        line(0,0,0,GRID_SIZE*mazecells.get(0).size()); //top
        line(0,GRID_SIZE*mazecells.get(0).size(),GRID_SIZE*mazecells.size(),GRID_SIZE*mazecells.get(0).size()); //right
        line(GRID_SIZE*mazecells.size(),0,GRID_SIZE*mazecells.size(),GRID_SIZE*mazecells.get(0).size()); //bpttom
        line(0,0,GRID_SIZE*mazecells.size(),0); //left
      }
      
      /*for(ArrayList<MazeCell> r : mazecells) {
        for(MazeCell c : r) {
          c.draw();
        }
      }*/
      
      for(MazeCell m : frontier) {
        m.draw();
      }
      
      stroke(255, 150, 150);
      for(MazeCell m : done) {
        if(m.bottom != null){
          walls.add(m.bottom);
        }
        if(m.right != null){
          walls.add(m.right);
        }
        for(MazeCell n : m.neighbors) {
          line(m.center.x, m.center.y, n.center.x, n.center.y);
          //println("i");
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
  Wall left;
  Wall top;
  PVector center;
  
  MazeCell() {   
  }
  
  MazeCell(int row, int col, PVector center, int size) {
    this.row = row;
    this.col = col;
    this.center = center; 
    right = new Wall(new PVector(size*(row+1), size*col),     new PVector(size*(row+1), size*(col+1))); // WALL2
    bottom = new Wall(new PVector(size*(row+1), size*(col+1)), new PVector(size*row, size*(col+1)));     // WALL3
    left = new Wall(new PVector(size*row, size*(col+1)),     new PVector(size*row, size*col));         // WALL4
    top = new Wall(new PVector(size*row, size*col),         new PVector(size*(row+1), size*col));     // WALL1


  }
  
  // idk
  void draw() {
    stroke(23, 255, 23);
    circle(center.x, center.y, 5);
  }
}
