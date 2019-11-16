import wollok.game.*
import niveles.*
import directions.*
import movimientos.*

object omniverse {
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

class OmniObjeto {
    var property mposition // = game.origin()
    var property multiverse

    method position() = omniverse.position(mposition, multiverse)

    method mover(){}

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
    var property direction = down
    var vidas = 3
    const mochila = []

    method image() =  direction.imageRick()

    method multiverse(_multiverse) {
        multiverse = _multiverse
        grabed.multiverse(multiverse)
    }

    method position() = omniverse.position(position, multiverse)

    method position(_position) {
        position = _position
        grabed.position(position)
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

    method trigger(destino) { grabed.trigger(destino, direction) }

    method manipularObjetos(){
        //self.verificarSiHayCollectable()
        if(self.hayObjetoParaAgarrar())
            self.grab()
        else
            self.sacar()
    }

    method sacar() {
        self.puedoSacarObjetosDeLaMochila()
        grabed = mochila.head()
        mochila.remove(grabed)
        barra.acomodar(mochila)
        grabed.position(position)
        //grabed.multiverse(multiverse)
    }

    method grab() {
        grabed = game.colliders(self).find{visual => visual.isCollectable()}
        //grabed.multiverse(omniverse.current())
        mochila.add(grabed)
        barra.acomodar(mochila)
        self.ungrab()
    }

    method hayObjetoParaAgarrar() = game.colliders(self).any{visual => visual.isCollectable() }

    method verificarSiHayCollectable(){
        if (not self.hayObjetoParaAgarrar()) {
            game.errorReporter(self)
            self.error("No hay que agarrar")
        }
    }

    method puedoSacarObjetosDeLaMochila() {
        if(mochila.size() <= 0)
            self.error("No hay nada en la mochila")

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

        game.removeVisual(cofre)
        game.say(self,"Empieza el final!")
    }

    method encontreElCofre(){
        return game.colliders(self).contains(cofre)
    }


    // se mueve si mira en direccion, si no, solo rota en el lugar,
    //method moveRickInDireccion_(_direction){
    //  if(_direction == direction ){
    //      self.position(direction.nextPosition(self.position()))
    //  }
    //  self.direction(_direction)
    //}

    method moveTo(_direction) { // se mueve sin condicion
        self.position(_direction.nextPosition(self.position()))
        self.direction(_direction)
    }

}

object none mixed with NotCollectable{
    const property image = ""
    const property position = game.at(0,0)
}

object nada mixed with NotCollectable {
    var property position = null
    var property multiverse = null
    method trigger(destino, direction){}
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
    var property mposition = game.at(1, 2)
    var property multiverse = 1 // refac hardcoded bad?

    method position() = omniverse.position(mposition, multiverse)

    method position(_position) { mposition = _position }

    method multiverse(value) {
        multiverse = value
    }

    method trigger(destino, direction) {
        new Ray( alcance = 7, mposition = mposition, multiverse = multiverse).shot()
    }

}

class Ray inherits OmniObjeto{
    var alcance

    method image() = "assets/v-ray-red.png"

    method shot() {
        mposition = mposition.up(1)
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
        game.schedule(50, { mposition = mposition.up(1) self.start() } )
    }

    method alcanzado(visual){}

}
/*
class Ray inherits OmniObjeto{
    var alcance
    const  image = "assets/v-ray-red.png"

    method image() = if (multiverse == omniverse.current() ) image else "assets/nada.png""

    method shot() {
        if (alcance > 0) {
            mposition = mposition.up(1)
            game.addVisual(self)
            new Ray( alcance = alcance - 1, mposition = mposition, multiverse = multiverse).shot()
            game.schedule(100, {game.removeVisual(self)})
        }

    }
}
*/

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


        const portal = new Portal(position = rick.direction().nextPosition(position), multiverse = multiverse, exit =
                       new Portal(position = rick.direction().nextPosition(position), multiverse = multiverseDestino, exit = null))
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

    method image() = if (multiverse == omniverse.current() ) image else "assets/nada.png"

    method travel(traveler) {
            omniverse.current(exit.multiverse())
            traveler.multiverse(exit.multiverse())
            traveler.position(exit.position())
    }

    method colisionasteCon(alguien){
        alguien.travel()
    }

}

class Fondo inherits OmniObjeto{
    const image = "assets/ram-fondo3.png"

    method image() = if (multiverse == omniverse.current() ) image else "assets/nada.png"

    method colisionasteCon(alguien){}

    method isPortal() = false

    method isCollectable() = false

    method esObstaculo() = false
}

class Enemigo inherits OmniObjeto mixed with NotCollectable {
    var property numeroEnemigo
    var property direction = down

    method image() = if (multiverse == omniverse.current() )
                            direction.imageEnemy(numeroEnemigo)
                     else "assets/nada.png"

    method direction(_direction) { direction = _direction }

    method direction() = direction

    method moveTo(_direction) { self.mposition(_direction.nextPosition(self.mposition())) }

    override method mover(){
        direction.toNewMposition(self)
        game.schedule(500, { self.mover() })
    }

    method colisionasteCon(alguien){
        alguien.catched()
    }
}

class Monstruo inherits Enemigo mixed with NotCollectable{
    method alcanzado(visual){
        game.removeVisual(self)
    }

    override method mover(){
        direction.toNewMposition(self)
        game.schedule(1000, { self.mover() })
    }

}

class Bloque inherits OmniObjeto{
    var property image =  "assets/blockOculto.png"

    method image() = if (multiverse == omniverse.current() ) image else "assets/nada.png"

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
