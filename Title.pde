Title title = new Title();

public class Title {
  int deep = 0;
  int scoreidx = 0;
  int t=0;
  int cnt;

  public void update() {
    fill(255);

    if (t<0)t++;
    else if (t>0)t--;

    if (Key.pressed('J')||Key.pressed('K')||Key.pressed('H')||Key.pressed('L'))
      playSwitch();

    if (Key.pressed('H'))
      deep=max(0, deep-1);
    if (Key.pressed('L')) {
      deep=min(2, deep+1);
      if (Tit.get().equals(Tit.Exit)) exit();
      cnt = 0;
    }
    switch(deep) {
    case 0:
      if (Key.pressed('J'))
        Tit.next();
      if (Key.pressed('K'))
        Tit.back();
      break;
    case 1:
      if (Key.pressed('J')) {
        scoreidx++;
        while (scoreidx>=score.size ())scoreidx-=score.size();
        if (t==0)
          t=10;
      }
      if (Key.pressed('K')) {
        scoreidx--;
        while (scoreidx<0)scoreidx+=score.size();
        if (t==0)
          t=-10;
      }
      break;
    case 2:
      if (Key.pushed('J', 30, 3)) 
        playedit.speed = max(playedit.speed-0.1, 0.5);
      if (Key.pushed('K', 30, 3)) 
        playedit.speed += 0.1;
      break;
    }

    Tit[] tits = Tit.values();
    textSize(40);
    for (int i=0; i<tits.length; i++) {
      color c=color(Tit.get().equals(tits[i])?#5555ff:255);
      fill(red(c), green(c), blue(c), 255-abs(deep-0)*120);
      text(tits[i].name, 100 - (deep-0) * 100, 100+(i+1)*100);
    }

    if (score.size()>0)
      for (int i=-1; i<3; i++) {
        int idx = (i+scoreidx+score.size())%score.size();
        color c=color(i==0?#5555ff:255);
        fill(red(c), green(c), blue(c), 255-abs(min(deep-1, 0))*120-(i<0?-i*2:i)*120);
        textSize(30);
        if (deep !=2 || i==0)
          text(score.get(idx).name, 150 - (deep-1) * 120, 100+(i+1)*60+t*6);
      }

    fill(255, 255-abs(min(deep-2, 0))*180);
    textSize(25);
    text("speed : "+nf(playedit.speed, 0, 1), 30+(2-deep)*120, 50);
    for (int i=0; i<5; i++) {
      int res = score.get(scoreidx).result.get(i);
      fill(255, 255-abs(min(deep-2, 0))*120);
      textSize(25);
      text((i+1), 30+(2-deep)*120, 400 + 40*i);
      text(" : "+res, 90+(2-deep)*120, 400 + 40*i);
    }


    if (deep == 2) {
      fill(200, 200, 255, abs(cos(PI/80*cnt++))*255);
      textSize(30);
      text(Tit.get().name+" to Press Enter Key!!", 120, 250);
      if (Key.pressed(ENTER)) {
        playDecide();
        deep = 0;
        Scene.to(Tit.get().scene);
        playedit.setScore(score.get(scoreidx));
      }
    }

    fill(255);
    textSize(20);
    text("'J' down\n'K' up\n'H' back\n'L' next", 420, 540);
    fill(#0000ff);
    if (Key.pressed('H'))
      text("\n\n'H back'", 420, 540);
    if (Key.pressed('L'))
      text("\n\n\n'L next'", 420, 540);
    if (Key.pressed('J'))
      text("'J down'", 420, 540);
    if (Key.pressed('K'))
      text("\n'K up'", 420, 540);
  }
}

