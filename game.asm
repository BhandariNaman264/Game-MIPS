##################################################################### #
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Naman Bhandari, 1005727732, bhand102
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed) # - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4 (choose the one the applies)
#   Milestone 1,2,3,4
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features) 
# 1. Increase in difficulty as game progresses. Difficulty can be achieved by making things faster after certain time
# and will keep increasing until max level speed which shows progression in game.
# 2. Enemy ships – some obstacles look different and move in “unnatural”, difficult, or surprising patterns 
# White box: it behaves different from other obstacle and move from top to bottom and if we collide with it game ends
# 3. d. Add “pick-ups” that the ship can pick up (at least 2 types).
# a) Health Maxer: This is a green color box if the user collides with it health gets back to max level.
# b) Spell Bandage: This is a white color box if the user collides with it health gets up by one unit and it repairs ship by working as 
# an bandage
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! #
#  https://play.library.utoronto.ca/83d5a24dfcd420cb8932914cfe0e1278
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well! #
# yes
# Any additional information that the TA needs to know:
# - (write here, if any)
# Spaceship is three buffer unit green box and we can move it using keys
# a -  to move left
# d - to move right
# w - to move up
# s - to move down
# Obstacle is three buffer unit red box and will move from random positions in game
# Enemy ship is of white color box and if user collide with it game ends
# Health Maxer: It is green color one unit buffer box if the user collides with health becomes full
# Spell Bandage: It is white color one unit buffer box if the user collides with it ship repairs and health goes up by one unit
# As the game progress, speed will increase and obstacles, enemy ship and health tools will move fast
# Health Box is at the bottom of the screen and after five collision, spaceship will be out of health and with each collision health 
# will go down by one unit
# By pressing "p" user can restart game first they will see game over screen and then game will be restarted
# When max collisions happen which is 5, game will end and user will see game over screen saying "END"
# #####################################################################

.data 
	
	DISPLAY_WIDTH: .word 32
	DISPLAY_HEIGHT: .word 32
	UNIT_WIDTH: .word 8
	UNIT_HEIGHT: .word 8
	ROW_SHIFT: .word 7
	DISPLAY_BASE_ADDRESS: .word 0x10008000
	SPACESHIP_GREEN_COLOR: .word 0x0000ff00
	OBSTACLE_RED_COLOR: .word 0x00ff0000
	SPACESHIP_START_POSITION: .word 0x10008600
	OBSTACLE_START_POSITION: .word 0x10008500
	BLACK_COLOR: .word 0x00000000
	COLLISION_COLOR: .word 0x00ffff00
	DISPLAY_END_ADDRESS: .word 0x10008000
	COLLISION_COUNTER: .word 0
	COLLISION_COUNTER_MAX: .word 5
	GAME_OVER_COLOR: .word 0x00ffffff
	GAME_OVER_BACKGROUND: .word 0x000000ff
	HEALTH_BACKGROUND_COLOR: .word 0x00ffffff
	HEALTH_COLOR: .word 0x0000ff00
	COUNTER_HEALTH: .word 0
	ENEMY_COLOR: .word 0x00ffffff
	SLEEP_COLOR: .word 0x000000ff
	TIMER_SLEEP: .word 300

	
	


.globl main1

.text

stackSetup:
	# Setting up stack to store values
	
	addi $sp, $sp, -124
	
	lw $t0, SPACESHIP_GREEN_COLOR
	sw $t0, 0($sp)
	lw $t0, OBSTACLE_RED_COLOR
	sw $t0, 4($sp)
	lw $t0, DISPLAY_BASE_ADDRESS
	sw $t0, 8($sp)
	lw $t0, SPACESHIP_START_POSITION
	sw $t0, 12($sp)
	lw $t0, OBSTACLE_START_POSITION
	sw $t0, 16($sp)
	lw $t0, BLACK_COLOR   # BACKGROUND BLACK COLOR
	sw $t0, 20($sp)
	lw $t0, 0x10008250   # OBSTACLE 1 MOVING POSITION
	sw $t0, 24($sp)
	lw $t0, 0x10008350  # OBSTACLE 2 MOVING POSITION
	sw $t0, 28($sp)
	lw $t0, 0x10008450  # OBSTACLE 3 MOVING POSITION
	sw $t0, 32($sp)
	lw $t0, SPACESHIP_START_POSITION  # SPACESHIP CURRENT POSITION 
	sw $t0, 36($sp)
	lw $t0, 0x10008500  # OBSTACLE 4 MOVING POSITION
	sw $t0, 40($sp)
	lw $t0, 0x10008100   # OBSTACLE 1 STARTING POSITION
	sw $t0, 44($sp)
	lw $t0, 0x10008200  # OBSTACLE 2 STARTING POSITION
	sw $t0, 48($sp)
	lw $t0, 0x10008300  # OBSTACLE 3 STARTING POSITION
	sw $t0, 52($sp)
	lw $t0, 0x10008500  # OBSTACLE 4 STARTING POSITION
	sw $t0, 56($sp)
	lw $t0, COLLISION_COLOR  # COLLISION COLOR
	sw $t0, 60($sp)
	lw $t0 DISPLAY_END_ADDRESS
	sw $t0, 64($sp)
	lw $t0 COLLISION_COUNTER
	sw $t0, 68($sp)
	lw $t0 COLLISION_COUNTER_MAX
	sw $t0, 72($sp)
	lw $t0 COLLISION_COUNTER  # Current Counter
	sw $t0, 76($sp)
	lw $t0 GAME_OVER_COLOR	# Game Over Color
	sw $t0, 80($sp)
	lw $t0 GAME_OVER_BACKGROUND  # Game Over Color Background
	sw $t0, 84($sp)
	lw $t0 HEALTH_BACKGROUND_COLOR  # Health Background Color
	sw $t0, 88($sp)
	lw $t0 HEALTH_COLOR  # Health Color
	sw $t0, 92($sp)
	lw $t0, COUNTER_HEALTH
	sw $t0, 96($sp)		# Counter for health change
	lw $t0, ENEMY_COLOR
	sw $t0, 100($sp)	# Enemy Color
	lw $t0, DISPLAY_BASE_ADDRESS
	sw $t0, 104($sp)	# Enemy Current Position
	lw $t0, DISPLAY_BASE_ADDRESS
	sw $t0, 108($sp)	# Health Booster Current Position
	lw $t0, SLEEP_COLOR
	sw $t0, 112($sp)	# Slow sleep color
	lw $t0, DISPLAY_BASE_ADDRESS
	sw $t0, 116($sp)	# sleep tool current Position
	lw $t0, COUNTER_HEALTH
	sw $t0, 120($sp)	# Current to score score 1 or 0
	lw $t0, TIMER_SLEEP
	sw $t0, 124($sp)	# Current to score score 1 or 0


	
	
	
	
	
	
	
	
	
	
	
