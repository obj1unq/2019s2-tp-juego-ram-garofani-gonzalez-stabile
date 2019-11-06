import personajes.*
import wollok.game.*
import niveles.*
import directions.*
import wollok.game.*
import Fichas.*
import Jugadores.*

object config{
	
	method teclas(){
		// teclas de rick
       	var numero = 0
       	var lastMultiverso = 0
		(0..4).forEach{ n => keyboard.num(n).onPressDo({ 
			numero = n 
			console.println("numero = " + numero )
		}) }
		
		keyboard.up().onPressDo({ 			
				rick.position(rick.position().up(1)) 
				rick.direction(up)
		})
		keyboard.right().onPressDo({ 
				rick.position(rick.position().right(1)) 
				rick.direction(right)			
		})
		keyboard.down().onPressDo({ 
				rick.position(rick.position().down(1))  
				rick.direction(down)			
		})
		keyboard.left().onPressDo({ 
				rick.position(rick.position().left(1))  
				rick.direction(left)			
		})
		//
		keyboard.z().onPressDo({ rick.grab() })
		keyboard.x().onPressDo({ rick.ungrab() })
		keyboard.space().onPressDo({ rick.trigger(numero) })
		keyboard.p().onPressDo({ rick.travel() })
		keyboard.m().onPressDo({ rick.guardar() })
		keyboard.n().onPressDo({ rick.sacar() })
        keyboard.control().onPressDo({ omniverse.current(lastMultiverso) })
        
        
        keyboard.g().onPressDo({rick.ponerseLentes()})
        keyboard.o().onPressDo({ rick.abrirCofre() })

                // to Debug
       	keyboard.alt().onPressDo({ 
       		lastMultiverso = omniverse.current() 
       		omniverse.current(numero)
       	})

      	// to Debug
		keyboard.q().onPressDo({ console.println(rick.position()) console.println(portalgun.position())})
		keyboard.w().onPressDo({ console.println(rick) console.println(rick.image())})
		keyboard.e().onPressDo({ game.allVisuals().forEach{v=> console.println(v) }})
		keyboard.r().onPressDo({ game.allVisuals().forEach{visual => visual.mover()}})
	}
	
	method ticks(){
		game.onTick(500, "", { self.moverObjetos() })		
	}
	
	method moverObjetos(){
            game.allVisuals().forEach { objeto => objeto.mover() }
        }
	
	method configurarColisiones(){
		game.onCollideDo(rick, { algo => algo.colisionasteCon(rick)})
	}
}

