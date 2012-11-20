package away3d.core.math {
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * @author holman
	 */
	public class GeometryUtilities {
		
		public static var eps:Number = Math.pow(2, -52);
		
		public static function containsPoint(pt: Point, bounds: Vector.<Point>, boundsAreIn: Boolean = true) : Boolean {
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();
			for each(var point: Point in bounds) {
				points.push(pointToVector3D(point));
			}
			return contains(pointToVector3D(pt), points, boundsAreIn);
		}
		
		private static function pointToVector3D(pt: Point) : Vector3D {
			return new Vector3D(pt.x, pt.y);
		}
		
		public static function contains(pt: Vector3D, bounds: Vector.<Vector3D>, boundsAreIn: Boolean = true) : Boolean {
			if(boundsAreIn) {
				if(onBoundary(pt, bounds)) {
					return true;
				}
			}
			var counter:int = 0;
			var xinters:Number;
			var p1:Vector3D;
			var p2:Vector3D; 
			p1 = bounds[0];
			for (var i:int = 1; i <= bounds.length; i++) {
				p2 = bounds[i % bounds.length];
				if (pt.y > Math.min(p1.y, p2.y)) {
					if (pt.y <= Math.max(p1.y, p2.y)) {
						if (pt.x <= Math.max(p1.x, p2.x)) {
							if (p1.y != p2.y) {
								xinters = (pt.y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
								if (p1.x == p2.x || pt.x <= xinters) counter++;
							}
						}
					}
				}
				p1 = p2;
			}
			if (counter % 2 == 0) {
				return false;
			}
			else {
				return true;
			}	
		}
		
		public static function onBoundary(pt: Vector3D, bounds: Vector.<Vector3D>) : Boolean {
			var p1:Vector3D;
			var p2:Vector3D; 
			p1 = bounds[0];
			for (var i:int = 1; i <= bounds.length; i++) {
				p2 = bounds[i % bounds.length];
				var det:Number = (p2.x - p1.x) * (pt.y - p1.y) - (p2.y - p1.y) * (pt.x - p1.x);
				if(Math.abs(det) < eps) {
					return true;
				}
				p1 = p2;
			}
			return false;	
			
		}
	}
}
