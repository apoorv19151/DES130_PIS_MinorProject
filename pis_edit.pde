
/*This is jumping jack PREFINAL version*/

import processing.sound.*;  //THIS IS TO IMPORT THE  SOUND LIBRARY FOR PONG SOUND 

import processing.serial.*;  

Serial myPort;   //THIS IS TO IMPORT THE PORT TO WHICH WE ARE CONNECTING THE ARDUINO

String myText="";
String myText1=""; //THIS IS TO TAKE INPUT FOR ULTRA SONIC SENSOR
String myText2="";  //THIS IS TO TAKE INPUT FOR THE SECOND ULTRA SONIC SENSOR
String myText3=""; //THIS IS TO TAKE INPUT FOR ULTRA SONIC SENSOR
String myText4=""; 

SoundFile file;  //THIS IS CREATION OF A FILE WHICH WOULD HELP US TO USE THE PING PONG mp3 SOUND

int startTimeMs;//THIS IS THE VARIABLE FOR INITIAL SEQUENCING  OF TIME THAT IS FROM 5 TO 1 SECONDS

final int startDelayMs = 5000;  // The time until the game starts, in milliseconds

boolean atStartup = true;

int begin; //NEXT THREE VARIBLES ARE FOR THE TIME SEQUENCE UPTO WHICH THE PLAYERS ARE GOING TO PLAY THAT IS FOR 30 SECONDS
int duration =100;
int time = 30;

Drop[] drops = new Drop[500]; //THIS STATEMENT CREATES THE LINE LIKE DROPS WHICH IS JUST THE STROKE OF LINE THUS ANIMATES THE FALLING OF GRAY DROPS 

int n1, n2, n3, n4;

int gameWidth = 500; /*NEXT TWO STATMENTSTELLS ABOUT DIMENSIONS OF THE SCREEN THAT IS LENGTH AND BREADTH RESP.*/
int gameHeight = 400;

int xA = 125;//NEXT TWO STATEMENTS  ARE FOR INITIAL X AND  Y COORDINATE OF THE BALL ON LEFT HAND SIDE THAT IS FOR PLAYER A
int yA = 100;
int xB = 375;//NEXT TWO STATEMENTS  ARE FOR INITIAL X AND  Y COORDINATE OF THE BALL ON RIGHT HAND SIDE THAT IS FOR PLAYER B 
int yB = 100;

int  x_paddle = 250; // VARIABLES TO KEEP TRACK OF PADDLE MOVEMENT X_PADDLE IS THE X COORDINATE OF PADDLE AND THE Y_PADDLE IS THE Y COORDINATE OF PADDLE 
int  y_paddle = 389;
int paddle_width_half = 40;//THIS IS THE PADDLE WIDTH THAT IS THE LENGTH OF THE PADDLE 

int y_speedB = 4;//THIS IS THE SPEED OF BALLB IN Y DIRECTION
int y_speedA = 4;//THIS IS THE SPEED OF BALLA IN Y DIRECTION

int speed = 3; //THIS IS THE SPEED OF THE PADDLE 

int scoreA = 0;// THIS IS THE SCORE OF THE PLAYER A THAT IS THE PLAYER  ON THE LEFT OF SCREEN 
int scoreB = 0;// THIS IS THE SCORE OF THE PLAYER B THAT IS THE PLAYER ON THE RIGHT OF SCREEN 

void setup()
{
  startTimeMs = millis();//THIS IS FOR THE INITIAL SEQUENCE OF TIME THAT IS FOR THE SEQUENCE FROM 5 TO 0  // millis() Returns the number of milliseconds since starting the program.

  size(500, 400); // THESE ARE THE DIIMENSIONS OF SCREEN
  rectMode(CENTER); // draws the image from its center point

  frameRate(60);// THIS HELPS TO CONTOL THE FRAME RATE THAT IS THE RATE AT WHICH THE FRAME OR DRDAW FUNCITON IS EXECUTED (60 times a second)

  file = new SoundFile(this, "pong.mp3");// THIS IS THE MP3 SOUND FILE WHICH IS FOR THE PING PONG SOUND
  begin = millis();//THIS IS FOR  30 SECOND TIMER 

  for (int i = 0; i < drops.length; i++)   //LOOP FOR CREATING DROPS 
  {
    drops[i] = new Drop();
  }

  myPort=new Serial(this, "COM3", 9600); // SIGNIFIES THAT TO WHICH PORT OUR ARDUINO IS CONNECTED TO 
  myPort.bufferUntil('\n');

  delay(1000);
}

