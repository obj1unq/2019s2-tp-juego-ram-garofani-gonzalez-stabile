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

object barra{
    // Refac
    const property image = "assets/barra.png"
    const property mposition = game.at(0, 13)

	method position() = omniverse.position(mposition, omniverse.current())

    method mover() {}

}

object rick{ // Wubba lubba dub dub
	var position = game.at(1,1)
    var multiverse = 1
	var grabed = nada 
	var direction = down
    var vidas = 3
    const mochila = []
	
	method image() =  direction.imageRick()
	
    method multiverse(_multiverse) { 
        multiverse = _multiverse
        grabed.multiverse(multiverse)
    }
    
	method position() = omniverse.position(position, multiverse)

	method position(_position) { 
        if (not niveles.estaFueraDeLosLimites(_position)){
            position = _position
            grabed.position(position)
        }
    }


    method direction(_direction) { direction = _direction }

	method travel() { self.verificarSiHayPortal() self.takePortal() }

    method verificarSiHayPortal() { 
            if (not game.colliders(self).any{ visible => visible.isPortal() }) {
                game.errorReporter(self)
                self.error("No hay por donde viajar")
            }
        }

    method takePortal() { game.colliders(self).find{ visible => visible.isPortal() }.travel(self) }

	method trigger(destino) { grabed.trigger(destino) }

    // Refac
    method guardar() { 
        grabed.position(game.at(barra.mposition().x() + mochila.size(), barra.mposition().y() ))
        grabed.multiverse(omniverse.current())
        mochila.add(grabed)
        self.ungrab()
    }

    method sacar() {
        grabed = mochila.head()
        mochila.remove(grabed)
        grabed.position(position)
        grabed.multiverse(multiverse)
    }

	method grab() { 
        self.verificarSiHayCollectable()
		grabed = game.colliders(self).find{visual => visual.isCollectable()}
	}

    method verificarSiHayCollectable(){
        if (not game.colliders(self).any{visual => visual.isCollectable() }) {
            game.errorReporter(self)
            self.error("No hay que agarrar")
        }
    }

	method ungrab() { 
		grabed = nada
	}

    method mover() {}

    method catched() {
        vidas -= 1
        if ( vidas == 0) {
            game.say(self, "Perdi!!!!!\nBye Bye!")
            // pensar ir a pantalla con estadisticas
            game.schedule(3000,{game.stop()})
        } else 
            game.say(self, "Outch!!!!!")
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

mixin Collectable{
	method colisionasteCon(alguien){
		game.say(alguien,"Hare guiso de lentejas con esto!")
	}

    method isCollectable() = true

}

object raygun mixed with Collectable{

    const property image = "assets/ray-gun.png"
    var property mposition = game.at(10, 2)
    var multiverse = 1

    method position() = omniverse.position(mposition, multiverse)

    method position(_position) { mposition = _position }

	method multiverse(value) {
		multiverse = value
	}

    method mover() {}

}
object portalgun mixed with Collectable{
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
	
	override method colisionasteCon(alguien){
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
	
	method colisionasteCon(alguien){}

    method isPortal() = false
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

class Bloque inherits OmniObjeto{
	var property image = "assets/blockOculto.jpg"
	
    //saco esto. debe ser mposition y esta en OmniObjeto
	//var property position
	method colisionasteCon(alguien){}
	method mover(){}
}

object nightVisionGoggles{
	var property image = "assets/nightVisionGoggles.png"
	var property position = game.at(0,0)
	var multiverse = 3
	method multiverse(value) { multiverse = value }        
	method position() = omniverse.position(position, multiverse)
	method colisionasteCon(alguien){}
	method mover(){}
}

