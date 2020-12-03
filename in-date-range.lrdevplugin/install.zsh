datelib=datesplitter-lua

if [[ -d $datelib/src ]] then 
  print Cleaning up before install
  files=$(ls date-splitter-lua/src | grep *.lua)
  rm $files
  rm -rf $datelib
else
  print Nothing clean up, installing
fi


git clone git@github.com:herrklaseen/datesplitter-lua.git

cp $datelib/src/*.lua .

## rm -rf datesplitter-lua