gameSetup:



	# this is for setting up of game at the begining
	
	#
	jal spaceshipSetup
	jal obstacle1Setup
	jal obstacle2Setup
	jal obstacle3Setup
	#
	jal obstacle4Setup
	jal healthSetup
	jal enemySetup
	jal healthboosterSetup
	jal slowSetup

	#SLEEP
	
	li $v0, 32
	li $a0, 500
	syscall
	j main1
	
slowSetup:

	# This is setting up spell tool at the begining of the game
	
	lw $t7, 8($sp)  # This is for milestone to slow setup
	
	addi $t7, $t7, 108
	

	li $v0, 42
	li $a0, 0
	li $a1, 25
	syscall
	
	li $t0, 128
	
	mult $a0 $t0
	mflo $t0
	
	lw $s1, 16($sp)
	add $t0, $t0, $t7
	
	sw $t0, 116($sp)
	
	lw $t1, 0($sp) 
	
	sw $t1, 0($t0)

	
	jr $ra

	
healthboosterSetup:

	# For boosting health setup

	lw $t7, 8($sp)
	
	addi $t7, $t7, 124
	

	li $v0, 42
	li $a0, 0
	li $a1, 25
	syscall
	
	li $t0, 128
	
	mult $a0 $t0
	mflo $t0
	
	lw $s1, 16($sp)
	add $t0, $t0, $t7
	
	sw $t0, 108($sp)
	
	lw $t1, 0($sp) 
	
	sw $t1, 0($t0)

	
	jr $ra

healthSetup:

	# Health Setup in the game

	lw $t0, 88($sp)	# Health BG 
	lw $t1, 92($sp) # Health
	
	lw $t3, 8($sp)	# Base Address
	
	# line 1
	
	sw $t0, 3584($t3)
	sw $t0, 3588($t3)
	sw $t0, 3592($t3)
	sw $t0, 3596($t3)
	sw $t0, 3600($t3)
	sw $t0, 3604($t3)
	sw $t0, 3608($t3)
	sw $t0, 3612($t3)
	sw $t0, 3616($t3)
	sw $t0, 3620($t3)
	sw $t0, 3624($t3)
	sw $t0, 3628($t3)
	sw $t0, 3632($t3)
	sw $t0, 3636($t3)
	sw $t0, 3640($t3)
	sw $t0, 3644($t3)
	sw $t0, 3648($t3)
	sw $t0, 3652($t3)
	sw $t0, 3656($t3)
	sw $t0, 3660($t3)
	sw $t0, 3664($t3)
	sw $t0, 3668($t3)
	sw $t0, 3672($t3)
	sw $t0, 3676($t3)
	sw $t0, 3680($t3)
	sw $t0, 3684($t3)
	sw $t0, 3688($t3)
	sw $t0, 3692($t3)
	sw $t0, 3696($t3)
	sw $t0, 3700($t3)
	sw $t0, 3704($t3)
	sw $t0, 3708($t3)
	
	# line 2
	
	sw $t0, 3712($t3)
	sw $t0, 3716($t3)
	sw $t0, 3720($t3)
	sw $t0, 3724($t3)
	sw $t0, 3728($t3)
	sw $t0, 3732($t3)
	
	sw $t1, 3736($t3)
	sw $t1, 3740($t3)
	sw $t1, 3744($t3)
	sw $t1, 3748($t3)
	sw $t1, 3752($t3)
	sw $t1, 3756($t3)
	sw $t1, 3760($t3)
	sw $t1, 3764($t3)
	sw $t1, 3768($t3)
	sw $t1, 3772($t3)
	sw $t1, 3776($t3)
	sw $t1, 3780($t3)
	sw $t1, 3784($t3)
	sw $t1, 3788($t3)
	sw $t1, 3792($t3)
	sw $t1, 3796($t3)
	sw $t1, 3800($t3)
	sw $t1, 3804($t3)
	sw $t1, 3808($t3)
	sw $t1, 3812($t3)
	

	sw $t0, 3816($t3)
	sw $t0, 3820($t3)
	sw $t0, 3824($t3)
	sw $t0, 3828($t3)
	sw $t0, 3832($t3)
	sw $t0, 3836($t3)
	
	# line 3
	
	
	sw $t0, 3840($t3)
	sw $t0, 3844($t3)
	sw $t0, 3848($t3)
	sw $t0, 3852($t3)
	sw $t0, 3856($t3)
	sw $t0, 3860($t3)
	
	sw $t1, 3864($t3)
	sw $t1, 3868($t3)
	sw $t1, 3872($t3)
	sw $t1, 3876($t3)
	sw $t1, 3880($t3)
	sw $t1, 3884($t3)
	sw $t1, 3888($t3)
	sw $t1, 3892($t3)
	sw $t1, 3896($t3)
	sw $t1, 3900($t3)
	sw $t1, 3904($t3)
	sw $t1, 3908($t3)
	sw $t1, 3912($t3)
	sw $t1, 3916($t3)
	sw $t1, 3920($t3)
	sw $t1, 3924($t3)
	sw $t1, 3928($t3)
	sw $t1, 3932($t3)
	sw $t1, 3936($t3)
	sw $t1, 3940($t3)
	

	sw $t0, 3944($t3)
	sw $t0, 3948($t3)
	sw $t0, 3952($t3)
	sw $t0, 3956($t3)
	sw $t0, 3960($t3)
	sw $t0, 3964($t3)
	
	
	
	# 4
	
	sw $t0, 3968($t3)
	sw $t0, 3972($t3)
	sw $t0, 3976($t3)
	sw $t0, 3980($t3)
	sw $t0, 3984($t3)
	sw $t0, 3988($t3)
	sw $t0, 3992($t3)
	sw $t0, 3996($t3)
	sw $t0, 4000($t3)
	sw $t0, 4004($t3)
	sw $t0, 4008($t3)
	sw $t0, 4012($t3)
	sw $t0, 4016($t3)
	sw $t0, 4020($t3)
	sw $t0, 4024($t3)
	sw $t0, 4028($t3)
	sw $t0, 4032($t3)
	sw $t0, 4036($t3)
	sw $t0, 4040($t3)
	sw $t0, 4044($t3)
	sw $t0, 4048($t3)
	sw $t0, 4052($t3)
	sw $t0, 4056($t3)
	sw $t0, 4060($t3)
	sw $t0, 4064($t3)
	sw $t0, 4068($t3)
	sw $t0, 4072($t3)
	sw $t0, 4076($t3)
	sw $t0, 4080($t3)
	sw $t0, 4084($t3)
	sw $t0, 4088($t3)
	sw $t0, 4092($t3)
	
	
	jr $ra
	
spaceshipSetup:

	# Setting up the spaceship 
	
	lw $t2, 8($sp) # Display base address
	addi $t0, $t2, 2056

	lw $t1 0($sp) # green color 
	
	sw $t0, 36($sp) # Current location of spaceship
	
	sw $t1 0($t0)
	sw $t1 128($t0)
	sw $t1 256($t0)
	
	
	jr $ra
	
