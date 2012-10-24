package org.mousebomb.utils
{

	/**
	 * 数据处理
	 * @author Mousebomb
	 * @since 09.2.13
	 */
	public class DataUtils
	{
		public function DataUtils()
		{
		}

		/**
		 * 数组乱序排序
		 * 
		 */
		public static function arrayRandomSort(arrayRef : Array) : void
		{
			arrayRef.sort(randomSort);
		}

		/**
		 * 服务于数组乱序排序
		 */
		private static function randomSort(...args) : int
		{
			return Math.random() > .5 ? 1 : -1;
		}
	}
}