package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class EnemyDebugText extends Entity 
	{
		private var target:Enemy;
		private var txtDebug:Text = new Text("tx: ###\nty: ###");
		
		private var tileX:int;
		private var tileY:int;
		
		public function EnemyDebugText(e:Enemy) 
		{
			target = e;
			txtDebug.size = 8;
			graphic = txtDebug;
		}
		
		public function UpdateStats():void
		{
			tileX = Math.ceil(target.x / 24);
			tileY = Math.ceil(target.y / 24);
			txtDebug.text = "tx: " + tileX + "\nty: " + tileY + "\nstate: " + target.getState() + "\ndir: " + target.getDir().toString();
		}
		
		public override function update():void
		{
			if (!target.isAlive())
			{
				FP.world.remove(this);
			}
			else
			{
				UpdateStats();
				x = target.x - 24;
				y = target.y - 24;
			}
		}
		
	}

}