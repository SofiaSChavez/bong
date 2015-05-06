tput clear

paddleLeft=20
scoreLeft=0
scoreRight=0
paddleRight=20
paddleLen=3
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

score1=0
score2=0

gameOver=0
winner=0

update() {
	# Test whether ball collides with wall
	if [ $ballX -eq $left ]; then
		speedX=1
		((score1++))
	elif [ $ballX -eq $right ]; then
		speedX=-1
		((score2++))
	fi
	
	if [ $ballY -eq $top ]; then
		speedY=1
	elif [ $ballY -eq $bottom ]; then
		speedY=-1
	fi

	# Test whether somebody loses
	if [ $ballX -eq $left ]; then
		if [ $ballY -lt $paddleLeft ] && [ $ballY -gt $((paddleLeft + paddleLen)) ]; then
			speedX=1
		else
			gameOver=1
			winner=1
		fi
	elif [ $ballX -eq $width ]; then
		if [ $ballY -lt $paddleRight ] && [ $ballY -gt $((paddleRight + paddleLen)) ]; then
			speedX=-1
		else
			gameOver=1
			winner=0
		fi
	fi
	
	let ballX=ballX+speedX
	let ballY=ballY+speedY
}

render() {
	# left paddle 
	tput setab 7
	for (( pX=$paddleLeft; pX < $(($paddleLeft+$paddleLen)); pX++ ))
	do
		tput cup $pX 0
		echo "$pX"
	done
	
	# right paddle 
	tput setab 7
	for (( pX=$paddleLeft; pX < $(($paddleLeft+$paddleLen)); pX++ ))
	do
		tput cup $pX $right
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
