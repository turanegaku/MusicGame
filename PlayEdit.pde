PlayEdit playedit = new PlayEdit();

final char keys[]= {
  'A', 'S', 'D', 'F', 'J', 'K', 'L', ';'
};

public class PlayEdit {
  private String name;
  private Score score;
  private ArrayList<Note> note = new ArrayList<Note>();
  private AudioPlayer song;
  private ArrayList<Integer> result;
  private int point;
  private float per, per2;
  private int ready;
  private int mark[] = new int[4];

  private int keyTime[] = new int[8];

  public float speed = 1.0;

  private ArrayList<Popup> popup=new ArrayList<Popup>();

  int wheel = 0;

  private void saveScore() {
    score.note.clear();
    score.note.addAll(note);
    File f = new File(dataPath("score/"+name+".sc"));
    try {
      ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream(f));
      os.writeInt(note.size());
      for (Note n : note)
        os.writeObject(n);
      os.close();

      println("score saveDone");
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  public void setScore(Score s) {
    score = s;
    song = s.song;
    name = s.name;
    note.clear();
    note.addAll(s.note);
    result = s.result;
    resetScore();
  }

  public void resetScore() {
    for (Note n : note)
      n.resetMark();
    song.rewind();
    if (Scene.get().equals(Scene.Play))
      ready=60*3;
    for (int i=0; i<4; i++)
      mark[i]=0;

    point = 0;
    per = 0;

    popup.clear();
    Res.back();
  }

  private void saveResult() {
    result.add(int(per2*100000));
    Collections.sort(result);
    Collections.reverse(result);

    File f = new File(dataPath("result/"+name+".rs"));
    try {
      ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream(f));
      for (int i=0; i<5; i++)
        os.writeInt(result.get(i));

      os.close();

      println("result saveDone");
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  private void update() {
    for (int i=0; i<8; i++) {
      if (Key.pressed(keys[i]))
        keyTime[i]=11;
    }

    stroke(#aaaaaa);
    strokeWeight(10);
    line(25, height-10, 25, 50);
    stroke(#77ff55);
    line(25, height-10, 25, height-10-(height-60)*per);
    strokeWeight(1);
    stroke(0);
    fill(song.isPlaying()?255:150);
    rectMode(CENTER);
    rect(25, height-10-(height-60)*song.position()/song.length(), 40, 10, 3);
    rectMode(CORNER);

    stroke(255);
    line(80, height-30, 80+55*7, height-30);
    for (int i=0; i<8; i++) {
      if (keyTime[i]>0)keyTime[i]--;

      strokeWeight(40);
      stroke(#333333);
      line(80+i*55, 0-20, 80+i*55, height+20);
      strokeWeight(1);

      fill(#5555ff);
      noStroke();
      ellipse(80+i*55, height-30, 40+keyTime[i], 20+keyTime[i]);
      fill(0);
      textAlign(CENTER);
      textSize(20+keyTime[i]);
      text(keys[i], 80+i*55, height-25);
      textAlign(LEFT);
      stroke(0);
    }

    stroke(0);
    for (Note n : note) {
      fill(n.mark.r, n.mark.g, n.mark.b);
      ellipse(80+n.pos*55, height-30+(song.position()-n.time)/5*speed, 40, 20);
    }

    strokeWeight(3);
    fill(50);
    rect(0, 0, width, 30);
    fill(255);
    textAlign(CENTER);
    textSize(30);
    text(name, width/2, 25);
    textAlign(LEFT);
    strokeWeight(1);
  }

  public void play() {
    update();

    if (ready>0) {
      ready--;
      if (ready == 0)
        song.play();

      textAlign(CENTER);
      fill(#ffffbb);
      textSize(20+(ready%60)*30/60);
      text(1+ready/60, 25+width/2, height/2);
      textAlign(LEFT);
    }

    if (song.position() == song.length()) {
      float perr=sq(abs(ready)/20.);
      noStroke();
      fill(0, 0, 0, 200);
      rectMode(CENTER);
      rect(25+width/2, height/2, 300*perr, 500*perr);
      rectMode(CORNER);

      if (ready > -20)
        ready--;
      else {
        if (Key.pressed('J'))
          Res.next();
        if (Key.pressed('K'))
          Res.back();
        if (Key.pressed(ENTER)) {
          saveResult();
          switch(Res.get()) {
          case Title:
            Scene.to(Scene.Title);
            break;
          case Retry:
            resetScore();
            break;
          }
        }

        textSize(45);
        textAlign(CENTER);
        if (per == 1) {
          fill(#ffff55);
          text("Clear!!", 25+width/2, 130);
        } else {
          fill(#ccaaaa);
          text("Fail...", 25+width/2, 130);
        }
        textAlign(CORNER);
        fill(255);
        text("Score : " + int(per2*100000), 150, 190);
        Mark marks[] = Mark.values();
        for (int i=1; i<marks.length; i++) {
          fill(marks[i].r, marks[i].g, marks[i].b);
          textSize(30);
          text(marks[i].name, 150, 200+40*i);
          fill(255);
          text(mark[i-1], 300, 200+40*i);
        }

        Res[] tits = Res.values();
        for (int i=0; i<tits.length; i++) {
          color c=color(Res.get().equals(tits[i])?#5555ff:255);
          fill(red(c), green(c), blue(c), 255);
          text(tits[i].txt, 200, 430+i*60);
        }
        textSize(20);
        fill(#dddddd);
        text("press jk ENTER", 300, 550);
      }
    } else {
      if (Key.get(CONTROL)>0&& Key.pressed('D')) {
        song.pause();
        Scene.to(Scene.Title);
      }

      for (Note n : note) {
        if (n.mark != Mark.none)continue;
        int diff = song.position()-n.time;
        if (diff > 200) { //過ぎ去っていたらbad
          n.mark = Mark.bad;
          point --;
          popup.add(new Popup(n.mark, 80+n.pos*55, height-30, 20));
          mark[3]++;
          continue;
        }
        if (keyTime[n.pos] != 10) continue;

        if (abs(diff) <= 2) {
          n.mark = Mark.perfect;
          popup.add(new Popup(n.mark, 80+n.pos*55, height-30, 20));
          point += 5;
          mark[0]++;
        } else if (abs(diff) < 50) {
          n.mark = Mark.great;
          popup.add(new Popup(n.mark, 80+n.pos*55, height-30, 20));
          point += 3;
          mark[1]++;
        } else if (-100 <= diff && diff <=200) {
          n.mark = Mark.good;
          popup.add(new Popup(n.mark, 80+n.pos*55, height-30, 20));
          point += 3;
          mark[2]++;
        }
      }

      per = constrain(point / (note.size() * 3 * 0.8), 0, 1);
      per2 = constrain(point / (note.size() * 3.), 0, 1);
    }

    for (int i=0; i<popup.size (); i++)
      if (popup.get(i).update())
        popup.remove(i--);
  }

  public void edit() {
    update();
    song.skip(wheel*100);
    wheel = 0;

    if (Key.get(CONTROL)>0) {
      if (Key.pressed('S')) {
        Collections.sort(note);
        saveScore();
      }
      if (Key.pressed('D')) {
        Scene.to(Scene.Title);
      }
      if (Key.get('H')>0) {
        for (int i=0; i<note.size (); i++) {
          int diff = abs(song.position()-note.get(i).time);
          if (diff < 100)
            note.remove(i--);
        }
      }
      if (Key.pressed('L'))
        song.rewind();
      if (Key.pushed('J', 30, 3))
        song.skip(100);
      if (Key.pushed('K', 30, 3))
        song.skip(-100);
    } else {
      for (int i=0; i<8; i++) {
        Note n = new Note(song.position(), i);
        if (Key.pressed(keys[i]) && !note.contains(n)) {
          note.add(n);
        }
      }
    }

    if (Key.pressed(' ')) {
      if (song.isPlaying())
        song.pause();
      else
        song.play();
    }
  }
}

