import personajes.*
import wollok.game.*

object config{
	method teclas(){
		// teclas de rick
		keyboard.up().onPressDo({ r.position(r.position().up(1)) })
		keyboard.right().onPressDo({ r.position(r.position().right(1)) })
		keyboard.down().onPressDo({ r.position(r.position().down(1)) })
		keyboard.left().onPressDo({ r.position(r.position().left(1)) })
		//
		keyboard.z().onPressDo({ r.grab() })
		keyboard.x().onPressDo({ r.ungrab() })
		keyboard.space().onPressDo({ r.trigger() })
		keyboard.p().onPressDo({ r.travel() })
	}
}
