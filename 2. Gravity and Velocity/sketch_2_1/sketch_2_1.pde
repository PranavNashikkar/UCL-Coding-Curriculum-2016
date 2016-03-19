Controller controller = new Controller();

void setup(){
  size(500,500);
  background(255,0,0);
}

void draw()
{
  controller.update();
}

class Controller
{
  private InputKey inputKey;
  private SquareObject square;
  public Controller()
  {
    inputKey=new InputKey();
    square = new SquareObject(30,30);
  }
  public void update()
  {
    background(255,0,0);
    if (inputKey.keyAvailable())
    {
      switch(key)
      {
        case 'a':
          square.changeX(-1);
          break;
        case 's':
          square.changeY(1);
          break;
        case 'd':
          square.changeX(1);
          break;
        case 'w':
          square.changeY(-1);
          break;
      }
    }
    square.update();
    square.draw();    
  }
}

class InputKey
{
  public boolean keyAvailable()
  {
    if ((key=='a'||key=='w'||key=='s'||key=='d')&&keyPressed)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
}

class SquareObject
{
  private float x,y;
  private float width=50,height=50;
  private float yVelocity=0,xVelocity=0;
  private float gravityStrength = 0.05;
  
  public SquareObject(float x,float y)
  {
    this.x=x;
    this.y=y;
  }
  
  public void update()
  {
    updateGravity();
    y+=yVelocity;
    x+=xVelocity;
  }
  private void updateGravity()
  {
    yVelocity+=gravityStrength;
  }
  public void changeX(float distance)
  {
    xVelocity+=distance;
  }
  public void changeY(float distance)
  {
    yVelocity+=distance;
  }
  public void draw()
  {
    fill(100,30,1);
    rect(x, y, width,height);//currently the square is of a fixed size
  }  
}