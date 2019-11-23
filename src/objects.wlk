import wollok.game.*
import omniverse.*
import mixins.*
import rick.*

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

object raygun mixed with Collectable{

    const property image = "assets/ray-gun.png"
    var property mposition = game.at(1, 2)
    var property multiverse = 1 // refac hardcoded bad?

    method position() = omniverse.position(mposition, multiverse)

    method position(_position) { mposition = _position }

    method multiverse(value) {
        multiverse = value
    }

    method trigger(destino, direction) {
        new Ray( direction = direction, alcance = 7, mposition = mposition, multiverse = multiverse).shot()
    }

}

class Ray inherits OmniObjeto{
    var alcance
    const direction

    override method imagen() = direction.imageRay()

    override method image() = self.imagen()

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
        game.schedule(150, { mposition = direction.nextPosition(mposition) self.start() } )
    }

    method alcanzado(visual){}

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
        self.verificarMultiversoDestinoEsDiferenteAlActual(multiverseDestino)
        self.crearPortalA(multiverseDestino, direction)
    }

    method crearPortalA(multiverseDestino, direction){ // refac crear portal en esta direccion


        const portal = new Portal(mposition = rick.direction().nextPosition(position), multiverse = multiverse, exit =
                       new Portal(mposition = rick.direction().nextPosition(position), multiverse = multiverseDestino, exit = null))
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



class Portal inherits OmniObjeto mixed with NotCollectable{
   // const mposition
   // const property multiverse
    const property imagen = "assets/portal.gif"
    var property exit

    //method position() = omniverse.position(mposition, multiverse)

    //method image() = if (multiverse == omniverse.current() ) image else "assets/nada.png"

    override method isPortal() = true

    method travel(traveler) {
            omniverse.current(exit.multiverse())
            traveler.multiverse(exit.multiverse())
            traveler.position(exit.position())
            game.removeVisual(self)
            game.removeVisual(exit)
    }

    method colisionasteCon(alguien){
        alguien.travel()
    }

}

class Fondo inherits OmniObjeto{
    const property imagen = "assets/ram-fondo3.png"

    //override method image() = if (multiverse == omniverse.current() ) image else "assets/nada.png"

    method colisionasteCon(alguien){}

    method isPortal() = false

    method isCollectable() = false

    method esObstaculo() = false
}



class Bloque inherits OmniObjeto{
    var property imagen =  "assets/blockOculto.png"

    //override method image() = if (multiverse == omniverse.current() ) image else "assets/nada.png"

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

    method trigger(destino, direction) { rick.abrirCofre() }
}
