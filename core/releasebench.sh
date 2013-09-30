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

for dir in js php java cs cpp32 cpp64 neko flash; do
  if [ -d "out/production/$dir" ]; then
    rm -Rf "out/production/$dir"
  fi;
  if [ -a "out/production/$dir" ]; then
    echo "out/production/$dir: Not an directory!"
    exit 255;
  fi;
  mkdir "out/production/$dir"
done;

./test.sh
if [ "${?}" -gt "0" ]; then
  echo "Could not release. Tests failed!";
  exit 255
fi;

echo "Start release build!";
echo ""
time haxe release.hxml

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
cecho "### C++ 64-bit" $blue
cecho "#####################################################" $blue
if [ -f "./out/production/cpp64/Main" ]; then
time ./out/production/cpp64/Main > /dev/null
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
#./out/production/cpp32/Main

echo ""
cecho "## JS" $blue
cecho "#####################################################" $blue
if [ $(which node) ]; then
time node out/production/js/Main.js > /dev/null
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
time neko out/production/neko/Main.n > /dev/null
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
time php out/production/php/index.php > /dev/null
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
time java -jar ./out/production/java/java.jar > /dev/null
if [ "${?}" -gt "0" ]; then
  cecho "# Java Test failed!" $red
  TESTRESULT=1
else
  cecho "# Java Test ok!" $green
fi;

echo ""
cecho "### C#" $blue
cecho "#####################################################" $blue
time mono ./out/production/cs/bin/cs.exe > /dev/null
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
