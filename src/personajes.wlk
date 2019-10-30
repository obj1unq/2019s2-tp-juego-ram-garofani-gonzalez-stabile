import wollok.game.*
import niveles.*
import directions.*
import movimientos.*

object omniverse{
    var property current = 1

    method position(pos, multiverse) = game.at(self.xfor(pos, multiverse), self.yfor(pos, multiverse) )

    method xfor(pos, multiverse) = self.origenXde(multiverse) + pos.x()

    method yfor(pos, multiverse) = self.origenYde(multiverse) + pos.y()

    method ancho() = game.width()

    method alto() = game.height() - 1

    method origenXde(multiverse) = self.ancho() * (multiverse - current)

    method origenYde(multiverse) = self.alto() * (multiverse - current)
}

class OmniObjeto{
	var property mposition = game.origin() 

        var multiverse 

        method multiverse(value) { multiverse = value }

	method position() = omniverse.position(mposition, multiverse)
}

object rick{
	var position = game.at(1,1)
        var multiverse = 1
	var grabed = nada 
	var direction = down
        var vidas = 3
	
	method image() =  direction.imageRick()
	
        method multiverse(value) { 
            multiverse = value 
            grabed.multiverse(multiverse)
        }
        
	method position() = omniverse.position(position, multiverse)

	method position(_position) { 
            if (not self.estaFueraDeLosLimites(_position)){
		position = _position
		grabed.position(position)
            }
	}

        method estaFueraDeLosLimites(pos) = pos.x() < 0 or pos.x() > omniverse.ancho()-1 or pos.y() < 0 or pos.y() > omniverse.alto()-1

        method direction(_direction) { direction = _direction }

	method travel() { game.colliders(self).find{
		visible => visible.isPortal() }.travel(self)
	}

	method trigger(destino) { grabed.trigger(destino) }

	method grab() { 
		grabed = game.colliders(self).head()
	}

	method ungrab() { 
		grabed = nada
	}

        method mover() {}

        method catched() {
            vidas -= 1
            if ( vidas == 0) {
		game.say(self, "Perdi!!!!!")
                // pensar ir a pantalla con estadisticas
		game.schedule(3000,{game.stop()})
            }

        }

}

object none{
        const property image = ""
        const property position = game.at(0,0)
        method mover() {}
	
}

object nada{
	var property position = null
	method trigger(detino){}
	method colisionasteCon(alguien){
	}
}

object gun{
	var property image = "assets/gun.png"
	var property position = game.at(5,5)
        var multiverse = 1
	const property isPortal = false

        method multiverse(value) { multiverse = value }
        
	method position() = omniverse.position(position, multiverse)

	method trigger(multiverseDestino){
            self.verificarMultiversoDestinoEsDiferenteAlActual(multiverseDestino)
            self.crearPortalA(multiverseDestino)
	}

        method crearPortalA(multiverseDestino){
            const portal = new Portal(position = position, multiverse = multiverse, exit = 
                           new Portal(position = position, multiverse = multiverseDestino, exit = null))
            portal.exit().exit(portal)
            game.addVisual(portal)
            game.addVisual(portal.exit())
        }

        method verificarMultiversoDestinoEsDiferenteAlActual(multiversoDestino){
            if (multiversoDestino == multiverse)  {
                game.errorReporter(self)
                self.error("Dame un multiverso destino!")
            }
        }
	
	method mover(){}
	
	method colisionasteCon(alguien){
		game.say(alguien,"Al fin, mi pistola de portales")
	}
}


class Portal{
	const position 
        const property multiverse 
	const property image = "assets/portal.gif"
	const property isPortal = true
        var property exit

	method position() = omniverse.position(position, multiverse)

	
	method travel(traveler) { 
            omniverse.current(exit.multiverse())
            traveler.multiverse(exit.multiverse())
            traveler.position(exit.position())
	}
	
	method colisionasteCon(alguien){}

	method mover(){}
}

class Fondo inherits OmniObjeto{ 
        var property image = "assets/ram-fondo3.png"

	method mover(){}
}

class Enemigo inherits OmniObjeto{
	var property numeroEnemigo
	var property direction = down

        method direction(_direction) { direction = _direction } 

        method direction() = direction

	method mover(){ 
            direction.newMposition(self)
        }
	
	method image() = direction.imageEnemy(numeroEnemigo)

	method colisionasteCon(alguien){
            alguien.catched()
	}
}

