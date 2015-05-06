tput clear
tput cup 2 2
echo X

paddleLeft=50
scoreLeft=0
scoreRight=0
paddleRight=50
paddleLen=3
ballX=50
ballY=50
speedX=1
speedY=1

update() {
	echo hi
}

render() {
	# left paddle 
	tput setab 7
	for (( pX=$paddleLeft; pX < $(($paddleLeft+$paddleLen)); pX++ ))
	do
		#tput cup 0 $pX
		echo "$pX"
	done

	tput setab 0
}

main() {
	while(true); do
		update
		render
		sleep 0.1
	done;
}

main
