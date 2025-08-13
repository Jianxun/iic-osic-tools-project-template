v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
L 7 500 -520 500 -490 {}
B 2 500 -230 1360 -80 {flags=graph,unlocked


ypos1=0
ypos2=2


unity=1


divx=5





dataset=-1
unitx=1
logx=0
logy=0
x1=0
x2=1e-06

y2=4.27916
y1=-1.02083


color=6
node=vin
digital=0






subdivx=1
subdivy=5
divy=3
rainbow=0
xlabmag=1.5
ylabmag=1.2
linewidth_mult=3}
B 2 500 -80 1360 80 {flags=graph,unlocked


ypos1=0
ypos2=2


unity=1


divx=5





dataset=-1
unitx=1
logx=0
logy=0
x1=0
x2=1e-06

y2=4.5
y1=-0.8


color=5
node=asig5v
digital=0






subdivx=1
subdivy=5
divy=3
rainbow=0

ylabmag=1.2
linewidth_mult=3
xlabmag=1.5}
P 7 7 600 -630 600 -580 590 -580 600 -560 610 -580 600 -580 600 -630 {}
P 7 7 420 -510 470 -510 470 -500 490 -510 470 -520 470 -510 420 -510 {}
T {PATH to IO cells ($PDK/$PDK_ROOT/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice)
.include /PATH-TO/gf180mcu_fd_io.spice} 620 -650 0 0 0.4 0.4 { layer=7}
T {If uncommented,
simulation do not work
"time step too small"} 220 -590 0 0 0.4 0.4 { layer=7}
T {This is a simple inverter simulation where it was added some PAD RING cells 
(schematic view) to test them, since they add a lot of passive componentes to 
the netlist. The simulation become sensitive ("time step too small") by 
adding de __cor.} -650 -450 0 0 0.4 0.4 { layer=18}
N 280 110 280 115 {
lab=GND}
N 280 -25 280 35 {
lab=DVDD}
N 340 95 340 115 {
lab=GND}
N 340 -25 340 35 {
lab=VDD}
N 280 115 340 115 {
lab=GND}
N 200 -230 260 -230 {
lab=vin}
N 200 -120 200 -100 {
lab=DVSS}
N 340 115 410 115 {
lab=GND}
N 410 95 410 115 {
lab=GND}
N 410 -10 410 35 {
lab=DVSS}
N 170 95 170 110 {
lab=GND}
N 170 110 280 110 {
lab=GND}
N 170 0 170 35 {
lab=VSS}
N 145 0 170 0 {
lab=VSS}
N 200 -230 200 -180 {
lab=vin}
N 300 -230 310 -230 {
lab=DVDD}
N 310 -260 310 -230 {
lab=DVDD}
N 300 -260 310 -260 {
lab=DVDD}
N 300 -160 310 -160 {
lab=DVSS}
N 310 -160 310 -130 {
lab=DVSS}
N 300 -130 310 -130 {
lab=DVSS}
N 300 -200 300 -190 {
lab=ASIG5V}
N 260 -230 260 -160 {
lab=vin}
N 300 -310 300 -260 {
lab=DVDD}
N 300 -190 440 -190 {
lab=ASIG5V}
N 400 -130 400 -70 {
lab=DVSS}
N 300 -130 300 -70 {
lab=DVSS}
N 280 95 280 110 {
lab=GND}
C {devices/code_shown.sym} -780 -90 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
"}
C {devices/code_shown.sym} 490 -570 0 0 {name=DUT only_toplevel=true
format="tcleval( @value )"
value="
.include $env(PDK_ROOT)/$env(PDK)/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice

*Xc1 DVDD DVSS VDD VSS gf180mcu_fd_io__cor
Xf1 DVDD DVSS VDD VSS gf180mcu_fd_io__fill5
Xf2 DVDD DVSS VDD VSS gf180mcu_fd_io__fill10

Xsup1 DVDD DVSS VSS gf180mcu_fd_io__dvdd
Xsup2 DVDD DVSS VDD gf180mcu_fd_io__dvss

Xa1 ASIG5V DVDD DVSS VDD VSS gf180mcu_fd_io__asig_5p0

"}
C {devices/vsource.sym} 280 65 0 0 {name=V1 value=3.3}
C {devices/gnd.sym} 280 115 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} 280 -5 0 0 {name=p1 sig_type=std_logic lab=DVDD}
C {devices/vsource.sym} 340 65 0 0 {name=V2 value=3.3}
C {devices/lab_wire.sym} 340 -5 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} 200 -150 0 1 {name=Vin value="pulse(0 3.3 50p 50p 50p 0.2u 0.4u)"}
C {devices/capa.sym} 400 -160 0 0 {name=C1
m=1
value=10a
footprint=1206
device="ceramic capacitor"}
C {devices/code_shown.sym} -745 80 0 0 {name=NGSPICE only_toplevel=true
value="

.option klu

.control
 save all
 tran 10n 1u
 
 write inverter_pads_tran.raw

.endc

"}
C {devices/lab_wire.sym} 410 -10 0 0 {name=p3 sig_type=std_logic lab=DVSS}
C {devices/vsource.sym} 170 65 0 0 {name=V3 value=0}
C {devices/lab_wire.sym} 150 0 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} 200 -100 0 0 {name=p7 sig_type=std_logic lab=DVSS}
C {devices/lab_wire.sym} 300 -75 0 0 {name=p9 sig_type=std_logic lab=DVSS}
C {devices/lab_wire.sym} 400 -75 0 0 {name=p11 sig_type=std_logic lab=DVSS}
C {devices/vsource.sym} 410 65 0 0 {name=V4 value=0}
C {devices/lab_wire.sym} 440 -190 0 1 {name=p5 sig_type=std_logic lab=ASIG5V}
C {symbols/nfet_03v3.sym} 280 -160 0 0 {name=M1
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 280 -230 0 0 {name=M2
L=1u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {devices/lab_wire.sym} 300 -305 0 0 {name=p8 sig_type=std_logic lab=DVDD}
C {devices/lab_wire.sym} 220 -230 0 0 {name=p6 sig_type=std_logic lab=vin}
C {devices/launcher.sym} 565 -265 0 0 {name=h1
descr="Load/unload waveforms in graph."
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw
"
}
