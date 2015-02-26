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
		[Embed(source = "../../../img/slide_straight.png")]
                private var ImageStraight:Class;
		[Embed(source = "../../../img/slide_small.png")]
                private var ImageSmall:Class;
		[Embed(source = "../../../img/slide_large.png")]
                private var ImageLarge:Class;

		private static var corner_steepness:Number = 1.0;
		private static var edge_steepness:Number = 1.0;
		
		protected var open_up:Boolean;
		protected var open_down:Boolean;
		protected var open_left:Boolean;
		protected var open_right:Boolean;

		private addCornerImage(open_cc:Boolean, open_cw:Boolean, quadrant:int):void
		{
			var img:Bitmap;

			var pix:Number = 12.5;

			if(open_cc && open_cw)
			{
				img = new ImageSmall();
				img.rotation = -90;
			}
			else if(open_cc)
			{
				img = new ImageStraight();
				img.rotation = -90;
			}
			else if(open_cw)
			{
				img = new ImageStraight();
				img.rotation = 0;
			}
			else
			{
				img = new ImageLarge();
				img.rotation = -90;
			}

			img.rotation += (quadrant-1)*90;

			if(quadrant == 1)
			{
				img.x = pix;
				img.y = pix;
			}
			else if(quadrant == 2)
			{
				img.x = -pix;
				img.y = pix;
			}
			else if(quadrant == 3)
			{
				img.x = -pix;
				img.y = -pix;
			}
			else if(quadrant == 4)
			{
				img.x = pix;
				img.y = -pix;
			}

			mc_object.addChild(img);
		}

		public function NodeSlide(_cg:ContainerGame, _json:Object)
		{
			super(_cg, _json);

			open_up = json["up"];
			open_down = json["down"];
			open_left = json["left"];
			open_right = json["right"];

			addCornerImage(open_up,open_right,1);
			addCornerImage(open_left,open_up,2);
			addCornerImage(open_down,open_left,3);
			addCornerImage(open_right,open_down,4);
		}
		
		/**
		 * Called by a Mail object to manipulate the Mail object
		 * @param	mail	the Mail to be affected
		 */
		override public function affectMail(mail:ABST_Mail):void
		{
			// Add a low potential along the axes and a high potential in the corners
			mail.state.addForce(new Point(
				-2*corner_steepness*(mail.state.position.x-position.x)*Math.pow(mail.state.position.y-position.y,2),
				-2*corner_steepness*Math.pow(mail.state.position.x-position.x,2)*(mail.state.position.y-position.y)
			));
			// Add a high potential along each closed edge
			if (!open_up && mail.state.position.y-position.y > 0 || !open_down && mail.state.position.y-position.y < 0)
				mail.state.addForce(new Point(0,-2*edge_steepness*(mail.state.position.y-position.y)));
			if (!open_right && mail.state.position.x-position.x > 0 || !open_left && mail.state.position.x-position.x < 0)
				mail.state.addForce(new Point(-2*edge_steepness*(mail.state.position.x-position.x),0));
		}
	}
}
