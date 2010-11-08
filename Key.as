/*
* Key.as - a replacement for the AS2 Key class
* Created by player_03
* Anyone may use or modify this code for any purpose
*/
package AS3Utils {
	import flash.utils.ByteArray;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	
	public class Key {
		private static var keyArray:ByteArray = new ByteArray(), mostRecentKey:uint = 0;
		
		private static const arrayLength:int = 222;
		
		//sets up the array and adds the appropriate event listeners
		public static function init(stage:Stage):void {
			keyArray.length = arrayLength;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		//records when a key is pressed
		public static function keyDownHandler(event:KeyboardEvent):void {
			mostRecentKey = event.keyCode;
			if(mostRecentKey > arrayLength)
				return;
			
			keyArray.position = mostRecentKey;
			keyArray.writeBoolean(true);
		}
		
		//records when a key is released
		public static function keyUpHandler(event:KeyboardEvent):void {
			clearKey(event.keyCode);
		}
		
		//clears all keys, whether or not they were released
		public static function clearAll():void {
			keyArray.position = 0;
			for(var index = 0; index <= arrayLength; index++) {
				keyArray.writeBoolean(false);
			}
		}
		
		//clears the given key, whether or not it was released
		public static function clearKey(keyCode:int):void {
			if(keyCode > arrayLength)
				return;
			
			keyArray.position = keyCode;
			keyArray.writeBoolean(false);
		}
		
		//clears the most recently pressed key
		//warning: if this key is still being pressed, it will most likely be recorded again
		public static function clearMostRecent():void {
			mostRecentKey = 0;
		}
		
		//returns whether or not the given key is down
		public static function isDown(keyCode:int):Boolean {
			if(keyCode > keyArray.length || keyCode < 0)
				return(false);
			keyArray.position = keyCode;
			return (keyArray.readBoolean());
		}
		
		//returns the most recently pressed key
		public static function getCode():int {
			return mostRecentKey;
		}
		
		//returns a string containing the name of the given key
		public static function keyCodeToString(keyCode:int):String {
			//if keyCode matches the ASCII value (that is, if the value is alphanumeric)
			if(48 <= keyCode && keyCode <= 57 || 65 <= keyCode && keyCode <= 90) {
				return(String.fromCharCode(keyCode));
			}
			
			switch(keyCode) {
				case 96:
					return("Numpad 0");
				case 97:
					return("Numpad 1");
				case 98:
					return("Numpad 2");
				case 99:
					return("Numpad 3");
				case 100:
					return("Numpad 4");
				case 101:
					return("Numpad 5");
				case 102:
					return("Numpad 6");
				case 103:
					return("Numpad 7");
				case 104:
					return("Numpad 8");
				case 105:
					return("Numpad 9");
				case 106:
					return("Numpad *");
				case 107:
					return("Numpad +");
				case 109:
					return("Numpad -");
				case 110:
					return("Numpad .");
				case 111:
					return("Numpad /");
				case 112:
					return("F1");
				case 113:
					return("F2");
				case 114:
					return("F3");
				case 115:
					return("F4");
				case 116:
					return("F5");
				case 117:
					return("F6");
				case 118:
					return("F7");
				case 119:
					return("F8");
				case 120:
					return("F9");
				case 122:
					return("F11");
				case 123:
					return("F12");
				case 124:
					return("F13");
				case 125:
					return("F14");
				case 126:
					return("F15");
				case 8:
					return("Backspace");
				case 9:
					return("Tab");
				case 13:
					return("Enter");
				case 16:
					return("Shift");
				case 17:
					return("Ctrl");
				case 20:
					return("Caps Lock");
				case 27:
					return("Esc");
				case 32:
					return("Space");
				case 33:
					return("Page Up");
				case 34:
					return("Page Down");
				case 35:
					return("End");
				case 36:
					return("Home");
				case 37:
					return("Left");
				case 38:
					return("Up");
				case 39:
					return("Right");
				case 40:
					return("Down");
				case 45:
					return("Insert");
				case 46:
					return("Delete");
				case 144:
					return("Num Lock");
				case 145:
					return("Scroll Lock");
				case 19:
					return("Break");
				case 186:
					return(";");
				case 187:
					return("+");
				case 189:
					return("-");
				case 191:
					return("/");
				case 192:
					return("~");
				case 219:
					return("[");
				case 220:
					return("\\");
				case 221:
					return("]");
				case 222:
					return("\"");
				case 188:
					return(",");
				case 190:
					return(".");
				default:
					return("Key #" + keyCode);
			}
		}
	}
}
