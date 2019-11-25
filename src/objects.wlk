import wollok.game.*
import omniverse.*
import mixins.*
import rick.*

object raygun inherits OmniObjeto(mposition = game.at(1,2), multiverse = 1) mixed with Collectable{

    const property imagen = "assets/ray-gun.png"

    method position(_position) { mposition = _position }

    method trigger(destino, direction) {
        new Ray( direction = direction, alcance = 7, mposition = mposition, multiverse = multiverse).shot()
    }

}

class Ray inherits OmniObjeto{
    var alcance
    const direction
    const property damage = -1

    override method imagen() = self.image()

    override method image() = direction.imageRay()

    method shot() {
        mposition = direction.nextPosition(mposition)
        game.addVisual(self)
        game.onCollideDo(self, {visual => visual.alcanzado(self)})
        self.start()
    }

    method start() {
        if (alcance > 0)
        {
            self.next()
            alcance -= 1
        }
        else
        {
            console.println("visual gone")
            game.removeVisual(self)
        }
    }

    method next(){
        game.schedule(300, { mposition = direction.nextPosition(mposition) self.start() } )
    }

    method alcanzado(visual){}

    method colisionasteCon(param) {}

}

object portalgun mixed with Collectable{
    var property image = "assets/gun.png"
    var property position = game.at(2,2)
    var multiverse = 1
    const property isPortal = false

    method multiverse(value) { multiverse = value }

    method position() = omniverse.position(position, multiverse)

    method image() = if (multiverse == omniverse.current() ) image else "assets/nada.png"

    method trigger(multiverseDestino, direction){
        self.verificarQueNohayPortalEnLaCeldaEn_(direction)
        self.verificarMultiversoDestinoEsDiferenteAlActual(multiverseDestino)
        self.crearPortalA(multiverseDestino, direction)
    }

    method crearPortalA(multiverseDestino, direction){


        const portal = new Portal(mposition = rick.direction().nextPosition(position), multiverse = multiverse, exit =
                       new Portal(mposition = rick.direction().nextPosition(position), multiverse = multiverseDestino, exit = null))
        portal.exit().exit(portal)
        game.addVisual(portal)
        game.addVisual(portal.exit())
    }

    method verificarQueNohayPortalEnLaCeldaEn_(direction){
        if (game.getObjectsIn(direction.nextPosition(position)).any{visual => visual.isPortal()}) {
            game.errorReporter(self)
            self.error("Ya hay un portal ahí")
        }
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


class Portal inherits OmniObjeto mixed with NotCollectable{
    const property imagen = "assets/portal.gif"
    var property exit

    override method isPortal() = true

    method travel(traveler) {
           // no cambiar si noes rick 
           // omniverse.current(exit.multiverse)
            traveler.multiverse(exit.multiverse())
            traveler.mposition(exit.mposition())

            game.schedule(1700, {
                game.removeVisual(self)
                game.removeVisual(exit)
            })
    }

    method colisionasteCon(visual){
        visual.takePortal()
    }

}

class Fondo inherits OmniObjeto{
    const property imagen 

    method colisionasteCon(alguien){}

    method isPortal() = false

    method isCollectable() = false

    method esObstaculo() = false
}



class Bloque inherits OmniObjeto{
    var property imagen =  "assets/blockOculto.png"

    method colisionasteCon(alguien){}

    method esObstaculo() = true
}

object nightVisionGoggles mixed with Collectable{
    var property image = "assets/nightVisionGoggles.png"
    var property position = game.at(0,0)
    var multiverse = 3

    method multiverse(value) { multiverse = value }
    method position() = omniverse.position(position, multiverse)

    method trigger(destino, direction) {
        rick.ponerseLentes()
    }
}

object finalPortal mixed with Collectable{
    //var property image = "assets/treasureChest.png"
    var property image = "assets/FinalPortal.png"
    var property position = game.at(7,2)
    var multiverse = 3

    method multiverse(value) { multiverse = value }
    method position() = omniverse.position(position, multiverse)


}

object portalBattery mixed with Collectable{
    //var property image = "assets/treasureKey.png"
    var property image = "assets/battery.png"
    var property position = game.at(7,3)
    var multiverse = 2

    method multiverse(value) { multiverse = value }
    method position() = omniverse.position(position, multiverse)

    method trigger(destino, direction) { rick.activarPortalFinal() }
}
