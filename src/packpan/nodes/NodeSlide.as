package packpan.nodes 
{
	import cobaltric.ContainerGame;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import packpan.mails.ABST_Mail;
	import packpan.PP;
	import packpan.PhysicsUtils;
	
	/**
	 * A slide is like an air table that has open and closed sides that curve the direction
	 * of the mail.
	 * 
	 * @author Jay Fisher
	 */
	public class NodeSlide extends ABST_Node 
	{

		private static corner_steepness:Number = 1.0;
		private static edge_steepness:Number = 1.0;
		
		protected open_up:Boolean;
		protected open_down:Boolean;
		protected open_left:Boolean;
		protected open_right:Boolean;
	
		public function NodeSlide(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json);

			open_up = json["up"];
			open_down = json["down"];
			open_left = json["left"];
			open_right = json["right"];
			
			// set up custom graphics
			mc_object.gotoAndStop("NodeConveyorNormalSingle");  //TODO: how does this work...?
		}
		
		/**
		 * Called by a Mail object to manipulate the Mail object
		 * @param	mail	the Mail to be affected
		 */
		override public function affectMail(mail:ABST_Mail):void
		{
			// Add a low potential along the axes and a high potential in the corners
			mail.state.addForce(new Point(
				-2*corner_steepness*(mail.state.position.x-x)*Math.pow(mail.state.position.y-y,2),
				-2*corner_steepness*Math.pow(mail.state.position.x-x)*(mail.state.position.y-y)
			));
			// Add a high potential along each closed edge
			if (!open_up && mail.state.position.y-y > 0 || !open_down && mail.state.position.y-y < 0)
				mail.state.addForce(new Point(0,-2*edge_steepness*(mail.state.position.y-y)));
			if (!open_right && mail.state.position.x-x > 0 || !open_left && mail.state.position.x-x < 0)
				mail.state.addForce(new Point(-2*edge_steepness*(mail.state.position.x-x),0));
		}
	}
}
