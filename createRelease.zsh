libname=in-date-range
lib=$libname.lrdevplugin
releaseDir=$libname.lrplugin
version=x.x.x.x

print Creating release
print - '----------------'
print -

if [[ -d $releaseDir ]] then
  print Removing previous release directory:
  rm -rfv $releaseDir
fi

mkdir $releaseDir

print Copying files:
rsync -rv --exclude=datesplitter-lua --exclude=install.zsh $lib/ $releaseDir

version=$(< $releaseDir/version.txt)

print -
print Packagaing files:

tar cvzf $libname.$version.tar.gz $releaseDir
print 

print Release packaged as: $libname.$version.tar.gz

print Cleaning up...

rm -rf $releaseDir

print Done. 
