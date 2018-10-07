class Tree  // this class controls an Array of Branches and is responsible for the actual branching and length of all branches and the main stems.
{
  Branch[] branches;
  float age;
  int branchNumber = 1;
  float straightness = 1;
  float splitChance = 0;
  float D = 1;
  int fade = 0;
  int maxBranches = 1;
  int treeHeight = 1;


  Tree(int nmaxBranches, float x, float y, float direction, float nsplitChance)
  {
    maxBranches = nmaxBranches;
    branches = new Branch[nmaxBranches];
    treeHeight = int((maxBranches-branchNumber)*0.0618*height/8*random(0.5, 1));  //sets the length of the main stem based on an archaid formula, this comes solely from experimentation/trial&error
    branches[0] = new Branch(treeHeight, x, y, direction+random(-0.2, 0.2),8); // this spawns the main branch
    branchNumber++;
    splitChance = nsplitChance*4; //the 4 was also added arbitrarily
  }


  void spawnBranch(float x, float y, float direction, float branchLength) // this method spawns all branches aside from the main branch and is called from the method updated
  {
    if (branchNumber<=maxBranches)
    {
      int newBranchLength = int((10-branchNumber)*0.0618*height/8*random(0.5, 1));
      branches[branchNumber-1] = new Branch(newBranchLength, x, y, direction, 4*newBranchLength/treeHeight);
      branchNumber++;
    }
  }


  void update()
  {

    for (int i=0; i<branchNumber-1; i++)
    {
      float sunDrive = 0;  //these loops check the direction of all branches and change the sunDrive variable which then is used as a modifier to give the branches a tendency to bend towards a sun.
      if (branches[i].dir > -HALF_PI && branches[i].dir <= 0)
      {
        sunDrive = -0.013*(branches[i].dir+HALF_PI); //makes the branches curve upward
      }
      else if (branches[i].dir > 0 && branches[i].dir <= HALF_PI)
      {
        sunDrive = -0.013*(branches[i].dir+HALF_PI); //makes the branches curve upward
      }
      else if ((branches[i].dir <= -HALF_PI && branches[i].dir >= -PI))
      {
        sunDrive = 0.013*(-branches[i].dir+PI); //makes the branches curve upward
      }
      else if (branches[i].dir <= -PI && branches[i].dir >= HALF_PI)
      {
        sunDrive = 0.013*(-branches[i].dir+PI); //makes the branches curve upward
      }     

      branches[i].grow((branches[i].dir+ sunDrive) *(straightness*(1+random(-.12, .12))), 5*growthSpeed/(1+(age))); //THIS IS THE ACTUAL COMPUTATION OF THE NEXT BRANCH POINT. 
      branches[i].drawBranch(); //this draws the branch after its next iteration has been computed.
      age=age+0.5/frameRate;
    }
    if (random(0, 1)<(splitChance*.001) && branches[0].count>5 && branchNumber < maxBranches) // THIS HANDLES THE SPAWNING OF NEW BRANCHES
    {
      int origin = int(random(0, branchNumber-1)); // randomly selects an existing branch to branch off of.
      float direction = random(0.45, 0.55);        // sets the deviation from former direction
      D = branches[0].returnMaxPoints() - branches[origin].returnCount(); // sets the base thickness of the new branch

      if (random(-1, 1) > 0) // 1 in 2 chance to grow either left or right
      {
        this.spawnBranch( branches[origin].returnLatestX(), branches[origin].returnLatestY(), branches[origin].returnLatestDir()+direction*(-1), D);
        branches[origin].setDir(branches[origin].returnLatestDir()-0.8*direction);
      }

      else 
      {
        this.spawnBranch( branches[origin].returnLatestX(), branches[origin].returnLatestY(), branches[origin].returnLatestDir()+direction, D);
        branches[origin].setDir(branches[origin].returnLatestDir()-1.8*direction);
      }
    }
    else //if no branch has spawned, increases the chance that one will spawn in the next iteration
    {
      splitChance=splitChance*1.1;
    }
  }


  void growLeaf() {
    fill(105, 139, 34);
    for (int i=0; i < branchNumber-1; i++)
    {
      float q = random(70);
      if (random(-2, 1) > 0)
      {
        arc(branches[i].returnLatestX() + (random(-q, q)), branches[i].returnLatestY() + (random(-q, q)), 10, 10, random(TWO_PI)/2.5, random(TWO_PI)/2.5);
        i = i + 1;
      }
    }
  }

  void growFlower() {
    noStroke();
    for (int i=1; i < branchNumber-1; i++)
    {
      fill(255, 153, 18, 3);
      ellipse(branches[i].returnLatestX() + (branches[i].returnLatestX())/35, branches[i].returnLatestY(), 20, 8);
      ellipse(branches[i].returnLatestX() - (branches[i].returnLatestX())/35, branches[i].returnLatestY(), 20, 8);
      ellipse(branches[i].returnLatestX(), branches[i].returnLatestY() + (branches[i].returnLatestY())/50, 8, 20);
      ellipse(branches[i].returnLatestX(), branches[i].returnLatestY() - (branches[i].returnLatestY())/50, 8, 20);

      fill(255, 236, 139, 5);
      ellipse(branches[i].returnLatestX(), branches[i].returnLatestY(), 10, 10);

      fill(255, 127, 36, 3);
      ellipse(branches[i].returnLatestX() + random((branches[i].returnLatestX())/35), branches[i].returnLatestY() + random((branches[i].returnLatestY())/50), 5, 5);
      ellipse(branches[i].returnLatestX() - random((branches[i].returnLatestX())/35), branches[i].returnLatestY() - random((branches[i].returnLatestY())/50), 5, 5);
    }
  }
}

