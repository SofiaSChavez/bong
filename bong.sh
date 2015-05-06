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

lines=$(tput lines)
cols=$(tput cols)

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

status() {
	local y=$((lines - 1))
	tput cup 0 $y
	echo $1
}

update() {
		
	if [ $ballY -eq $top ]; then
		status "Top wall"
		speedY=1
	elif [ $ballY -eq $bottom ]; then
		status "Bottom wall"
		speedY=-1
	fi

	# Test whether somebody loses
	if [ $ballX -eq $left ]; then
		if [ $ballY -lt $paddleLeft ] && [ $ballY -gt $((paddleLeft + paddleLen)) ]; then
			status "Left paddle"
			speedX=1
		else
			status "Left wall"
			gameOver=1
			winner=1
		fi
	elif [ $ballX -eq $width ]; then
		if [ $ballY -lt $paddleRight ] && [ $ballY -gt $((paddleRight + paddleLen)) ]; then
			status "Right paddle"
			speedX=-1
		else
			status "Right wall"
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
