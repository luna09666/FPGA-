module clock(
    input clk,   //clka
    input clr,   //clr为清零信号
    input set1, //set1为调节分钟加1的按键信号
    input set2, //set2为调节时钟钟加1的按键信号
    input set3, //set3为决定数码管显示闹钟时间还是时钟时间的信号
    input set4, //set4为时钟时间是显示小时和分钟，还是分钟与秒钟的信号，因为只有四个数码管不能同时显示时、分、秒
  input set5, //set5为调节分钟加1的拨码开关信号
  input set6, //set6为调节小时加1的拨码开关信号
  input set9,//倒计时
  input set10,//打开闹钟
  input set11,//秒表
    output [6:0] seg7,  //seg7为7段数码管输出驱动信号
    output [3:0] an, //an为4个7段数码管的选通信号，低电平有效
    output dp, //dp为7段数码管的小数点
 output  led1, //led1为判断是否到了整点的信号
    output  led2, //led2为判断当前数码管显示的是闹钟时间还是时钟时间的信号
    output  led3, //led3为判断是否到了闹钟设定时间的信号
    output led4//打开倒计时
    );
    
        wire set7,set8;  //set7,set8是综合按键调节与拨码开关调节时间后的调节信号，由于按键开关调节较繁琐，需要一下一下按，所以增加了拨码开关调节时间
        wire [7:0] qs,qm,qh; //时钟的时、分、秒，以4位BCD8421码表示
        wire [7:0] a_m,a_h;  //闹钟的时、分，以4为BCD8421码表示
        wire [7:0] ds,dm;
        wire [7:0] st_s,st_t;
        wire  [15:0] data;   //四个数码管的显示数据,以4位BCD8421码表示
        wire co3; //闹钟模式引用的分钟模块进位信号，实际上用不到
        assign dp=1'b1;   //不需显示小数点
        fenpin u1(.rst(clr),.clk(clk),.clk_fenpin(clk_1));   //模块实例化，产生1Hz时钟，用于秒钟计数
        fenpin u2(.rst(clr),.clk(clk),.clk_fenpin(clk_3)); //模块实例化，产生1Hz时钟，用于倒计时
        fenpin u3(.rst(clr),.clk(clk),.clk_fenpin(clk_2)); ////模块实例化，产生1Hz时钟，用于秒表秒钟计数
        fenpin #2500_00 u4(.rst(clr),.clk(clk),.clk_fenpin(clk_200)); //模块实例化，通过常量传递产生200Hz时钟，用于数码管的动态扫描显示
        fenpin100 u5(.rst(clr),.clk(clk),.clk_fenpin(clk_100));//模块实例化，产生100Hz时钟，用于秒表毫秒计数
 
  cnt60 u6(clk_1,clr,qs,co1);
  //秒计数模块的实例化；
  cnt60 u7(clk1,clr,qm,co2);
  //分钟计数模块的实例化，以调整后的秒进位的进位信号clk1作为时钟
  cnt24 u8(clk2,clr,qh);
  //小时计数模块的实例化，以调整后的分钟进位信号clk2作为时钟
  assign clk__3=(set9)?clk_3:0;
  assign clk__100=(set11)?clk_100:0;
  assign clk__2=(set11)?clk_2:0;
  cntd60 u9(clk__3,clr,ds);//倒计时秒
  cnt100 u10(clk__100,clr,st_t);//秒表毫秒
  cnt60 u11(clk__2,clr,st_s);//秒表秒

  
  assign set7 = set1 || set5;   //拨码开关与按键均可调节时间
  assign set8 = set2 || set6;
  
  adjust u12(.clk(clk_1),.co1(co1),.co2(co2),.co3(co3),.set1(set7),.set2(set8),.clk1(clk1),.clk2(clk2),.led1(led2),.clk3(clk3),.clk4(clk4));
 //调整时钟时间模块的实例化；
  cnt60 u13(clk3,clr,a_m,co3);  //得到闹钟模式的分
  cnt24 u14(clk4,clr,a_h);  //得到闹钟模式的时
  
  
  
  //整点报时功能
  assign led1= (qm==0)? clk_1:0;  //如果分钟等于0，说明到了整点,led1灯应亮   
  
  //闹钟功能
  assign led2= (set3)? clk_1:0;  //当set3为高电平时说明当前是显示闹钟时间，led2灯应亮
  assign led3= (({qh,qm}=={a_h,a_m})&&(set10))? 1:0;//判断时钟时间是否与闹钟时间一致，若到达闹钟设定时间，LED3灯应亮
  assign led4= (set9)? 1:0;//是否开启倒计时
  
  
  assign data =(set3)? ({a_h,a_m}): ((set4)? ({qh,qm}): ((set9)?{dm,ds}:{(set11)?{st_s,st_t}:{qm,qs}})); //判断数码管应该显示哪个时间
  scan u15(.clk(clk_200),.data(data),.seg7(seg7),.an(an));

endmodule



