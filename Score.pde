ArrayList<Score> score = new ArrayList<Score>();

public class Score {
  public String name;
  public AudioPlayer song;
  public ArrayList<Note> note;
  public ArrayList<Integer> result = new ArrayList<Integer>();

  public Score(String name, AudioPlayer song) {
    this.name = name;
    this.song = song;
    note = new ArrayList<Note>();

    File f = new File(dataPath("score/"+name+".sc"));
    if (f.exists())
    try {
      ObjectInputStream os = new ObjectInputStream(new FileInputStream(f));
      int n=os.readInt();
      for (int i=0; i<n; i++) {
        Note nt=(Note)os.readObject();
        nt.resetMark();
        println(nt);
        note.add(nt);
      }
      os.close();
    }
    catch(Exception e) {
      e.printStackTrace();
    }

    f = new File(dataPath("result/"+name+".rs"));
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
}

