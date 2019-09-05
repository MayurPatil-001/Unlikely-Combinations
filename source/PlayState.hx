package;

import flixel.FlxSubState;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.ui.FlxButton;
import flixel.ui.FlxBar;
import flixel.system.FlxSound;

class PlayState extends FlxState {
	var blocks:FlxSpriteGroup;
	var activeBlocks:FlxSpriteGroup;
	var selectedBlock:GridBlock;
	var backdrop:FlxBackdrop;
	var score:Int = 0;
	var defaultLevelTime = 10;
	var levelTime:Float;
	var scoreText:FlxText;
	var levelSelectables:Int = 0;
	var levelTimeText:FlxText;
	var uiBar:FlxBar;
	var timeBar:FlxBar;

	var tileGap:Int = 55;
	var tileSize:Int = 136;

	var clickSound:FlxSound;

	// Substate
	var gameOverSubstate:FlxSubState;

	override public function create():Void {
		super.create();

		backdrop = new FlxBackdrop(AssetPaths.darkPurple__png, 1, 1, true, true);
		add(backdrop);

		var tempBar:Int = 100;
		uiBar = new FlxBar(0, 200, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 10, null, "tempBar", 0, 100, true);
		add(uiBar);

		var tempXPos:Int = tileSize + (2 * tileGap);
		var timeBarWidth:Int = FlxG.width - tileSize - tileGap - tempXPos;
		timeBar = new FlxBar(tempXPos, tileGap + 60, FlxBarFillDirection.LEFT_TO_RIGHT, timeBarWidth, 24, null, "levelTime", 0, defaultLevelTime, true);
		add(timeBar);

		scoreText = new FlxText(tileGap, 10, 0, Std.string("Score : " + score), 24);

		add(scoreText);

		levelTimeText = new FlxText(tempXPos, tileGap, 0, "Time :" + levelTime, 24);
		add(levelTimeText);

		FlxG.camera.bgColor = FlxColor.GRAY;
		// trace("Begin generation");

		clickSound = FlxG.sound.load(AssetPaths.click2__ogg);

		blocks = new FlxSpriteGroup();
		add(blocks);

		restartGame();
	}

	override public function update(elapsed:Float):Void {
		#if desktop
		if (FlxG.mouse.justPressed) {
			var xpos = FlxG.mouse.x;
			var ypos = FlxG.mouse.y;
			FlxG.overlap(new FlxObject(xpos, ypos), blocks, onOverlap);
		}
		#end
		#if mobile
		for (touch in FlxG.touches.list) {
			if (touch.pressed) {
				var xpos = touch.x;
				var ypos = touch.y;
				FlxG.overlap(new FlxObject(xpos, ypos), blocks, onOverlap);
			}
		}
		#end
		// trace("levelSelectables =" + levelSelectables);
		levelTime -= elapsed;
		updateLevelTimeText();

		if (levelTime <= 0.0) {
			// GameOver Substate

			var gameOverScoreText:FlxText;
			gameOverSubstate = new FlxSubState(0x99808080);
			var gameOverText:FlxText = new FlxText(0, 0, 0, "Game Over !", 30);
			gameOverText.x = FlxG.width / 2 - gameOverText.width / 2;
			gameOverText.y = FlxG.height / 2 - 60;
			gameOverSubstate.add(gameOverText);

			gameOverScoreText = new FlxText(0, 0, 0, "Your Score:" + score, 30);
			gameOverScoreText.x = FlxG.width / 2 - gameOverScoreText.width / 2;
			gameOverScoreText.y = FlxG.height / 2;
			gameOverSubstate.add(gameOverScoreText);

			var gameOverRestartButton:FlxButton = new FlxButton(0, 0, "Restart", restartGame);
			gameOverRestartButton.loadGraphic(AssetPaths.Button_Blue__png, true, 190, 49);
			gameOverRestartButton.x = FlxG.width / 2 - gameOverRestartButton.width / 2;
			gameOverRestartButton.y = FlxG.height / 2 + 60;
			gameOverRestartButton.onUp.sound = FlxG.sound.load(AssetPaths.click2__ogg, 100, false);
			gameOverRestartButton.label.size = 30;
			gameOverSubstate.add(gameOverRestartButton);
			openSubState(gameOverSubstate);
		}
		super.update(elapsed);
	}

	function onOverlap(obj1:FlxObject, obj2:FlxObject):Void {
		var block:GridBlock = cast obj2;
		clickSound.play(true);
		// trace("imageName :" + block.imageName);
		if (selectedBlock.imageName == block.imageName) {
			block.destroy();
			score += 1;
			updateScoreText();
			levelSelectables--;
		} else {
			block.animate();
			FlxG.camera.shake(0.01, 0.2);
			score -= 2;
			if (score < 0) {
				score = 0;
				// TODO: GameOver
			}
			updateScoreText();
		}
		if (levelSelectables <= 0) {
			generateGrid();
		}
	}

	function generateGrid():Void {
		trace("generateGrid Begin");
		levelSelectables = 0;
		blocks.clear();
		var yOffset:Int = 160;
		var index = FlxG.random.int(0, GridBlock.AnimalTypes.length - 1);
		var selectedName:String = GridBlock.AnimalTypes[index];
		var tempArr:Array<Float> = new Array<Float>();
		for (x in 0...GridBlock.AnimalTypes.length) {
			if (x == index) {
				tempArr.push(0.05 * GridBlock.AnimalTypes.length);
			} else {
				tempArr.push(0.02 * GridBlock.AnimalTypes.length);
			}
		}

		// trace("tempArr : " + tempArr);
		var x:Int = tileGap;
		var y:Int = tileGap;
		selectedBlock = new GridBlock(x, y, selectedName);
		add(selectedBlock);
		for (x in 0...3) {
			for (y in 0...5) {
				var name = FlxG.random.getObject(GridBlock.AnimalTypes, tempArr);

				// block.loadGraphic(AssetPaths.bear__png);
				var xpos = (x * tileSize) + tileGap + (x * tileGap);
				var ypos = (y * tileSize) + tileGap + (y * tileGap) + yOffset;
				// trace("x :" + xpos + " y :" + ypos);
				var block:GridBlock = new GridBlock(xpos, ypos, name);
				// block.setPosition(xpos, ypos);
				if (name == selectedName) {
					levelSelectables++;
				}
				blocks.add(block);
			}
		}
		trace("levelSelectables :" + levelSelectables);

		if (levelSelectables <= 0) {
			generateGrid();
		}
	}

	function updateScoreText():Void {
		scoreText.text = "Score :" + score;
	}

	function updateLevelTimeText():Void {
		levelTimeText.text = "Select from below time :" + Std.int(levelTime);
		timeBar.value = Std.int(levelTime);
		timeBar.updateBar();
	}

	function restartGame():Void {
		clickSound.play(true);
		if (gameOverSubstate != null) {
			FlxG.camera.fade(FlxColor.BLACK, .33, true, function() {
				// FlxG.switchState(new PlayState());
				gameOverSubstate.close();
			});
		}
		score = 0;
		levelTime = defaultLevelTime;
		updateScoreText();
		updateLevelTimeText();
		generateGrid();
	}
}
