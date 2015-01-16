import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import gifAnimation.*;

int score = 0;
float bgSpeed=8;
float z=1;
PImage bgImg; 
boolean isMouseClicked = false;
PImage backgroundImage;
PImage explosionImage;
Gif pepsiGif;
Gif cokeGif;
Capture video;
OpenCV opencv;

int[] pepsix = { getRandomX(), getRandomX(), getRandomX(), getRandomX(), getRandomX() };
int[] pepsiy = { 0, 0, 0, 0, 0 };

int getRandomX()
{
    return int(random(0,600));
}
    
void setup()
{
    //Size
    size (600, 800);
    frameRate(120);
    
    video = new Capture(this, 640, height);
    opencv = new OpenCV(this, 640, height);
    
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
     //opencv.loadCascade("cascade-cowabunga-16-20.xml"); 
    
    video.start();
    smooth ();
    backgroundImage= loadImage("background.jpg");
    
    explosionImage = loadImage("explosion.png");
    explosionImage.resize(45,45);
    
    pepsiGif = new Gif(this, "pepsi.gif");
    pepsiGif.loop();
    
    cokeGif = new Gif(this, "coke.gif");
    cokeGif.loop();
    
}
   
void draw()
{      
    //Game Style
    clear();
    println("Start"+pepsiGif); 
    
    //Code to shift background
    z+=bgSpeed;//a+=b equals a=a+b;
    z%=2950;
    image(backgroundImage, 0, int(z)-2950);

    opencv.loadImage(video);
    //image(video,0,0);
    
    //Start Pepsi Falling animation on different thread
    thread("pepsiFalling");

    stroke(0, 255, 0);
    strokeWeight(3);
    
    //println("Detect falling 1  " + millis());

    Rectangle[] faces = opencv.detect();
    println(faces.length);

    for (int i = 0; i < faces.length; i++) 
    {
      println("xyz  "+ faces[i].x + "," + faces[i].y + ","+faces[i].width+","+faces[i].height);
    
      //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      
// Uncomment to use mouse
//Shoot. Check if mouse is clicked

//      if(isMouseClicked)
//      {
//        image(img, mouseX - 75, 300);
//        println("Calling cannon");
//        cannon(mouseX, mouseY);
//        isMouseClicked = false; 
//      }
      
      //else
      {
        image(cokeGif, faces[i].x, faces[i].y);
        cannon(faces[i].x + (faces[i].width/2), faces[i].y);
      }
      
    }     

    // Display score
    textSize(32);
    fill(0,255,0);
    text("SCORE:"+score, 32,32);
    
    //Check whether game has finished 
    gameFinish();    

  }
  
  void pepsiFalling()
  { 
    stroke(39, 154, 240);
    fill (39, 154, 240);
    
    for (int i=0; i<5; i++)
    {   
      image(pepsiGif, pepsix[i], pepsiy[i]);
      pepsiy[i] = pepsiy[i]+20;

      //ellipse(pepsix[i], pepsiy[i]++, pepsiSize, pepsiSize);
    }
  }
   
  void cannon(int shotX, int shotY)
  {
    boolean strike = false;
    for (int i = 0; i < 5; i++)
    {
      if((shotX >= (pepsix[i]-(pepsiGif.width/2))) && (shotX <= (pepsix[i] + pepsiGif.width/2))) 
      {
        strike = true;
        line(shotX, shotY, shotX, pepsiy[i]);
        image(explosionImage, pepsix[i],pepsiy[i]);
        //ellipse(pepsix[i], pepsiy[i],pepsiSize+25, pepsiSize+25);
        pepsix[i] = getRandomX();
        pepsiy[i] = 0;
        score++;
      }   
    }
  }
   
void captureEvent(Capture c) 
{
  c.read();
}

//GameOver
   
void gameFinish()
{
    for (int i=0; i<5; i++)
    {
      if(pepsiy[i]==height)
      {
          //fill(color(0,255,0));
          fill(0, 255, 0);
          textSize(32);
          textAlign(CENTER);
          text("GAME OVER", width/2, height/2);
          text("Well done! Your score is: "+ score, width/2, height/2 + 50);     
          noLoop();
       }
    }
}

//Detect Mouse Click
void mousePressed()
{
  println("Mouse Clicked");
  isMouseClicked = true;
}
