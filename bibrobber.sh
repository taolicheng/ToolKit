#!/bin/sh

#BIBTEX extractor

#Usage: $APP searchkeys output_file
#Both list of keys or single key are acceptable

#Currently, only searches on inspirehep and CDS@CERN available
#For inspirehep please provide arXiv number
#For CDS@CERN please provide document number such as CMS-PAS-SUS-14-004

#echo "$1"

#Tag=$(echo $1 | cut -c1)

extractbib(){
	local key=$1
	local file=$2

	echo $key;
	Tag=$(echo $key | cut -c1);
	echo $Tag;

	if [[ $Tag =~ ^[0-9]+$ ]]; then
		eigine="inspirehep.net"
	elif [[ $Tag =~ [A-Z] ]]; then
		eigine="cds.cern.ch"
	else 
		echo "search unavailable!"
		exit 0
	fi

	echo $eigine

	rm bibfile
	#wget -q -O bibfile http://$eigine/search?p=find+eprint+$1\&of=hx
	#wget -q -O bibfile http://$eigine/search?p=find+eprint+$1\&of=hx | sed -i "/<pre>/,/<\/pre>/p"
	wget -q -O bibfile http://$eigine/search?p=$key\&of=hx
	sed -i '1,/<pre>/d' bibfile
	sed -i '/<\/pre>/,$d' bibfile
	cat bibfile >> $file

}


echo "updated on $(date)" >>$2

if [ -f $1 ]; then

	while read line
	do
		extractbib $line $2

	done <$1

else

	extractbib $1 $2
fi

rm bibfile
