//Lyrics.pde
//draw the Lyrics
//1-4-10 Machiko Ogawa

/*
今回のプログラミング演習２では、Lyricsクラスの作成と、動画編集、音楽編集を行いました。
クラスでは、テキストから、表示する歌詞と歌詞の表示したい秒数をテキストから読み込んで、
ゲームプレイ中の時間を取得し、それを条件文に使うことで、タイミングよく流すようにしました。
動画編集では、金子さんの作成した動画素材や画像を組み合わせて、アニメーションや転換を付ける作業を行いました。
また、音楽編集では、もともとの音楽を発表用に編集し、リズムをキープしたまま違和感なく再生できるように編集しました。
また、メニュー画面などに使われている効果音や、プレイ中にボタンを押すと鳴るタップ音なども、
荒川研ゼミでの経験を生かして作成しました。
*/

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