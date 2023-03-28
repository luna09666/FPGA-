module clock(
    input clk,   //clka
    input clr,   //clrΪ�����ź�
    input set1, //set1Ϊ���ڷ��Ӽ�1�İ����ź�
    input set2, //set2Ϊ����ʱ���Ӽ�1�İ����ź�
    input set3, //set3Ϊ�����������ʾ����ʱ�仹��ʱ��ʱ����ź�
    input set4, //set4Ϊʱ��ʱ������ʾСʱ�ͷ��ӣ����Ƿ��������ӵ��źţ���Ϊֻ���ĸ�����ܲ���ͬʱ��ʾʱ���֡���
  input set5, //set5Ϊ���ڷ��Ӽ�1�Ĳ��뿪���ź�
  input set6, //set6Ϊ����Сʱ��1�Ĳ��뿪���ź�
  input set9,//����ʱ
  input set10,//������
  input set11,//���
    output [6:0] seg7,  //seg7Ϊ7���������������ź�
    output [3:0] an, //anΪ4��7������ܵ�ѡͨ�źţ��͵�ƽ��Ч
    output dp, //dpΪ7������ܵ�С����
 output  led1, //led1Ϊ�ж��Ƿ���������ź�
    output  led2, //led2Ϊ�жϵ�ǰ�������ʾ��������ʱ�仹��ʱ��ʱ����ź�
    output  led3, //led3Ϊ�ж��Ƿ��������趨ʱ����ź�
    output led4//�򿪵���ʱ
    );
    
        wire set7,set8;  //set7,set8���ۺϰ��������벦�뿪�ص���ʱ���ĵ����źţ����ڰ������ص��ڽϷ�������Ҫһ��һ�°������������˲��뿪�ص���ʱ��
        wire [7:0] qs,qm,qh; //ʱ�ӵ�ʱ���֡��룬��4λBCD8421���ʾ
        wire [7:0] a_m,a_h;  //���ӵ�ʱ���֣���4ΪBCD8421���ʾ
        wire [7:0] ds,dm;
        wire [7:0] st_s,st_t;
        wire  [15:0] data;   //�ĸ�����ܵ���ʾ����,��4λBCD8421���ʾ
        wire co3; //����ģʽ���õķ���ģ���λ�źţ�ʵ�����ò���
        assign dp=1'b1;   //������ʾС����
        fenpin u1(.rst(clr),.clk(clk),.clk_fenpin(clk_1));   //ģ��ʵ����������1Hzʱ�ӣ��������Ӽ���
        fenpin u2(.rst(clr),.clk(clk),.clk_fenpin(clk_3)); //ģ��ʵ����������1Hzʱ�ӣ����ڵ���ʱ
        fenpin u3(.rst(clr),.clk(clk),.clk_fenpin(clk_2)); ////ģ��ʵ����������1Hzʱ�ӣ�����������Ӽ���
        fenpin #2500_00 u4(.rst(clr),.clk(clk),.clk_fenpin(clk_200)); //ģ��ʵ������ͨ���������ݲ���200Hzʱ�ӣ���������ܵĶ�̬ɨ����ʾ
        fenpin100 u5(.rst(clr),.clk(clk),.clk_fenpin(clk_100));//ģ��ʵ����������100Hzʱ�ӣ��������������
 
  cnt60 u6(clk_1,clr,qs,co1);
  //�����ģ���ʵ������
  cnt60 u7(clk1,clr,qm,co2);
  //���Ӽ���ģ���ʵ�������Ե���������λ�Ľ�λ�ź�clk1��Ϊʱ��
  cnt24 u8(clk2,clr,qh);
  //Сʱ����ģ���ʵ�������Ե�����ķ��ӽ�λ�ź�clk2��Ϊʱ��
  assign clk__3=(set9)?clk_3:0;
  assign clk__100=(set11)?clk_100:0;
  assign clk__2=(set11)?clk_2:0;
  cntd60 u9(clk__3,clr,ds);//����ʱ��
  cnt100 u10(clk__100,clr,st_t);//������
  cnt60 u11(clk__2,clr,st_s);//�����

  
  assign set7 = set1 || set5;   //���뿪���밴�����ɵ���ʱ��
  assign set8 = set2 || set6;
  
  adjust u12(.clk(clk_1),.co1(co1),.co2(co2),.co3(co3),.set1(set7),.set2(set8),.clk1(clk1),.clk2(clk2),.led1(led2),.clk3(clk3),.clk4(clk4));
 //����ʱ��ʱ��ģ���ʵ������
  cnt60 u13(clk3,clr,a_m,co3);  //�õ�����ģʽ�ķ�
  cnt24 u14(clk4,clr,a_h);  //�õ�����ģʽ��ʱ
  
  
  
  //���㱨ʱ����
  assign led1= (qm==0)? clk_1:0;  //������ӵ���0��˵����������,led1��Ӧ��   
  
  //���ӹ���
  assign led2= (set3)? clk_1:0;  //��set3Ϊ�ߵ�ƽʱ˵����ǰ����ʾ����ʱ�䣬led2��Ӧ��
  assign led3= (({qh,qm}=={a_h,a_m})&&(set10))? 1:0;//�ж�ʱ��ʱ���Ƿ�������ʱ��һ�£������������趨ʱ�䣬LED3��Ӧ��
  assign led4= (set9)? 1:0;//�Ƿ�������ʱ
  
  
  assign data =(set3)? ({a_h,a_m}): ((set4)? ({qh,qm}): ((set9)?{dm,ds}:{(set11)?{st_s,st_t}:{qm,qs}})); //�ж������Ӧ����ʾ�ĸ�ʱ��
  scan u15(.clk(clk_200),.data(data),.seg7(seg7),.an(an));

