tput clear
tput cup 2 2
echo X

paddleLeft=50
scoreLeft=0
scoreRight=0
paddleRight=50
ballx=50
bally=50
speedx=1
speedy=1

update() {
	echo hi
}

render() {
	echo ho
}

main() {
	while(true); do
		update
		render
		sleep 0.1
	done;
}

main
