package away3d.primitives
{

	import away3d.core.base.SubGeometry;

	/**
	 * A UV Capsule primitive mesh.
	 */
	public class CapsuleGeometry extends PrimitiveBase
	{
		private var _radius:Number;
		private var _height:Number;
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _yUp:Boolean;
		private var vertices:Vector.<Number>;

		/**
		 * Creates a new Capsule object.
		 * @param radius The radius of the capsule.
		 * @param height The height of the capsule.
		 * @param segmentsW Defines the number of horizontal segments that make up the capsule. Defaults to 16.
		 * @param segmentsH Defines the number of vertical segments that make up the capsule. Defaults to 15. Must be uneven value.
		 * @param yUp Defines whether the capsule poles should lay on the Y-axis (true) or on the Z-axis (false).
		 */
		public function CapsuleGeometry(radius:Number = 50, height:Number = 100, segmentsW:uint = 16, segmentsH:uint = 15, yUp:Boolean = true)
		{
			super();

			_radius = radius;
			_height = height;
			_segmentsW = segmentsW;
			_segmentsH = (segmentsH%2 == 0)? segmentsH : segmentsH+1 ;
			_yUp = yUp;
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target:SubGeometry):void
		{
			var vertexNormals:Vector.<Number>;
			var vertexTangents:Vector.<Number>;
			var indices:Vector.<uint>;
			var i:uint, j:uint, triIndex:uint;
			var comp1 :Number, comp2 :Number;
			var startIndex:uint;
			var t1:Number, t2:Number;
			var numVerts:uint = (_segmentsH + 1)*(_segmentsW + 1);

			if(numVerts == target.numVertices) {
				vertices = target.vertexData;
				vertexNormals = target.vertexNormalData;
				vertexTangents = target.vertexTangentData;
				indices = target.indexData;
				
			} else {
				vertices = new Vector.<Number>(numVerts*3, true);
				vertexNormals = new Vector.<Number>(numVerts*3, true);
				vertexTangents = new Vector.<Number>(numVerts*3, true);
				indices = new Vector.<uint>((_segmentsH - 1)*_segmentsW*6, true);
			}

			numVerts = 0;
			for(j = 0; j <= _segmentsH; ++j)
			{
				var horangle:Number = Math.PI*j/_segmentsH;
				var z:Number = -_radius*Math.cos(horangle);
				var ringradius:Number = _radius*Math.sin(horangle);
				startIndex = numVerts;

				for(i = 0; i <= _segmentsW; ++i)
				{
					var verangle:Number = 2*Math.PI*i/_segmentsW;
					var x:Number = ringradius*Math.cos(verangle);
					var offset:Number = j > _segmentsH/2 ? _height/2 : -_height/2;
					var y:Number = ringradius*Math.sin(verangle);
					var normLen:Number = 1/Math.sqrt(x*x + y*y + z*z);
					var tanLen:Number = Math.sqrt(y*y + x*x);
					
					if(_yUp){
						t1 = 0;
						t2 = tanLen > .007 ? x/tanLen : 0;
						comp1 = -z;
						comp2 = y;
					} else {
						t1 = tanLen > .007 ? x/tanLen : 0;
						t2 = 0;
						comp1 = y;
						comp2 = z;
					}
					 
					if (i == _segmentsW) {
						vertexNormals[numVerts] = vertexNormals[startIndex] + (x * normLen) * .5 ;
						vertexTangents[numVerts] = tanLen > .007 ? -y / tanLen : 1;
						vertices[numVerts++] = vertices[startIndex];
						vertexNormals[numVerts] = vertexNormals[startIndex+1] +( comp1 * normLen) * .5;
						vertexTangents[numVerts] = t1;
						vertices[numVerts++] = vertices[startIndex+1];
						vertexNormals[numVerts] = vertexNormals[startIndex+2] +(comp2 * normLen) * .5;
						vertexTangents[numVerts] = t2;
						vertices[numVerts++] = vertices[startIndex+2];
						
					} else {
						vertexNormals[numVerts] = x * normLen;
						vertexTangents[numVerts] = tanLen > .007 ? -y / tanLen : 1;
						vertices[numVerts++] =  x;
						vertexNormals[numVerts] =  comp1 * normLen;
						vertexTangents[numVerts] = t1;
						vertices[numVerts++] = (_yUp)? comp1- offset : comp1;
						vertexNormals[numVerts] = comp2 * normLen;
						vertexTangents[numVerts] = t2;
						vertices[numVerts++] = (_yUp)? comp2 : comp2 + offset;
					}
					
					if(i > 0 && j > 0) {
						var a:int = (_segmentsW + 1)*j + i;
						var b:int = (_segmentsW + 1)*j + i - 1;
						var c:int = (_segmentsW + 1)*(j - 1) + i - 1;
						var d:int = (_segmentsW + 1)*(j - 1) + i;

						if(j == _segmentsH) {
							startIndex = ((_segmentsW + 1) * j) *3;
							vertices[numVerts-3] = vertices[startIndex];
							vertices[numVerts-2] = vertices[startIndex+1];
							vertices[numVerts-1] = vertices[startIndex+2];
							
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;
							
						} else if(j == 1) {
							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;
							
						} else {
							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;
						}
					}
				}
			}

			target.updateVertexData(vertices);
			target.updateVertexNormalData(vertexNormals);
			target.updateVertexTangentData(vertexTangents);
			target.updateIndexData(indices);
		}

		/**
		 * @inheritDoc
		 */
		protected override function buildUVs(target:SubGeometry):void
		{
			var i:int, j:int;
			var numUvs:uint = (_segmentsH + 1)*(_segmentsW + 1)*2;
			var uvData:Vector.<Number>;
			var uvv:Number = 0;
			
			if(target.UVData && numUvs == target.UVData.length)
				uvData = target.UVData;
			else
				uvData = new Vector.<Number>(numUvs, true);

			numUvs = 0;
			var numVerts:uint = (_yUp)? 1: 2;
			
			for(j = 0; j <= _segmentsH; ++j)
			{
				//trace(vertices[numVerts]);
				uvv = (j> _segmentsH*.5)? (1- (vertices[numVerts]/_height))-1 : 1- Math.abs(vertices[numVerts]/_height);
				
				for(i = 0; i <= _segmentsW; ++i)
				{
					uvData[numUvs++] = i/_segmentsW;
					uvData[numUvs++] = uvv;
					numVerts += 3;
				}
				
				trace("uv v: "+uvv);
			}
			
			//trace(vertices);
			
			target.updateUVData(uvData);
		}

		/**
		 * The radius of the capsule.
		 */
		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			invalidateGeometry();
		}

		/**
		 * The height of the capsule.
		 */
		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
			invalidateGeometry();
		}

		/**
		 * Defines the number of horizontal segments that make up the capsule. Defaults to 16.
		 */
		public function get segmentsW():uint
		{
			return _segmentsW;
		}

		public function set segmentsW(value:uint):void
		{
			_segmentsW = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * Defines the number of vertical segments that make up the capsule. Value should be uneven. Defaults to 15.
		 */
		public function get segmentsH():uint
		{
			return _segmentsH;
		}

		public function set segmentsH(value:uint):void
		{
			_segmentsH = value;
			invalidateGeometry();
			invalidateUVs();
		}

		/**
		 * Defines whether the capsule poles should lay on the Y-axis (true) or on the Z-axis (false).
		 */
		public function get yUp():Boolean
		{
			return _yUp;
		}

		public function set yUp(value:Boolean):void
		{
			_yUp = value;
			invalidateGeometry();
		}
	}
}
