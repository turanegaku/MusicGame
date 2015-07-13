import java.io.Serializable;

public class Note implements Comparable<Note>, Serializable {
  public int time, pos;
  transient public Mark mark;
  
  public Note(int t, int p) {
    time = t;
    pos = p;
    resetMark();
  }
  
  public void resetMark(){
    mark = Mark.none;
  }

  public int compareTo(Note other) {
    return this.time - other.time;
  }

  public int hashCode() {
    System.out.println("hash");
    return time;
  }

  public boolean equals(Object o) {
    if (o == null || !(o instanceof Note)) return false;
    Note other = (Note)o;
    return this.time == other.time && this.pos == other.pos;
  }
  
  public String toString(){
    return time+":"+pos;
  }
}

