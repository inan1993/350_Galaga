


main:


initialize:
#$s0 is numLevel, $s1 is numEnemies. These should be CONSTANT
	lw $s0, numLevel($zero)
	lw $s1, constNumEnemies($s0)
	sw $s1, numEnemies($zero)
	
initPlayer:
	lw $t2, constPlayer($zero)
	sw $t2, player($zero)
	
	sub $t6, $t6, $t6
	addi $t6, $t6, 4
	lw $t2, constPlayer($t6)
	sw $t2, player($t6)	
	
	addi $t6, $t6, 4
	lw $t2, constPlayer($t6)
	sw $t2, player($t6)
#copyEnemies	
	lw $t0, levelOffsets($s0)
	lw $t1, constNumEnemies($s0)
	sub $t5, $t5, $t5
	addi $t1, $t1, -1
copyEnemies: 
#t5 will be counter -- $t0 is the offset, which we grab the value from :: 
#$t0 is for loading $t5 is for saving
	#Decrement numEnemies
	addi $t1, $t1, -1
	lw $t2, enemiesLevel1($t0)
	sw $t2, enemies($t5)
	addi $t5, $t5, 4
	addi $t0, $t0, 4
	lw $t2, enemiesLevel1($t0)
	sw $t2, enemies($t5)
	addi $t5, $t5, 4
	addi $t0, $t0, 4
	lw $t2, enemiesLevel1($t0)
	sw $t2, enemies($t5)
	addi $t5, $t5, 4
	addi $t0, $t0, 4
	blt $t1, $zero, levelStart
	j copyEnemies
	
levelStart:
	jal updatePlayer
	jal updateEnemies
	jal updatePlayerBullets
	jal updateEnemyBullets
	jal checkCollisions
	jal checkGameOver	
	j levelStart
		
updatePlayer:
	jr $ra
updateEnemies:
	jr $ra
updatePlayerBullets:
	jr $ra
updateEnemyBullets:
	jr $ra
checkCollisions:
	jr $ra
	

checkGameOver:	
	lw $t1, numEnemies($zero)
	addi $t2, $zero, 4
	blt $t1, $t2, gameOverWin
	
	sub $t2, $t2, $t2
	addi $t2, $zero, 8
	lw $t1, player($t2)
	addi $t4, $zero, 1
	blt $t1, $t4, gameOverLoss
	
	sub $t3, $t3, $t3
	addi $t3, $zero, 4
	lw $t2, enemies($t3)
	lw $t1, enemiesBarrier($zero)
	blt $t2, $t1, gameOverLoss
	jr $ra
gameOverWin:
	#print out win state, or go to next level
	lw $t0, numLevel($zero)
	addi $t0, $t0, 4
	sw $t0, numLevel($zero)
	j initialize
gameOverLoss:
	#print out loss state, restart game
	j initialize

		
.data 
.align 2
	GridHeight: .word 100
	GridWidth: .word 100 
	player: .word 0,0,0
	constPlayer: .word 50,0, 3
	#cumulative
	numEnemies: .word 4
	constNumEnemies: .word 4, 1
	numLevel: .word 0
	#stores offsets f each levels enemies array
	levelOffsets: .word 0, 12
	enemiesBarrier: .word 40
	#always start with fathest down enemies 
	#different Levels in same vector, as stored
	enemiesLevel1: .word 20, 100, 1, 40, 100, 1, 60, 100, 1, 80, 100, 1
	enemiesLevel2: .word 20, 80, 1
	#randomShots: .word 1,0,0,0,1,1,0,1,0,0,1,0,1,0,0,0,0,0,0,1,1,1,0,1,1,1,1,0,0,1,0,0,1,1,0,0,1,0,0,1	
	enemies: .word 0
