import personajes.*
import wollok.game.*
import niveles.*


object config{
	method teclas(){
                var numero = 0
		(0..9).forEach{ n => keyboard.num(n).onPressDo({ numero = n console.println("numero = " + numero )}) }
                keyboard.alt().onPressDo({ 
                                            multiverso.enVista(numero) numero = 0 })
		// teclas de rick
		keyboard.up().onPressDo({ rick.position(rick.position().up(1)) })
		keyboard.right().onPressDo({ rick.position(rick.position().right(1)) })
		keyboard.down().onPressDo({ rick.position(rick.position().down(1)) })
		keyboard.left().onPressDo({ rick.position(rick.position().left(1)) })
		//
		keyboard.z().onPressDo({ rick.grab() })
		keyboard.x().onPressDo({ rick.ungrab() })
		keyboard.space().onPressDo({ rick.trigger(numero) numero = 0 })
		keyboard.p().onPressDo({ rick.travel() })
	}
}
