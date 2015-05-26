import ddf.minim.*;
import SimpleOpenNI.*;

SimpleOpenNI  kinect;
boolean       autoCalib=true;
Minim minim;
AudioPlayer player[];
float volume;
boolean beenNext, beenPrev, beenMiddle; 
int i = 0;
PImage albums[];
PImage volmenos,volmas,pausa,play,previous,next;

void setup()
{
  kinect = new SimpleOpenNI(this);  minim = new Minim(this);
  kinect.setMirror(true);           volume = -13.0;
  player = new AudioPlayer[6];      albums = new PImage[6];
  
  beenNext  = false; beenMiddle = false; beenPrev = false; 
  
  player[0] = minim.loadFile("cuba.mp3");
  player[1] = minim.loadFile("getlow.mp3");
  player[2] = minim.loadFile("leanon.mp3");
  player[3] = minim.loadFile("surrender.mp3");
  player[4] = minim.loadFile("turndownforwhat.mp3");
  player[5] = minim.loadFile("uptownfunk.mp3");
  
  albums[0] = loadImage("cuba.png");
  albums[1] = loadImage("getlow.png");
  albums[2] = loadImage("leanon.png");
  albums[3] = loadImage("surrender.png");
  albums[4] = loadImage("turndownforwhat.png");
  albums[5] = loadImage("uptownfunk.png");
  
  volmenos = loadImage("volmenos.png");
  volmas = loadImage("volmas.png");
  play = loadImage("play.png");
  pausa = loadImage("pausa.png");
  previous = loadImage("previous.png");
  next = loadImage("next.png");
  
  volmenos.resize(100,100);  previous.resize(100,100);
  volmas.resize(100,100);  next.resize(100,100);
  play.resize(100,100);
  
  if(kinect.enableDepth() == false)
  {
     println("No se puede abrir mapa de profundidad"); 
     exit();
     return;
  }
  if(kinect.enableRGB() == false)
  {
     println("No se puede abrir imagen RGB"); 
     exit();
     return;
  }
  kinect.enableUser();
  
  background(255);
  //size(kinect.rgbWidth(), kinect.rgbHeight());
  size(kinect.rgbWidth(), kinect.rgbHeight());
}

void draw()
{
  kinect.update();
  background(0);
  
  image(kinect.userImage(),0,0);
  //kinect.setDepthImageColor(100, 150, 200);
  //image(kinect.depthImage(),0,0);
  
  image(albums[albumPosition(i-1)],0,0,kinect.rgbWidth()/3,kinect.rgbHeight()/6);
  image(albums[albumPosition(i)],kinect.rgbWidth()/3,0,kinect.rgbWidth()/3,kinect.rgbHeight()/6);
  image(albums[albumPosition(i+1)],2*(kinect.rgbWidth()/3),0,kinect.rgbWidth()/3,kinect.rgbHeight()/6);
  
  int[] userList = kinect.getUsers();
  for(int j=0;j<userList.length;j++)
  {
    
    if(kinect.isTrackingSkeleton(userList[j]))
    {
      drawSkeleton(userList[j]);      
    }
  }
  player[i].setGain(volume);
}

void nextSong()
{
  player[i].pause();
  player[i].rewind();
  ++i;
  if (i == player.length) //Player.length
    i=0;
  player[i].play();
}

void lastSong()
{
  player[i].pause();
  player[i].rewind();
  --i;
    if (i == -1) 
 {
     i = (player.length) - 1;  //Player.length -1
     player[i].play();
 }
}
void PlayPause()
{
  if(player[i].isPlaying()) 
    {
      player[i].pause();
    }
    else
    {
      player[i].play();
    }
}

void volumeUp()
{
  if (volume < -13)
  {
    volume = volume + 1;
  }
}

void volumeDown()
{
  if (volume > -80)
  {
    volume = volume - 1;
  }
}