void serialEvent(Serial myPort)
{
  myText=myPort.readStringUntil('\n');

  String[] list=split(myText, '-');
  n1 = Integer.parseInt(list[0].trim());
  n2 = Integer.parseInt(list[1].trim());
  n3 = Integer.parseInt(list[2].trim());
  n4 = Integer.parseInt(list[3].trim());
  println(n1, "-", n2, "-", n3, "-", n4);
}

void draw()
{

  if (atStartup) // If we're in the startup time window, show a countdown
  {
    int curTimeMs = millis();// The current time, in milliseconds
    int startupTimeRemainingMs = startDelayMs - (curTimeMs - startTimeMs);// The remaining time in the startup period
    startScreen(startupTimeRemainingMs);
    atStartup = startupTimeRemainingMs > 0; // Short-circuit if we're still in the startup phase.
    return;
  }

  background(240);// SETS THE BACKGROUND COLOR 
  fill(0);//FILL THE BLACK COLOR 

  textAlign(CENTER, CENTER);//ALIGN THE TEXT TO CENTRE 

  text("GO!", gameWidth/2, gameHeight/2);                  /////////////AMBIGUITY////////////

  yB = yB + y_speedB;//THIS IS TO MAKE THE BALL B MOVE IN VERTICAL DIRECTION(going down) 
  yA = yA + y_speedA;//THIS IS TO MAKE THE BALL A MOVE IN VERTICAL DIRECTION 

  if (yB<=0)  /*THE NEXT TWO STAEMENT REVERSES THE DIRECTION OF BALL MOVEMENT AS  IT GOES BEYOND THE X=0THAT IS THE UPPER PART OF SCREEN*/
  {
    yB=0;
    y_speedB = -y_speedB;
  }

  if (yA<=0)
  {
    yA=0;
    y_speedA = -y_speedA;
  }


  //THESE ARE THE STATEMENT WHICH ALONG WITH THE TOUCH SENSOR MAKES THE BALL TO LIFT UP 

  if ( n1<8 && n1>0 && yB>0 && yB<=400)//CODITION TO CHECK LENGTH OF STRING AND CHECKING IF THE BALL B HAS NOT GONE BEYOND THE SCREEN 
  {
    yB=yB-7;//MAKES THE BALL B TO DECREASE ITS Y COORDINATE AT WHTEVER POSITION IT IS
  }


  if ( n2<8 && n2>0 && yA>0 && yA<=400)
  {
    yA=yA-7;//LIFTING THE BALL A UP IN VERTICAL DIRECTION
  }
  if ( n3==1 && yB>0 &&yB<=400)
  { 
    yB=10;
  }
  if ( n4==1 && yA>0 &&yA<=400)
  { 
    yA=10;
  }
  // Check if paddle is at edge of screen 
  if (x_paddle>width)
    x_paddle = width;

  if (x_paddle<0)
    x_paddle = 0;

  // CHECKING THE COLLISION OF BALL B WITH THE PADDLE 
  if ((x_paddle - paddle_width_half)<xB && (x_paddle + paddle_width_half)>xB && (y_paddle-10)<=yB && (y_paddle)>=yB) 
  { 
    file.play();//WHEN THE BALL HITS THE PADDLE ITS MAKES THE PONG SOUND

    y_speedB = -y_speedB;//REVERSES THE DIRECTION OF BALL B WHEN IT HITS THE PADDLE

    scoreB = scoreB + 1;//WHEN THE BALLB HITS THE PADDLE INCREMENT THE SCORE BY 1
  }

  if ((x_paddle-paddle_width_half)<xA && (x_paddle+paddle_width_half)>xA && (y_paddle-10)<=yA && (y_paddle)>=yA)
  {
    file.play();//WHEN THE BALL HITS THE PADDLE ITS MAKES THE PONG SOUND

    y_speedA = -y_speedA;//REVERSES THE DIRECTION OF BALL A WHEN IT HITS THE PADDLE

    scoreA = scoreA + 1;//WHEN THE BALL A HITS THE PADDLE INCREMENT THE SCORE BY 1
  }

  background(0);// Clear screen to black
  fill(255);//COLOR THE SHAPES TO BE WHITE HERE 255 IS COLOR CODE OF WHITE

  ellipse(xB, yB, 10, 10);//CREATING THE  BALL B .X,Y ARE VARIABLE COORDINATE  
  ellipse(xA, yA, 10, 10);//CREATING THE BALL A.BALL X,BALL Y ARE VARIABLE COORDINATE  

  rect(250,10, 5, 750);//CREATING THE PARTITIONING LINE IN THE MIDDLE 
  rect(x_paddle, y_paddle, paddle_width_half*2 + 1, 10);//CREATING THE PADDLE 

  x_paddle = x_paddle + speed;//THIS IS TO INCREASE OR DECREASE THE VALUE OF X COORDINATE OF THE PADDLE DEPENDING ON THE VALUE OF SPEED(BECOMES -VE WHEN ON THE RIGHT CORNER AND VICEVERSA)

  if (x_paddle>500||x_paddle<0)
  {
    speed = -1*speed;  //THIS ENSURES THAT IF THE PADDLE GOES BEYOND THE SCREEN IN RIGHT OR LEFT SIDE MAKE IT DIRECTION REVERSE BY CHENGING THE DIRECTION OF SPEED
  }

  //      SCORE DISPLAY

  /*THIS IS SCORE DSPLAY FOR PLAYER A*/
  textSize(13);      // SIZE OF TEXT TO BE DISPLAYED WILL BE 13
  textAlign(RIGHT);  // ALIGNMENT OF THE TEXT TO THE RIGHT
  text("PLAYER A :", 75, 20);  // PLAYER A :AT X=75 AND Y=20
  textAlign(LEFT);
  text(scoreA, 95, 20);// X SCORE=95 AND YSCORE=20    FORMAT PLAYER A : SCORE 

  /*THIS IS SCORE DIPLAY FOR PLAYER B*/
  textSize(13);//SIZE OF TEXT TO BE DISPLAYED WILL BE 13
  textAlign(RIGHT);//ALIGNMENT OF THE TEXT TO THE RIGHT
  text("PLAYER B", 440, 20);//PLAYER B :AT X=440 AND  Y=20
  textAlign(LEFT);
  text(scoreB, 470, 20);// X SCORE=470 AND YSCORE=20    FORMAT PLAYER B : SCORE 

  if (time > 0)  // THIS IS THE SET OF STATEMENT WHICH ENSURES THAT IF THE TIME IS >0 DECREASE THE TIME FROM 30TO 0
  {  
    time = duration - (millis() - begin)/1000;//DECREASE THE TIME 
    fill(255);//MAKE THE TEXT TO DISPLAY WHITE. COLOR CODE FOR WHITE IS 255
    textAlign(RIGHT);
    textSize(15);//SIZE OF TEXT IS 15
    text("TIMER:", 250, 20);//SHOWING THE TIMER ON THE MIDDLE OF SCREEN WHICH DECREASES TO 0FROM 30 SECONDS    
    text(time, 270, 20);//THIS SHOWS THE VALUE OF SECONDS LEFT IN TH GAME
  }///////////////////////////////////////////////////////////////////////////

  /* FOLLWING STATEMNETS TELL THAT WHEN THE ANY OF THE BALL(A OR B) GO BEYOND THE Y=400 THAT THE HEIGHT THEN SHOW GAMEOVER IN THEIR RESPECTIVE SCREEN*/
  if (yB>height)//THIS IS FOR BALL B
  {
    textSize(15);
    textAlign(CENTER);
    text("Game over", 375, 150);
    textSize(20);
  }

  if (yA>height)//THIS IS FOR BALL A
  { 
    textSize(15);
    textAlign(CENTER);
    text("Game over", 125, 150);
    textSize(20);
  }        

  /*WHEN THE BOTH THE BALL GOES BEYOND THE Y=400 MAKE THE SCREEN DISPLAY THE ANIMATION (THE DROPPING OF BLACK DROPS IN GRAY BACKGROUND) AND SHOWING THE RESULT(WHETHER WHO WINS PLAYERA /PLAYERB/OR ITS TIE)*/
  if (yA>400 && yB>400 )
  {     
    background(23);
    fill(230);

    for (int i = 0; i < drops.length; i++) 
    {
      drops[i].fall(); // sets the shape and speed of drop
      drops[i].show(); // render drop
    }     

    if (scoreA==scoreB)  // STATEMENTS TO CHECK IF THERE IS A TIE OR NOT THIS IS DONE BY COMPARING THE SCORES OF BOTH PLAYERS (SEE SCOREA==SCORE)
    {  
      textSize(40);
      textAlign(CENTER);
      text("IT'S A TIE", 250, 150);
    } else if (scoreA>scoreB)  // THIS SHOWS THAT IF PLAYERA HAS A GREATER SCORE AS COMPARED TO PLAYER B THAN CLAIM THAT A IS A WINNER
    {  
      textSize(40);
      textAlign(CENTER);
      text("PLAYER A WINS", 250, 150);
    } else  // IF PLAYER A DOESNOT WIN AND ITS NOT A TIE; CLAIM THAT PLAYER B HAS WON
    { 
      textSize(40);
      textAlign(CENTER);
      text("PLAYER B WINS", 250, 150);
    }
  }

  /* THESE ARE THE STATEMENTS WHICH DECLARES THE WINNER AFTER THE TIMER OF 30 SECONDS HAS GOT OVER .
   WE WILL COMPARE THE SCORE OF BOTH PLAYERS TO ARRIVE AT THE RESULT(TIE,OR ANY OF THEM IS A WINNER)*/

  else if (time==0)
  {
    background(23);
    fill(230);

    for (int i = 0; i < drops.length; i++) //DROPS THE BLACK RAIN DROPS IN GRAY BACKGROUND
    {
      drops[i].fall(); // sets the shape and speed of drop
      drops[i].show(); // render drop
    }

    if (scoreA==scoreB)  // STATEMENTS TO CHECK IF THERE IS A TIE OR NOT THIS IS DONE BY COMPARING THE SCORES OF BOTH PLAYERS (SEE SCOREA==SCORE)
    {   
      textSize(40);
      textAlign(CENTER);
      text("IT'S A TIE", 250, 150);
    } else if (scoreA>scoreB)  // THIS SHOWS THAT IF PLAYERA HAS A GREATER SCORE AS COMPARED TO PLAYER B THAN CLAIM THAT A IS A WINNER
    {  
      textSize(40);
      textAlign(CENTER);
      text("PLAYER A WINS", 250, 150);
    } else    // IF PLAYER A DOESNOT WIN AND ITS NOT A TIE; CLAIM THAT PLAYER B HAS WON
    {    
      textSize(40);
      textAlign(CENTER);
      text("PLAYER B WINS", 250, 150);
    }
  }
}
/*THIS IS THE FUNCITON WHICH HELPS TO SHOW THE STARTING SCREEN  IT SHOWS TTHE TIME SEQUENCE , JUMPING JACK GAME  AND STARTS IN */
void startScreen(int remainingTimeMs) 
{
  background(23);
  textSize(20);
  fill(230);
  textAlign(CENTER, CENTER);

  /*THIS IS THE SET OF STATEMENTS THAT ENSURES THE DROPPPING OF DROPS*/
  for (int i = 0; i < drops.length; i++) 
  {
    drops[i].fall(); // sets the shape and speed of drop
    drops[i].show(); // render drop
  }

  /*TEXT TO SHOW THE STARTING OF GAME */
  text("JUMPING JACK GAME", gameWidth/2, gameHeight/2-40);//SHOWS JUMPING JACK GAME 
  text("GAME STARTS IN ", gameWidth/2, gameHeight/2-10);// SHOWS "GAME STARTS IN  JUST BELOW JUMPING JACK GAME "
  textSize(60);
  fill(230);
  // Show the remaining time, in seconds;
  // show n when there are n or fewer seconds remaining.
  text(ceil(remainingTimeMs/1000.0), gameWidth/2, 300);// SHOWS THE TIME ON INITIAL SCREEN
}
