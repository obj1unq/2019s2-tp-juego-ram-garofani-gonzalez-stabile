import personajes.*
import wollok.game.*
import niveles.*
object config{
	method teclas(){
		// teclas de rick
		keyboard.up().onPressDo({ rick.position(rick.position().up(1)) })
		keyboard.right().onPressDo({ rick.position(rick.position().right(1)) })
		keyboard.down().onPressDo({ rick.position(rick.position().down(1)) })
		keyboard.left().onPressDo({ rick.position(rick.position().left(1)) })
		//
		keyboard.z().onPressDo({ rick.grab() })
		keyboard.x().onPressDo({ rick.ungrab() })
		keyboard.space().onPressDo({ rick.trigger() })
		keyboard.p().onPressDo({ rick.travel() })
	}
}

object laucher{
	method lauchGame(){
		nivel.init()
     	nivel.actual(nivel.disponibles().get(1))
        nivel.actual().show()
	}
}