enemySetup:

	# Setting up the enemy in the game
	
	lw $t7, 8($sp)
	


	li $v0, 42
	li $a0, 0
	li $a1, 30
	syscall
	
	li $t0, 4
	
	mult $a0 $t0
	mflo $t0
	
	lw $s1, 16($sp)
	
	add $t0, $t0, $t7
	
	sw $t0, 104($sp)
	
	lw $t1, 100($sp) 
	
	sw $t1, 0($t0)

	
	jr $ra

obstacle1Setup:

	# Obstacle 1 setup
	
	
	lw $t7, 8($sp) #
	
	addi $t7, $t7, 116
	




	li $v0, 42
	li $a0, 0 # 1
	li $a1, 25
	syscall
	
	li $t0, 128
	
	mult $a0 $t0
	mflo $t0
	
	lw $s1, 16($sp)
	
	add $t0, $t0, $t7
	
	sw $t0, 24($sp)
	
	lw $t1, 4($sp) 
	
	sw $t1, 0($t0)
	sw $t1, 128($t0)
	sw $t1, 256($t0)
	
	jr $ra
	
obstacle2Setup:


	# Obstacle 2 setup
	lw $t7, 8($sp)
	
	addi $t7, $t7, 116
	




	li $v0, 42
	li $a0, 0
	li $a1, 25
	syscall
	
	li $t0, 128
	
	mult $a0 $t0
	mflo $t0
	
	lw $s1, 16($sp)
	add $t0, $t0, $t7
	
	sw $t0, 28($sp)
	
	lw $t1, 4($sp) 
	
	sw $t1, 0($t0)
	sw $t1, 128($t0)
	sw $t1, 256($t0)
	
	jr $ra
	
	
obstacle3Setup:

	# Obstacle 3 setup
	
	lw $t7, 8($sp)
	
	addi $t7, $t7, 116
	




	li $v0, 42
	li $a0, 0
	li $a1, 25
	syscall
	
	li $t0, 128
	
	mult $a0 $t0
	mflo $t0
	
	lw $s1, 16($sp)
	add $t0, $t0, $t7
	
	sw $t0, 32($sp)
	
	lw $t1, 4($sp) 
	
	sw $t1, 0($t0)
	sw $t1, 128($t0)
	sw $t1, 256($t0)
	
	jr $ra
	
	
obstacle4Setup:

	# Obstacle 4 setup

	lw $t7, 8($sp)
	
	addi $t7, $t7, 116
	




	li $v0, 42
	li $a0, 0
	li $a1, 25
	syscall
	
	li $t0, 128
	
	mult $a0 $t0
	mflo $t0
	
	lw $s1, 16($sp)
	add $t0, $t0, $t7
	
	sw $t0, 40($sp)
	
	lw $t1, 4($sp) 
	
	sw $t1, 0($t0)
	sw $t1, 128($t0)
	sw $t1, 256($t0)
	
	jr $ra
	
	
enemyShipSetup:

	# enemy ship setup
	
	lw $t7, 8($sp)
	
	addi $t7, $t7, 116
	




	li $v0, 42
	li $a0, 0
	li $a1, 25
	syscall
	
	li $t0, 128
	
	mult $a0 $t0
	mflo $t0
	
	lw $s1, 16($sp)
	add $t0, $t0, $t7
	
	sw $t0, 40($sp)
	
	lw $t1, 4($sp) 
	
	sw $t1, 0($t0)
	sw $t1, 128($t0)
	sw $t1, 256($t0)
	
	jr $ra
	
	
	
	

main1:

	# This is the main funcrion which will be called recursively
	
	jal obstacle1Move
	jal checkcollisionObstacle1
	jal obstacle2Move
	jal checkcollisionObstacle2
	jal obstacle2Move
	jal checkcollisionObstacle2
	jal obstacle3Move
	jal checkcollisionObstacle3
	jal obstacle4Move
	jal checkcollisionObstacle4
	jal enemyMove
	jal enemyCollision
	jal healthMove
	jal healthcollison
	jal sleepMove
	jal sleepcollision
	jal keyboardChecking

	
	lw $t0, 124($sp)
	li $t1, 75
	
	# bge $t0, $t1, sleep
	#Sleeps
	li $v0, 32
	li $a0, 250
	syscall
	
	j main1
	
sleep:
	# This is the function for sleep to complete milestone and as the game proceeds it becomes faster
	
	lw $t2, 124($sp)
	
	li $v0, 32
	move $a0, $t2
	syscall
	
	j main1

	
keyboardChecking:

	# To check keyboard key is pressed or not
	
	li $t0, 0xffff0000
	lw $t1, 0($t0)
	beq $t1, 1, inputChecking
	jr $ra
	
inputChecking:

	# Checking which key is being pressed
	
	lw $t0, 0xffff0004
	lw $t1, 0($sp)	 #Spaceship Color
	lw $t2, 36($sp)  # Current Position
	
	
	lw $t5, 20($sp)  # Black Color
	
	# Checking which key is pressed
	
	beq $t0, 0x77, respond_to_w
	beq $t0, 0x64, respond_to_d
	beq $t0, 0x61, respond_to_a
	beq $t0, 0x73, respond_to_s
	beq $t0, 0x70, respond_to_p
	jr $ra
	
leaveKeyboard:

	# Leaving keyboard

	jr $ra

dummyObject:


	# This is the dummy object which will be used when a key is pressed and we need to swap positions
	# of blocks so as to show it moving

	sw $t5, 0($t2)
	sw $t5, 128($t2)
	sw $t5, 256($t2)


	sw $t3, 36($sp)
	
	
	
	sw $t1, 0($t3)
	sw $t1, 128($t3)
	sw $t1, 256($t3)

	
	jr $ra
	
respond_to_p:

	# This wil respond to KEY "p"
	
	lw $t2, 8($sp)     # contains base address
	
	addi $t3, $t2, 4147
	
	li $t0, 0
	sw $t0, 96($sp)
	sw $t0, 76($sp)

fillBlack:

	# This will be used when user presses "p" and to restart the game we set the screen to black

	bge $t2, $t3, showEnd2

	lw $t1, 20($sp)		# bg color of black
	sw $t1 0($t2)
	
	addi $t2, $t2, 4
	
	j fillBlack

respond_to_a:

	# This wil respond to KEY "a"

	lw $t7, 8($sp)
	
	# Spaceship cant pass the left side of screen
	
	beq $t2, $t7, leaveKeyboard	#1
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#2
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#3
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#4
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#5
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#6
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#7
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#8
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#9
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#10
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#11
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#12
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#13
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#14
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#15
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#16
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#17
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#18
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#19
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#20
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#21
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#22
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#23
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#24
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#25
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#26
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#27
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#28
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#29
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#30
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#31
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#32
	


	addi $t3, $t2, -4
	move $s1 $ra
	jal dummyObject
	move $ra, $s1
	li $v0, 32
	li $a0, 20
	syscall 
	j leaveKeyboard

