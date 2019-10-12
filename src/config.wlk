import personajes.*
import wollok.game.*
import niveles.*


object config{
	method teclas(){
                var buffer = null
		(0..9).forEach{ n => keyboard.num(n).onPressDo({ buffer = n }) }
                keyboard.alt().onPressDo({ console.println("buffer =" + buffer )
                                            universo.enVista(buffer) buffer = 0})
		// teclas de rick
		keyboard.up().onPressDo({ rick.position(rick.position().up(1)) })
		keyboard.right().onPressDo({ rick.position(rick.position().right(1)) })
		keyboard.down().onPressDo({ rick.position(rick.position().down(1)) })
		keyboard.left().onPressDo({ rick.position(rick.position().left(1)) })
		//
		keyboard.z().onPressDo({ rick.grab() })
		keyboard.x().onPressDo({ rick.ungrab() })
		keyboard.space().onPressDo({ rick.trigger(buffer) buffer = 0 })
		keyboard.p().onPressDo({ rick.travel() })
	}
}
