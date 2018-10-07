
import processing.serial.*;

import cc.arduino.*;

import processing.serial.*;
 

Arduino arduino;

PImage img;

//Tree Variables
float growthSpeed = 6;
int maxTrees = 40;

//Class Arrays
Tree[] motherTree;
float clickCounter=0;
int treeCounter=0;
int treeSpawn=0;      // decides in which position in the array a tree gets saved, cyclically overwriting another
Tree a;

//Growth Variables
float numofSun = 0;
int timesUpdated = 0;

//Solar Arrays
int count = 0;
float[] sunxp;
float[] sunyp;
float[] sun_size;
int[] sunactive;

//root variables
pathfinder[] paths;
int num;
static int count1;


void setup() {
  size(1600, 920);
  background(0, 191, 255); //initializes background
  noStroke();
  fill(255);
  smooth();
  motherTree = new Tree[maxTrees];  // sets up the Arrays to handle the objects.

  sunxp = new float[count];    //Sun x-location array
  sunyp = new float[count];    //Sun y-location array
  sun_size = new float[count]; //Sun size array 
  sunactive = new int[count];  //Array determining whether the sun is active or not

   println(Arduino.list());
   arduino = new Arduino(this, Arduino.list()[0], 57600);
   arduino.pinMode(13, Arduino.INPUT);

   a = new Tree(10, 800, height - 198, -HALF_PI, 20);
   
   img = loadImage("can.png");
   
  noStroke();
  float fill_arc = 0;  //Hill Design
  for (float arc_y = 1220; arc_y < 1400; arc_y = arc_y + 12) {                //Sets up consecutive arcs
    fill((fill_arc * 0.75) + 105, (fill_arc * 0.9) + 139, fill_arc + 34);
    arc(800, arc_y, 2200, 1000, PI, TWO_PI);
    fill_arc = fill_arc - 12;
  }

   
   ellipseMode(CENTER);
  stroke(200, 0, 0, 200);
  smooth();
  num = 2;
  count1 = 0;
  paths = new pathfinder[num];
  for(int i = 0; i < num; i++) paths[i] = new pathfinder();
}
int onn = 0;  //state of light
void draw() 
{  
  if((arduino.analogRead(0)+arduino.analogRead(1))/2 > 512)
  {

    if(onn==0){
      lightOn();
    }
    onn = 1;
    println("onn");   
    
  }
  else if((arduino.analogRead(0)+arduino.analogRead(1))/2 < 512 && onn == 1)
  {
    
    onn = 0;
    
    lightOff();    
  }
 if (onn==1) {
   
    sun_size[count-1]++;
   
    
  }
  noStroke();
  for (int i=0; i<count; i++) {
    fade(i);
    drawSun(i);
    if (sun_size[i] > 1) {
      numofSun = numofSun + 0.01;
     // println(numofSun);
    }
  }
  stroke(105, 139, 34);              //resets stroke and fill properties
  fill(105, 139, 34);
  strokeWeight(1);
  println(arduino.analogRead(2));
  

  
  if (timesUpdated < numofSun && (frameCount%30)==0 ) {
    a.update();
    timesUpdated++;
  }
  if (numofSun > 10)
  {
    if (numofSun < 55 && (arduino.analogRead(0)+arduino.analogRead(1))/2 > 512) {
      a.growLeaf();
    }
  }

  if (numofSun > 50) {
    if (numofSun < 80 && (arduino.analogRead(0)+arduino.analogRead(1))/2 > 512) {
      a.growFlower();
    }
  }

    for (int i = 0; i < paths.length; i++) {
    PVector loc = paths[i].location;
    PVector lastLoc = paths[i].lastLocation;
    strokeWeight(paths[i].diameter);
    stroke(102,51,0);
    line(lastLoc.x, lastLoc.y, loc.x, loc.y);
    if(arduino.analogRead(2)>50 ){
      image(img, 1000, 500, 200, 200);
      if (frameCount%20==0){
              paths[i].update();
              
      }
    }
    else{
      fill(0, 191, 255);
      noStroke();
      rect(1000, 500, 200, 200);
     
    }
  }


}

void fade(int ind) {
     if (sunactive[ind] == 1 && sun_size[ind] > 0) {
    sun_size[ind] -= 1;
  }

}


void lightOn()
{
  sunxp = expand(sunxp, count + 1);
  sunyp = expand(sunyp, count + 1);
  sun_size = expand(sun_size, count + 1);
  sunactive = expand(sunactive, count + 1);
  sunxp[count] = 0.782*(arduino.analogRead(1)-arduino.analogRead(0)-1163)+1600;
  sunyp[count] = 100;
  sun_size[count] = 0;
  sunactive[count] = 0;
  count ++;
  println("pressedPressed");
}


void lightOff()
{
  if (sunactive[count-1] == 0) {
    sunactive[count-1] = 1;
  }
  println("releasedReleased");
}


void drawSun(int ind)
{
  float sun_r = sun_size[ind]/1.2;
  float alph = 10 + sun_size[ind]/10;
  fill(0, 191, 255);
  ellipse(sunxp[ind], sunyp[ind], sun_r * 2, sun_r * 2);
  for (float r = sun_r; r > 0; r = r - 10) {
    fill(255, 236, 160, alph);
    ellipse(sunxp[ind], sunyp[ind], r * 2, r * 2);
  }
  fill(255, 255, 251, 230);
  ellipse(sunxp[ind], sunyp[ind], sun_r * 0.5, sun_r * 0.5);
  noFill();
  stroke(0, 191, 255);
  ellipse(sunxp[ind], sunyp[ind], (sun_r * 2 + 1), (sun_r * 2 + 1));
  noStroke();
}



