package away3d.textures {

	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;


	/** Simple class to replace the one lost in the transition to the new materials
	 * by composition setup. Loads a bitmap texture from the file path specified.
	 * 
	 * @author holman
	 */
	public class BitmapFileTexture extends BitmapTexture {
		
		/** Loads a bitmap from the given file path. If fixTexture is set to true,
		 * automatically resizes the texture to the closest power of 2.
		 */
		public function BitmapFileTexture(src: String, fixTexture: Boolean = false) {
			super(new BitmapData(256, 256));
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onImageLoadedError);
			l.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onImageLoadedError);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onImageLoaded);
			l.load(new URLRequest(src));
		}

		private function onImageLoaded(event : Event) : void {
			var loader:LoaderInfo = event.target as LoaderInfo;
			loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onImageLoadedError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onImageLoadedError);
			loader.removeEventListener(Event.COMPLETE, this.onImageLoaded);  
			bitmapData = Bitmap(loader.content).bitmapData;
		}

		private function onImageLoadedError(event : IOErrorEvent) : void {
			
		}
	}
}
