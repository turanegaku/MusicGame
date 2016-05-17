ArrayList<Score> score = new ArrayList<Score>();

public class Score {
  public String name;
  public AudioPlayer song;
  public ArrayList<Note> note;
  public ArrayList<Integer> result = new ArrayList<Integer>();
  public AnalysisBPM ab;

  private File getFile(String dir, String ext) {
    return new File(dataPath(String.format("%s/%s.%s", dir, name, ext)));
  }
  private File getScoreFile() {
    return getFile("score", "sc");
  }
  private File getResultFile() {
    return getFile("result", "rs");
  }

  public void loadScore() {
    File f = getScoreFile();
    if (f.exists()) {
      try {
        ObjectInputStream os = new ObjectInputStream(new FileInputStream(f));
        ab.t += os.readFloat();
        int n=os.readInt();
        for (int i=0; i<n; i++) {
          Note nt=(Note)os.readObject();
          nt.resetMark();
//          println(nt);
          note.add(nt);
        }
        os.close();
      }
      catch(Exception e) {
        e.printStackTrace();
      }
    } else {
      println("NoScore");
    }
  }

  public void saveScore(List<Note> note) {
    this.note.clear();
    this.note.addAll(note);
    File f = getScoreFile();
    try {
      ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream(f));
      os.writeFloat(ab.t);
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

  public void loadResult() {
    File f = getResultFile();
    if (f.exists()) {
      try {
        ObjectInputStream os = new ObjectInputStream(new FileInputStream(f));
        for (int i=0; i<5; i++)
          result.add(os.readInt());

        os.close();
      }
      catch(Exception e) {
        e.printStackTrace();
      }
    } else {
      for (int i=0; i<5; i++)
        result.add(0);
    }
  }

  private void saveResult(float per2) {
    result.add(int(per2*100000));
    Collections.sort(result);
    Collections.reverse(result);

    File f = getResultFile();
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

  public Score(File file) {
    this.name = file.getName();
    this.song = minim.loadFile(file.getPath());
    this.ab = new AnalysisBPM(file);
    note = new ArrayList<Note>();

    loadScore();
    loadResult();
  }
}

