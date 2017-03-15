public class GameOfLife {
  final color ALIVE = color(255);

  final int[][]
  GLIDER = {{0, 0}, {1, 0}, {1, -1}, {1, -2}, {-1, -1}},
  LWSS_H = {{0, 0}, {3, 0}, {4, 1}, {0, 2}, {4, 2}, {1, 3}, {2, 3}, {3, 3}, {4, 3}},
  LWSS_V = {{0, 0}, {0, 3}, {1, 4}, {2, 0}, {2, 4}, {3, 1}, {3, 2}, {3, 3}, {3, 4}},
  LWSS_U = {{0, 0}, {0, -3}, {1, -4}, {2, -0}, {2, -4}, {3, -1}, {3, -2}, {3, -3}, {3, -4}},
  LWSS_U_R = {{-0, 0}, {-0, -3}, {-1, -4}, {-2, -0}, {-2, -4}, {-3, -1}, {-3, -2}, {-3, -3}, {-3, -4}},
  BLOCK = {{-2, -2}, {-2, -1}, {-2, 0}, {-2, 1}, {-2, 2}, {-1, -2}, {-1, -1}, {-1, 0}, {-1, 1}, {-1, 2}, {0, -2}, {0, -1}, {0, 0}, {0, 1}, {0, 2}, {1, -2}, {1, -1}, {1, 0}, {1, 1}, {1, 2}, {2, -2}, {2, -1}, {2, 0}, {2, 1}, {2, 2}},
  STAR  = {{-1, 0}, {0, -1}, {1, 0}, {0, 1}, };

  final int[][][] SPACESHIPS = {GLIDER, LWSS_H, LWSS_V};

  private PApplet parent;

  public int cols, rows;

  public boolean[][] cells;
  public boolean[][] cellsBuffer;
  public boolean[][][] history;

  GameOfLife (PApplet parent, int cols, int rows) {
    this.parent = parent;

    this.cols = cols;
    this.rows = rows;

    this.cells = new boolean[this.cols][this.rows];
    this.cellsBuffer = new boolean[this.cols][this.rows];
    this.history = new boolean[3][this.cols][this.rows];

    for (int i = 0; i < this.history.length; i++) {
      for (int x = 0; x < this.cols; x++) {
        for (int y = 0; y < this.rows; y++) {
          this.history[i][x][y] = false;
        }
      }
    }

    for (int x = 0; x < this.cols; x++) {
      for (int y = 0; y < this.rows; y++) {
        this.cells[x][y] = false;
      }
    }
  }

  // -------------------------------------------------------------------------
  // renderer

  public PImage render () { return this.render(this.cols, this.rows); }
  public PImage render (int width) { return this.render(width, width); }
  public PImage render (int width, int height) {
    PGraphics pg = createGraphics(width, height, OPENGL);
    int size = width / this.cols;

    pg.beginDraw();
    pg.background(0);
    pg.stroke(0);


    pg.fill(255, 50);
    for (boolean[][] state : this.history) {
      for (int x = 0; x < this.cols; x++) {
        for (int y = 0; y < this.rows; y++) {
          if (state[x][y]) {
            pg.rect(x * size, y * size, size, size);
          }
        }
      }
    }



    pg.fill(255);
    for (int x = 0; x < this.cols; x++) {
      for (int y = 0; y < this.rows; y++) {
        if (this.cells[x][y]) {
          pg.rect(x * size, y * size, size, size);
        }
      }
    }
    pg.endDraw();

    return pg.get();
  }

  // -------------------------------------------------------------------------
  // various cell manipulation helpers

  public void spawn (int i, int j) {
    int[][] pattern = this.SPACESHIPS[int(random(this.SPACESHIPS.length))];
    this.spawn(pattern, i, j);
  }

  public void spawn (int[][] pattern, int si, int sj) {
    for (int[] cell : pattern) {
      int i = si + cell[0];
      int j = sj + cell[1];
      if (i >= 0 && i < this.cols && j >= 0 && j < this.rows) {
        this.cells[i][j] = true;
      }
    }
  }

  public void fill (int w, int h) { this.fill(0, 0, w, h); }
  public void fill (int i, int j, int w, int h) {
    for (int x = i; x < i + w; x++) {
      for (int y = j; y < j + h; y++) {
        if (x >= 0 && x < this.cols && y >= 0 && y < this.rows) {
          this.cells[x][y] = true;
        }
      }
    }
  }



  // -------------------------------------------------------------------------
  // gol core

  public void iterate () { iterate(0, 0, this.cols, this.rows); }
  public void iterate (int i, int j, int w, int h) {
    this.pushHistoryState(this.cells);

    // save cells to buffer (so we opeate with one array keeping the other intact)
    this.cellsBuffer = deepCopy(this.cells);

    // visit each cell
    for (int x = i; x < w; x++) {
      for (int y = j; y < h; y++) {
        // visit all the neighbours of each cell
        int neighbours = 0;
        for (int xx = x - 1; xx <= x + 1; xx++) {
          for (int yy = y - 1; yy <= y + 1; yy++) {
            // check out of bounds
            if (((xx >= 0) && (xx < this.cols)) && ((yy >= 0) && (yy < this.rows))) {
              // check against self
              if (xx != x || yy != y) {
                // check alive neighbours and count them
                if (this.cellsBuffer[xx][yy]){
                  neighbours++;
                }
              }
            }
          }
        }

        // apply rules
        if (this.cellsBuffer[x][y]) {
          // the cell is alive: kill it if necessary
          if (neighbours < 2 || neighbours > 3) {
            // die unless it has 2 or 3 neighbours
            this.cells[x][y] = false;
          }
        } else {
           // the cell is dead: make it live if necessary
           if (neighbours == 3 ) {
            // only if it has 3 neighbours
            this.cells[x][y] = true;
          }
        }
      }
    }
  }

  // -------------------------------------------------------------------------

  private void pushHistoryState (boolean[][] newState) {
    for (int i = this.history.length - 1; i > 0; i--) {
      this.history[i] = this.history[i - 1];
    }

    this.history[0] = deepCopy(newState);
  }

  public int diffHistory () { return diffHistory(0, 0, this.cols, this.rows); }
  public int diffHistory (int i, int j, int w, int h) {
    int count = 0;
    for (int x = i; x < w; x++) {
      for (int y = j; y < h; y++) {
        boolean isSame = true;

        diffing:
        for (int a = 0; a < this.history.length; a++) {
          for (int b = 0; b < this.history.length; b++) {
            if (a != b) {
              if (this.history[a][x][y] != this.history[b][x][y]) {
                isSame = false;
                break diffing;
              }
            }
          }
        }
        if (!isSame) count++;
      }
    }
    return count;
  }

  // -------------------------------------------------------------------------

  private boolean[][] deepCopy (boolean[][] array) {
    boolean[][] copy = new boolean[this.cols][this.rows];

    for (int x = 0; x < this.cols; x++) {
      for (int y = 0; y < this.rows; y++) {
        copy[x][y] = array[x][y];
      }
    }

    return copy;
  }

}