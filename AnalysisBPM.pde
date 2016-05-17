import java.io.File;
import java.util.List;

public class BPM implements Comparable<BPM> {
  public float bpm;
  public float r, t;

  public BPM(float bpm, Pair<Float, Float> p) {
    float a = p.first, b = p.second;
    float c = atan2(b, a);
    while (c < 0) c += TWO_PI;

    this.bpm = bpm;
    this.r = sqrt(sq(a) + sq(b));
    this.t = c / (TWO_PI * bpm);
  }

  public int compareTo(BPM o) {
    if (r > o.r) return 1;
    if (r < o.r) return -1;
    return 0;
  }

  public String toString() {
    return String.format("%.1f : v = %.3f, t = %.6f", bpm, r, t);
  }
}

public class AnalysisBPM extends Thread {
  private float rate, s;
  private File file;
  private float[] diff;
  private boolean done=false;
  private BPM[] bpms;
  private BPM rhythm3, rhythm4;
  public int rhythm;
  public float t;

  private final int frame_size = 480;
  private final int bpmMin = 60;
  private final int bpmMax = 240+1;
  
  public AnalysisBPM(File file) {
    super();
    bpms = new BPM[bpmMax - bpmMin];
    this.file = file;
    start();
  }

  private Pair<Float, Float> rbpm(float bpm) {
    float fbpm = bpm/60f;
    float a = 0, b = 0;
    for (int n = 0; n < diff.length; n++) {
      a += diff[n] * cos(TWO_PI * fbpm * n / s);
      b += diff[n] * sin(TWO_PI * fbpm * n / s);
    }

    return new Pair<Float, Float>(a, b);
  }

  public void run() {
    AudioSample sample = minim.loadSample(file.getPath());

    rate = sample.sampleRate();
    s = rate/frame_size;
    float[] l = sample.getChannel(AudioSample.LEFT);
    float[] r = sample.getChannel(AudioSample.RIGHT);

    sample.close();

    int sample_total = l.length;
    int sample_max = sample_total - (sample_total % frame_size);
    int frame_max = sample_max / frame_size;
    diff = new float[frame_max];

    float[] amp = new float[frame_max];
    for (int i = 0; i < amp.length; i++) {
      for (int j = 0; j < frame_size; j++) {
        int idx = i * frame_size + j;
        amp[i] += sq(l[idx] + r[idx]);
      }
      amp[i] /= frame_size;
    }

    for (int i = 0; i < diff.length-1; i++) {
      diff[i] = max(amp[i+1] - amp[i], 0);
    }

    for (int bpm = bpmMin; bpm < bpmMax; bpm++) {
      bpms[bpm - bpmMin] = new BPM(bpm, rbpm(bpm));
    }

    List<BPM> list = java.util.Arrays.asList(bpms);
    Collections.sort(list);
    Collections.reverse(list);
    int cnt = 0;

    rhythm3 = new BPM(bpms[0].bpm/3f, rbpm(bpms[0].bpm/3f));
    rhythm4 = new BPM(bpms[0].bpm/2f, rbpm(bpms[0].bpm/2f));
    rhythm = (rhythm3.compareTo(rhythm4) > 0) ? 3 : 2;
    t += (rhythm3.compareTo(rhythm4) > 0) ? rhythm3.t : rhythm4.t;

    println(file.getName());
    println(bpms[0]);
    println(rhythm3);
    println(rhythm4);
    println();
  }

  public float beatms(int i) {
    return 60000 / bpms[i].bpm;
  }
  public float beatms() {
    return beatms(0);
  }

  public float barms() {
    return 60000 * rhythm / bpms[0].bpm;
  }

  public BPM[] getBPM() {
    return bpms;
  }

  public PImage getImage() {
    PGraphics g = createGraphics(400, 400);
    g.beginDraw();
    g.background(255);
    g.textAlign(CENTER);
    g.stroke(0);
    g.fill(0);

    float max_v = bpms[0].r;
    for (BPM b : bpms) {
      float x = map(b.bpm, bpmMin, bpmMax, 10, g.width-10);
      float v = map(b.r, 0, max_v, 0, g.height - 50);
      g.line(x, height - 20, x, height -20 - v);

      if (b.bpm%10 == 0) {
        g.text(b.bpm, x, height-2);
      }
    }
    g.endDraw();
    return g;
  }
}

