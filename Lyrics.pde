// machiko

class Lyrics {
  String [] lines;
  float  [] time;

  Lyrics(String fileName) {
    lines = loadStrings(fileName);
    time = new float[lines.length/2];
    for (i=0; i<time.length; i++) {
      time[i] = float(lines[i*2+1]);
    }
  }

  String word(int Time) {
    for (i=0; i<(time.length)-1; i++) {
      if (Time>=time[i]*20 && Time<time[i+1]*20) {
        return lines[i*2];
      }
    }
    if (Time>=time[time.length-1]*20) {
      return lines[lines.length-2];
    }
    return "";
  }
}