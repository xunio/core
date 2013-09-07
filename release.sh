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

for dir in js php cpp32 cpp64 neko flash; do
  if [ -d "out/release/$dir" ]; then
    rm -Rf "out/release/$dir"
  fi;
  if [ -a "out/release/$dir" ]; then
    echo "out/release/$dir: Not an directory!"
    exit 255;
  fi;
  mkdir "out/release/$dir"
done;

cd test
./test.sh
if [ "${?}" -gt "0" ]; then
  echo "Could not release. Tests failed!";
  exit 255
fi;
cd ..

echo "Start release build!";
echo ""
time haxe release.hxml

if [ "${?}" -gt "0" ]; then
  echo "Build failed";
  exit 255
fi;
