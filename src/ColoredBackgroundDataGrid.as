/**
 * ColoredBackgroundDataGrid
 * 
 * This class extends DataGrid and overrides the drawColumnBackground function. This class also introduces
 * the property, columnBackgroundAlpha.
 * 
 */
package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;

	public class ColoredBackgroundDataGrid extends DataGrid
	{
		public function ColoredBackgroundDataGrid()
		{
			super();
		}
		
		/**
		 * The rowColorFunction can be assigned any function which returns a color. The signature of the
		 * function is:
		 * 
		 * 	function rowColorFunction( item:Object, rowIndex:int, dataIndex:int, color:uint ) : uint
		 * 
		 * The color parameter is the color that would normally be assigned (eg, one of the alternating 
		 * row colors). The item is the data record for the row. If item is null, it means the row has
		 * no data and is just a filler row.
		 * 
		 */
		public var rowColorFunction:Function;
		
		/**
		 * drawRowBackground override
		 * 
		 * This function is responsible for drawing the background of the row. In this class, if the
		 * rowColorFunction has been defined, it is called to pick the color. Otherwise the given
		 * color is used.
		 */
		override protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void
		{
			if( rowColorFunction != null ) {
				var dp:ArrayCollection = dataProvider as ArrayCollection;
				var item:Object;
				if( dataIndex < dp.length ) item = dp.getItemAt(dataIndex);
				color = rowColorFunction( item, rowIndex, dataIndex, color );
			}
			super.drawRowBackground(s,rowIndex,y,height,color,dataIndex);
		}
		
		/**
		 * columnBackgroundAlpha - the alpha value to use for the column background
		 */
		public var columnBackgroundAlpha:Number = 1;
		
		/**
		 * columnBackgroundFunction - this is a function which, if defined, is invoked to
		 * color the background of a column. The function is given a Shape to fill and
		 * color.
		 */
		public var columnBackgroundFunction:Function;
		
		/**
		 * drawColumnBackground (override)
		 * 
		 * This function lets the super class draw the background, then it changes its alpha
		 * to the value of columnBackgroundAlpha property.
		 */
		override protected function drawColumnBackground(s:Sprite, columnIndex:int, color:uint, column:DataGridColumn):void
		{
			super.drawColumnBackground(s,columnIndex,color,column);
			
			var background:Shape = Shape(s.getChildByName(columnIndex.toString()));
			if( background ) {
				background.alpha = columnBackgroundAlpha;
			}
			
			if( columnBackgroundFunction != null ) {
				var columnShape:Shape = Shape(s.getChildByName("lines"+columnIndex.toString()));
				if( columnShape == null ) {
					columnShape = new Shape();
					columnShape.name = "lines"+columnIndex;
					s.addChild(columnShape);
				}
				var lastRow:Object = rowInfo[listItems.length - 1];
		        var xx:Number = listItems[0][columnIndex].x;
	        	var yy:Number = rowInfo[0].y;
	        	var ww:Number = listItems[0][columnIndex].width;
	        	if (this.headerHeight > 0)
	            	yy += rowInfo[0].height;
	
	        	// Height is usually as tall is the items in the row, but not if
	        	// it would extend below the bottom of listContent
	        	var hh:Number = Math.min(lastRow.y + lastRow.height,
	                                     listContent.height - yy);
	                                     
	            columnBackgroundFunction( column, columnIndex, columnShape, xx, yy, ww, hh );
			}
		}
		
	}
}