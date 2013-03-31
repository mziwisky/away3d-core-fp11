package away3d.animators.nodes
{
	import away3d.animators.data.*;

	/**
	 * A SpriteSheetClipNode containing time-based animation data as individual uv animation frames.
	 */
	public class SpriteSheetClipNode extends AnimationClipNodeBase implements ISpriteSheetAnimationNode
	{
		private var _frames : Vector.<SpriteSheetAnimationFrame> = new Vector.<SpriteSheetAnimationFrame>();
		private var _currentFrameID : uint = 0;
		private var _reverse : Boolean;
		private var _back : Boolean;
		private var _backAndForth : Boolean;

		/**
		 * Creates a new <code>SpriteSheetClipNode</code> object.
		 */
		public function SpriteSheetClipNode(){}


		public function set reverse(b:Boolean):void
		{	
			_back = false;
			_reverse = b;
		}

		public function set backAndForth(b:Boolean):void
		{
			if(b) _reverse = false;
			_back = false;
			_backAndForth = b;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentFrameData() : SpriteSheetAnimationFrame
		{
			if (_framesDirty)
				updateFrames();
			
			return _frames[_currentFrameID];
		}
		
		public function get currentFrameNumber() : uint
		{
			return _currentFrameID;
		}
		 
		/**
		 * Returns a vector of SpriteSheetAnimationFrame representing the uv values of each animation frame in the clip.
		 */
		public function get frames():Vector.<SpriteSheetAnimationFrame>
		{
			return _frames;
		}
		
		
		/**
		 * Adds a SpriteSheetAnimationFrame object to the internal timeline of the animation node.
		 * 
		 * @param spriteSheetAnimationFrame The frame object to add to the timeline of the node.
		 * @param duration The specified duration of the frame in milliseconds.
		 */
		public function addFrame(spriteSheetAnimationFrame : SpriteSheetAnimationFrame, duration : uint) : void
		{
			_frames.push(spriteSheetAnimationFrame);
			_durations.push(duration);
			_numFrames = _durations.length;
			
			_stitchDirty = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateTime(time:int):void
		{
			super.updateTime(time);
			
			_framesDirty = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateFrames() : void
		{
			super.updateFrames();
			
			if(_reverse){

				if(_currentFrameID-1>-1){
					_currentFrameID--;
				} else if (_looping){

					if(_backAndForth){
						_reverse = false;
					} else {
						_currentFrameID = _frames.length-1;	
					}
					
				}

			} else {

				if(_currentFrameID<_frames.length-1){
					_currentFrameID++;

				} else if (_looping){

					if(_backAndForth){
						_reverse = true;
					} else {
						_currentFrameID = 0;
					}
					
				}
			}
 
		}
		 
	}
}
