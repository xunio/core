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

cd tests
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
