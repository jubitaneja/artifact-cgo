#!/bin/sh

CGO_HOME=$(pwd)
souper_sound=$CGO_HOME/scratch/soundness/souper
souper_build=$souper_sound/build
souper=$souper_build/souper
souper_check=$souper_build/souper-check
souper2llvm=$souper_build/souper2llvm-precision-test

llvm_build=$souper_sound/third_party/llvm/Release/bin
llvm_as=$llvm_build/llvm-as

z3_path=$souper_sound/third_party/z3-install/bin/z3
SOUPER_SOLVER="-z3-path=$z3_path"

test_case=$CGO_HOME/section-4.7

echo "===========================================";
echo " Evaluation: (Soundness bugs) Section 4.7 ";
echo "===========================================";

echo
echo
echo "----------------------------------------------------------"
echo "Testing Soundness Bug #1 in non-zero dataflow analysis";
echo "----------------------------------------------------------"
echo

cat $test_case/sound1.opt
echo
$souper_check $SOUPER_SOLVER -infer-non-zero $test_case/sound1.opt
echo
$souper2llvm < $test_case/sound1.opt | $llvm_as | $souper $SOUPER_SOLVER -print-non-zero-at-return
echo
echo


echo "----------------------------------------------------------"
echo "Testing Soundness Bug #2 in sign bits dataflow analysis";
echo "----------------------------------------------------------"
echo

cat $test_case/sound2.opt
echo
$souper_check $SOUPER_SOLVER -infer-sign-bits $test_case/sound2.opt
echo
$souper2llvm < $test_case/sound2.opt | $llvm_as | $souper $SOUPER_SOLVER -print-sign-bits-at-return
echo
echo


echo "----------------------------------------------------------"
echo "Testing Soundness Bug #3 in known bits dataflow analysis";
echo "----------------------------------------------------------"
echo

cat $test_case/sound3.opt
echo
$souper_check $SOUPER_SOLVER -infer-known-bits $test_case/sound3.opt
echo
$souper2llvm < $test_case/sound3.opt | $llvm_as | $souper $SOUPER_SOLVER -print-known-at-return
echo
echo

echo "********************************************"
echo "NOTE for reviewers: You will notice that dataflow facts computed by
LLVM compiler are more precise than computed by our tool, Souper. That's
where we detect unsoundness in LLVM's analysis with these examples."
echo "********************************************"
