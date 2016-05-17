import ddf.minim.*;
import java.io.*;
import java.util.Collections;
import keymanager.Key;

Minim minim;

AudioSample swi, dec;

void setup() {
  Key.setApplet(this);
  minim = new Minim(this);

  swi = minim.loadSample("se/032-Switch01.mp3");
  dec = minim.loadSample("se/decide18.wav");

  size(500, 650);
  textFont(loadFont("BuxtonSketch-40.vlw"));

  File songs = new File(dataPath("song"));
  for (File f : songs.listFiles ()) {
    score.add(new Score(f));
    println(f.getName());
  }
}

void playSwitch() {
  swi.trigger();
}

void playDecide() {
  dec.trigger();
}

void draw() {
  background(10);

  switch(Scene.get()) {
  case Title:
    title.update();
    break;
  case Play:
    playedit.play();
    break;
  case Edit:
    playedit.edit();
    break;
  }
}

public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
  playedit.wheel += e.getWheelRotation();
}

public void keyPressed(java.awt.event.KeyEvent e) {
}

void stop(){
  println(235);
  swi.close();
  dec.close();
  for(Score s:score){
    s.song.close();
  }
  minim.stop();
  
  super.stop();
}