endmodule



module fenpin(
    input rst,  //��λ�ź�
    input clk,  //100MHzʱ���ź�
    output reg clk_fenpin  //1Hzʱ��
    );
    
    parameter clk_number=32'd5000_0000;
 reg [31:0] clk_count;  //����ʱ�ӷ�Ƶ�ļ�������
 //������50M��ԭʱ�����ں�ʱ�ӷ�תһ�Σ��Ͳ�����1HZ���ź�
  always@(posedge clk or posedge rst)
 begin
  if(rst)
  begin
   clk_fenpin<=0;
   clk_count<=0;
  end
  else if(clk_count==clk_number) //����50M��ԭʱ�����ں�ʱ�ӷ�תһ�Σ��Ͳ�����1HZ���ź�
  begin
   clk_count<=0;
   clk_fenpin<=~clk_fenpin;
  end
  else
   clk_count<=clk_count+1; //�����˶��ٸ�100MHzʱ��
 end

endmodule

module fenpin100(
    input rst,  //��λ�ź�
    input clk,  //100MHzʱ���ź�
    output reg clk_fenpin  //1Hzʱ��
    );
    
    parameter clk_number=32'd500000;
 reg [31:0] clk_count;  //����ʱ�ӷ�Ƶ�ļ�������
 //������50M��ԭʱ�����ں�ʱ�ӷ�תһ�Σ��Ͳ�����1HZ���ź�
  always@(posedge clk or posedge rst)
 begin
  if(rst)
  begin
   clk_fenpin<=0;
   clk_count<=0;
  end
  else if(clk_count==clk_number) //����50M��ԭʱ�����ں�ʱ�ӷ�תһ�Σ��Ͳ�����1HZ���ź�
  begin
   clk_count<=0;
   clk_fenpin<=~clk_fenpin;
  end
  else
   clk_count<=clk_count+1; //�����˶��ٸ�100MHzʱ��
 end

endmodule

module cnt60(
    input clk,
    input clr,
    output reg [7:0] q,
    output reg c
    );
