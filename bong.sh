tput clear

paddleLeft=20
scoreLeft=0
scoreRight=0
paddleRight=20
paddleLen=3
paddleColor=0
ballX=0
ballY=0
speedX=1
speedY=1

width=100
height=30

top=0
bottom=29
left=0
right=99

gameOver=0
winner=0

iteration=0
iterationOld=0




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
	
	# update color
	if [ $iteration -ge $((iterationOld+10)) ]; then
		iterationOld=$iteration
		paddleColor=$(((paddleColor+1)%7))
	fi

	# left paddle 
	tput setab $paddleColor
	for (( pX=$paddleLeft; pX < $((paddleLeft+paddleLen)); pX++ ))
	do
		tput cup $pX 0
		echo " "
	done
	
	# right paddle 
	tput setab 7
	for (( pX=$paddleLeft; pX < $((paddleLeft+paddleLen)); pX++ ))
	do
		tput cup $pX $right
		echo " "
	done

	# ball
	tput setab 3
	echo $ballX $ballY
	#tput cup $ballX $ballY
	echo " "

        tput setab 0
}

main() {
	while(true); do
		update
		render
		let iteration=iteration+1
		echo $iteration
		sleep 0.5
	done;
}

main
