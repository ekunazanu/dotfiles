echo "name:" && read filename
data="$(cat $filename.json)"
num_elements=$(($(echo "$data" | jq length)-1))

for i in mako sway swaynag swaylock termite
do
	cp ../$i/config.main ../$i/config.$filename
	for j in $(seq 1 $num_elements)
	do
		key=\$$(echo $data | jq -r "keys_unsorted[$j]")
		val=$(echo $data | jq -r ".[keys_unsorted[$j]]")
		sed -i "s/$key/$val/g" ../$i/config.$filename
	done
done
for i in waybar wofi
do
	cp ../$i/style.css.main ../$i/style.css.$filename
	for j in $(seq 1 $num_elements)
	do
		key=\$$(echo $data | jq -r "keys_unsorted[$j]")
		val=$(echo $data | jq -r ".[keys_unsorted[$j]]")
		sed -i "s/$key/$val/g" ../$i/style.css.$filename
	done
done
