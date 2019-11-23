import wollok.game.*
import objects.*
import mixins.*
import misc.*
import omniverse.*
import directions.*
import niveles.*

object rick mixed with NotCollectable{
    var position = game.at(1,1)
    var multiverse = 1
    var property grabed = nada
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

    method travel() { self.takePortal() }

    method takePortal() {
        game.colliders(self).find{ visible => visible.isPortal() }.travel(self)
        barra.acomodar(mochila) // acomoda las referencias de la mochila al nuevo multiverso//refac
    }

    method alcanzado() {}

    method trigger(destino) { grabed.trigger(destino, direction) }

    method manipularObjetos(extremo){
        //self.verificarSiHayCollectable()
        if(self.hayObjetoParaAgarrar())
            self.grab()
        else
            self.sacar(extremo)
    }
    
    method sacar(extremo) {
        self.puedoSacarObjetosDeLaMochila()
        grabed = self.getObjectFromBag(extremo)        
        barra.acomodar(mochila)
        grabed.position(position)	
        //grabed.multiverse(multiverse)
    }

    method grab() {
        grabed = game.colliders(self).find{visual => visual.isCollectable()}
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

    method moveTo(_direction) { // se mueve sin condicion
        self.position(_direction.nextPosition(self.position()))
        self.direction(_direction)
    }
    method rotarSentidoHorario(){
        self.direction(direction.siguiente())
    }
    
    method rotarSentidoAntiHorario(){
        self.direction(direction.anterior())
    }
    
    method getObjectFromBag(extremo){ //refac
        const obj = extremo.getObject(mochila)
        mochila.remove(obj)
        return obj
    }
}
