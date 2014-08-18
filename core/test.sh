#!/bin/bash
#########################################################################################################
#                                                                                                       #
# xun.io                                                                                                #
# Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>                                             #
#                                                                                                       #
# Licensed under GNU Affero General Public License                                                      #
# For full copyright and license information, please see the LICENSE                                    #
# Redistributions of files must retain the above copyright notice.                                      #
#                                                                                                       #
# @author        Maximilian Ruta <mr@xtain.net>                                                         #
# @copyright     Copyright (c) 2013 XTAIN oHG, <https://company.xtain.net>                              #
# @link          http://xun.io/ xun.io Project                                                          #
# @license       http://www.gnu.org/licenses/agpl-3.0.html GNU Affero General Public License            #
#                                                                                                       #
#########################################################################################################

tput sgr0

if [ "${1}" == "total" ]; then

for dir in js php java cs cpp32 cpp64 neko flash; do
  if [ -d "out/test/$dir" ]; then
    rm -Rf "out/test/$dir"
  fi;
done;

fi;

for dir in js php java cs cpp32 cpp64 neko flash; do
  if ! [ -a "out/test/$dir" ]; then
    mkdir "out/test/$dir"
  fi;
  if ! [ -a "out/test/$dir/ndll" ]; then
    mkdir "out/test/$dir/ndll"
  fi;
done;

RUNPWD=$PWD

time haxe test.hxml

#cd ../native/cpp/clipboard && make && cp ./bin/clipboard.ndll $RUNPWD/out/test/cpp64/ndll/clipboard.ndll && cp ./bin/clipboard.ndll $RUNPWD/out/test/neko/ndll/clipboard.ndll
#cd $RUNPWD

if [ "${?}" -gt "0" ]; then
  echo "Build failed";
  exit 255
fi;


TESTRESULT=0

black='\E[30m'
red='\E[31m'
green='\E[32m'
yellow='\E[33m'
blue='\E[34m'
magenta='\E[35m'
cyan='\E[36m'
white='\E[37m'

cecho ()                     # Color-echo.
                             # Argument $1 = message
                             # Argument $2 = color
{
  color=${2:-$black}           # Defaults to black, if not specified.

  echo -ne "$color"
  echo "$1"
  tput sgr0

  return
}

echo ""
echo ""
echo ""
cecho "#####################################################" $blue
cecho "#                                                   #" $blue
cecho "#   Start testing, good luck :)                     #" $blue
cecho "#                                                   #" $blue
cecho "#####################################################" $blue

echo ""
cecho "### C++ 64-bit" $blue
cecho "#####################################################" $blue
if [ -f "./out/test/cpp64/TestingFramework-debug" ]; then
cd ./out/test/cpp64/
if [ "${1}" == "out" ]; then
  time ./TestingFramework-debug > /dev/null
else
  time ./TestingFramework-debug
fi;
cd "${RUNPWD}"
if [ "${?}" -gt "0" ]; then
  cecho "# C++ Test failed!" $red
  TESTRESULT=1
else
  cecho "# C++ Test ok!" $green
fi;
else
  cecho "# C++ Test not available!" $yellow
fi;

#echo "### C++ 32-bit"
#echo "#####################################################"
#./out/test/cpp32/TestingFramework-debug

NODECMD=""
if [ $(which node) ]; then
  NODECMD="node"
else
if [ $(which nodejs) ]; then
  NODECMD="nodejs"
fi
fi

echo ""
cecho "## JS" $blue
cecho "#####################################################" $blue
if [ "${NODECMD}" ]; then
if [ "${1}" == "out" ]; then
  time "${NODECMD}" out/test/js/TestingFramework.js > /dev/null
else
  time "${NODECMD}" out/test/js/TestingFramework.js
fi;
if [ "${?}" -gt "0" ]; then
  cecho "# JS Test failed!" $red
  TESTRESULT=1
else
  cecho "# JS Test ok!" $green
fi;
else
  cecho "# JS Test not available!" $yellow
fi;

echo ""
cecho "## NekoVM" $blue
cecho "#####################################################" $blue
if [ $(which neko) ]; then
cd ./out/test/neko/
if [ "${1}" == "out" ]; then
  time neko TestingFramework.n > /dev/null
else
  time neko TestingFramework.n
fi;
cd "${RUNPWD}"
if [ "${?}" -gt "0" ]; then
  cecho "# NekoVM Test failed!" $red
  TESTRESULT=1
else
  cecho "# NekoVM Test ok!" $green
fi;
else
  cecho "# NekoVM Test not available!" $yellow
fi;

echo ""
cecho "## PHP" $blue
cecho "#####################################################" $blue
if [ $(which php) ]; then
if [ "${1}" == "out" ]; then
  time php out/test/php/index.php > /dev/null
else
  time php out/test/php/index.php
fi;
if [ "${?}" -gt "0" ]; then
  cecho "# PHP Test failed!" $red
  TESTRESULT=1
else
  cecho "# PHP Test ok!" $green
fi;
else
  cecho "# PHP Test not available!" $yellow
fi;

echo ""
cecho "### Java" $blue
cecho "#####################################################" $blue
if [ "${1}" == "out" ]; then
  time java -jar ./out/test/java/java.jar > /dev/null
else
  time java -jar ./out/test/java/java.jar
fi;
if [ "${?}" -gt "0" ]; then
  cecho "# Java Test failed!" $red
  TESTRESULT=1
else
  cecho "# Java Test ok!" $green
fi;

echo ""
cecho "### C#" $blue
cecho "#####################################################" $blue
if [ "${1}" == "out" ]; then
  time mono ./out/test/cs/bin/cs.exe > /dev/null
else
  time mono ./out/test/cs/bin/cs.exe
fi;
if [ "${?}" -gt "0" ]; then
  cecho "# C# Test failed!" $red
  TESTRESULT=1
else
  cecho "# C# Test ok!" $green
fi;

echo ""
cecho "#####################################################" $blue
echo ""
echo ""
if [ "${TESTRESULT}" -gt "0" ]; then
  cecho "Test failed!" $red
  exit ${TESTRESULT}
fi;

cecho "Tests ok!" $green
exit 0
