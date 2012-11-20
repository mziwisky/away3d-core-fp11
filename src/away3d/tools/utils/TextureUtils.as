package away3d.tools.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class TextureUtils
	{
		private static const MAX_SIZE : uint = 2048;

		public static function isBitmapDataValid(bitmapData : BitmapData) : Boolean
		{
			if (bitmapData == null) return true;

			return isDimensionValid(bitmapData.width) && isDimensionValid(bitmapData.height);
		}
		
		public static function adjustToValidSize(bitmapData: BitmapData) : BitmapData {
			if(!isBitmapDataValid(bitmapData)) {
				var scaledWidth:Number = getBestPowerOf2(bitmapData.width);
				var scaledHeight:Number = getBestPowerOf2(bitmapData.height);
				var result:BitmapData = new BitmapData(scaledWidth, scaledHeight, true, 0x00000000);
				result.draw(bitmapData, new Matrix(scaledWidth / bitmapData.width, 0, 0, scaledHeight / bitmapData.height));
				bitmapData.dispose();
				return result;
			}
			return bitmapData;
		}

		public static function isDimensionValid(d : uint) : Boolean
		{
			return d >= 1 && d <= MAX_SIZE && isPowerOfTwo(d);
		}

		public static function isPowerOfTwo(value : int) : Boolean
		{
			return value ? ((value & -value) == value) : false;
		}

		public static function getBestPowerOf2(value : uint) : Number
		{
			var p : uint = 1;

			while (p < value)
				p <<= 1;

			if (p > MAX_SIZE) p = MAX_SIZE;

			return p;
		}
	}
}
