import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private int numMinesStart = (NUM_ROWS*NUM_COLS)/5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOn = true;
private int numClicked = 0;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i ++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i, j);
      }
    }
    
    for(int i = 0; i < numMinesStart; i++){
      setMines();
    }
}
public void setMines()
{
    int row = (int)(Math.random()*(NUM_ROWS));
    int column = (int)(Math.random()*(NUM_COLS));
    
    if(!(mines.contains(buttons[row][column]))){
      mines.add(buttons[row][column]);
    }
}

public void draw ()
{
    background(0);
    isWon();
}
public boolean isWon()
{
    if(numClicked >= ((NUM_ROWS*NUM_COLS)-mines.size())){
      return true;
    }else{
      return false;
    }
}
public void displayLosingMessage()
{
    gameOn = false;
    int r = 9;
    buttons[r][6].myLabel = "Y";
    buttons[r][7].myLabel = "O";
    buttons[r][8].myLabel = "U";
    buttons[r][9].myLabel = "";
    buttons[r][10].myLabel = "L";
    buttons[r][11].myLabel = "O";
    buttons[r][12].myLabel = "S";
    buttons[r][13].myLabel = "T";
}
public void displayWinningMessage()
{
    gameOn = false;
    int r = 9;
    buttons[r][6].myLabel = "Y";
    buttons[r][7].myLabel = "O";
    buttons[r][8].myLabel = "U";
    buttons[r][9].myLabel = "";
    buttons[r][10].myLabel = "W";
    buttons[r][11].myLabel = "O";
    buttons[r][12].myLabel = "N";
    buttons[r][13].myLabel = "!";
}
public boolean isValid(int r, int c)
{
  if((r<NUM_ROWS)&&(c<NUM_COLS)&&(0<=r)&&(0<=c)){
    return true;
  }else{
    return false;
  }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int j = -1; j < 2; j++){
      for(int i = -1; i < 2; i++){
        if((isValid(row+j, col+i)) && (mines.contains(buttons[row+j][col+i])) && ((row+j != row)||(col+i != col))){
          numMines++;
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    public String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(gameOn == true){
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if(flagged == false){clicked = false;}
        }else if(mines.contains(buttons[myRow][myCol])){
          displayLosingMessage();
        }else if(countMines(myRow, myCol) > 0){
          myLabel = Integer.toString(countMines(myRow, myCol));
        }else{
          for(int i = -1; i < 2; i++){
            for(int j = -1; j < 2; j++){
              if((myRow+i != myRow) || (myCol+j != myCol) && isValid(myRow+i, myCol+j) && !(buttons[myRow+i][myCol+j].flagged)){
                buttons[myRow+i][myCol+j].mousePressed();
                System.out.println((myRow+i) + "," + (myCol+j));
              }
            }
          }
        }
      }
    }
    public void draw () 
    {    
        textSize(10);
        if (flagged)
            fill(0,0,255);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
