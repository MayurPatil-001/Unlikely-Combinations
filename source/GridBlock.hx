package;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class GridBlock extends FlxSprite {
	// public static var AnimalTypes:Array<String> = [
	// 	"bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey"
	// ];
	public static var AnimalTypes:Array<String> = [
		"bear",
		"buffalo",
		"chick",
		"chicken",
		"cow",
		"crocodile",
		"dog",
		"duck",
		"elephant"
	];

	public var imageName:String;

	public function new(x:Int, y:Int, name:String) {
		super(x, y);
		imageName = name;
		loadImage();
	}

	public function animate() {
		FlxTween.tween(this, {alpha: 0.3}, 0.3, {onComplete: backwardTween});
	}

	function backwardTween(tween:FlxTween) {
		// trace("backwardTween");
		FlxTween.tween(this, {alpha: 1.0}, 0.3);
	}

	private function loadImage() {
		switch (imageName) {
			case "bear":
				loadGraphic(AssetPaths.bear__png);
			case "buffalo":
				loadGraphic(AssetPaths.buffalo__png);
			case "chick":
				loadGraphic(AssetPaths.chick__png);
			case "chicken":
				loadGraphic(AssetPaths.chicken__png);
			case "cow":
				loadGraphic(AssetPaths.cow__png);
			case "crocodile":
				loadGraphic(AssetPaths.crocodile__png);
			case "dog":
				loadGraphic(AssetPaths.dog__png);
			case "duck":
				loadGraphic(AssetPaths.duck__png);
			case "elephant":
				loadGraphic(AssetPaths.elephant__png);
			case "frog":
				loadGraphic(AssetPaths.frog__png);
			case "giraffe":
				loadGraphic(AssetPaths.giraffe__png);
			case "goat":
				loadGraphic(AssetPaths.goat__png);
			case "gorilla":
				loadGraphic(AssetPaths.gorilla__png);
			case "hippo":
				loadGraphic(AssetPaths.hippo__png);
			case "horse":
				loadGraphic(AssetPaths.horse__png);
			case "monkey":
				loadGraphic(AssetPaths.monkey__png);
			default:
				loadGraphic(AssetPaths.bear__png);
		}
	}
}
