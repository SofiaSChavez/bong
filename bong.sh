#!/bin/bash

trap "stty $(stty -g)" EXIT
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
	#echo -n $key

	if [ "$key" == "q" ]; then
		run=0
	fi

	local dy=0

	if [ "$key" == *"^[[A"* ]; then
		dy=$((dy-1))
	fi

	if [ "$key" == *"^[[B"* ]; then
		dy=$((dy+1))
	fi

	paddleLeft=$((paddleLeft+dy))

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

fillXY() {
	echo -ne "\033[$1;"$2"f "
}

echoXY() {
	echo -ne "\033[$1;"$2"f"$3
}

clearXY() {
	echo -ne '\0033\0143'

	# hide the cursor
	tput civis -- invisible
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
			fillXY $pY $left
		done

		# right paddle
		for (( pY=$paddleRight; pY < $((paddleRight+paddleLen)); pY++ ))
		do
			fillXY $pY $right
		done

		# ball
		tput setab 1
		fillXY $ballY $ballX

		# score
		tput setab 0
		tput setaf 2
		echoXY 2 40 $score1
		echoXY 2 80 $score2

		# corners
		tput setab 6
		for (( borderY=$((top-1)); borderY <= $((bottom+1)); borderY++ )); do
			if [ $borderY -eq $((top-1)) ] || [ $borderY -eq $((bottom+1)) ]; then
				for (( borderX=$left; borderX <= $right; borderX++ )); do
					fillXY $borderY $borderX
				done
			fi

			fillXY $borderY $((left-1))
			fillXY $borderY $((right+1))
		done

		# show status
		tput setab 3
		tput setaf 0
		echoXY $((lines-3)) 0 $laststatus

	) # end buffer

	tput setab 0
	clearXY
	echo -n $buffer
}

main() {
	while [ $run -eq 1 ]; do
		update
		render
		let iteration=iteration+1
		sleep 0.05
	done;

	clearXY

	# show cursor again
	tput cnorm -- normal
}

main
