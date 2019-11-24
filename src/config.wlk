import rick.*
import omniverse.*
import misc.*
import objects.*
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
            indicadorDeMDestino.numero(numero)
        }) }

        keyboard.up().onPressDo({ rick.moveTo(up) })
        keyboard.right().onPressDo({ rick.moveTo(right) })
        keyboard.down().onPressDo({ rick.moveTo(down) })
        keyboard.left().onPressDo({ rick.moveTo(left) })


		keyboard.a().onPressDo({rick.rotarSentidoAntiHorario()})
		keyboard.d().onPressDo({rick.rotarSentidoHorario()})
		
		//Agarra el objeto y lo guarda en la mochila
		keyboard.z().onPressDo({ rick.manipularObjetos(inicio) })
		keyboard.x().onPressDo({ rick.manipularObjetos(fin) })		
		//Tira el objeto que tiene en la mano
		keyboard.c().onPressDo({ rick.ungrab() })		
		//Ejecuta el elemento que tenga en la mano
		keyboard.space().onPressDo({ rick.trigger(numero) })
		//Ver otros multiversos		
        keyboard.control().onPressDo({ omniverse.current(lastMultiverso) })
        //Comenzar juego		
        keyboard.enter().onPressDo({ omniverse.current(1) })


        // to Debug
        keyboard.r().onPressDo({ rick.multiverse(numero) omniverse.current(numero) })
        keyboard.del().onPressDo({ // del is backspace (Cuaq!)
            lastMultiverso = omniverse.current()
            omniverse.current(numero)
        })

        // to Debug
        keyboard.q().onPressDo({ console.println(rick.position()) console.println(portalgun.position())})
        keyboard.w().onPressDo({ console.println(rick) console.println(rick.image())})
        keyboard.e().onPressDo({ game.allVisuals().forEach{v=> console.println(v) }})
        keyboard.r().onPressDo({ game.allVisuals().forEach{visual => visual.mover()}})
    }

    method moverObjetos(){
            game.allVisuals().forEach { objeto => objeto.mover() }
        }

    method configurarColisiones(){
        game.onCollideDo(rick, { algo => algo.colisionasteCon(rick)})
    }
}

