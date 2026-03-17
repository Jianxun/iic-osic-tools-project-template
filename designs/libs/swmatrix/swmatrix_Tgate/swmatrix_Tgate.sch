v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
T {3.3V Devices
New sizing 2025/11/23 should give 50 Ohm resistance nominal} 105 -465.625 0 0 0.3 0.3 {}
N -140 -130 -100 -130 {
lab=gated_control}
N -60 -190 -60 -160 {
lab=T2}
N -60 -90 -60 -70 {
lab=T1}
N -60 -90 110 -90 {
lab=T1}
N -60 -100 -60 -90 {
lab=T1}
N -60 -160 110 -160 {
lab=T2}
N 110 -100 110 -90 {
lab=T1}
N 150 -130 240 -130 {
lab=gated_controlb}
N -60 -130 -20 -130 {lab=VSSd}
N 45 -130 110 -130 {lab=VDDd}
N 45 3.75 60 3.75 {lab=VDDd}
N 45 -130 45 3.75 {lab=VDDd}
N -20 -130 -20 -6.25 {lab=VSSd}
N -100 -6.25 -20 -6.25 {lab=VSSd}
N -136.25 -301.875 -96.875 -301.875 {lab=control}
N -136.25 -261.875 -96.875 -261.875 {lab=enable}
N 23.125 -281.875 37.5 -281.875 {lab=#net1}
N 117.5 -281.875 121.875 -281.875 {lab=gated_control}
N 121.875 -281.875 183.75 -281.875 {lab=gated_control}
C {iopin.sym} -60 -70 0 1 {name=p1 lab=T1}
C {iopin.sym} -60 -190 0 0 {name=p2 lab=T2}
C {iopin.sym} 60 3.75 0 0 {name=p9 lab=VDDd
}
C {iopin.sym} -100 -6.25 0 1 {name=p10 lab=VSSd
}
C {symbols/nfet_03v3.sym} -80 -130 2 1 {name=M1
L=0.28u
W=48u
nf=6
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
C {symbols/pfet_03v3.sym} 130 -130 0 1 {name=M2
L=0.28u
W=144u
nf=18
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
C {gf180mcu_fd_sc_mcu9t5v0/inv_1.sym} 223.75 -281.875 0 0 {name=x1 VGND=VSSd VNB=VDDd VPB=VSSd VPWR=VDDd prefix=gf180mcu_fd_sc_mcu9t5v0__ }
C {lab_wire.sym} 263.75 -281.875 1 0 {name=p14 sig_type=std_logic lab=gated_controlb}
C {lab_wire.sym} 240 -130 0 1 {name=p7 sig_type=std_logic lab=gated_controlb
}
C {lab_wire.sym} -140 -130 0 0 {name=p5 sig_type=std_logic lab=gated_control}
C {gf180mcu_fd_sc_mcu9t5v0/nand2_1.sym} -36.875 -281.875 0 0 {name=x2 VGND=VSSd VNB=VDDd VPB=VSSd VPWR=VDDd prefix=gf180mcu_fd_sc_mcu9t5v0__ }
C {ipin.sym} -136.25 -301.875 0 0 {name=p4 lab=control}
C {ipin.sym} -136.25 -261.875 0 0 {name=p6 lab=enable}
C {gf180mcu_fd_sc_mcu9t5v0/inv_1.sym} 77.5 -281.875 0 0 {name=x3 VGND=VSSd VNB=VDDd VPB=VSSd VPWR=VDDd prefix=gf180mcu_fd_sc_mcu9t5v0__ }
C {lab_wire.sym} 122.5 -281.875 1 0 {name=p8 sig_type=std_logic lab=gated_control}
