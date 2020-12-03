datelib=datesplitter-lua

if [[ -d $datelib/src ]] then 
  print Cleaning up before install
  files=($datelib/src/*.lua)

  print Deleting:
  for file in $files;
  do rm -v ${file##"$datelib/src/"};
  done;
  print Done deleting

  rm -rf $datelib
else
  print Nothing clean up, installing
fi

git clone git@github.com:herrklaseen/datesplitter-lua.git

cp $datelib/src/*.lua .

sourceFiles=($datelib/src/*.lua)
files=()

for file in $sourceFiles
do 
  files+=(${file##"$datelib/src/"})
done

print Removing \'src.\' from require calls to reflect new location of source files. 

for file in $files 
do
  sed -E -e "s/(require.*[\"'])src\./\1/" -i '' $file
done
