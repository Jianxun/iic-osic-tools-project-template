v {xschem version=3.4.2 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
B 2 210 -30 830 310 {flags=graph,unlocked


ypos1=0
ypos2=2


unity=1









unitx=1
logx=0
logy=0







color="4 5"
node="vin
asig5v"
digital=0
linewidth_mult=4






subdivy=6

rainbow=0
xlabmag=1
ylabmag=1
x1=0
x2=3.3
y1=0
y2=3.4
divy=5
subdivx=2
divx=5
dataset=0}
P 7 7 310 -420 310 -370 300 -370 310 -350 320 -370 310 -370 310 -420 {}
T {PATH to IO cells ($PDK/$PDK_ROOT/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice)
.include /PATH-TO/gf180mcu_fd_io.spice} 330 -440 0 0 0.4 0.4 { layer=7}
T {This is a simple inverter simulation where it was added some PAD RING cells 
(schematic view) to test them, since they add a lot of passive componentes to 
the netlist. This is a DC simulation, works fine with these PADS} -940 -240 0 0 0.4 0.4 { layer=18}
N -20 300 -20 305 {
lab=GND}
N -20 165 -20 225 {
lab=DVDD}
N 40 285 40 305 {
lab=GND}
N 40 165 40 225 {
lab=VDD}
N -20 305 40 305 {
lab=GND}
N -120 -80 -60 -80 {
lab=vin}
N -120 30 -120 50 {
lab=DVSS}
N 40 305 110 305 {
lab=GND}
N 110 285 110 305 {
lab=GND}
N 110 180 110 225 {
lab=DVSS}
N -130 285 -130 300 {
lab=GND}
N -130 300 -20 300 {
lab=GND}
N -130 190 -130 225 {
lab=VSS}
N -155 190 -130 190 {
lab=VSS}
N -120 -80 -120 -30 {
lab=vin}
N -20 -80 -10 -80 {
lab=DVDD}
N -10 -110 -10 -80 {
lab=DVDD}
N -20 -110 -10 -110 {
lab=DVDD}
N -20 -10 -10 -10 {
lab=DVSS}
N -10 -10 -10 20 {
lab=DVSS}
N -20 20 -10 20 {
lab=DVSS}
N -20 -50 -20 -40 {
lab=ASIG5V}
N -60 -80 -60 -10 {
lab=vin}
N -20 -160 -20 -110 {
lab=DVDD}
N -20 -40 120 -40 {
lab=ASIG5V}
N 80 20 80 80 {
lab=DVSS}
N -20 20 -20 80 {
lab=DVSS}
N -20 285 -20 300 {
lab=GND}
C {devices/code_shown.sym} -970 120 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
"}
C {devices/code_shown.sym} 200 -360 0 0 {name=DUT only_toplevel=true
format="tcleval( @value )"
value="
.include /home/gmaranhao/pdk/gf180mcuC/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice

Xc1 DVDD DVSS VDD VSS gf180mcu_fd_io__cor
Xf1 DVDD DVSS VDD VSS gf180mcu_fd_io__fill5
Xf2 DVDD DVSS VDD VSS gf180mcu_fd_io__fill10

Xsup1 DVDD DVSS VSS gf180mcu_fd_io__dvdd
Xsup2 DVDD DVSS VDD gf180mcu_fd_io__dvss

Xa1 ASIG5V DVDD DVSS VDD VSS gf180mcu_fd_io__asig_5p0

"}
C {devices/vsource.sym} -20 255 0 0 {name=V1 value=3.3}
C {devices/gnd.sym} -20 305 0 0 {name=l1 lab=GND}
C {devices/lab_wire.sym} -20 185 0 0 {name=p1 sig_type=std_logic lab=DVDD}
C {devices/vsource.sym} 40 255 0 0 {name=V2 value=3.3}
C {devices/lab_wire.sym} 40 185 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {devices/vsource.sym} -120 0 0 1 {name=Vin value=0}
C {devices/capa.sym} 80 -10 0 0 {name=C1
m=1
value=10a
footprint=1206
device="ceramic capacitor"}
C {devices/code_shown.sym} -425 120 0 0 {name=NGSPICE only_toplevel=true
value="

.control
 save all
 dc Vin 0 3.3 1m
 
 write inverter_pads_dc.raw

.endc

"}
C {devices/lab_wire.sym} 110 180 0 0 {name=p3 sig_type=std_logic lab=DVSS}
C {devices/vsource.sym} -130 255 0 0 {name=V3 value=0}
C {devices/lab_wire.sym} -150 190 0 0 {name=p4 sig_type=std_logic lab=VSS}
C {devices/lab_wire.sym} -120 50 0 0 {name=p7 sig_type=std_logic lab=DVSS}
C {devices/lab_wire.sym} -20 75 0 0 {name=p9 sig_type=std_logic lab=DVSS}
C {devices/lab_wire.sym} 80 75 0 0 {name=p11 sig_type=std_logic lab=DVSS}
C {devices/vsource.sym} 110 255 0 0 {name=V4 value=0}
C {devices/lab_wire.sym} 120 -40 0 1 {name=p5 sig_type=std_logic lab=ASIG5V}
C {symbols/nfet_03v3.sym} -40 -10 0 0 {name=M1
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
C {symbols/pfet_03v3.sym} -40 -80 0 0 {name=M2
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
C {devices/lab_wire.sym} -20 -155 0 0 {name=p8 sig_type=std_logic lab=DVDD}
C {devices/lab_wire.sym} -100 -80 0 0 {name=p6 sig_type=std_logic lab=vin}
C {devices/launcher.sym} 265 -55 0 0 {name=h1
descr="Load/unload waveforms in graph."
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw dc
"
}
