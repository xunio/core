if [ "${1}" == "total" ]; then

for dir in js php java cs cpp32 cpp64 neko flash; do
  if [ -d "out/debug/$dir" ]; then
    rm -Rf "out/debug/$dir"
  fi;
done;

fi;

for dir in js php java cs cpp32 cpp64 neko flash; do
  if ! [ -a "out/debug/$dir" ]; then
    mkdir "out/debug/$dir"
  fi;
done;


time haxe build.hxml

if [ "${?}" -gt "0" ]; then
  echo "Build failed";
  exit 255
fi;
