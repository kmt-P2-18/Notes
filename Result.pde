//Result.pde
/*
 プレイ後リザルト画面を表示するクラス
 表示する内容はスコア、最大コンボ数、各判定（cool、good、bad）の数、過去の最大スコア、コンボとの差
 ボタンを押すかキーを押すことで曲名、スコア、コンボ数をツイートすることができる
 */
//3-4 Ikeda Tomoki

import java.awt.Desktop;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;

class Result {
  int combo, cool, good, bad, current, time, iStartMillisecond;
  String  title;
  String score;
  int pscore, pcombo;
  boolean finished=false;
  PImage jacket;

  Result(String Dir, int Combo, int[] Count) {
    title=music_title.get(Dir);
    combo=Combo;
    cool=Count[2];
    good=Count[1];
    bad=Count[0];
    score=str((combo*1000)+(cool*4000)+(good*2800));
    //"score.txt"から過去のスコア、コンボ数を取得する
    String [] data=loadStrings(Dir + "/score.txt");
    pscore=int(data[0]);
    pcombo=int(data[1]);
    //スコア、コンボ数が更新されたら"score.txt"に書き込む
    if (int(score)>pscore) {
      data[0]=score;
    }
    if (combo>pcombo) {
      data[1]=str(combo);
    }
    saveStrings("data/" + Dir + "/score.txt", data);
    jacket = loadImage(Dir + "/jacket.png");
  }

  void display(int time) {

    background(0);
    textAlign(LEFT);
    if (time<0) return;

    if (time == 0) {
      result_start.rewind();
      result_start.play();
    }

    if (time == 10) {
      result_score.rewind();
      result_score.play();
    }

    if (time>=10) {
      fill(255);
      textSize(40);
      text("score", 120, 150);
      textSize(120);
      for (int i=0; i<score.length(); i++) {
        if (time>=30+i) {
          if ((time-30)*25<255)
            fill((time-30)*10);
          else fill(255);
          if (score=="1000000") {
            if (250+i*20-(time-30)*20>=250) {
              text(score.charAt(i), 650-(score.length()-i)*80, 250+i*20-(time-30)*20);
            } else {
              text(score.charAt(i), 650-(score.length()-i)*80, 250);
            }
          }
          if (250+i*20-(time-35)*10>=250) {
            text(score.charAt(i), 680-(score.length()-i)*80, 270+i*20-(time-35)*10);
          } else {
            text(score.charAt(i), 680-(score.length()-i)*80, 270);
          }
        }
      }
      if (time>=48) {
        if (int(score)>pscore) {
          textSize(35);
          fill(255, 255, 0);
          text("▲", 505, 320);
          text(str(int(score)-pscore), 540, 320);
        }
      }


      //枠
      stroke(255);
      fill(0);
      rect(230, 420, 300, 150, 15);
      line(240, 460, 500, 460);
      line(240, 510, 500, 510);
      line(240, 560, 500, 560);
      image(jacket, 520, 30, 100, 100);
      fill(255);
      rect(635, 85, 25, 25);
      textSize(30);
      text(title, 672, 110);

      if (time>=53) {
        textSize(35);
        fill(192, 192, 192);
        text("MAX COMBO", 360, 365);
        text(combo, 590, 365);
      }
      if (time>=58) {
        if (combo>pcombo) {
          textSize(25);
          fill(255, 255, 0);
          text("▲"+(int(combo)-pcombo), 575, 405);
        }
      }

      textSize(30);
      if (time>=63) {
        fill(240, 190, 10);
        text("COOL", 240, 450);
        text(cool, 390, 450);
      }

      if (time>=68) {
        fill(100, 240, 100);
        text("GOOD", 240, 500);
        text(good, 390, 500);
      }

      if (time>=73) {
        fill(100, 100, 190);
        text("BAD", 240, 550);
        text(200-(cool+good), 390, 550);
      }

      if (time>=83) {
        text("PUSH", 760, 350);
        image(circle, 730, 350, 150, 150);
        image(tweet, 760, 380, 85, 80);
      }
    }
  }
  //〇ボタンを押すとツイートする
  void buttonPressed(int time) {
      if (buttonPressed[0] != 0){
        tweetScore();
        button.hex = 0;
    }
      else if (button.hex > 0){
        if(time < 90) {
          iStartMillisecond -= 90;
          button.hex = 0;
          return;
        }
        this.finished = true;
      }
  }
  //ツイートする関数
  void tweetScore() {
    try {
      _encodedText_ = URLEncoder.encode(title+"\n"+"Score: "+score+"\n"+"Combo: "+combo+"\n#P演習 #project_MIKO", "UTF-8");
      URI uri = new URI("https://twitter.com/intent/tweet?text=" + _encodedText_);
      desktop.browse(uri);
    }
    catch(URISyntaxException e) {
      e.printStackTrace();
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }
}