respond_to_d:

	# This wil respond to KEY "d"
	lw $t7, 8($sp)
	
	addi $t7, $t7, 124
	
	# Spaceship cant pass the right side of screen
	
	beq $t2, $t7, leaveKeyboard	#1
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#2
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#3
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#4
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#5
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#6
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#7
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#8
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#9
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#10
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#11
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#12
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#13
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#14
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#15
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#16
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#17
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#18
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#19
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#20
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#21
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#22
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#23
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#24
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#25
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#26
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#27
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#28
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#29
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#30
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#31
	addi $t7, $t7, 128
	beq $t2, $t7, leaveKeyboard	#32
	

	
	addi $t3, $t2, 4
	lw $t4 0($t3)
	move $s1 $ra
	jal dummyObject
	move $ra $s1
	li $v0, 32
	li $a0, 20
	syscall 
	j leaveKeyboard
	
respond_to_w:
	
	# This wil respond to KEY "w"
	
	lw $t7, 8($sp)
	
	# Spaceship cant pass the top side of screen
	
	beq $t2, $t7, leaveKeyboard	#1
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#2
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#3
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#4
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#5
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#6
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#7
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#8
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#9
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#10
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#11
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#12
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#13
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#14
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#15
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#16
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#17
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#18
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#19
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#20
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#21
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#22
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#23
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#24
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#25
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#26
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#27
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#28
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#29
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#30
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#31
	addi $t7, $t7, 4
	beq $t2, $t7, leaveKeyboard	#32


	
	
	
	
	addi $t3, $t2, -128
	lw $t4, 0($t3)
	move $s1 $ra
	jal dummyObject
	move $ra $s1
	li $v0, 32
	li $a0, 20
	syscall 
	j leaveKeyboard
	
respond_to_s:

	# This wil respond to KEY "s"
	
	lw $t7, 8($sp)
	addi $t7, $t7, 3456
	
	addi $t6, $t2, 256
	
	# Spaceship cant pass the bottom side of screen
	
	beq $t6, $t7, leaveKeyboard	#1
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#2
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#3
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#4
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#5
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#6
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#7
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#8
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#9
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#10
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#11
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#12
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#13
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#14
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#15
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#16
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#17
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#18
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#19
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#20
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#21
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#22
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#23
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#24
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#25
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#26
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#27
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#28
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#29
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#30
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#31
	addi $t7, $t7, 4
	beq $t6, $t7, leaveKeyboard	#32

	
	
	addi $t3, $t2, 128
	lw $t4, 0($t3)
	move $s1 $ra
	jal dummyObject
	move $ra $s1
	li $v0, 32
	li $a0, 20
	syscall 
	j leaveKeyboard
	
	
obstacle1EdgeRemove:


	


	# This is to decrement sleep timing whenever obstacle 1 reaches left end
	lw $s7, 124($sp)
	addi $s7, $s7, -25
	sw $s7, 124($sp)
	
	# When obstacle 1 will reach left end of screen we need to pain it black to match the background color

	lw $t5, 24($sp)
	lw $t6, 20($sp)
	
	
	sw $t6, 0($t5)
	sw $t6, 128($t5)
	sw $t6, 256($t5)
	

	
	
	j obstacle1Setup
	
obstacle2EdgeRemove:

	# When obstacle 2 will reach left end of screen we need to paint it black to match the background color


	lw $t5, 28($sp)
	lw $t6, 20($sp)
	
	
	sw $t6, 0($t5)
	sw $t6, 128($t5)
	sw $t6, 256($t5)
	
	j obstacle2Setup
	
obstacle3EdgeRemove:

	# When obstacle 3 will reach left end of screen we need to pain it black to match the background color


	lw $t5, 32($sp)
	lw $t6, 20($sp)
	
	
	sw $t6, 0($t5)
	sw $t6, 128($t5)
	sw $t6, 256($t5)
	
	j obstacle3Setup
	
obstacle4EdgeRemove:

	# When obstacle 4 will reach left end of screen we need to pain it black to match the background color


	lw $t5, 40($sp)
	lw $t6, 20($sp)
	
	
	sw $t6, 0($t5)
	sw $t6, 128($t5)
	sw $t6, 256($t5)
	
	j obstacle4Setup
	
enemyEdgeRemove:

	# When enemy will reach bottom end of screen we need to pain it black to match the background color


	lw $t5, 104($sp)
	lw $t6, 20($sp)
	
	
	sw $t6, 0($t5)

	
	j enemySetup
	
	
	
	

enemyMove:
	
	# This function will keep moving enemy down untill it reaches bottom end
	
	lw $t2, 104($sp)
	
	lw $t7, 8($sp)
	
	
	
	addi $t7, $t7, 3456
	
	# If spell reaches left end of the screen a new will appear and previous will dissapear
	
	beq $t2, $t7, enemyEdgeRemove	#1
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#2
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#3
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#4
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#5
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#6
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#7
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#8
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#9
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#10
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#11
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#12
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#13
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#14
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#15
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#16
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#17
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#18
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#19
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#20
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#21
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#22
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#23
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#24
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#25
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#26
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#27
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#28
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#29
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#30
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#31
	addi $t7, $t7, 4
	beq $t2, $t7, enemyEdgeRemove	#32
	
	
	
	lw $t1, 100($sp)   # enemy color
	addi $t4, $t2, 128
	lw $t3, 20($sp)  # black
	
	sw $t4, 104($sp)

	sw $t1, 0($t4)
	
	sw $t3, 0($t2)

	
	
	jr $ra

healthEdgeRemove:

	# When health healer will reach left end of screen we need to pain it black to match the background color
	
	lw $t5, 108($sp)
	lw $t6, 20($sp)
	
	
	sw $t6, 0($t5)

	
	j healthboosterSetup
	

	
healthMove:

	# This function will keep moving health towards left until it reaches left end

	lw $t2, 108($sp)
	
	lw $t7, 8($sp)
		
	# If health maxer reaches left end of screen a new one will appear 
	
	beq $t2, $t7, healthEdgeRemove	#1
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#2
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#3
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#4
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#5
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#6
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#7
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#8
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#9
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#10
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#11
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#12
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#13
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#14
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#15
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#16
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#17
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#18
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#19
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#20
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#21
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#22
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#23
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#24
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#25
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#26
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#27
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#28
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#29
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#30
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#31
	addi $t7, $t7, 128
	beq $t2, $t7, healthEdgeRemove	#32
	
	
	lw $t1, 0($sp)   #  green
	addi $t4, $t2, -4
	lw $t3, 20($sp)  # black
	
	sw $t4, 108($sp)

	sw $t1, 0($t4)

	
	sw $t3, 0($t2)

	
	
	jr $ra
	
sleepcollision:

	# This function will check collision of spell with spaceship
	
	lw $t0, 36($sp)
	addi $t1, $t0, 128
	addi $t2, $t0, 256
	
	lw $s1, 116($sp)
	# Minumim collison has to be minimum of 1 for spell to increase health
	beq $t0, $s1, checkZero
	beq $t1, $s1, checkZero
	beq $t2, $s1, checkZero
	
	jr $ra
	
