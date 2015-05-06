tput clear
tput cup 2 2
echo X

paddleLeft=50
scoreLeft=0
scoreRight=0
paddleRight=50
ballX=50
ballY=50
speedX=1
speedY=1

width=50
height=50

top=0
bottom=49
left=0
right=49

gameOver=0
winner=0

update() {
	# Test whether ball collides with wall
	if [ $ballX -eq $left ]; then
		speedX=1
	#else if [ $ballX -eq $right ]; then
		speedX=-1
	fi
	
	if [ $ballY -eq $top ]; then
		speedY=1
	elif [ $ballY -eq $bottom ]; then
		speedY=-1
	fi

	# Test whether Player 1 loses
	if [ $ballX -eq $left ]; then
		gameOver=1
		winner=1
	elif [ $ballX -eq $width ]; then
		gameOver=1
		winner=0
	fi
	
	let ballX=ballX+speedX
	let ballY=ballY+speedY
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
