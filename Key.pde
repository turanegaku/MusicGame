public static class Key {
  private static int pressTime[] = null;
  private static boolean keyOff[] = null;

  public static void setApplet(PApplet applet) {
    pressTime = new int[Character.MAX_VALUE];
    keyOff = new boolean[Character.MAX_VALUE];

    applet.addKeyListener(new java.awt.event.KeyAdapter() {

      @Override
        public void keyPressed(java.awt.event.KeyEvent e) {
        if (pressTime[e.getKeyCode()] <= 0)
          pressTime[e.getKeyCode()] = 1;
      }

      @Override
        public void keyReleased(java.awt.event.KeyEvent e) {
        keyOff[e.getKeyCode()] = true;
      }
    }
    );
  }

  public static int get(int code) {
    return pressTime[code];
  }
  public static boolean pressed(int code) {
    return get(code)==2;
  }
  public static boolean released(int code) {
    return get(code)==-1;
  }
  public static boolean pushed(int code, int n, int m) {
    return pressed(code)||(get(code)>=n&&get(code)%m==0);
  }

  public static void update() {
    for (int i=0; i<pressTime.length; i++) {
      pressTime[i]+=pressTime[i]!=0?1:0;
      if (keyOff[i]) {
        pressTime[i]=-1;
        keyOff[i]=false;
      }
    }
  }
}