//clrΪ�����ź�
//clkΪʱ���źţ����������ʱ��ʱ���ź�ӦΪ1Hz�����źţ�����ʱ�ӵķ��Ӽ���ʱ��ʱ���ź�ӦΪ��У��������ӽ�λ�źţ��������ӵķ��Ӽ���ʱ��ʱ���ź�ӦΪУ���źš�
  //qΪ����/���Ӽ��������������ΪҪ���������������ʾ��������BCD����ʽ��ʾ
  //cΪ������Сʱ�Ľ�λ�źŻ�����������ӵĽ�λ�ź�
  always @(posedge clk or posedge clr)
  begin
  if (clr)  //clrΪ�ߵ�ƽʱ���ź�����
   q<=0;
  else if (q[7:4]!=4'b0101)  //����/���ӵĸ�λ��Ϊ5ʱ
   begin
    if (q[3:0]==4'b1001)//��λ��Ϊ5����λ����9�Ļ�����λ+1
     begin
     q[7:4]<=q[7:4]+1; q[3:0]<=4'b0000;c<=1'b0;
     end
     //��λ��Ϊ5����λΪ9ʱ��ʱ�ӵ����󣬸�λ��1,��λ��Ϊ0
    else 
     begin
     q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;c<=1'b0;
     //��λ��Ϊ9ʱ��ʱ�ӵ����󣬵�λ��1����λ����
     end
   end
  else  //����/���ӵĸ�λΪ5ʱ
   if (q[3:0]==4'b1001)
    begin
    q[7:4]<=4'b0000; q[3:0]<=4'b0000;c<=1'b1;
    end
    //59����һ��״̬ʱ00
   else
    begin
    q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1;c<=1'b0;
    end //��λ��Ϊ9ʱ����һʱ�̵�λ��1����λ����
 end
endmodule

module cntd60(
    input clk,
    input clr,
    output reg [7:0] q
    );
//clrΪ�����ź�
//clkΪʱ���źţ����������ʱ��ʱ���ź�ӦΪ1Hz�����źţ�����ʱ�ӵķ��Ӽ���ʱ��ʱ���ź�ӦΪ��У��������ӽ�λ�źţ��������ӵķ��Ӽ���ʱ��ʱ���ź�ӦΪУ���źš�
  //qΪ����/���Ӽ��������������ΪҪ���������������ʾ��������BCD����ʽ��ʾ
  //cΪ������Сʱ�Ľ�λ�źŻ�����������ӵĽ�λ�ź�
  always @(posedge clk or posedge clr)
  begin
  if (clr)  //clrΪ�ߵ�ƽʱ
   q<=8'b01011001;
  else if (q[7:4]!=4'b0000)  //����/���ӵĸ�λ��Ϊ0ʱ
   begin
    if (q[3:0]!=4'b0000)//��λ��Ϊ0ʱ��ʱ�ӵ����󣬵�λ��1����λ����
     begin
     q[3:0]<=q[3:0]-1;  q[7:4]<=q[7:4];
     end
     //��λ��Ϊ0����λΪ0ʱ��ʱ�ӵ����󣬸�λ��1,��λ��Ϊ9
    else 
     begin
     q[7:4]<=q[7:4]-1; q[3:0]<=4'b1001;
     
     end
   end
  else  //����/���ӵĸ�λΪ0ʱ
   if (q[3:0]==4'b0000)
    begin
    q[7:4]<=4'b0101; q[3:0]<=4'b1001;
    end
    //00����һ��״̬ʱ59
   else
    begin
    q[7:4]<=q[7:4]; q[3:0]<=q[3:0]-1;
    end //��λ��Ϊ0ʱ����һʱ�̵�λ��1����λ����
 end
endmodule


module cnt24(
    input clk,
    input clr,
    output reg [7:0] q
    );
    
    //clkʱ���źţ�
  //qΪСʱ���������������ΪҪ�����������ʾ������BCD����ʽ��ʾ
 always @(posedge clk or posedge clr)
  begin
  if (clr) //�����źŸߵ�ƽʱ����
   q<=0;
  else if (q[7:4]!=4'b0010)  //ʱ�ӵĸ�λ��Ϊ2ʱ
   begin
    if (q[3:0]==4'b1001)
     begin
     q[7:4]<=q[7:4]+1; q[3:0]<=4'b0000;
     end
     //ʱ�ӵ�λΪ9ʱ��ʱ�ӵ����󣬸�λ��1,��λ��Ϊ0
    else 
     begin
     q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;
     //��λ��Ϊ9ʱ��ʱ�ӵ����󣬵�λ��1����λ����
     end
   end
  else  //ʱ�ӵĸ�λΪ2ʱ
   if (q[3:0]==4'b0011)
    begin
    q[7:4]<=4'b0000; q[3:0]<=4'b0000;
    end
    //23Сʱ����һ��״̬ʱ00ʱ�������+1
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
    
    //clkʱ���źţ�
  //qΪСʱ���������������ΪҪ�����������ʾ������BCD����ʽ��ʾ
 always @(posedge clk or posedge clr)
  begin
  if (clr) //�����źŸߵ�ƽʱ����
   q<=0;
  else if (q[7:4]!=4'b1001)  //ʱ�ӵĸ�λ��Ϊ9ʱ
   begin
    if (q[3:0]==4'b1001)
     begin
     q[7:4]<=q[7:4]+1; q[3:0]<=4'b0000;
     end
     //ʱ�ӵ�λΪ9ʱ��ʱ�ӵ����󣬸�λ��1,��λ��Ϊ0
    else 
     begin
     q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;
     //��λ��Ϊ9ʱ��ʱ�ӵ����󣬵�λ��1����λ����
     end
   end
  else  //ʱ�ӵĸ�λΪ9ʱ
   if (q[3:0]==4'b1001)
    begin
    q[7:4]<=4'b0000; q[3:0]<=4'b0000;
    end
    //99����һ��״̬ʱ00ʱ�������+1
   else
    begin
    q[7:4]<=q[7:4]; q[3:0]<=q[3:0]+1'b1;
    end
 end

endmodule

module adjust(
    input clk,   //1Hzʱ���źţ������µ�ʱ/�ְ���ʱ��ÿ��һ�������1Сʱ/����
    input co1,   //��������ӵĽ�λ�ź�
    input co2,  //������ʱ�ӵĽ�λ�ź�
    input co3,   //��������ӵĽ�λ�ź�
    input co4,  //������ʱ�ӵĽ�λ�ź�
    input set1,   //���ڷ��ӵĽ�λ�ź�
    input set2, //����ʱ�ӵĽ�λ�ź�
 input led1,   //�ж��Ǵ������ӵ�������ʱ�ӵ������ź�
 input led2,
    output  clk1,  //������ʱ��ģʽ�ķ��ӵ�ʱ��
    output clk2, //������ʱ��ģʽ��Сʱ��ʱ��
 output  clk3, //���ӵķ��ӵ�ʱ��
 output  clk4 //���ӵ�Сʱ��ʱ��
    );
    
assign clk1 = (set1&&!led1)? clk:co1;
  assign clk2 = (set2&&!led1)? clk:(!set1&&co2);
  assign clk3 = (set1&&led1)? clk:clk3;
  assign clk4 = (set2&&led1)? clk:clk4;
  //��ledΪ�ߵ�ƽʱ������������ʱ�䣬�����������ʱ��ʱ��
  //set1Ϊ�ߵ�ƽʱʵ��У�֣�����set1Ϊ�ߵ�ƽʱ��ÿ��һ���һ���ӣ�set1Ϊ�͵�ƽʱ������ʱ
  //set2Ϊ�ߵ�ƽʱʵ��Уʱ���Ҷ���ʱ�Ӽ���ʱҪ��֤У�ֵ��µķ��ӽ�λ��Ӱ��Сʱ

endmodule


module scan(
    input wire clk,
    input wire[15:0] data,
    output reg [6:0] seg7,
    output reg [3:0] an
    );
    
    //clkΪ����ܵ�ɨ��ʱ�ӣ�Ϊʹ��ʾ����ͬʱ�����Ч�������Դ���30��ÿ����ٶ�������ʾ
  //dataΪ�ĸ�����ܵ���ʾ���ݣ������������BCD8421�룩
  reg [1:0] q; //����ѡ�����������ѡ���ĸ��������ʾ�����Լ���ʾ�ĸ�����
  reg [3:0] d; //������ʾ���ݵļĴ����������Ҫ��ʾ�ľ����������
  always @(posedge clk)  //��̬ɨ�裬ʹѡ�������ʱ�ӵ��������ı䣬�Ӷ�����ѡ��Ҫ��ʾ��������Լ�����
  begin
   q<=q+1; //ѡ�����ÿ����һ��ʱ���źžͼ�1��ʵ�ֶ�̬ɨ��
  end
  always @(posedge clk)
  begin
  case(q)  //case��ͬ����ֱ���ʾʱ�֡����ͷ���
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
   always@(d)  //�߶�����ܵ�BCD����
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