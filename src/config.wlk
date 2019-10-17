import personajes.*
import wollok.game.*
import niveles.*
import Directions.*

object config{
	method teclas(){
		// teclas de rick
		keyboard.up().onPressDo({ rick.position(rick.position().up(1),directionUp) })
		keyboard.right().onPressDo({ rick.position(rick.position().right(1),directionRight) })
		keyboard.down().onPressDo({ rick.position(rick.position().down(1),directionDown) })
		keyboard.left().onPressDo({ rick.position(rick.position().left(1),directionLeft) })
		//
		keyboard.z().onPressDo({ rick.grab() })
		keyboard.x().onPressDo({ rick.ungrab() })
		keyboard.space().onPressDo({ rick.trigger() })
		keyboard.p().onPressDo({ rick.travel() })
	}
	
	method ticks(){
		game.onTick(500, "", { self.MoverObjetos() })		
	}
	
	method MoverObjetos(){
		(nivel.actual()).objetos().forEach { 
			objeto => objeto.mover()
		}
	}
}

object laucher{
	method lauchGame(){
		nivel.init()
     	nivel.actual(nivel.disponibles().get(1))
        nivel.actual().show()
	}
}