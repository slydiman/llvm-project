; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=aarch64-eabi -mattr=+sve2 < %s | FileCheck %s

define float @add_f32(<vscale x 8 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: add_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fadd z0.s, z0.s, z1.s
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    fadd z0.s, z0.s, z2.s
; CHECK-NEXT:    faddv s0, p0, z0.s
; CHECK-NEXT:    // kill: def $s0 killed $s0 killed $z0
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fadd.f32.nxv8f32(float -0.0, <vscale x 8 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fadd.f32.nxv4f32(float -0.0, <vscale x 4 x float> %b)
  %r = fadd fast float %r1, %r2
  ret float %r
}

;define float @fmul_f32(<vscale x 8 x float> %a, <vscale x 4 x float> %b) {
;  %r1 = call fast float @llvm.vector.reduce.fmul.f32.nxv8f32(float 1.0, <vscale x 8 x float> %a)
;  %r2 = call fast float @llvm.vector.reduce.fmul.f32.nxv4f32(float 1.0, <vscale x 4 x float> %b)
;  %r = fmul fast float %r1, %r2
;  ret float %r
;}

define float @fmin_f32(<vscale x 8 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fmin_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    fminnm z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    fminnm z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    fminnmv s0, p0, z0.s
; CHECK-NEXT:    // kill: def $s0 killed $s0 killed $z0
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fmin.nxv8f32(<vscale x 8 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float> %b)
  %r = call float @llvm.minnum.f32(float %r1, float %r2)
  ret float %r
}

define float @fmax_f32(<vscale x 8 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fmax_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    fmaxnm z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    fmaxnm z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    fmaxnmv s0, p0, z0.s
; CHECK-NEXT:    // kill: def $s0 killed $s0 killed $z0
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fmax.nxv8f32(<vscale x 8 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float> %b)
  %r = call float @llvm.maxnum.f32(float %r1, float %r2)
  ret float %r
}

define float @fminimum_f32(<vscale x 8 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fminimum_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    fmin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    fminv s1, p0, z2.s
; CHECK-NEXT:    fminv s0, p0, z0.s
; CHECK-NEXT:    fminnm s0, s0, s1
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fminimum.nxv8f32(<vscale x 8 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fminimum.nxv4f32(<vscale x 4 x float> %b)
  %r = call float @llvm.minnum.f32(float %r1, float %r2)
  ret float %r
}

define float @fmaximum_f32(<vscale x 8 x float> %a, <vscale x 4 x float> %b) {
; CHECK-LABEL: fmaximum_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    fmax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    fmaxv s1, p0, z2.s
; CHECK-NEXT:    fmaxv s0, p0, z0.s
; CHECK-NEXT:    fmaxnm s0, s0, s1
; CHECK-NEXT:    ret
  %r1 = call fast float @llvm.vector.reduce.fmaximum.nxv8f32(<vscale x 8 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fmaximum.nxv4f32(<vscale x 4 x float> %b)
  %r = call float @llvm.maxnum.f32(float %r1, float %r2)
  ret float %r
}


define i32 @add_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: add_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add z0.s, z0.s, z1.s
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    add z0.s, z0.s, z2.s
; CHECK-NEXT:    uaddv d0, p0, z0.s
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.add.i32.nxv8i32(<vscale x 8 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.add.i32.nxv4i32(<vscale x 4 x i32> %b)
  %r = add i32 %r1, %r2
  ret i32 %r
}

define i16 @add_ext_i16(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: add_ext_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z2.h, z0.b
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpkhi z3.h, z1.b
; CHECK-NEXT:    uunpklo z1.h, z1.b
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    add z0.h, z0.h, z2.h
; CHECK-NEXT:    add z1.h, z1.h, z3.h
; CHECK-NEXT:    add z0.h, z0.h, z1.h
; CHECK-NEXT:    uaddv d0, p0, z0.h
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %ae = zext <vscale x 16 x i8> %a to <vscale x 16 x i16>
  %be = zext <vscale x 16 x i8> %b to <vscale x 16 x i16>
  %r1 = call i16 @llvm.vector.reduce.add.i16.nxv16i16(<vscale x 16 x i16> %ae)
  %r2 = call i16 @llvm.vector.reduce.add.i16.nxv16i16(<vscale x 16 x i16> %be)
  %r = add i16 %r1, %r2
  ret i16 %r
}

define i16 @add_ext_v32i16(<vscale x 32 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: add_ext_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z3.h, z1.b
; CHECK-NEXT:    uunpklo z4.h, z0.b
; CHECK-NEXT:    uunpkhi z1.h, z1.b
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    uunpkhi z5.h, z2.b
; CHECK-NEXT:    uunpklo z2.h, z2.b
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    add z0.h, z0.h, z1.h
; CHECK-NEXT:    add z1.h, z4.h, z3.h
; CHECK-NEXT:    add z0.h, z1.h, z0.h
; CHECK-NEXT:    add z1.h, z2.h, z5.h
; CHECK-NEXT:    add z0.h, z0.h, z1.h
; CHECK-NEXT:    uaddv d0, p0, z0.h
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %ae = zext <vscale x 32 x i8> %a to <vscale x 32 x i16>
  %be = zext <vscale x 16 x i8> %b to <vscale x 16 x i16>
  %r1 = call i16 @llvm.vector.reduce.add.i16.nxv32i16(<vscale x 32 x i16> %ae)
  %r2 = call i16 @llvm.vector.reduce.add.i16.nxv16i16(<vscale x 16 x i16> %be)
  %r = add i16 %r1, %r2
  ret i16 %r
}

;define i32 @mul_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
;  %r1 = call i32 @llvm.vector.reduce.mul.i32.nxv8i32(<vscale x 8 x i32> %a)
;  %r2 = call i32 @llvm.vector.reduce.mul.i32.nxv4i32(<vscale x 4 x i32> %b)
;  %r = mul i32 %r1, %r2
;  ret i32 %r
;}

define i32 @and_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: and_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, z1.d
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    andv s0, p0, z0.s
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.and.i32.nxv8i32(<vscale x 8 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.and.i32.nxv4i32(<vscale x 4 x i32> %b)
  %r = and i32 %r1, %r2
  ret i32 %r
}

define i32 @or_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: or_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    orr z0.d, z0.d, z2.d
; CHECK-NEXT:    orv s0, p0, z0.s
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.or.i32.nxv8i32(<vscale x 8 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.or.i32.nxv4i32(<vscale x 4 x i32> %b)
  %r = or i32 %r1, %r2
  ret i32 %r
}

define i32 @xor_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: xor_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor3 z0.d, z0.d, z1.d, z2.d
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    eorv s0, p0, z0.s
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.xor.i32.nxv8i32(<vscale x 8 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.xor.i32.nxv4i32(<vscale x 4 x i32> %b)
  %r = xor i32 %r1, %r2
  ret i32 %r
}

define i32 @umin_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: umin_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    umin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    umin z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    uminv s0, p0, z0.s
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.umin.i32.nxv8i32(<vscale x 8 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.umin.i32.nxv4i32(<vscale x 4 x i32> %b)
  %r = call i32 @llvm.umin.i32(i32 %r1, i32 %r2)
  ret i32 %r
}

define i32 @umax_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: umax_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    umax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    umax z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    umaxv s0, p0, z0.s
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.umax.i32.nxv8i32(<vscale x 8 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.umax.i32.nxv4i32(<vscale x 4 x i32> %b)
  %r = call i32 @llvm.umax.i32(i32 %r1, i32 %r2)
  ret i32 %r
}

define i32 @smin_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: smin_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    sminv s0, p0, z0.s
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.smin.i32.nxv8i32(<vscale x 8 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.smin.i32.nxv4i32(<vscale x 4 x i32> %b)
  %r = call i32 @llvm.smin.i32(i32 %r1, i32 %r2)
  ret i32 %r
}

define i32 @smax_i32(<vscale x 8 x i32> %a, <vscale x 4 x i32> %b) {
; CHECK-LABEL: smax_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z2.s
; CHECK-NEXT:    smaxv s0, p0, z0.s
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %r1 = call i32 @llvm.vector.reduce.smax.i32.nxv8i32(<vscale x 8 x i32> %a)
  %r2 = call i32 @llvm.vector.reduce.smax.i32.nxv4i32(<vscale x 4 x i32> %b)
  %r = call i32 @llvm.smax.i32(i32 %r1, i32 %r2)
  ret i32 %r
}

declare float @llvm.vector.reduce.fadd.f32.nxv8f32(float, <vscale x 8 x float>)
declare float @llvm.vector.reduce.fadd.f32.nxv4f32(float, <vscale x 4 x float>)
declare float @llvm.vector.reduce.fmul.f32.nxv8f32(float, <vscale x 8 x float>)
declare float @llvm.vector.reduce.fmul.f32.nxv4f32(float, <vscale x 4 x float>)
declare float @llvm.vector.reduce.fmin.nxv8f32(<vscale x 8 x float>)
declare float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float>)
declare float @llvm.vector.reduce.fminimum.nxv8f32(<vscale x 8 x float>)
declare float @llvm.vector.reduce.fminimum.nxv4f32(<vscale x 4 x float>)
declare float @llvm.vector.reduce.fmax.nxv8f32(<vscale x 8 x float>)
declare float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float>)
declare float @llvm.vector.reduce.fmaximum.nxv8f32(<vscale x 8 x float>)
declare float @llvm.vector.reduce.fmaximum.nxv4f32(<vscale x 4 x float>)
declare i32 @llvm.vector.reduce.add.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.add.i32.nxv4i32(<vscale x 4 x i32>)
declare i16 @llvm.vector.reduce.add.i16.nxv32i16(<vscale x 32 x i16>)
declare i16 @llvm.vector.reduce.add.i16.nxv16i16(<vscale x 16 x i16>)
declare i32 @llvm.vector.reduce.mul.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.mul.i32.nxv4i32(<vscale x 4 x i32>)
declare i32 @llvm.vector.reduce.and.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.and.i32.nxv4i32(<vscale x 4 x i32>)
declare i32 @llvm.vector.reduce.or.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.or.i32.nxv4i32(<vscale x 4 x i32>)
declare i32 @llvm.vector.reduce.xor.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.xor.i32.nxv4i32(<vscale x 4 x i32>)
declare i32 @llvm.vector.reduce.umin.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.umin.i32.nxv4i32(<vscale x 4 x i32>)
declare i32 @llvm.vector.reduce.umax.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.umax.i32.nxv4i32(<vscale x 4 x i32>)
declare i32 @llvm.vector.reduce.smin.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.smin.i32.nxv4i32(<vscale x 4 x i32>)
declare i32 @llvm.vector.reduce.smax.i32.nxv8i32(<vscale x 8 x i32>)
declare i32 @llvm.vector.reduce.smax.i32.nxv4i32(<vscale x 4 x i32>)
declare float @llvm.minnum.f32(float, float)
declare float @llvm.maxnum.f32(float, float)
declare float @llvm.minimum.f32(float, float)
declare float @llvm.maximum.f32(float, float)
declare i32 @llvm.umin.i32(i32, i32)
declare i32 @llvm.umax.i32(i32, i32)
declare i32 @llvm.smin.i32(i32, i32)
declare i32 @llvm.smax.i32(i32, i32)
