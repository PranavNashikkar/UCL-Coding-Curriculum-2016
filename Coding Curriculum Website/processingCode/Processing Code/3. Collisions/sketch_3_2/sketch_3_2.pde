Controller controller = new Controller();

void setup(){
  size(500,500);
  background(255,0,0);
}

void draw()
{
  controller.update();
}

public interface canCollide
{
  public float getX();
  public float getY();
  public float getWidth();
  public float getHeight();
}


class Controller
{
  private InputKey inputKey;
  private SquareObject square;
  private Platform platform;
  
  public Controller()
  {
    inputKey=new InputKey();
    square = new SquareObject(30,30);
    platform = new Platform(30,250);
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
    platform.draw();
    
  }
}


class CollisionDetection
{
  public Boolean collision(canCollide a,canCollide b)
  {
    /*
    4 checks have to be carried out, and they must all fail in order for no collision to be present. 
    1) if A left edge is to the right of B right edge, it can't be colliding
    2) if A's right edge is to the left of B's left, then it can't be colliding
    3) if A's top edge is below B's bottom, then it can't be colliding
    4) if A's bottom edge is above B's top edge, then it can't be colliding.
    Note: this assumes that the two colliding objects are rectangular.    
    see documentation for pictoral evidence
    The co-ordinate system used has x,y as the top left co-ordinates of the shape
    */
    if (a.getX()>(b.getX()+b.getWidth()))
    {
      return false;
    }
    if ((a.getX()+a.getWidth())<b.getX())
    {
      return false;
    }
    if (a.getY()<(b.getY()+b.getHeight()))
    {
      return false;
    }
    if ((a.getY()+a.getHeight())>b.getY())
    {
      return false;
    }
    return true;
  }
}

class Platform implements canCollide
{
  private float x,y, width=200,height=50;
  public Platform(float x, float y)
  {
    this.x=x;
    this.y=y;
  }
  public float getX()
  {
    return x;
  }
  public float getY()
  {
    return y;
  }
  public float getWidth()
  {
    return width;
  }
  public float getHeight()
  {
    return height;
  }
  public void draw()
  {
    fill(0,0,255);
    rect(x, y, width,height);//currently the square is of a fixed size
  }
}

class SquareObject implements canCollide
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
  public float getX()
  {
    return x;
  }
  public float getY()
  {
    return y;
  }
  public float getWidth()
  {
    return width;
  }
  public float getHeight()
  {
    return height;
  }

  
  public void draw()
  {
    fill(100,30,1);
    rect(x, y, width,height);//currently the square is of a fixed size
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