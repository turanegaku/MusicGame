public class Popup {
  Mark m;
  int x, y, t, mt;

  public Popup(Mark m, int x, int y, int t) {
    this.m=m;
    this.x=x;
    this.y=y;
    this.t=t;
    mt=t;
  }

  public boolean update() {
    fill(m.r, m.g, m.b, 255*t/mt);
    textSize(30);
    textAlign(CENTER);
    text(m.name, x, y-=2);
    textAlign(CORNER);
    return t--==0;
  }
}

