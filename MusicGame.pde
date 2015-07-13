import ddf.minim.*;
import java.io.*;
import java.util.Collections;

Minim minim;

AudioSnippet swi, dec;

void setup() {
  Key.setApplet(this);
  minim = new Minim(this);

  swi = minim.loadSnippet("se/032-Switch01.mp3");
  dec = minim.loadSnippet("se/decide18.wav");

  size(500, 650);
  textFont(createFont("Buxton Sketch", 40));

  File songs = new File(dataPath("song"));
  for (File f : songs.listFiles ()) {
    score.add(new Score(f.getName(), minim.loadFile(f.getPath())));
    println(f.getName());
  }
}

void playSwitch() {
  swi.rewind();
  swi.play();
}

void playDecide() {
  dec.rewind();
  dec.play();
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

  Key.update();
}

public void mouseWheelMoved(java.awt.event.MouseWheelEvent e) {
  playedit.wheel += e.getWheelRotation();
}

public void keyPressed(java.awt.event.KeyEvent e) {
}

