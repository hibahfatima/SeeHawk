import 'dart:async';
import 'dart:io';

class Data {
  double x;
  double y;
  int blinkCount;
  double attentionSpan;
  double timePassed;
  int pagesRead;
  int linesRead;
  double readingSpeed;

  Data(this.x, this.y, this.blinkCount, this.attentionSpan, this.timePassed, this.pagesRead, this.linesRead, this.readingSpeed);
}