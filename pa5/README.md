# cmps012b-pt.w18/pa5

The following is a set of performance tests to run on your Simulation program.

## Installation

Run the following in your working directory (the directory you wrote your code
in) to get the test script and example input files:

```bash
curl https://raw.githubusercontent.com/legendddhgf/cmps012b-pt.w18.grading/master/pa5/pa5.sh > pa5.sh
chmod +x pa5.sh
```

## Usage

After installation, you can run the script with this line:

```bash
./pa5.sh
```
The tests will include 4 unit tests from ModelDictionaryTest.java which will
provide information on which tests were passed / whether you had an exception
in your code / your final score for the unit tests. You will also be tested on
memory leaks

## Removal

Everything that the script generates or downloads should automatically be
deleted by the script so if you would like to delete all files related to the
script, use the following. Note that the script leaves the backup folder for you
and you may choose to delete it if you like.

```bash
rm -rf pa5.sh backup
```