module fenpin(
    input rst,  //复位信号
    input clk,  //100MHz时钟信号
    output reg clk_fenpin  //1Hz时钟
    );
    
    parameter clk_number=32'd5000_0000;
 reg [31:0] clk_count;  //用于时钟分频的计数变量
 //代表经过50M个原时钟周期后，时钟翻转一次，就产生了1HZ的信号
  always@(posedge clk or posedge rst)
 begin
  if(rst)
  begin
   clk_fenpin<=0;
   clk_count<=0;
  end
  else if(clk_count==clk_number) //经过50M个原时钟周期后，时钟翻转一次，就产生了1HZ的信号
  begin
   clk_count<=0;
   clk_fenpin<=~clk_fenpin;
  end
  else
   clk_count<=clk_count+1; //记来了多少个100MHz时钟
 end

endmodule

module fenpin100(
    input rst,  //复位信号
    input clk,  //100MHz时钟信号
    output reg clk_fenpin  //1Hz时钟
    );
    
    parameter clk_number=32'd500000;
 reg [31:0] clk_count;  //用于时钟分频的计数变量
 //代表经过50M个原时钟周期后，时钟翻转一次，就产生了1HZ的信号
  always@(posedge clk or posedge rst)
 begin
  if(rst)
  begin
   clk_fenpin<=0;
   clk_count<=0;
  end
  else if(clk_count==clk_number) //经过50M个原时钟周期后，时钟翻转一次，就产生了1HZ的信号
  begin
   clk_count<=0;
   clk_fenpin<=~clk_fenpin;
  end
  else
   clk_count<=clk_count+1; //记来了多少个100MHz时钟
 end

endmodule

module cnt60(
    input clk,
    input clr,
    output reg [7:0] q,
    output reg c
    );
