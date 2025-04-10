//Automatic Washing Machine
//Top module
module auto_washing_machine(clk,reset,door_close,start,filled,detergent_added,cycle_timeout,spin_timeout,door_lock,motor_on,fill_valve_on,drain_valve_on,done,soap_wash,water_wash);
input clk,reset,door_close,start,filled,detergent_added,cycle_timeout,spin_timeout;
output reg door_lock,motor_on,fill_valve_on,drain_valve_on,done,soap_wash,water_wash;
// defining states
parameter check_door= 3'b000;
parameter fill_water= 3'b001;
parameter add_detergent= 3'b010;
parameter cycle= 3'b011;
parameter drain_water= 3'b100;
parameter spin= 3'b101;
//state declaration
reg [2:0]ps,ns;

//sequential block
always@(posedge clk)
begin
if(reset)
ps<= 3'b000;
else
ps<=ns;
end

//combinational block
always@(ps,door_close,start,filled,detergent_added,cycle_timeout,spin_timeout)
begin
case(ps)//case statement
check_door: begin //Check door
if(start==1'b1 && door_close==1'b1)
begin
ns= fill_water;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b0;
water_wash=1'b0;
done=1'b0;
end
else
begin
ns=ps;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b0;
soap_wash=1'b0;
water_wash=1'b0;
done=1'b0;
end
end
fill_water: begin    //Fill_water
if(filled==1'b1)
begin
if(soap_wash==1'b0)
begin
ns=add_detergent;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b0;
done=1'b0;
end
else
begin
ns=cycle;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b1;
done=1'b0;
end
end
else
begin
ns=ps;
motor_on=1'b0;
fill_valve_on=1'b1;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b0;
water_wash=1'b0;
done=1'b0;
end
end
add_detergent: begin   //Add_detergent
if(detergent_added==1'b1)
begin
ns=cycle;
motor_on=1'b1; //motor on
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b0;
done=1'b0;
end
else
begin
ns=ps;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b0;
done=1'b0;
end
end
cycle: begin   //Cycle
if(cycle_timeout==1'b1)
begin
ns=drain_water;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b0;
done=1'b0;
end
else
begin
ns=ps;
motor_on=1'b1;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b0;
done=1'b0;
end
end
drain_water: begin //Drain_water
if(filled==1'b0)
begin
//filled=1'b0;
if(water_wash==1'b0)
begin
ns=fill_water;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b1;
done=1'b0;
end
else
begin
ns=spin;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b1;
done=1'b0;
end
end
else
begin
ns=ps;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b1;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b1;
done=1'b0;
end
end
spin: begin   //Spin
if(spin_timeout==1'b1)
begin
ns=door_close;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b0;
door_lock=1'b0;
soap_wash=1'b0;
water_wash=1'b0;
done=1'b1;
end
else
begin
ns=ps;
motor_on=1'b0;
fill_valve_on=1'b0;
drain_valve_on=1'b1;
door_lock=1'b1;
soap_wash=1'b1;
water_wash=1'b1;
done=1'b0;
end
end
default:    //Default
ns=check_door;
endcase
end
endmodule


module auto_washing_machine_tst();
reg clk,reset,door_close,start,filled,detergent_added,cycle_timeout,spin_timeout;
wire door_lock,motor_on,fill_valve_on,drain_valve_on,done,soap_wash,water_wash;
auto_washing_machine machine1(clk,reset,door_close,start,filled,detergent_added,cycle_timeout,spin_timeout,door_lock,motor_on,fill_valve_on,drain_valve_on,done,soap_wash,water_wash);

initial
begin
clk=1'b1;
reset=1'b1;
door_close=1'b0;
start=1'b0;
filled=1'b0;
detergent_added=1'b0;
cycle_timeout=1'b0;
//drained=1'b0;
spin_timeout=1'b0;
end
always
#5 clk=~clk;
initial
begin
#10 reset=1'b0;
#10 start=1'b1;door_close=1'b1;
#20 filled=1'b1;
#20 detergent_added=1'b1;
#20 cycle_timeout=1'b1;
#20 filled=1'b0; cycle_timeout=1'b0;
#20 filled=1'b1;
#20 cycle_timeout=1'b1;
#20 filled=1'b0;
#20 spin_timeout=1'b1;start=1'b0;door_close=1'b0;

end
initial
begin
$monitor ($time, "status=%b",done);
#500 $stop;
end
endmodule

