/*
 * Key.as - created by Joseph Cloutier.
 * Licensed under CC0 (http://creativecommons.org/publicdomain/zero/1.0/).
 */
package AS3Utils {
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	
	/**
	 * A replacement for the AS2 Key class. Provides static access to the keys currently pressed.
	 */
	public class Key {
		private static var keyArray:ByteArray = new ByteArray(), mostRecentKey:uint = 0;
		
		private static const arrayLength:int = 222;
		
		/**
		 * Initializes the class. Required before this will be able to provide any information.
		 * @param stage A reference to the stage.
		 */
		public static function init(stage:Stage):void {
			keyArray.length = arrayLength;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(Event.DEACTIVATE, clearAll);
		}
		
		private static function keyDownHandler(event:KeyboardEvent):void {
			mostRecentKey = event.keyCode;
			if(mostRecentKey > arrayLength)
				return;
			
			keyArray.position = mostRecentKey;
			keyArray.writeBoolean(true);
		}
		
		private static function keyUpHandler(event:KeyboardEvent):void {
			clearKey(event.keyCode);
		}
		
		/**
		 * Clears all keys, whether or not they were released. This can be useful in case Flash
		 * missed the KEY_UP event. (Which happens if the player clicks off or right-clicks before
		 * releasing the key.)
		 */
		public static function clearAll(e:Event = null):void {
			keyArray.position = 0;
			for(var index:int = 0; index <= arrayLength; index++) {
				keyArray.writeBoolean(false);
			}
		}
		
		/**
		 * Clears the given key, whether or not it was released.
		 */
		public static function clearKey(keyCode:int):void {
			if(keyCode > arrayLength)
				return;
			
			keyArray.position = keyCode;
			keyArray.writeBoolean(false);
		}
		
		/**
		 * Clears the most recently pressed key. Warning: if this key is still being pressed,
		 * it will most likely be recorded again almost immediately.
		 */
		public static function clearMostRecent():void {
			clearKey(mostRecentKey);
			mostRecentKey = 0;
		}
		
		/**
		 * @return Whether the given key is currently pressed.
		 */
		public static function isDown(keyCode:int):Boolean {
			if(keyCode > keyArray.length || keyCode < 0)
				return(false);
			keyArray.position = keyCode;
			return (keyArray.readBoolean());
		}
		
		/**
		 * @return The key code of the most recently pressed key.
		 */
		public static function getCode():int {
			return mostRecentKey;
		}
		
		/**
		 * @return A string containing a human-readable name for the given key.
		 */
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
		
		//enumeration of common keys
		//(note that the flash.ui.Keyboard class provides a more thorough enumeration)
		public static const BACKSPACE:int = 8;
		public static const TAB:int = 9;
		public static const ENTER:int = 13;
		public static const SHIFT:int = 16;
		public static const CTRL:int = 17;
		public static const ESC:int = 27;
		public static const SPACE:int = 32;
		public static const END:int = 35;
		public static const HOME:int = 36;
		public static const INSERT:int = 45;
		public static const DELETE:int = 46;
		public static const LEFT:int = 37;
		public static const UP:int = 38;
		public static const RIGHT:int = 39;
		public static const DOWN:int = 40;
		public static const ZERO:int = 48;
		public static const ONE:int = 49;
		public static const TWO:int = 50;
		public static const THREE:int = 51;
		public static const FOUR:int = 52;
		public static const FIVE:int = 53;
		public static const SIX:int = 54;
		public static const SEVEN:int = 55;
		public static const EIGHT:int = 56;
		public static const NINE:int = 57;
		public static const A:int = 65;
		public static const B:int = 66;
		public static const C:int = 67;
		public static const D:int = 68;
		public static const E:int = 69;
		public static const F:int = 70;
		public static const G:int = 71;
		public static const H:int = 72;
		public static const I:int = 73;
		public static const J:int = 74;
		public static const K:int = 75;
		public static const L:int = 76;
		public static const M:int = 77;
		public static const N:int = 78;
		public static const O:int = 79;
		public static const P:int = 80;
		public static const Q:int = 81;
		public static const R:int = 82;
		public static const S:int = 83;
		public static const T:int = 84;
		public static const U:int = 85;
		public static const V:int = 86;
		public static const W:int = 87;
		public static const X:int = 88;
		public static const Y:int = 89;
		public static const Z:int = 90;
		public static const SEMICOLON:int = 186;
		public static const COMMA:int = 188;
		public static const PERIOD:int = 190;
	}
}