checkZero:

	# This function will check the count of total hit with obstacle and keep it above zero
	lw $t3, 76($sp)
	bgtz $t3, updatehealth
	
	jr $ra
	
updatehealth:

	# This function will increase the health by one unit after spaceship consumes spell
	
	lw $s7, 76($sp)
	addi $t3, $t3, -1
	sw $t3, 76($sp)
	
	lw, $t4, 8($sp)
	
	
	
	addi $t5, $t4, 3812

	addi $t6, $t4, 3940
	
	li $t7, 16
	mult $t3, $t7
	mflo $s2
	
	sub $t5, $t5, $s2	# t5 contain address till which we need to paint green in health bar from starting
	
	
	
	j loophealth
	
	
loophealth:

	# This will fill up the health afer using spell and will show health bar an increase of one unit
	addi $s3, $t4, 3736

	add $s5, $t5, $zero
	
	addi $s0, $t4, 3864

	
fillhealthloop:

	# This function is the continution of the above function and will fill health bar with green color
	
	bgt $s3, $s5, exitloop
	
	lw $s6, 0($sp)
	sw $s6, 0($s3)
	
	addi $s3, $s3, 4
	
	lw $s6, 0($sp)
	sw $s6, 0($s0)
	
	addi $s0, $s0, 4

	
	j fillhealthloop
	
exitloop:


	# After filling health we need to exit the loop and mantain the style of health bar

	lw $t0, 88($sp)	# Health BG 
	lw $t1, 92($sp) # Health
	
	
	
	lw $t3, 8($sp)	# Base Address
	
	sw $t0, 3816($t3)
	sw $t0, 3820($t3)
	sw $t0, 3824($t3)
	sw $t0, 3828($t3)
	sw $t0, 3832($t3)
	sw $t0, 3836($t3)

	

	sw $t0, 3944($t3)
	sw $t0, 3948($t3)
	sw $t0, 3952($t3)
	sw $t0, 3956($t3)
	sw $t0, 3960($t3)
	sw $t0, 3964($t3)
	
	j sleepEdgeRemove
	
healthcollison:


	# This function will check collision of spaceship with full health tool which will increase the health to max level

	lw $t0, 36($sp)
	addi $t1, $t0, 128
	addi $t2, $t0, 256
	
	lw $s1, 108($sp)
	# If collision call fullhealth to make health to max again
	beq $t0, $s1, fullhealth
	beq $t1, $s1, fullhealth
	beq $t2, $s1, fullhealth
	
	jr $ra
	
fullhealth:

	# If collision took place filling health bar to max level

	li $t4, 0
	sw $t4, 76($sp)
	
	sw $t4, 96($sp)
	
	
	
	lw $t5, 8($sp)
	
	lw $t6, 0($sp)
	
	# line 2
	

	
	sw $t6, 3736($t5)
	sw $t6, 3740($t5)
	sw $t6, 3744($t5)
	sw $t6, 3748($t5)
	sw $t6, 3752($t5)
	sw $t6, 3756($t5)
	sw $t6, 3760($t5)
	sw $t6, 3764($t5)
	sw $t6, 3768($t5)
	sw $t6, 3772($t5)
	sw $t6, 3776($t5)
	sw $t6, 3780($t5)
	sw $t6, 3784($t5)
	sw $t6, 3788($t5)
	sw $t6, 3792($t5)
	sw $t6, 3796($t5)
	sw $t6, 3800($t5)
	sw $t6, 3804($t5)
	sw $t6, 3808($t5)
	sw $t6, 3812($t5)
	

	
	# line 3

	sw $t6, 3864($t5)
	sw $t6, 3868($t5)
	sw $t6, 3872($t5)
	sw $t6, 3876($t5)
	sw $t6, 3880($t5)
	sw $t6, 3884($t5)
	sw $t6, 3888($t5)
	sw $t6, 3892($t5)
	sw $t6, 3896($t5)
	sw $t6, 3900($t5)
	sw $t6, 3904($t5)
	sw $t6, 3908($t5)
	sw $t6, 3912($t5)
	sw $t6, 3916($t5)
	sw $t6, 3920($t5)
	sw $t6, 3924($t5)
	sw $t6, 3928($t5)
	sw $t6, 3932($t5)
	sw $t6, 3936($t5)
	sw $t6, 3940($t5)
	
	#removing existance
	
	#lw $t5, 8($sp)
	
	#addi $t5, $t5, 3968
	
	#sw $t5, 108($sp)
	
	#lw $t7, 88($sp)
	
	#sw $t7, 0($t5)
	
	#jr $ra
	
	j healthEdgeRemove
	
sleepEdgeRemove:

	# When spell reaches left side of screen it needs to be fill black and a new spell will enter from a new place
	lw $t5, 116($sp)
	lw $t6, 20($sp)
	
	
	sw $t6, 0($t5)
	
	j slowSetup


	
sleepMove:

	# To move spell towards left we use this function
	lw $t2, 116($sp)
	
	lw $t7, 8($sp)
		
	# On collision with the left screen we call sleepEdgeRemove 
	
	beq $t2, $t7, sleepEdgeRemove	#1
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#2
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#3
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#4
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#5
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#6
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#7
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#8
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#9
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#10
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#11
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#12
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#13
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#14
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#15
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#16
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#17
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#18
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#19
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#20
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#21
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#22
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#23
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#24
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#25
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#26
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#27
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#28
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#29
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#30
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#31
	addi $t7, $t7, 128
	beq $t2, $t7, sleepEdgeRemove	#32
	
	
	lw $t1, 112($sp)   #  blue
	addi $t4, $t2, -4
	lw $t3, 20($sp)  # black
	
	sw $t4, 116($sp)

	sw $t1, 0($t4)

	
	sw $t3, 0($t2)

	
	
	jr $ra
	
obstacle1Move:

	# To move obstacle 1 to the left end of the screen

	lw $t2, 24($sp) # Obstacle Current
	
	lw $t7, 8($sp) # base address
		
	# If obstacle reaches left end of the screen then make it dissapear and a new will appear randomly
	
	beq $t2, $t7, obstacle1EdgeRemove	#1
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#2
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#3
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#4
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#5
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#6
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#7
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#8
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#9
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#10
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#11
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#12
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#13
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#14
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#15
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#16
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#17
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#18
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#19
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#20
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#21
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#22
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#23
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#24
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#25
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#26
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#27
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#28
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#29
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#30
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#31
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle1EdgeRemove	#32
	
	
	lw $t1, 4($sp)   # red
	addi $t4, $t2, -4
	lw $t3, 20($sp)  # black
	
	sw $t4, 24($sp)

	sw $t1, 0($t4)
	sw $t1, 128($t4)
	sw $t1, 256($t4)
	
	sw $t3, 0($t2)
	sw $t3, 128($t2)
	sw $t3, 256($t2)
	
	
	jr $ra
	
