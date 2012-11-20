package away3d.primitives
{
	import away3d.core.base.SubGeometry;
	
	import flash.geom.Vector3D;

	public class QuadrilateralGeometry extends PrimitiveBase
	{
		
		private var pts:Vector.<Vector3D>;
		//private var _segmentsH:int = 1;
		//private var _segmentsW:int = 1;
		
		public function QuadrilateralGeometry(pts: Vector.<Vector3D>)
		{
			this.pts = pts;
		}		
		
		protected override function buildGeometry(target : SubGeometry) : void
		{
			var vertices : Vector.<Number>;
			var normals : Vector.<Number>;
			var tangents : Vector.<Number>;
			var indices : Vector.<uint>;
			var numVerts : uint = 4;
			if (numVerts == target.numVertices) {
				vertices = target.vertexData;
				normals = target.vertexNormalData;
				tangents = target.vertexTangentData;
				indices = target.indexData;
			}
			else {
				vertices = new Vector.<Number>(numVerts * 3, true);
				normals = new Vector.<Number>(numVerts * 3, true);
				tangents = new Vector.<Number>(numVerts * 3, true);
				indices = new Vector.<uint>(2 * 3, true);
			}
			numVerts = 0;
			for(var i:int = 0; i < 4; i++) {
				var pt:Vector3D = pts[i]; 
				vertices[numVerts] = pt.x;
				normals[numVerts] = 0;
				tangents[numVerts++] = 1;
				
				vertices[numVerts] = pt.y;
				normals[numVerts] = 0;
				tangents[numVerts++] = 0;
					
				vertices[numVerts] = pt.z;
				normals[numVerts] = 1;
				tangents[numVerts++] = 0;					
			}
			indices[0] = 0;
			indices[1] = 1;
			indices[2] = 2;
			indices[3] = 0;
			indices[4] = 2;
			indices[5] = 3;
			target.updateVertexData(vertices);
			target.updateVertexNormalData(normals);
			target.updateVertexTangentData(tangents);
			target.updateIndexData(indices);
		}
	
		override protected function buildUVs(target : SubGeometry) : void
		{
			var uvs : Vector.<Number> = new Vector.<Number>();
			//var numUvs : uint = (_segmentsH + 1) * (_segmentsW + 1) * 2;
			var numUvs:uint = 8;
			if (target.UVData && numUvs == target.UVData.length)
				uvs = target.UVData;
			else
				uvs = new Vector.<Number>(numUvs, true);
			uvs[0] = 0;
			uvs[1] = 0;
			uvs[2] = 1;
			uvs[3] = 0;
			uvs[4] = 1;
			uvs[5] = 1;
			uvs[6] = 0;
			uvs[7] = 1;
			/*
			for (var yi : uint = 0; yi <= _segmentsH; ++yi) {
				for (var xi : uint = 0; xi <= _segmentsW; ++xi) {
					uvs[numUvs++] = xi/_segmentsW;
					uvs[numUvs++] = 1 - yi/_segmentsH;
				}
			}
			*/
			
			target.updateUVData(uvs);
		}
	}
}