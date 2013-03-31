package away3d.animators
{
	import away3d.animators.IAnimationSet;
	import away3d.materials.passes.MaterialPassBase;
	import away3d.core.managers.Stage3DProxy;
	import flash.display3D.Context3D;

	/**
	 * The animation data set containing the Spritesheet animation state data.
	 * 
	 * @see away3d.animators.SpriteSheetAnimator
	 * @see away3d.animators.SpriteSheetAnimationState
	 */
	public class SpriteSheetAnimationSet extends AnimationSetBase implements IAnimationSet
	{
		/**
		 * @inheritDoc
		 */
		public function getAGALVertexCode(pass:MaterialPassBase, sourceRegisters:Array, targetRegisters:Array):String
		{
			var agalCode:String = "mov "+targetRegisters[0]+", "+sourceRegisters[0]+"\n";
			agalCode += "mov "+targetRegisters[1]+", "+sourceRegisters[1]+"\n";

			var UVSource:String = "va1";
			var UVTarget:String = "v0";

			var tempUV : String = "vt"+UVSource.substring(2,3);		
			//var idConstant:int = pass.numUsedVertexConstants;
			//var constantRegID : String = "vc" + idConstant;

			agalCode += "mov " + tempUV +", "+ UVSource +"\n";
			//agalCode += "mul " + tempUV +".xy, "+ tempUV +".xy, "+ constantRegID+".zw \n";	 
			//agalCode += "add " + tempUV +".xy, "+ tempUV +".xy, "+ constantRegID+".xy \n";
			agalCode += "mov " + UVTarget +", "+ tempUV+"\n";

			return agalCode;
		}
		
		/**
		 * @inheritDoc
		 */
		public function activate(stage3DProxy:Stage3DProxy, pass:MaterialPassBase):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function deactivate(stage3DProxy:Stage3DProxy, pass:MaterialPassBase):void
		{
			var context : Context3D = stage3DProxy.context3D;
			context.setVertexBufferAt(0, null);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function addState(stateName:String, animationState:IAnimationState):void
		{
			super.addState(stateName, animationState);
			
			animationState.addOwner(this, stateName);
		}
	}
}