obstacle2Move:

	# To move obstacle 2 to the left end of the screen

	lw $t2, 28($sp)	
	
	lw $t7, 8($sp)	
	
	# If obstacle reaches left end of the screen then make it dissapear and a new will appear randomly
	
	
	beq $t2, $t7, obstacle2EdgeRemove	#1
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#2
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#3
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#4
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#5
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#6
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#7
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#8
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#9
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#10
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#11
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#12
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#13
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#14
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#15
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#16
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#17
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#18
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#19
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#20
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#21
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#22
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#23
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#24
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#25
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#26
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#27
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#28
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#29
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#30
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#31
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle2EdgeRemove	#32
	
	
	lw $t1, 4($sp)   # red
	addi $t4, $t2, -4
	lw $t3, 20($sp)  # black
	
	sw $t4, 28($sp)

	
	sw $t1, 0($t4)
	sw $t1, 128($t4)
	sw $t1, 256($t4)
	
	sw $t3, 0($t2)
	sw $t3, 128($t2)
	sw $t3, 256($t2)
	
	jr $ra
	
obstacle3Move:

	# To move obstacle 3 to the left end of the screen
	
	lw $t2, 32($sp)
	
	lw $t7, 8($sp)
		
	# If obstacle reaches left end of the screen then make it dissapear and a new will appear randomly
	
	beq $t2, $t7, obstacle3EdgeRemove	#1
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#2
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#3
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#4
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#5
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#6
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#7
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#8
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#9
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#10
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#11
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#12
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#13
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#14
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#15
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#16
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#17
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#18
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#19
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#20
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#21
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#22
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#23
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#24
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#25
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#26
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#27
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#28
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#29
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#30
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#31
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle3EdgeRemove	#32
	
	
	lw $t1, 4($sp)   # red
	addi $t4, $t2, -4
	lw $t3, 20($sp)  # black
	
	sw $t4, 32($sp)

	sw $t1, 0($t4)
	sw $t1, 128($t4)
	sw $t1, 256($t4)
	
	sw $t3, 0($t2)
	sw $t3, 128($t2)
	sw $t3, 256($t2)
	
	jr $ra
	
obstacle4Move:

	# To move obstacle 4 to the left end of the screen

	lw $t2, 40($sp)
	
	lw $t7, 8($sp)
		
	# If obstacle reaches left end of the screen then make it dissapear and a new will appear randomly
	
	beq $t2, $t7, obstacle4EdgeRemove	#1
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#2
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#3
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#4
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#5
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#6
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#7
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#8
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#9
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#10
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#11
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#12
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#13
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#14
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#15
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#16
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#17
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#18
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#19
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#20
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#21
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#22
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#23
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#24
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#25
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#26
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#27
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#28
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#29
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#30
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#31
	addi $t7, $t7, 128
	beq $t2, $t7, obstacle4EdgeRemove	#32
	
	
	lw $t1, 4($sp)   # red
	addi $t4, $t2, -4
	lw $t3, 20($sp)  # black
	
	sw $t4, 40($sp)

	sw $t1, 0($t4)
	sw $t1, 128($t4)
	sw $t1, 256($t4)
	
	sw $t3, 0($t2)
	sw $t3, 128($t2)
	sw $t3, 256($t2)
	
	jr $ra
	
enemyCollision:


	# Checking for enemy collision with spaceship
	
	lw $t0, 36($sp)   # current spaceship location
	addi $t1, $t0, 128
	addi $t2, $t0, 256
	
	
	
	lw $t3, 104($sp)   # enemy location 

	
	
	lw $t7, 0($sp)
	
	# If collision checking go to a function called collision color enemy and then show collision and end game

	
	beq $t0, $t3, collisonColorEnemy
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t3, collisonColorEnemy
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t3, collisonColorEnemy
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	
	

	
	jr $ra
	
	

checkcollisionObstacle1:

	# Checking collision with spaceship

	lw $t0, 36($sp)   # current spaceship location
	addi $t1, $t0, 128
	addi $t2, $t0, 256
	
	
	
	lw $t3, 24($sp)   # obstacle 1 location
	addi $t4, $t3, 128
	addi $t5, $t3, 256
	
	
	
	lw $t7, 0($sp)

	# calling collisioncolor which will show collision as yellow color and warn user about it
	
	beq $t0, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	
	beq $t0, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)

	beq $t0, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)

	

	
	jr $ra
	
checkcollisionObstacle2:

	# Checking collision with spaceship
	
	lw $t0, 36($sp)   # current spaceship location
	addi $t1, $t0, 128
	addi $t2, $t0, 256
	
	
	
	lw $t3, 28($sp)   # obstacle 2 location
	addi $t4, $t3, 128
	addi $t5, $t3, 256

	lw $t7, 0($sp)
	
	# calling collisioncolor which will show collision as yellow color and warn user about it
	
	beq $t0, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	
	beq $t0, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)

	beq $t0, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)

	
	jr $ra
	
checkcollisionObstacle3:

	# Checking collision with spaceship
	
	lw $t0, 36($sp)   # current spaceship location
	addi $t1, $t0, 128
	addi $t2, $t0, 256
	
	
	
	lw $t3, 32($sp)   # obstacle 3 location
	addi $t4, $t3, 128
	addi $t5, $t3, 256
	
	lw $t7, 0($sp)
	
	# calling collisioncolor which will show collision as yellow color and warn user about it
	
	beq $t0, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	
	beq $t0, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)

	beq $t0, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)

	

	
	jr $ra
	
checkcollisionObstacle4:

	# Checking collision with spaceship
	
	lw $t0, 36($sp)   # current spaceship location
	addi $t1, $t0, 128
	addi $t2, $t0, 256
	
	
	
	lw $t3, 40($sp)   # obstacle 4 location
	addi $t4, $t3, 128
	addi $t5, $t3, 256

	
	lw $t7, 0($sp)
	
	# calling collisioncolor which will show collision as yellow color and warn user about it
	
	beq $t0, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t3, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	
	beq $t0, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t4, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)

	beq $t0, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t1, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	beq $t2, $t5, collisonColor
	sw $t7, 0($t0)
	sw $t7, 0($t1)
	sw $t7, 0($t2)
	

	
	jr $ra
	
