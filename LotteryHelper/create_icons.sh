SIZES='16 32 64 128 256 512 1024'
for i in $SIZES
do
convert $1 -resize $i\x$i $i\.png
done
