class BranchPoint // these are the points in space used to calculate the trees
{
  float pX;
  float pY;
  float age;
  boolean done = false;
  float thickness;

  BranchPoint(float X, float Y)
  {
    pX=X;
    pY=Y;
    age=0;
  }

  float returnX() {
    return pX;
  }

  float returnY() {
    return pY;
  }

  void beDone() {
    done = true;
  }

  void age() { // if the branch hasn't been told to stop, this will age the points, thereby they will grow thicker over time.
    if (done == false)
    {
      age = age+2/frameRate;
    }
  }

  void setThickness(float newThickness) {
    thickness = newThickness;
  }
}

