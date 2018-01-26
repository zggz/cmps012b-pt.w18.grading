#!/usr/bin/bash

SRCDIR=https://raw.githubusercontent.com/legendddhgf/cmps012b-pt.w18.grading/master/pa2
NUMTESTS=3
NUMVERSIONS=2
PNTSPERTEST=10
let MAXPTS=$NUMTESTS*$PNTSPERTEST

if [ ! -e backup ]; then
  echo "WARNING: a backup has been created for you in the \"backup\" folder"
  mkdir backup
fi

cp *.java Makefile backup   # copy all files of importance into backup

for NUM in $(seq 1 $NUMTESTS); do
  curl $SRCDIR/infile$NUM.txt > infile$NUM.txt
  for VERSION in $(seq 1 $NUMVERSIONS); do
  curl $SRCDIR/model-outfile$NUM-$VERSION.txt > model-outfile$NUM-$VERSION.txt
  done
done

curl $SRCDIR/ModelSearchTest.java > ModelSearchTest.java

make

if [ ! -e Search ] || [ ! -x Search ]; then # exist and executable
  echo ""
  echo "Makefile doesn't correctly create Executable!!!"
  echo ""
  rm -f *.class
  javac -Xlint Search.java
  echo "Main-class: Search" > Manifest
  jar cvfm Search Manifest *.class
  rm Manifest
  chmod +x Search
fi

echo ""
echo ""

testArgs=(\
  [0]=""\
  [1]="key happy dictionary"\
  [2]="10 twelve two 2 65 five 6 six nine 1000 onehundred and 1"\
  )

searchtestspassed=$(expr 0)
searchuseseasymethod=$(expr 0)
echo "Please be warned that the following tests discard all output to stdout/stderr"
echo "Search tests: If nothing between '=' signs, then test is passed"
echo "Press enter to continue"
read verbose
for NUM in $(seq 1 $NUMTESTS); do
  rm -f outfile$NUM.txt
  timeout 5 Search infile$NUM.txt ${testArgs[NUM - 1]} &> outfile$NUM.txt >> outfile$NUM.txt
  # ideally print out working version diff
  WORKING_VERSION=-1
  for VERSION in $(seq 1 2); do
    if [ "$WORKING_VERSION" -ne "-1" ]; then
      break
    fi
    diff -bBwu outfile$NUM.txt model-outfile$NUM-$VERSION.txt &> diff$NUM-$VERSION.txt >> diff$NUM-$VERSION.txt
    if [ -e diff$NUM-$VERSION.txt ] && [[ ! -s diff$NUM-$VERSION.txt ]]; then
      WORKING_VERSION=$VERSION
    fi
  done
  echo "Test $NUM:"
  echo "=========="
  if [ "$WORKING_VERSION" -eq "-1" ]; then
    cat diff$NUM-1.txt
  else
    cat diff$NUM-$WORKING_VERSION.txt
    let searchtestspassed+=1
    if [ "$WORKING_VERSION" -ne "1" ]; then
      searchuseseasymethod=$(expr 1)
    fi
  fi
  echo "=========="
  rm -f infile$NUM* *outfile$NUM* diff$NUM*
done

echo ""
echo ""

let searchtestpoints=$PNTSPERTEST*$searchtestspassed-$searchuseseasymethod*10

echo "Passed $searchtestspassed / $NUMTESTS Search tests"
if [ "$searchuseseasymethod" -ne "0" ]; then
  echo "Be aware that your search tests were marked down 10 points for using the easy method"
fi
echo "This gives a total of $searchtestpoints / $MAXPTS points"


echo ""
echo ""

make clean

if [ -e Search ] || [ -e *.class ]; then
  echo "WARNING: Makefile didn't successfully clean all files"
fi

echo ""
echo ""
echo "MergeTests not yet ready"
exit

echo ""

echo "Press Enter To Continue with MergeTest Results"
read verbose

javac ModelMergeTest.java Merge.java
if [ "$verbose" == "v" ]; then
  timeout 5 java ModelMergeTest -v > MergeTest-out.txt &>> MergeTest-out.txt
else
  #timeout 5 java ModelMergeTest > MergeTest-out.txt &>> MergeTest-out.txt
  # because the two tend not to be consistent with each other
  timeout 5 java ModelMergeTest -v > MergeTest-out.txt &>> MergeTest-out.txt
fi

cat MergeTest-out.txt
rm -f MergeTest-out.txt

rm -f *.class ModelMergeTest.java garbage
