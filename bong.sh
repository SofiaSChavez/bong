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
