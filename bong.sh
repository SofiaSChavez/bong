trap "stty $(stty -g)" EXIT

tput civis -- invisible
stty -echo -icanon -icrnl time 0 min 0

paddleLeft=20
scoreLeft=0
scoreRight=0
paddleRight=20
paddleLen=3
paddleColor=1
ballX=2
ballY=2
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

iteration=0
iterationOld=0

run=1


status() {
	local y=$((lines - 1))
	tput cup $y 0
	echo $1
}

update() {
	local key=$(cat -v)
	echo $key
	
	if [ "$key" = "q" ]; then
		run = 0
	fi
		
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
	
	if [ $gameOver -eq 1 ]; then
		status "Game Over"
	else
		let ballX=ballX+speedX
		let ballY=ballY+speedY
	fi
}

render() {
	tput clear

	# update color
	if [ $iteration -ge $((iterationOld+10)) ]; then
		iterationOld=$iteration
		paddleColor=$(((paddleColor+1)%6+1))
	fi

	# left paddle 
	tput setab $paddleColor
	for (( pY=$paddleLeft; pY < $((paddleLeft+paddleLen)); pY++ ))
	do
		tput cup $pY 0
		echo " "
	done
	
	# right paddle 
	for (( pY=$paddleLeft; pY < $((paddleLeft+paddleLen)); pY++ ))
	do
		tput cup $pY $right
		echo " "
	done

	# ball
	tput setab 3
	#echo $ballX $ballY
	tput cup $ballY $ballX
	echo " "

        tput setab 0
}

main() {

	while [ $run -eq 1 ]; do
		update
		render
		let iteration=iteration+1
		#sleep 0.1
	done;
}


main
tput cnorm -- normal
