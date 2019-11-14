#!/bin/sh

CGO_HOME=$(pwd)

souper_prec=$CGO_HOME/scratch/precision/souper
souper_build=$CGO_HOME/scratch/precision/souper/build
souper=$souper_build/souper
souper_check=$souper_build/souper-check
souper2llvm=$souper_build/souper2llvm-precision-test
souper2llvm_db=$souper_build/souper2llvm-db

llvm_build=$souper_prec/third_party/llvm/Release/bin
llvm_as=$llvm_build/llvm-as

kb_test_cases=$CGO_HOME/section-4.2
souper_kb_arg="-infer-known-bits"
llvm_kb_arg="-print-known-at-return"

power_test_cases=$CGO_HOME/section-4.3
souper_power_arg="-infer-power-two"
llvm_power_arg="-print-power-two-at-return"

db_test_cases=$CGO_HOME/section-4.4
souper_db_arg="-infer-demanded-bits"
llvm_db_arg="-print-demanded-bits-from-harvester"

range_test_cases=$CGO_HOME/section-4.5
souper_range_arg="-infer-range -souper-range-max-precise "
llvm_range_arg="-print-range-at-return -souper-range-max-tries=300"

z3_path=$CGO_HOME/third_party/z3-install/bin/z3
SOUPER_SOLVER="-z3-path=$z3_path"

echo "===========================================";
echo " Evaluation: (Known bits) Section 4.2 ";
echo "===========================================";
echo

for i in `ls $kb_test_cases/known*.opt`; do
    echo "---------------------";
    echo "Test: $i";
    echo "---------------------";
    cat "$i";
    $souper_check $SOUPER_SOLVER $souper_kb_arg $i;
    $souper2llvm < $i | $llvm_as | $souper $SOUPER_SOLVER $llvm_kb_arg;
    echo;
    echo;
done

echo "===========================================";
echo " Evaluation: (Power of two) Section 4.3 ";
echo "===========================================";
echo

for i in `ls $POWER_TEST_CASES/power*.opt`; do
    echo "---------------------";
    echo "Test: $i";
    echo "---------------------";
    cat "$i";
    $souper_check $SOUPER_SOLVER $souper_power_arg $i;
    $souper2llvm < $i | $llvm_as | $souper $SOUPER_SOLVER $llvm_power_arg;
    echo;
    echo;
done

echo "===========================================";
echo " Evaluation: (Demanded bits) Section 4.4 ";
echo "===========================================";
echo

for i in `ls $DEMANDED_TEST_CASES/demanded*.opt`; do
    echo "---------------------";
    echo "Test: $i";
    echo "---------------------";
    cat "$i";
    $souper_check $SOUPER_SOLVER $souper_db_arg $i;
    $souper2llvm_db < $i | $llvm_as | $souper $SOUPER_SOLVER $llvm_db_arg;
    echo;
    echo;
done

echo "===========================================";
echo " Evaluation: (Range) Section 4.5 ";
echo "===========================================";
echo

for i in `ls $RANGE_TEST_CASES/range*.opt`; do
    echo "---------------------";
    echo "Test: $i";
    echo "---------------------";
    cat "$i";
    $souper_check $SOUPER_SOLVER $souper_range_arg $i;
    $souper2llvm < $i | $llvm_as | $souper $SOUPER_SOLVER $llvm_range_arg;
    echo;
    echo;
done

