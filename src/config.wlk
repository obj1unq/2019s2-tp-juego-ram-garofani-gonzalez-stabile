import personajes.*
import wollok.game.*
import niveles.*
import directions.*

object config{
	method teclas(){
		// teclas de rick
                var numero = 0
                var lastMultiverso = 0
		(0..2).forEach{ n => keyboard.num(n).onPressDo({ numero = n console.println("numero = " + numero )}) }
		keyboard.up().onPressDo({ rick.position(rick.position().up(1)) rick.direction(directionUp) })
		keyboard.right().onPressDo({ rick.position(rick.position().right(1)) rick.direction(directionRight) })
		keyboard.down().onPressDo({ rick.position(rick.position().down(1))  rick.direction(directionDown) })
		keyboard.left().onPressDo({ rick.position(rick.position().left(1))  rick.direction(directionLeft) })
		//
		keyboard.z().onPressDo({ rick.grab() })
		keyboard.x().onPressDo({ rick.ungrab() })
		keyboard.q().onPressDo({ console.println(rick.position()) console.println(gun.position())})
		keyboard.w().onPressDo({ console.println(rick) console.println(rick.image())})
		keyboard.e().onPressDo({ game.allVisuals().forEach{v=> console.println(v) }})
		keyboard.space().onPressDo({ rick.trigger(numero) })
		keyboard.p().onPressDo({ rick.travel() })
                keyboard.alt().onPressDo({ lastMultiverso = omniverse.current() omniverse.current(numero) })
	}
	
	method ticks(){
		game.onTick(3500, "", { self.MoverObjetos() })		
	}
	
	method MoverObjetos(){
            game.allVisuals().forEach { objeto => objeto.mover() }
        }
}

/*
object laucher{
	method lauchGame(){
		nivel.init()
     	nivel.actual(nivel.disponibles().get(1))
        nivel.actual().show()
	}
}
*/