collisonColorEnemy:


	# Changing color to yellow when collision took place

	
	lw $t0, 60($sp)    # color of collision
	
	lw $s0, 36($sp)		# spsaceship current position
	
	sw $t0, 0($s0)
	sw $t0, 128($s0)
	sw $t0, 256($s0)
	
	lw $s1, 76($sp)		# collision counter
	li $s1, 0
	sw $s1, 76($sp)
	
	lw $t1, 20($sp)    # health bg color black

	
	lw $t3, 8($sp)	# Base Address
	
	
	# line 2
	

	
	sw $t1, 3736($t3)
	sw $t1, 3740($t3)
	sw $t1, 3744($t3)
	sw $t1, 3748($t3)
	sw $t1, 3752($t3)
	sw $t1, 3756($t3)
	sw $t1, 3760($t3)
	sw $t1, 3764($t3)
	sw $t1, 3768($t3)
	sw $t1, 3772($t3)
	sw $t1, 3776($t3)
	sw $t1, 3780($t3)
	sw $t1, 3784($t3)
	sw $t1, 3788($t3)
	sw $t1, 3792($t3)
	sw $t1, 3796($t3)
	sw $t1, 3800($t3)
	sw $t1, 3804($t3)
	sw $t1, 3808($t3)
	sw $t1, 3812($t3)
	


	
	# line 3
	

	
	sw $t1, 3864($t3)
	sw $t1, 3868($t3)
	sw $t1, 3872($t3)
	sw $t1, 3876($t3)
	sw $t1, 3880($t3)
	sw $t1, 3884($t3)
	sw $t1, 3888($t3)
	sw $t1, 3892($t3)
	sw $t1, 3896($t3)
	sw $t1, 3900($t3)
	sw $t1, 3904($t3)
	sw $t1, 3908($t3)
	sw $t1, 3912($t3)
	sw $t1, 3916($t3)
	sw $t1, 3920($t3)
	sw $t1, 3924($t3)
	sw $t1, 3928($t3)
	sw $t1, 3932($t3)
	sw $t1, 3936($t3)
	sw $t1, 3940($t3)
	

	
	
	#sleep
	li $v0, 32
	li $a0, 50
	syscall 
	
	
	# Changing color to black to exit game
	
	j blueBackroundsetup
	

collisonColor:

	# Changing color of spaceship to yellow to show collision
	
	lw $t0, 60($sp)
	
	lw $s0, 36($sp)
	
	sw $t0, 0($s0)
	sw $t0, 128($s0)
	sw $t0, 256($s0)
	
	lw $s1, 76($sp)

	# also calling function to decrease health on collision by one unit
	
	lw $t2, 20($sp)    # health bg color
	
	lw $s2, 72($sp)    # max
	
	lw $t7, 8($sp)	   # Base Address
	
	addi $t7, $t7, 3812
	addi $t1, $t7, 128
	
	li $t6, 16
	mult $t6, $s1
	mflo $t4
	
	sub $t3, $t7, $t4
	sub $s3, $t1, $t4
	
	sw $t2, 0($t3)
	addi $t3, $t3, -4
	sw $t2, 0($t3)
	addi $t3, $t3, -4
	sw $t2, 0($t3)
	addi $t3, $t3, -4
	sw $t2, 0($t3)
	
	
	sw $t2, 0($s3)
	addi $s3, $s3, -4
	sw $t2, 0($s3)
	addi $s3, $s3, -4
	sw $t2, 0($s3)
	addi $s3, $s3, -4
	sw $t2, 0($s3)


	addi $s1, $s1, 1
	sw $s1, 76($sp)
	
	
	# If collision number reaches 5 which is the max level we have to call another function to show black screen
	# which then call to show a game over screen

	beq $s1, $s2, blueBackroundsetup
	
	
	#sleep
	li $v0, 32
	li $a0, 50
	syscall 
	
	
	
	
	j main1
	

blueBackroundsetup:

	# Setup for setting up black background
	
	lw $t2, 8($sp)     # contains base address
	
	addi $t3, $t2, 4147

fillBackground:

	# Filling background with black color

	bge $t2, $t3, showEnd

	lw $t1, 20($sp)		# bg color of end blue
	sw $t1 0($t2)
	
	addi $t2, $t2, 4
	j fillBackground
	
	
	
	
	

showEnd:

	# This function will print "END" when game is over
	lw $t4, 80($sp)
	lw $t5, 8($sp)
	
	# MADE E
	
	sw $t4, 916($t5)
	sw $t4, 920($t5)
	sw $t4, 924($t5)
	sw $t4, 928($t5)
	sw $t4, 1044($t5)
	sw $t4, 1048($t5)
	sw $t4, 1052($t5)
	sw $t4, 1056($t5)
	sw $t4, 1172($t5)
	sw $t4, 1176($t5)
	sw $t4, 1300($t5)
	sw $t4, 1304($t5)
	sw $t4, 1428($t5)
	sw $t4, 1432($t5)
	sw $t4, 1436($t5)
	sw $t4, 1440($t5)
	sw $t4, 1556($t5)
	sw $t4, 1560($t5)
	sw $t4, 1564($t5)
	sw $t4, 1568($t5)
	sw $t4, 1684($t5)
	sw $t4, 1688($t5)
	sw $t4, 1812($t5)
	sw $t4, 1816($t5)
	sw $t4, 1940($t5)
	sw $t4, 1944($t5)
	sw $t4, 1948($t5)
	sw $t4, 1952($t5)
	sw $t4, 2068($t5)
	sw $t4, 2072($t5)
	sw $t4, 2076($t5)
	sw $t4, 2080($t5)
	

	# MADE N
	
	sw $t4, 944($t5)
	sw $t4, 948($t5)
	sw $t4, 1072($t5)
	sw $t4, 1076($t5)
	sw $t4, 1200($t5)
	sw $t4, 1204($t5)
	sw $t4, 1328($t5)
	sw $t4, 1332($t5)
	sw $t4, 1456($t5)
	sw $t4, 1460($t5)
	sw $t4, 1584($t5)
	sw $t4, 1588($t5)
	sw $t4, 1712($t5)
	sw $t4, 1716($t5)
	sw $t4, 1840($t5)
	sw $t4, 1844($t5)
	sw $t4, 1968($t5)
	sw $t4, 1972($t5)
	sw $t4, 2096($t5)
	sw $t4, 2100($t5)
	
	sw $t4, 976($t5)
	sw $t4, 980($t5)
	sw $t4, 1104($t5)
	sw $t4, 1108($t5)
	sw $t4, 1232($t5)
	sw $t4, 1236($t5)
	sw $t4, 1360($t5)
	sw $t4, 1364($t5)
	sw $t4, 1488($t5)
	sw $t4, 1492($t5)
	sw $t4, 1616($t5)
	sw $t4, 1620($t5)
	sw $t4, 1744($t5)
	sw $t4, 1748($t5)
	sw $t4, 1872($t5)
	sw $t4, 1876($t5)
	sw $t4, 2000($t5)
	sw $t4, 2004($t5)
	sw $t4, 2128($t5)
	sw $t4, 2132($t5)
	
	
	sw $t4, 1076($t5)
	sw $t4, 1208($t5)
	sw $t4, 1340($t5)
	sw $t4, 1472($t5)
	sw $t4, 1604($t5)
	sw $t4, 1736($t5)
	sw $t4, 1868($t5)
	sw $t4, 2000($t5)
	
	
	# MAKE D
	
	sw $t4, 996($t5)
	sw $t4, 1000($t5)
	sw $t4, 1124($t5)
	sw $t4, 1128($t5)
	sw $t4, 1252($t5)
	sw $t4, 1256($t5)
	sw $t4, 1380($t5)
	sw $t4, 1384($t5)
	sw $t4, 1508($t5)
	sw $t4, 1512($t5)
	sw $t4, 1636($t5)
	sw $t4, 1640($t5)
	sw $t4, 1764($t5)
	sw $t4, 1768($t5)
	sw $t4, 1892($t5)
	sw $t4, 1896($t5)
	sw $t4, 2020($t5)
	sw $t4, 2024($t5)
	sw $t4, 2148($t5)
	sw $t4, 2152($t5)
	
	
	sw $t4, 1004($t5)
	sw $t4, 1008($t5)
	sw $t4, 1132($t5)
	sw $t4, 1136($t5)
	
	sw $t4, 2028($t5)
	sw $t4, 2032($t5)
	sw $t4, 2156($t5)
	sw $t4, 2160($t5)
	
	sw $t4, 1268($t5)
	sw $t4, 1272($t5)
	sw $t4, 1396($t5)
	sw $t4, 1400($t5)
	sw $t4, 1524($t5)
	sw $t4, 1528($t5)
	sw $t4, 1652($t5)
	sw $t4, 1656($t5)
	sw $t4, 1780($t5)
	sw $t4, 1784($t5)
	sw $t4, 1908($t5)
	sw $t4, 1912($t5)
	
	# Exiting game
	
	#Sleep
	li $v0, 32
	li $a0, 1500
	syscall
	
	li $v0, 10 # terminate the program gracefully
	syscall
	
	
