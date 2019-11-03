import wollok.game.*
import niveles.*
import directions.*
import movimientos.*

object omniverse mixed with NotCollectable{
    var property current = 1

    method position(pos, multiverse) = game.at(self.xfor(pos, multiverse), self.yfor(pos, multiverse) )

    method xfor(pos, multiverse) = self.origenXde(multiverse) + pos.x()

    method yfor(pos, multiverse) = self.origenYde(multiverse) + pos.y()

    method ancho() = game.width()

    method alto() = game.height() - barra.altura()

    method origenXde(multiverse) = self.ancho() * self.distanciaACurrent(multiverse)

    method origenYde(multiverse) = self.alto() * self.distanciaACurrent(multiverse)

    method distanciaACurrent(multiverse) = multiverse - current
}

class OmniObjeto mixed with NotCollectable{
	var property mposition = game.origin() 
	var multiverse 

    method multiverse(value) { multiverse = value }

	method position() = omniverse.position(mposition, multiverse)
	
	override method mover(){}
	
	override method esObstaculo() = false
	
}

object barra mixed with NotCollectable{
    // Refac
    const property image = "assets/barra.png"
    const property mposition = game.at(0, 13)
	method position() = omniverse.position(mposition, omniverse.current())

    method acomodar(mochila){ 
        mochila.fold(0, {
            index, visual => 
            visual.position(game.at(mposition.x() + index, mposition.y()))
            visual.multiverse(omniverse.current())
            index + 1 })
    }

    method altura() = 1

}

object rick mixed with NotCollectable{ 
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
        if (niveles.puedeMoverSiguientePosicion(_position)){ 
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

    method takePortal() {
        game.colliders(self).find{ visible => visible.isPortal() }.travel(self)
        barra.acomodar(mochila) // acomoda las referencias de la mochila al nuevo multiverso//refac
    }

	method trigger(destino) { grabed.trigger(destino) }

    // Refac
    method guardar() { 
        grabed.verificarInventariable(self)
        grabed.multiverse(omniverse.current())
        mochila.add(grabed)
        barra.acomodar(mochila)
        self.ungrab()
    }

    method sacar() {
        grabed = mochila.head()
        mochila.remove(grabed)
        barra.acomodar(mochila)
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

    method catched() {
        vidas -= 1
        if ( vidas == 0) {
            game.say(self, "Perdi!!!!!\nBye Bye!")
            // pensar ir a pantalla con estadisticas
            game.schedule(3000,{game.stop()})
        } else 
            game.say(self, "Outch!!!!!")
    }

    method isPortal() = false
    
    method ponerseLentes(){
    	if(!self.tieneElObjetoEnLaMochila(nightVisionGoggles)){
    		self.error("No tengo los lentes de vision nocturna");
    	}    	
    	niveles.mostrarBloquesEnAreasProhibidas()  	
    	niveles.ponerCofre()
    }
    
    method tieneElObjetoEnLaMochila(objeto){
    	return mochila.contains(objeto)
    }
    
    method abrirCofre(){
    	if(!self.encontreElCofre()){
    		self.error("Aca no hay ningun cofre");
    	}
    	if(!self.tieneElObjetoEnLaMochila(llave)){
    		self.error("Necesito la llave para abrir el cofre");
    	}
		game.removeVisual(cofre)
		game.say(self,"Empieza el final!")
    }
    
    method encontreElCofre(){
    	return game.colliders(self).contains(cofre)
    }

}

object none mixed with NotCollectable{
    const property image = ""
    const property position = game.at(0,0)	
}

object nada mixed with NotCollectable {
	var property position = null
    var property multiverse = null
	method trigger(destino){}
	method colisionasteCon(alguien){ }
    method verificarInventariable(owner) {
        game.errorReporter(owner)
        self.error("Nada que guardar!")
    }
}

mixin Collectable{
	const property esObstaculo = false
	
	method colisionasteCon(alguien){
		game.say(alguien,self.quote())
	}

    method quote() = [
            "Hare guiso de lentejas con esto!",
            "Wubba lubba dub dub",
            "A veces la ciencia es mas arte que ciencia",
            "No so fast!"
        ].anyOne()

    method isCollectable() = true
    method verificarInventariable(owner) { }
    
    method mover(){}
}

mixin NotCollectable{
	method esObstaculo() = false
    method isCollectable() = false
    method mover(){}	
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

	override method colisionasteCon(alguien){
		game.say(alguien,"Al fin, mi pistola de portales")
	}
}


class Portal mixed with NotCollectable{
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

}

class Fondo inherits OmniObjeto{ 
   	var property image = "assets/ram-fondo3.png"
	
	method colisionasteCon(alguien){}

    method isPortal() = false
}

class Enemigo inherits OmniObjeto{
	var property numeroEnemigo
	var property direction = down
	var property image = ""
    method direction(_direction) { direction = _direction } 

    method direction() = direction

	override method mover(){ 
        direction.newMposition(self)
    }
	
	method image() = direction.imageEnemy(numeroEnemigo)

	method colisionasteCon(alguien){
    	alguien.catched()
	}
}

class Bloque inherits OmniObjeto{
	var property image =  "assets/blockOculto.png"
	method colisionasteCon(alguien){}
	
	override method esObstaculo() = true
}

object nightVisionGoggles mixed with Collectable{
	var property image = "assets/nightVisionGoggles.png"
	var property position = game.at(0,0)
	var multiverse = 3
	method multiverse(value) { multiverse = value }        
	method position() = omniverse.position(position, multiverse)
}

object cofre mixed with Collectable{
	var property image = "assets/treasureChest.png"
	var property position = game.at(7,3)
	var multiverse = 3
	method multiverse(value) { multiverse = value }        
	method position() = omniverse.position(position, multiverse)
}

object llave mixed with Collectable{
	var property image = "assets/treasureKey.png"
	var property position = game.at(7,3)
	var multiverse = 2
	method multiverse(value) { multiverse = value }        
	method position() = omniverse.position(position, multiverse)
}
