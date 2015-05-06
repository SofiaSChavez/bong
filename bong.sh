trap "stty $(stty -g)" EXIT

tput civis -- invisible
stty -echo -icanon -icrnl time 0 min 0

width=100
height=30

top=5
bottom=29
left=10
right=99

paddleLeft=$((top+(bottom-top)/2))
paddleRight=$((top+(bottom-top)/2))
paddleColor=1
paddleLen=3
scoreLeft=0
scoreRight=0
ballX=$((left+(right-left)/2))
ballY=$((top+(bottom-top)/2))
speedX=1
speedY=1

lines=$(tput lines)
cols=$(tput cols)

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
			score1=$((++score1))
			gameOver=1
			winner=1
		fi
	elif [ $ballX -eq $width ]; then
		if [ $ballY -lt $paddleRight ] && [ $ballY -gt $((paddleRight + paddleLen)) ]; then
			status "Right paddle"
			speedX=-1
		else
			status "Right wall"
			score2=$((++score2))
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
	# score
	tput setab 0
        tput setaf 2
	tput cup 2 33
	echo $score1
	tput cup 2 66
	echo $score2
	
	# corners
	tput setab 6
	tput cup $top $left
	echo " "
	tput cup $top $right
	echo " "
	tput cup $bottom $left
	echo " "
	tput cup $bottom $right
	echo " "

	# update color
	if [ $iteration -ge $((iterationOld+10)) ]; then
		iterationOld=$iteration
		paddleColor=$(((paddleColor+1)%6+1))
	fi

	# left paddle 
	tput setab $paddleColor
	for (( pY=$paddleLeft; pY < $((paddleLeft+paddleLen)); pY++ ))
	do
		tput cup $pY $left
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
	tput cup $ballY $ballX
	echo " "
}

main() {

	while [ $run -eq 1 ]; do
		update
		render
		let iteration=iteration+1
		sleep 0.1
	
		tput setab 0
		tput clear
	done;
}


main
tput cnorm -- normal
