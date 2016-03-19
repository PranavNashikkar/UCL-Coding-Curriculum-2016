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
  public void handleCollide(int direction, canCollide b); 
  public float getRestCoeff();
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
  private CollisionDetection collisionDetector=new CollisionDetection();
  private float squareVelocity = 0.4;
  
  public Controller()
  {
    inputKey=new InputKey();
    square = new SquareObject(30,30);
    platform = new Platform(30,250,0.5);
  }
  public void update()
  {
    background(255,0,0);
    if (inputKey.keyAvailable())
    {
      switch(key)
      {
        case 'a':
          square.changeX(-1*squareVelocity);
          break;
        case 's':
          square.changeY(squareVelocity);
          break;
        case 'd':
          square.changeX(squareVelocity);
          break;
        case 'w':
          square.changeY(-1*squareVelocity);
          break;
      }
    }
    square.update();
    if (collisionDetector.collision(square,platform))
    {
      int direction = collisionDetector.getDirection(square,platform);
      square.handleCollide(direction,platform);
    }
    square.draw();  
    platform.draw();
    
    
  }
}


class CollisionDetection
{
  public int getDirection(canCollide a, canCollide b)
  {
    //1,2,3,4 are possible return values corresponding to top,right,bottom,left
    if (CollisionIsVertical(a,b)) //if the collision is vertical, we have to work out if A is colliding on the top or bottom 
    {
      if (a.getY()+(a.getHeight()/2)>b.getY()+(b.getHeight()/2))
      {
        return 1; //'top' collision
      }
      else
      {
        return 3; //'bottom' collision
      }
    }
    else
    {
      if (a.getX()+(a.getWidth()/2)>b.getX()+(b.getWidth()/2))
      {
        return 2; //'right' collision
      }
      else
      {
        return 4; //'left' collision
      }
    }
  }
  
  private Boolean CollisionIsVertical(canCollide a, canCollide b) 
  {
    float angle = getAngle(a,b);
    //need to calculate the angles that A could travel into B at for it to be considered 'vertical' 
    float verticalAngle =(float) Math.toDegrees(Math.atan(3.0)); 
    if (Math.abs(angle)<verticalAngle)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  private float getAngle(canCollide a,canCollide b) //this returns the int in relation to a moving into b
  {
    //this function compares their centres so we must first compute these centres of A and B
    float aCentrex = a.getX() + (0.5*a.getWidth());
    float aCentrey = a.getY() + (0.5*a.getHeight());
    float bCentrex = b.getX() + (0.5*b.getWidth());
    float bCentrey = b.getY() + (0.5*b.getHeight());
    float xDifference = aCentrex - bCentrex;
    float yDifference = aCentrey - bCentrey;
    return (float) Math.toDegrees(Math.atan(xDifference/yDifference));    
  }
  
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
    //1) if A left edge is to the right of B right edge, it can't be colliding
    if (a.getX()>(b.getX()+b.getWidth())) 
    {
      return false;
    }
    //2) if A's right edge is to the left of B's left, then it can't be colliding
    if ((a.getX()+a.getWidth())<b.getX())
    {
      return false;
    }
    //3) if A's top edge is below B's bottom, then it can't be colliding
    if (a.getY()>(b.getY()+b.getHeight()))
    {
      return false;
    }
    //4) if A's bottom edge is above B's top edge, then it can't be colliding.
    if ((a.getY()+a.getHeight())<b.getY())
    {
      return false;
    }
    return true;
  }
}

class Platform implements canCollide
{
  private float x,y, width=200,height=150;
  private float restitution;
  public Platform(float x, float y, float restitution)
  {
    this.x=x;
    this.y=y;
    this.restitution=restitution;
  }
  public void handleCollide(int direction, canCollide b){}
  public float getRestCoeff()
  {
    return restitution;
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
  
  public void handleCollide(int direction, canCollide b)
  {
    float restCoeff = b.getRestCoeff();
    switch (direction)
    {
      case 1://'top' collision
        yVelocity=-1 * restCoeff * yVelocity;
        y = b.getY()+b.getHeight();
        break;
      case 2://'right' collision
        xVelocity = -1 * restCoeff * xVelocity;
        x = b.getX()+b.getWidth();
        break;
      case 3: //'bottom' collision
        yVelocity=-1 * restCoeff * yVelocity;
        y = (b.getY())-height;
        break;
      case 4://'left' collision  
        xVelocity = -1 * restCoeff * xVelocity;
        x = b.getX()-width;
        break;       
    }
  }
  public float getRestCoeff()
  {
    return -1;
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