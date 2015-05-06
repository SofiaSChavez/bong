trap "stty $(stty -g)" EXIT

tput civis -- invisible
stty -echo -icanon -icrnl time 0 min 0

top=5
bottom=29
left=10
right=109

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

laststatus=""

status() {
	laststatus=$1
}

update() {
	local key=$(cat -v)
	echo $key
	
	if [ "$key" = "q" ]; then
		run=0
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
		if [ $ballY -gt $paddleLeft ] && [ $ballY -lt $((paddleLeft + paddleLen)) ]; then
			status "Left paddle"
			speedX=1
		else
			status "Left wall"
			score1=$((++score1))
				#gameOver=1
			winner=1
			speedX=1
			ballX=$((left+(right-left)/2))
		fi
	elif [ $ballX -eq $right ]; then
		if [ $ballY -gt $paddleRight ] && [ $ballY -lt $((paddleRight + paddleLen)) ]; then
			status "Right paddle"
			speedX=-1
		else
			status "Right wall"
			score2=$((++score2))
			#gameOver=1
			winner=0
			speedX=-1
			ballX=$((left+(right-left)/2))
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
	# update color
	if [ $iteration -ge $((iterationOld+10)) ]; then
		iterationOld=$iteration
		paddleColor=$((++paddleColor))
		[ $paddleColor -ge 8 ] && paddleColor=1
	fi

	buffer=$(

	# left paddle 
	tput setab $paddleColor
	for (( pY=$paddleLeft; pY < $((paddleLeft+paddleLen)); pY++ ))
	do
		tput cup $pY $left
		echo " "
	done

	# right paddle 
	for (( pY=$paddleRight; pY < $((paddleRight+paddleLen)); pY++ ))
	do
		tput cup $pY $right
		echo " "
	done

	# ball
	tput setab 1
	tput cup $ballY $ballX
	echo " "

	# score
	tput setab 0
	tput setaf 2
	tput cup 2 40
	echo $score1
	tput cup 2 80
	echo $score2

	tput setab 6
	# corners
	for (( borderY=$((top-1)); borderY <= $((bottom+1)); borderY++ )); do
		if [ $borderY -eq $((top-1)) ] || [ $borderY -eq $((bottom+1)) ]; then
			for (( borderX=$left; borderX <= $right; borderX++ )); do
				tput cup $borderY $borderX
				echo " "
			done
		fi
		tput cup $borderY $((left-1))
		echo " "
		tput cup $borderY $((right+1))
		echo " "
	done

	# show status
	tput setab 3
	tput setaf 0
	tput cup $((lines-3)) 0
	echo $laststatus

	) # end buffer

	tput setab 0
	tput clear
	echo "$buffer"
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
