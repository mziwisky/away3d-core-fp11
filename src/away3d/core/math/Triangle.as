package away3d.core.math {
	import flash.geom.Vector3D;
	/**
	 * @author holman
	 */
	public class Triangle {
		
		private var _idxOne:int;
		private var _idxTwo:int;
		private var _idxThree:int;
		private var p:Polygon;
		
		public function Triangle(p: Polygon, idxOne: int, idxTwo: int, idxThree: int) {
			this._idxOne = idxOne;
			this._idxTwo = idxTwo;
			this._idxThree = idxThree;
			this.p = p;
		}
		
		public function getBounds() : Vector.<Vector3D> {
			var bounds:Vector.<Vector3D> = new Vector.<Vector3D>();
			bounds.push(p.getBound(_idxOne), p.getBound(_idxTwo), p.getBound(_idxThree));
			return bounds;
		}
		
		public function contains(idx: int) : Boolean {
			if(idx == _idxOne || idx == _idxTwo || idx == _idxThree) {
				return false;
			}
			return GeometryUtilities.contains(p.getBound(idx), getBounds());
		}

		public function get idxOne() : int {
			return _idxOne;
		}

		public function get idxTwo() : int {
			return _idxTwo;
		}

		public function get idxThree() : int {
			return _idxThree;
		}
		
		public function toString() : String {
			return "Triangle: [" + _idxOne + ", "	+ _idxTwo + ", " + _idxThree + "]";
		}
	}
}
