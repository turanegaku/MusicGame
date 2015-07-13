enum Scene {
  Title, 
  Play, 
  Edit;

  private static Scene instance = Title;

  public static Scene get() {
    return instance;
  }

  public static void to(Scene t) {
    instance = t;
  }
}

enum Tit {
  Play("Play", Scene.Play), 
  Edit("Edit", Scene.Edit), 
  Exit("Exit", null);

  private static Tit instance = Play;

  public static Tit get() {
    return instance;
  }

  public static void next() {
    switch(instance) {
    case Play:
      instance = Edit;
      break;
    case Edit:
      instance = Exit;
      break;
    case Exit:
      //      instance = Play;
      break;
    }
  }
  public static void back() {
    switch(instance) {
    case Play:
      //      instance = Exit;
      break;
    case Edit:
      instance = Play;
      break;
    case Exit:
      instance = Edit;
      break;
    }
  }

  public String name;
  public Scene scene;

  private Tit(String nm, Scene s) {
    name = nm;
    scene = s;
  }
}

enum Res {
  Title("Back to Title"), 
  Retry("Retry");

  private static Res instance = Title;
  public static Res get() {
    return instance;
  }

  public String txt;
  private Res(String t) {
    txt=t;
  }

  public static void next() {
    instance = Retry;
  }
  public static void back() {
    instance = Title;
  }
}

enum Mark {
  none(null, 200, 200, 200), 
  perfect("perfect", 255, 255, 50), 
  great("great", 255, 50, 255), 
  good("good", 50, 255, 50), 
  bad("bad", 255, 50, 50);

  public int r, g, b;
  public String name;
  private Mark(String n, int rr, int gg, int bb) {
    name =n;
    r=rr;
    g=gg;
    b=bb;
  }
}

