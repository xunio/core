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

for dir in js php cpp32 cpp64 neko flash; do
  if [ -d "out/$dir" ]; then
    rm -Rf "out/$dir"
  fi;
  if [ -a "out/$dir" ]; then
    echo "out/$dir: Not an directory!"
    exit 255;
  fi;
  mkdir "out/$dir"
done;

fi;

time haxe test.hxml

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
if [ -f "./out/cpp64/TestRunner-debug" ]; then
time ./out/cpp64/TestRunner-debug
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
#./out/cpp32/TestRunner-debug

echo ""
cecho "## JS" $blue
cecho "#####################################################" $blue
if [ $(which node) ]; then
time node out/js/TestRunner.js
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
time neko out/neko/TestRunner.n
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
time php out/php/index.php
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
cecho "#####################################################" $blue
echo ""
echo ""
if [ "${TESTRESULT}" -gt "0" ]; then
  cecho "Test failed!" $red
  exit ${TESTRESULT}
fi;

cecho "Tests ok!" $green
exit 0
