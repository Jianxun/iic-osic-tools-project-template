v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 170 -170 180 -170 {
lab=DVDD}
N 180 -200 180 -170 {
lab=DVDD}
N 170 -200 180 -200 {
lab=DVDD}
N 170 -100 180 -100 {
lab=DVSS}
N 180 -100 180 -70 {
lab=DVSS}
N 170 -70 180 -70 {
lab=DVSS}
N 170 -140 170 -130 {
lab=A}
N 130 -170 130 -100 {
lab=Y}
N 170 -250 170 -200 {
lab=DVDD}
N 170 -70 170 -10 {
lab=DVSS}
N 50 -140 130 -140 {
lab=Y}
N 170 -140 280 -140 {
lab=A}
C {symbols/nfet_03v3.sym} 150 -100 0 0 {name=M1
L=2u
W=2u
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
C {symbols/pfet_03v3.sym} 150 -170 0 0 {name=M2
L=2u
W=2u
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
C {devices/code_shown.sym} -760 -450 0 0 {name=DUT only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/designs/Chipathon2025_pads/gf180mcu_fd_io.spice

Xbit A CS DVDD DVSS IE OE PAD PD PDRV0 PDRV1 PU SL VDD VSS Y gf180mcu_fd_io__bi_t



"}
C {devices/iopin.sym} -330 -250 0 0 {name=p1 lab=A}
C {devices/iopin.sym} -330 -230 0 0 {name=p2 lab=CS}
C {devices/iopin.sym} -330 -210 0 0 {name=p3 lab=DVDD}
C {devices/iopin.sym} -330 -190 0 0 {name=p4 lab=DVSS}
C {devices/iopin.sym} -330 -170 0 0 {name=p5 lab=IE}
C {devices/iopin.sym} -330 -150 0 0 {name=p6 lab=OE}
C {devices/iopin.sym} -330 -130 0 0 {name=p7 lab=PAD}
C {devices/iopin.sym} -330 -110 0 0 {name=p8 lab=PD}
C {devices/iopin.sym} -330 -90 0 0 {name=p9 lab=PDRV0}
C {devices/iopin.sym} -330 -70 0 0 {name=p10 lab=PDRV1}
C {devices/iopin.sym} -330 -50 0 0 {name=p11 lab=PU}
C {devices/iopin.sym} -330 -30 0 0 {name=p12 lab=SL}
C {devices/iopin.sym} -330 -10 0 0 {name=p13 lab=VDD}
C {devices/iopin.sym} -330 10 0 0 {name=p14 lab=VSS}
C {devices/iopin.sym} -330 30 0 0 {name=p15 lab=Y}
C {devices/lab_wire.sym} 70 -140 0 0 {name=p17 sig_type=std_logic lab=Y}
C {devices/lab_wire.sym} 170 -250 0 0 {name=p18 sig_type=std_logic lab=DVDD}
C {devices/lab_wire.sym} 170 -10 2 1 {name=p19 sig_type=std_logic lab=DVSS}
C {devices/lab_wire.sym} 280 -140 0 1 {name=p20 sig_type=std_logic lab=A}
