/*
* ScrollHandler.as - a class to prevent the mouse wheel from scrolling the page for AS3 games
* Created by player_03
* Anyone may use or modify this code for any purpose
*/
package AS3Utils {
	import flash.text.TextField;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	
	public class ScrollHandler extends TextField {
		//the default scroll position
		private var defaultScrollV:int;
		private var container:DisplayObjectContainer;
		
		//sets up the ScrollHandler
		//stage must be a reference to the stage
		//initWidth and initHeight are optional, but not specifying them may lead to erratic behavior
		public function ScrollHandler(stage:Stage, initWidth:Number = NaN, initHeight:Number = NaN) {
			//create the text field
			super();
			
			//record the container object
			container = stage.getChildAt(0) as DisplayObjectContainer;
			if(container == null) {
				//use the stage as the container if the root cannot be found
				container = stage;
			}
			
			//if initWidth and/or initHeight wasn't provided, set it based on the stage
			if(isNaN(initWidth)) {
				initWidth = stage.width;
			}
			if(isNaN(initHeight)) {
				initHeight = stage.height;
			}
			
			//set up the text field
			width = initWidth;
			height = initHeight;
			selectable = false;
			multiline = true;
			
			//input blank lines until the text field can scroll
			var i:int;
			for(i = 0; maxScrollV == 1; i++) {
				appendText("\n");
			}
			
			//input a number of additional lines, to make sure the text field has plenty of room to scroll
			for(; i >= -10; i--) {
				appendText("\n\n");
			}
			
			//scroll halfway down the text field
			defaultScrollV = int(maxScrollV / 2);
			scrollV = defaultScrollV;
			
			//add this to the stage on top of any currently existing objects
			//any objects added later will show up on top of this, possibly causing the scrolling mechanism to stop working
			stage.addChild(this);
			
			//pass all mouse events on to the display object below this
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
		}
		
		//passes the given mouse event on to the display object below this
		private var displayObjectList:Array;
		private var prevDisplayObject:DisplayObject = null;
		private var currentDisplayObject:DisplayObject;
		private var tempPoint:Point;
		private function onMouseEvent(e:MouseEvent):void {
			//get all objects contained by the container object under the given point
			tempPoint = new Point(e.stageX, e.stageY);
			displayObjectList = container.getObjectsUnderPoint(tempPoint);
			
			//find the top display object under the current point, if there is one
			if(displayObjectList.length != 0) {
				currentDisplayObject = displayObjectList[displayObjectList.length - 1] as DisplayObject;
			} else {
				currentDisplayObject = null;
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
			
			//reset scrollV
			//scrolling is applied after this event listener is called, so add e.delta to counteract it
			scrollV = defaultScrollV + e.delta;
		}
	}
}
