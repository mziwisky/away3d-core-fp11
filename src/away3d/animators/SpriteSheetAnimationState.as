package away3d.animators
{
	import away3d.arcane;
	import away3d.animators.nodes.*;
	
	use namespace arcane;
	
	/**
	 * The animation state class used to store spritesheet animation node data.
	 * 
	 * @see away3d.animators.SpriteSheetAnimator
	 * @see away3d.animators.SpriteSheetAnimationSet
	 */
	public class SpriteSheetAnimationState extends AnimationStateBase implements IAnimationState
	{
		private var _spriteSheetAnimationSet:SpriteSheetAnimationSet;
		
		/**
		 * Creates a new <code>SpriteSheetAnimationState</code> object.
		 * 
		 * @param rootNode Sets the root animation node used by the state for determining the output pose of the spritesheet animation node data.
		 */
		public function SpriteSheetAnimationState(rootNode:SpriteSheetClipNode)
		{
			super(rootNode);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addOwner(owner:IAnimationSet, stateName:String):void
		{
			if (!(owner is SpriteSheetAnimationSet))
				throw new Error("A SpriteSheet animation state can only be added to a SpriteSheetAnimationSet");
			
			super.addOwner(owner, stateName);
						
			_spriteSheetAnimationSet = owner as SpriteSheetAnimationSet;
		}
	}
}
