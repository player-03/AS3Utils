/*
 * ScrollHandler.as - created by Joseph Cloutier.
 * Licensed under CC0 (http://creativecommons.org/publicdomain/zero/1.0/).
 */
package AS3Utils {
	import flash.text.TextField;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	
	/**
	 * A text field that covers a certain portion of the stage and absorbs mouse wheel events,
	 * preventing them from scrolling the webpage.
	 */
	public class ScrollHandler extends TextField {
		//the default scroll position
		private var defaultScrollV:int;
		
		public var targetObject:InteractiveObject;
		
		/**
		 * Sets up the ScrollHandler.
		 * @param stage A reference to the stage.
		 * @param initWidth The width of the area to cover.
		 * @param initHeight The width of the area to cover.
		 * @param targetObject The object to pass mouse events to. If this isn't specified, mouse
		 * events will be passed to an object behind this that is under the mouse.
		 */
		public function ScrollHandler(stage:Stage, initWidth:Number = NaN, initHeight:Number = NaN, targetObject:InteractiveObject = null) {
			//create the text field
			super();
			
			//if initWidth and/or initHeight wasn't provided, set it based on the stage
			if(isNaN(initWidth)) {
				initWidth = stage.width;
			}
			if(isNaN(initHeight)) {
				initHeight = stage.height;
			}
			
			//record the target object
			this.targetObject = targetObject;
			
			//set up the text field
			width = initWidth;
			height = initHeight;
			selectable = false;
			multiline = true;
			wordWrap = false;
			
			textColor = 0x00FF00;
			
			//input blank lines until the text field can scroll
			//(apply a minimum and a maximum because this apparently isn't reliable)
			var i:int;
			for(i = 0; i <= 20 || maxScrollV == 1 && i < 5000; i++) {
				appendText("\n");
			}
			
			//input a number of additional lines, to make sure the text field has plenty of room to scroll
			for(i *= 3; i >= -20; i--) {
				appendText("\n");
			}
			
			//scroll halfway down the text field
			defaultScrollV = int(maxScrollV / 2);
			scrollV = defaultScrollV;
			
			//pass all mouse events on to the display object below this
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
		}
		
		private var prevDisplayObject:DisplayObject = null;
		private var displayObjectIndex:int;
		private var currentDisplayObject:DisplayObject;
		private var tempPoint:Point;
		
		/**
		 * Passes the given mouse event on to the display object below this.
		 */
		private function onMouseEvent(e:MouseEvent):void {
			if(e.type == MouseEvent.MOUSE_WHEEL && scrollV == maxScrollV) {
				appendText("\n\n");
				defaultScrollV = int(maxScrollV / 2);
			}
			
			//reset scrollV
			scrollV = defaultScrollV;
			
			if(parent == null) {
				return;
			}
			
			//if the target object is defined, simply use it
			if(targetObject != null) {
				currentDisplayObject = targetObject;
			} else {
				//get all objects contained by the parent object under the given point
				tempPoint = new Point(e.stageX, e.stageY);
				var displayObjectList:Array = parent.getObjectsUnderPoint(tempPoint);
				
				//find the top display object under the current point, if there is one
				currentDisplayObject = null;
				for(displayObjectIndex = displayObjectList.length - 1; displayObjectIndex > 0; displayObjectIndex--) {
					currentDisplayObject = displayObjectList[displayObjectIndex] as DisplayObject;
					
					if(currentDisplayObject != null && currentDisplayObject != this) {
						break;
					}
				}
			}
			
			//make sure to avoid errors
			if(currentDisplayObject == null || currentDisplayObject == this) {
				return;
			}
			if(prevDisplayObject == null) {
				prevDisplayObject = currentDisplayObject;
			}
			
			//check if a rollOver/rollOut event needs to be passed
			//this will only be necessary for mouseMove events
			if(e.type == MouseEvent.MOUSE_MOVE
			   //this will not be necessary if the object under the mouse didn't change
			   && currentDisplayObject != prevDisplayObject
			   //this will not be necessary if either object contains the other
			   && (!(currentDisplayObject is DisplayObjectContainer)
				   || !DisplayObjectContainer(currentDisplayObject).contains(prevDisplayObject))
			   && (!(prevDisplayObject is DisplayObjectContainer)
				   || !DisplayObjectContainer(prevDisplayObject).contains(currentDisplayObject))) {
				
				//dispatch the rollOut event first
				if(prevDisplayObject != null) {
					tempPoint = prevDisplayObject.globalToLocal(new Point(e.stageX, e.stageY));
					prevDisplayObject.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, e.bubbles, e.cancelable,
																   tempPoint.x, tempPoint.y,
																   currentDisplayObject as InteractiveObject,
																   e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown));
				}
				
				//dispatch the rollOver event
				if(currentDisplayObject != null) {
					tempPoint = currentDisplayObject.globalToLocal(new Point(e.stageX, e.stageY));
					currentDisplayObject.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, e.bubbles, e.cancelable,
																	  tempPoint.x, tempPoint.y,
																	  prevDisplayObject as InteractiveObject,
																	  e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown));
				}
			}
			
			//pass the given event type on to the current display object
			if(currentDisplayObject != null) {
				tempPoint = currentDisplayObject.globalToLocal(new Point(e.stageX, e.stageY));
				
				currentDisplayObject.dispatchEvent(new MouseEvent(e.type, e.bubbles, e.cancelable, tempPoint.x, tempPoint.y,
																  null, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta));
			}
			
			prevDisplayObject = currentDisplayObject;
		}
	}
}
