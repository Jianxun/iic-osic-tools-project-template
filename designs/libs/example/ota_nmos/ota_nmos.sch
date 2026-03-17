v {xschem version=3.4.7 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N -70 -120 70 -120 {lab=#net1}
N 10 -50 10 0 {lab=vss}
N -200 0 10 0 {lab=vss}
N -160 -60 -40 -60 {lab=vbn}
N -160 -190 -110 -190 {lab=inp}
N 110 -190 160 -190 {lab=inn}
N -60 -130 60 -130 {lab=vss}
N 10 -130 10 -50 {lab=vss}
N -30 -310 30 -310 {lab=#net2}
N 0 -310 0 -250 {lab=#net2}
N -70 -250 0 -250 {lab=#net2}
N -200 -380 80 -380 {lab=vdd}
N 70 -250 160 -250 {lab=out}
N 0 -120 0 -90 {lab=#net1}
N 0 -30 -0 -0 {lab=vss}
N 0 -60 10 -60 {lab=vss}
N -70 -160 -70 -120 {lab=#net1}
N -60 -190 -60 -130 {lab=vss}
N -70 -190 -60 -190 {lab=vss}
N 70 -160 70 -120 {lab=#net1}
N 60 -190 60 -130 {lab=vss}
N 60 -190 70 -190 {lab=vss}
N 70 -280 70 -220 {lab=out}
N 70 -380 70 -340 {lab=vdd}
N 80 -380 80 -310 {lab=vdd}
N 70 -310 80 -310 {lab=vdd}
N -70 -380 -70 -340 {lab=vdd}
N -80 -380 -80 -310 {lab=vdd}
N -80 -310 -70 -310 {lab=vdd}
N -70 -280 -70 -220 {lab=#net2}
N 220 -50 220 0 {lab=vss}
N 10 0 220 0 {lab=vss}
N 210 -30 210 0 {lab=vss}
N 210 -60 220 -60 {lab=vss}
N 220 -90 220 -50 {lab=vss}
N 210 -90 220 -90 {lab=vss}
N 170 -60 170 -0 {lab=vss}
C {ipin.sym} -160 -190 0 0 {name=p3 lab=inp}
C {ipin.sym} 160 -190 0 1 {name=p4 lab=inn}
C {opin.sym} 160 -250 0 0 {name=p1 lab=out}
C {ipin.sym} -160 -60 0 0 {name=p2 lab=vbn}
C {iopin.sym} -200 0 0 1 {name=p5 lab=vss}
C {iopin.sym} -200 -380 0 1 {name=p6 lab=vdd}
C {symbols/nfet_03v3.sym} -20 -60 0 0 {name=M1
L=0.5u
W=30u
nf=6
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} -90 -190 0 0 {name=M2
L=0.5u
W=30u
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
C {symbols/nfet_03v3.sym} 90 -190 0 1 {name=M3
L=0.5u
W=30u
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
C {symbols/pfet_03v3.sym} 50 -310 0 0 {name=M4
L=0.5u
W=30u
nf=6
m=1*3
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} -50 -310 0 1 {name=M5
L=0.5u
W=30u
nf=6
m=1*3
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 190 -60 0 0 {name=M_DUMMY
L=0.5u
W=30u
nf=6
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
