package away3d.core.math {
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * @author holman
	 */
	public class Polygon {
		
		private var bounds:Vector.<Vector3D>;
		private var _minX:Number = Number.MAX_VALUE;
		private var _minY:Number = Number.MAX_VALUE;
		private var _maxX:Number = Number.MIN_VALUE;
		private var _maxY:Number = Number.MIN_VALUE;

		/** Creates a new polygon. If the bounds are not in clockwise order,
		 * they are reversed.
		 */ 		
		public function Polygon(bounds: Vector.<Vector3D>) {
			this.bounds = bounds;
			for each(var bound:Vector3D in bounds) {
				if(bound.x > _maxX) {
					_maxX = bound.x;
				}
				if(bound.y > _maxY) {
					_maxY = bound.y;
				}
				if(bound.x < _minX) {
					_minX = bound.x;
				}
				if(bound.y < _minY) {
					_minY = bound.y;
				}
			}
			if(!isClockwise()) {
				bounds.reverse();
			}
		}
		
		public function getBound(idx: int) : Vector3D {
			return bounds[idx];
		}
		
		public function get boundsCount() : int {
			return bounds.length;
		}
		
		public function get maxX() : Number {
			return _maxX;
		}
		
		public function get maxY() : Number {
			return _maxY;
		}
		
		public function get minX() : Number {
			return _minX;
		}
		
		public function get minY() : Number {
			return _minY;
		}
		
		public function get width() : Number {
			return _maxX - _minX;
		}
		
		public function get height() : Number {
			return _maxY - minY;
		}
		
		/** Using ear clipping, returns a set of polygons that represent a set
		 * of covering triangles. 
		 */
		public function triangularize() : Vector.<Triangle> {
			var triangles:Vector.<Triangle> = new Vector.<Triangle>();
			var vertices:Vector.<int> = new Vector.<int>();
			for(var i:int = 0; i < bounds.length; i++) {
				vertices.push(i);
			}
			var reflexPts:Vector.<int> = getReflexPoints(vertices);
			var ears:Vector.<int> = new Vector.<int>();
			var notEars:Vector.<int> = new Vector.<int>();
			//Sort vertices into ears and not ears
			for(var j:int = 0; j < vertices.length; j++) {
				var isEar:Boolean = true;
				var tri:Triangle = generateSubTriangle(j, vertices);
				//Check all reflex vertices to see if they are contained in the
				//triangle. If so, or if the vertex itself is reflex, it's not an ear
				for each(var reflexPt: int in reflexPts) {
					if(reflexPt == j || tri.contains(reflexPt)) {
						isEar = false;
					}
				}
				if(isEar) {
					ears.push(j);
				}
				else notEars.push(j);
			}
			while(vertices.length > 2) {
				//Grab the top ear, save the resulting triangle and remove it
				//from the vertices list.
				if(ears.length == 0) {
					throw new Error("no ears found");
				}
				var ear:int = ears.pop();
				triangles.push(generateSubTriangle(ear, vertices));
				vertices.splice(vertices.indexOf(ear), 1);
				//Regenerate the reflex points list for the test below
				reflexPts = getReflexPoints(vertices);
				//Walk over all the non ear stuff rechecking for earness
				//Repeat until there are only 3 vertices left, at which point
				//the last sub triangle will have all three vertices
				var stillNotEars:Vector.<int> = new Vector.<int>();
				for(j = 0; j < notEars.length; j++) {
					isEar = true;
					tri = generateSubTriangle(notEars[j], vertices);
					for each(reflexPt in reflexPts) {
						if(reflexPt == notEars[j] || tri.contains(reflexPt)) {
							isEar = false;
						}
					}
					if(isEar) {
						ears.push(notEars[j]);
					}
					else stillNotEars.push(notEars[j]);
				}
				notEars = stillNotEars;
			}
			return triangles;
		}
		
		public function generateSubTriangle(ear: int, vertices: Vector.<int>) : Triangle {
			var start:int = vertices.indexOf(ear);
			if(start == 0) {
				return new Triangle(this, vertices[vertices.length - 1], 
					vertices[0], vertices[1]);
			}
			else if(start == vertices.length - 1) {
				return new Triangle(this, vertices[vertices.length - 2],
					vertices[vertices.length - 1], vertices[0]);
			}
			return new Triangle(this, vertices[start - 1], vertices[start], 
				vertices[start + 1]);
		}
		 
		public function removePoint(pt: Vector3D) : void {
			bounds.splice(bounds.indexOf(pt), 1);
		}
		
		public function clone() : Polygon {
			return new Polygon(bounds.concat());
		}
		
		/** Returns the index of points in the polygon where the angle for that vertex is concave. These
		 * are the only points that need to be checked for inside-ness during
		 * ear clipping, for instance.
		 */
		public function getReflexPoints(vertices: Vector.<int>) : Vector.<int> {
			var result:Vector.<int> = new Vector.<int>();
			if(vertices.length < 3) {
				return result;
			}
			for(var i:int = 0; i < vertices.length; i++)  {
				if(i == 0) {
					if(angleBetween(bounds[vertices[vertices.length - 1]], 
						bounds[vertices[0]], bounds[vertices[1]]) <= 0) {
						result.push(vertices[0]);
					}
				}
				else if(i == vertices.length - 1) {
					if(angleBetween(bounds[vertices[vertices.length - 2]], 
						bounds[vertices[vertices.length - 1]], bounds[vertices[0]]) <= 0) {
						result.push(vertices[vertices.length - 1]);
					}
				}
				else if(angleBetween(bounds[vertices[i - 1]], bounds[vertices[i]], bounds[vertices[i + 1]]) <= 0) {
					result.push(vertices[i]);
				}
			}
			return result;
		}
		
		
		private function angleBetween(a: Vector3D, b: Vector3D, c: Vector3D) : Number {
			var ab:Vector3D = new Vector3D(a.x - b.x, a.y - b.y);
			var cb:Vector3D = new Vector3D(c.x - b.x, c.y - b.y);
			var radians:Number =  Math.atan2(ab.y, ab.x) - Math.atan2(cb.y, cb.x); 
			if(Math.abs(radians) > Math.PI) {
				if(radians < 0) {
					radians += (2 * Math.PI);
				}
				else radians -= (2 * Math.PI);
			}
			var degrees:Number = radians * 180/Math.PI;
			if(degrees == 180) {
				degrees = 0;
			}
			return degrees;
		}
		
		private function isClockwise() : Boolean {
			var accum:int = 0;
			var p1:Vector3D;
			var p2:Vector3D; 
			p1 = bounds[0];
			for (var i:int = 1; i <= bounds.length; i++) {
				p2 = bounds[i % bounds.length];
				//Y is downward so reverse the sign
				var edge:Number = (p2.x - p1.x) * (-p2.y + -p1.y);
				accum += edge;
				p1 = p2;
			}
			return accum > 0;			
		}
		
		public function toString() : String {
			var result:String = "[";
			for each(var pt: Vector3D in bounds) {
				result += pt.x + "," + pt.y;
				result += " ";
			}
			result += "]";
			return result; 
		}
	}
}