showEnd2:
	
	# Setting gaame speed back to the speed which was at the begining 
	lw $s7, 124($sp)
	li $s7, 300
	sw $s7, 124($sp)


	# Thus function will also print "END" and is being exectued when we press "p" to restart the game

	lw $t4, 80($sp)
	lw $t5, 8($sp)
	
	# MADE E
	
	sw $t4, 916($t5)
	sw $t4, 920($t5)
	sw $t4, 924($t5)
	sw $t4, 928($t5)
	sw $t4, 1044($t5)
	sw $t4, 1048($t5)
	sw $t4, 1052($t5)
	sw $t4, 1056($t5)
	sw $t4, 1172($t5)
	sw $t4, 1176($t5)
	sw $t4, 1300($t5)
	sw $t4, 1304($t5)
	sw $t4, 1428($t5)
	sw $t4, 1432($t5)
	sw $t4, 1436($t5)
	sw $t4, 1440($t5)
	sw $t4, 1556($t5)
	sw $t4, 1560($t5)
	sw $t4, 1564($t5)
	sw $t4, 1568($t5)
	sw $t4, 1684($t5)
	sw $t4, 1688($t5)
	sw $t4, 1812($t5)
	sw $t4, 1816($t5)
	sw $t4, 1940($t5)
	sw $t4, 1944($t5)
	sw $t4, 1948($t5)
	sw $t4, 1952($t5)
	sw $t4, 2068($t5)
	sw $t4, 2072($t5)
	sw $t4, 2076($t5)
	sw $t4, 2080($t5)
	

	# MADE N
	
	sw $t4, 944($t5)
	sw $t4, 948($t5)
	sw $t4, 1072($t5)
	sw $t4, 1076($t5)
	sw $t4, 1200($t5)
	sw $t4, 1204($t5)
	sw $t4, 1328($t5)
	sw $t4, 1332($t5)
	sw $t4, 1456($t5)
	sw $t4, 1460($t5)
	sw $t4, 1584($t5)
	sw $t4, 1588($t5)
	sw $t4, 1712($t5)
	sw $t4, 1716($t5)
	sw $t4, 1840($t5)
	sw $t4, 1844($t5)
	sw $t4, 1968($t5)
	sw $t4, 1972($t5)
	sw $t4, 2096($t5)
	sw $t4, 2100($t5)
	
	sw $t4, 976($t5)
	sw $t4, 980($t5)
	sw $t4, 1104($t5)
	sw $t4, 1108($t5)
	sw $t4, 1232($t5)
	sw $t4, 1236($t5)
	sw $t4, 1360($t5)
	sw $t4, 1364($t5)
	sw $t4, 1488($t5)
	sw $t4, 1492($t5)
	sw $t4, 1616($t5)
	sw $t4, 1620($t5)
	sw $t4, 1744($t5)
	sw $t4, 1748($t5)
	sw $t4, 1872($t5)
	sw $t4, 1876($t5)
	sw $t4, 2000($t5)
	sw $t4, 2004($t5)
	sw $t4, 2128($t5)
	sw $t4, 2132($t5)
	
	
	sw $t4, 1076($t5)
	sw $t4, 1208($t5)
	sw $t4, 1340($t5)
	sw $t4, 1472($t5)
	sw $t4, 1604($t5)
	sw $t4, 1736($t5)
	sw $t4, 1868($t5)
	sw $t4, 2000($t5)
	
	
	# MAKE D
	
	sw $t4, 996($t5)
	sw $t4, 1000($t5)
	sw $t4, 1124($t5)
	sw $t4, 1128($t5)
	sw $t4, 1252($t5)
	sw $t4, 1256($t5)
	sw $t4, 1380($t5)
	sw $t4, 1384($t5)
	sw $t4, 1508($t5)
	sw $t4, 1512($t5)
	sw $t4, 1636($t5)
	sw $t4, 1640($t5)
	sw $t4, 1764($t5)
	sw $t4, 1768($t5)
	sw $t4, 1892($t5)
	sw $t4, 1896($t5)
	sw $t4, 2020($t5)
	sw $t4, 2024($t5)
	sw $t4, 2148($t5)
	sw $t4, 2152($t5)
	
	
	sw $t4, 1004($t5)
	sw $t4, 1008($t5)
	sw $t4, 1132($t5)
	sw $t4, 1136($t5)
	
	sw $t4, 2028($t5)
	sw $t4, 2032($t5)
	sw $t4, 2156($t5)
	sw $t4, 2160($t5)
	
	sw $t4, 1268($t5)
	sw $t4, 1272($t5)
	sw $t4, 1396($t5)
	sw $t4, 1400($t5)
	sw $t4, 1524($t5)
	sw $t4, 1528($t5)
	sw $t4, 1652($t5)
	sw $t4, 1656($t5)
	sw $t4, 1780($t5)
	sw $t4, 1784($t5)
	sw $t4, 1908($t5)
	sw $t4, 1912($t5)
	
	
	#Sleep
	li $v0, 32
	li $a0, 1500
	syscall
	
	j againBlack
	
againBlack:

	# Filling the screen with black and setting up that for loop to execute
	
	lw $t2, 8($sp)     # contains base address
	
	addi $t3, $t2, 4147

fillBlackAgain:

	# Filling up the screen with black color 

	bge $t2, $t3, gameSetup

	lw $t1, 20($sp)		# bg color of end blue
	sw $t1 0($t2)
	
	addi $t2, $t2, 4
	j fillBlackAgain
	

	
	
	