void onNewUser(SimpleOpenNI asus, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  asus.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI asus, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI asus, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

void drawSkeleton(int userId)
{
  PVector coordLeftShoulder = new PVector();  PVector coordLeftHand = new PVector();
  PVector coordLeftHip = new PVector();       PVector coordRightShoulder = new PVector();
  PVector coordRightHand = new PVector();     PVector coordRightHip = new PVector();
  PVector coordRightFoot = new PVector();     PVector coordLeftFoot = new PVector();
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, coordLeftShoulder);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, coordLeftHand);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, coordLeftHip); 
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, coordRightShoulder);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, coordRightHand);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, coordRightHip);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, coordRightFoot);
  kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, coordLeftFoot);
  
  kinect.convertRealWorldToProjective(coordLeftShoulder, coordLeftShoulder);
  kinect.convertRealWorldToProjective(coordLeftHand, coordLeftHand);
  kinect.convertRealWorldToProjective(coordLeftHip, coordLeftHip);
  kinect.convertRealWorldToProjective(coordRightShoulder, coordRightShoulder);
  kinect.convertRealWorldToProjective(coordRightHand, coordRightHand);
  kinect.convertRealWorldToProjective(coordRightHip, coordRightHip);
  kinect.convertRealWorldToProjective(coordLeftFoot, coordLeftFoot);
  kinect.convertRealWorldToProjective(coordRightFoot, coordRightFoot);
 
  //Resize button 
  if (userId == 1)
  {
  image(next,coordRightShoulder.x +100,coordRightShoulder.y - 100);
  image(previous,coordLeftShoulder.x - 200,coordLeftShoulder.y - 100);
  image(volmas,coordRightHip.x + 100, coordRightHip.y + 50);
  image(volmenos,coordLeftHip.x - 200, coordLeftHip.y + 50);
  
  if(  coordRightFoot.x > coordRightHip.x + 80             
    && coordRightFoot.y > coordRightHip.y + 50)         
  { volumeUp(); }
  else if( coordLeftFoot.x < coordLeftHip.x -80             
    && coordLeftFoot.y > coordLeftHip.y + 50)          
    //&& coordLeftFoot.y < coordLeftHip.y + 150)
    { volumeDown();}
  
  if(coordRightHand.x > coordRightShoulder.x + 100             // I = hombro.x
    && coordRightHand.y > coordRightShoulder.y - 100           // - = hombro.y
    && coordRightHand.y < coordRightShoulder.y                // - = cadera.y
    && beenNext == false)
  { 
    beenNext = true;
    nextSong();
  }
  else if (coordRightHand.x < coordRightShoulder.x + 100 || 
           coordRightHand.y < coordRightShoulder.y -100 || 
           coordRightHand.y > coordRightShoulder.y )
           {beenNext = false;}  
          
   if(coordLeftHand.x < coordLeftShoulder.x-100              // I = hombro.x
    && coordLeftHand.y > coordLeftShoulder.y - 100           // - = hombro.y
    && coordLeftHand.y < coordLeftShoulder.y                // - = cadera.y
    && beenPrev == false)
  { 
    beenPrev = true;
    lastSong();
  }
  else if (coordLeftHand.x > coordLeftShoulder.x-100 || 
           coordLeftHand.y < coordLeftShoulder.y - 100 || 
           coordLeftHand.y > coordLeftShoulder.y )
           {beenPrev = false;}  
            
  if (coordRightHand.x > kinect.rgbWidth()/3 && 
      coordRightHand.x < 2*(kinect.rgbWidth()/3) && 
      coordRightHand.y < kinect.rgbHeight()/6 && 
      beenMiddle == false)   
  {
    beenMiddle = true;
    PlayPause();
  }
  else if(coordRightHand.x < kinect.rgbWidth()/3 || coordRightHand.x > 2*(kinect.rgbWidth()/3) || 
      coordRightHand.y > kinect.rgbHeight()/6)
  {beenMiddle = false;}
  }
} 

int albumPosition(int index)
{
      if(index == albums.length) //albums.length;
      {
        return 0; //index - albums.length
      }
      else if(index == -1)
      {  
        int ind = albums.length -1;
        return ind;
      }
      else
      {return index;}
}


