name=$(cat colors.json | jq -r '.name')
data=$(cat colors.json | jq -jr 'keys[] as $k | "s/\\$\($k)/\(.[$k])/g; "')

for i in mako swaylock swaynag termite
do
	sed "$data" ../$i/config.main > ../$i/config.$name
	ln -sf ../$i/config.$name ../$i/config
done
for i in waybar wofi
do
	sed "$data" ../$i/style.css.main > ../$i/style.css.$name
	ln -sf ../$i/style.css.$name ../$i/style.css
done
sed "$data" ../sway/config.main > ../sway/config.$name
sed -i "s/include\ config.*/include\ config.$name/" ../sway/config
