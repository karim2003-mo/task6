import 'package:task6/responsivesize/constants.dart';

class StdPadding{
  double vertical=0;
  double horizontal=0;
  StdPadding({required double screenwidth,required screenheight}){
    vertical=screenheight*0.05;
    horizontal=screenwidth*0.04;
  }
}
class StdMargin{
  double vertical=0;
  double horizontal=0;
  StdMargin({required double screenwidth,required screenheight}){
    vertical=screenheight*0.07;
    horizontal=screenwidth*0.05;
  }
}
class StdFontSize{
  double small=0;
  double medium=0;
  double large=0;
  StdFontSize({required double screenwidth}){
    small=((Constants.MAXWIDTH/screenwidth)+(screenwidth/Constants.MINWIDTH))*(screenwidth/Constants.MINWIDTH)*2;
    medium=((Constants.MAXWIDTH/screenwidth)+(screenwidth/Constants.MINWIDTH))*(screenwidth/Constants.MINWIDTH)*4;
    large=((Constants.MAXWIDTH/screenwidth)+(screenwidth/Constants.MINWIDTH))*(screenwidth/Constants.MINWIDTH)*6;
}}