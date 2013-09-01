if [ "${1}" == "total" ]; then

for dir in js php cpp32 cpp64 neko flash; do
  if [ -d "out/debug/$dir" ]; then
    rm -Rf "out/debug/$dir"
  fi;
  if [ -a "out/debug/$dir" ]; then
    echo "out/debug/$dir: Not an directory!"
    exit 255;
  fi;
  mkdir "out/debug/$dir"
done;

fi;

time haxe build.hxml

if [ "${?}" -gt "0" ]; then
  echo "Build failed";
  exit 255
fi;
