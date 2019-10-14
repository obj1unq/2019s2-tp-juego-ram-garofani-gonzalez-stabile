import personajes.*
import wollok.game.*
import niveles.*
import Directions.*

object config{
	method teclas(){
		// teclas de rick
		keyboard.up().onPressDo({ rick.position(rick.position().up(1),DirectionUp) })
		keyboard.right().onPressDo({ rick.position(rick.position().right(1),DirectionRight) })
		keyboard.down().onPressDo({ rick.position(rick.position().down(1),DirectionDown) })
		keyboard.left().onPressDo({ rick.position(rick.position().left(1),DirectionLeft) })
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