//clr为清零信号
//clk为时钟信号，用于秒计数时，时钟信号应为1Hz脉冲信号，用于时钟的分钟计数时，时钟信号应为经校正后的秒钟进位信号，用于闹钟的分钟计数时，时钟信号应为校正信号。
  //q为秒钟/分钟计数器的输出，因为要在数码管上译码显示，所以以BCD码形式表示
  //c为分钟向小时的进位信号或者秒钟向分钟的进位信号
  always @(posedge clk or posedge clr)
  begin
  if (clr)  //clr为高电平时，信号清零
   q<=0;
  else if (q[7:4]!=4'b0101)  //秒钟/分钟的高位不为5时
   begin
    if (q[3:0]==4'b1001)//高位不为5，低位不是9的话，低位+1
     begin
     q[7:4]<=q[7:4]+1; q[3:0]<=4'b0000;c<=1'b0;
     end
     //高位不为5，低位为9时，时钟到来后，高位加1,低位变为0
    else 
     begin
     q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;c<=1'b0;
     //低位不为9时，时钟到来后，低位加1，高位不变
     end
   end
  else  //秒钟/分钟的高位为5时
   if (q[3:0]==4'b1001)
    begin
    q[7:4]<=4'b0000; q[3:0]<=4'b0000;c<=1'b1;
    end
    //59的下一个状态时00
   else
    begin
    q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1;c<=1'b0;
    end //低位不为9时，下一时刻低位加1，高位不变
 end
endmodule

module cntd60(
    input clk,
    input clr,
    output reg [7:0] q
    );
//clr为清零信号
//clk为时钟信号，用于秒计数时，时钟信号应为1Hz脉冲信号，用于时钟的分钟计数时，时钟信号应为经校正后的秒钟进位信号，用于闹钟的分钟计数时，时钟信号应为校正信号。
  //q为秒钟/分钟计数器的输出，因为要在数码管上译码显示，所以以BCD码形式表示
  //c为分钟向小时的进位信号或者秒钟向分钟的进位信号
  always @(posedge clk or posedge clr)
  begin
  if (clr)  //clr为高电平时
   q<=8'b01011001;
  else if (q[7:4]!=4'b0000)  //秒钟/分钟的高位不为0时
   begin
    if (q[3:0]!=4'b0000)//低位不为0时，时钟到来后，低位减1，高位不变
     begin
     q[3:0]<=q[3:0]-1;  q[7:4]<=q[7:4];
     end
     //高位不为0，低位为0时，时钟到来后，高位减1,低位变为9
    else 
     begin
     q[7:4]<=q[7:4]-1; q[3:0]<=4'b1001;
     
     end
   end
  else  //秒钟/分钟的高位为0时
   if (q[3:0]==4'b0000)
    begin
    q[7:4]<=4'b0101; q[3:0]<=4'b1001;
    end
    //00的下一个状态时59
   else
    begin
    q[7:4]<=q[7:4]; q[3:0]<=q[3:0]-1;
    end //低位不为0时，下一时刻低位减1，高位不变
 end
endmodule


module cnt24(
    input clk,
    input clr,
    output reg [7:0] q
    );
    
    //clk时钟信号；
  //q为小时计数器的输出，因为要在数码管上显示所以以BCD码形式表示
 always @(posedge clk or posedge clr)
  begin
  if (clr) //清零信号高电平时清零
   q<=0;
  else if (q[7:4]!=4'b0010)  //时钟的高位不为2时
   begin
    if (q[3:0]==4'b1001)
     begin
     q[7:4]<=q[7:4]+1; q[3:0]<=4'b0000;
     end
     //时钟低位为9时，时钟到来后，高位加1,低位变为0
    else 
     begin
     q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;
     //低位不为9时，时钟到来后，低位加1，高位不变
     end
   end
  else  //时钟的高位为2时
   if (q[3:0]==4'b0011)
    begin
    q[7:4]<=4'b0000; q[3:0]<=4'b0000;
    end
    //23小时的下一个状态时00时，否则就+1
   else
    begin
    q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;
    end
 end

endmodule

module cnt100(
    input clk,
    input clr,
    output reg [7:0] q
    );
    
    //clk时钟信号；
  //q为小时计数器的输出，因为要在数码管上显示所以以BCD码形式表示
 always @(posedge clk or posedge clr)
  begin
  if (clr) //清零信号高电平时清零
   q<=0;
  else if (q[7:4]!=4'b1001)  //时钟的高位不为9时
   begin
    if (q[3:0]==4'b1001)
     begin
     q[7:4]<=q[7:4]+1; q[3:0]<=4'b0000;
     end
     //时钟低位为9时，时钟到来后，高位加1,低位变为0
    else 
     begin
     q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;
     //低位不为9时，时钟到来后，低位加1，高位不变
     end
   end
  else  //时钟的高位为9时
   if (q[3:0]==4'b1001)
    begin
    q[7:4]<=4'b0000; q[3:0]<=4'b0000;
    end
    //99的下一个状态时00时，否则就+1
   else
    begin
    q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;
    end
 end

endmodule

module adjust(
    input clk,   //1Hz时钟信号，当按下调时/分按键时，每过一秒就增加1小时/分钟
    input co1,   //秒钟向分钟的进位信号
    input co2,  //分钟向时钟的进位信号
    input co3,   //秒钟向分钟的进位信号
    input co4,  //分钟向时钟的进位信号
    input set1,   //调节分钟的进位信号
    input set2, //调节时钟的进位信号
 input led1,   //判断是处于闹钟调整还是时钟调整的信号
 input led2,
    output  clk1,  //调整后时钟模式的分钟的时钟
    output clk2, //调整后时钟模式的小时的时钟
 output  clk3, //闹钟的分钟的时钟
 output  clk4 //闹钟的小时的时钟
    );
    
assign clk1 = (set1&&!led1)? clk:co1;
  assign clk2 = (set2&&!led1)? clk:(!set1&&co2);
  assign clk3 = (set1&&led1)? clk:clk3;
  assign clk4 = (set2&&led1)? clk:clk4;
  //当led为高电平时调整的是闹钟时间，否则调整的是时钟时间
  //set1为高电平时实现校分，即在set1为高电平时，每过一秒加一分钟，set1为低电平时正常记时
  //set2为高电平时实现校时，且对于时钟计数时要保证校分导致的分钟进位不影响小时

endmodule


module scan(
    input wire clk,
    input wire[15:0] data,
    output reg [6:0] seg7,
    output reg [3:0] an
    );
    
    //clk为数码管的扫描时钟，为使显示做到同时输出的效果必须以大于30次每秒的速度依次显示
  //data为四个数码管的显示数据（计数器输出的BCD8421码）
  reg [1:0] q; //定义选择变量，用来选择哪个数码管显示数据以及显示哪个数据
  reg [3:0] d; //定义显示数据的寄存器，数码管要显示的就是这个数据
  always @(posedge clk)  //动态扫描，使选择变量随时钟的来到而改变，从而依次选择要显示的数码管以及数据
  begin
   q<=q+1; //选择变量每经过一个时钟信号就加1，实现动态扫描
  end
  always @(posedge clk)
  begin
  case(q)  //case后不同情况分别显示时分、、和分秒
  2'b00:d=data[15:12];
  2'b01:d=data[11:8];
  2'b10:d=data[7:4];
  2'b11:d=data[3:0];
  default d=data[3:0];
  endcase
  case(q) 
  2'b00:an=4'b0111; 
  2'b01:an=4'b1011; 
  2'b10:an=4'b1101; 
  2'b11:an=4'b1110; 
  default an=4'b1110; 
  endcase
  end
   always@(d)  //七段数码管的BCD译码
  begin
  case(d)
  4'b0000:seg7=7'b1000000;
  4'b0001:seg7=7'b1111001;
  4'b0010:seg7=7'b0100100;
  4'b0011:seg7=7'b0110000;
  4'b0100:seg7=7'b0011001;
  4'b0101:seg7=7'b0010010;
  4'b0110:seg7=7'b0000010;
  4'b0111:seg7=7'b1111000;
  4'b1000:seg7=7'b0000000;
  4'b1001:seg7=7'b0010000;


  default: seg7=7'b1000000;
  endcase
  end

endmodule