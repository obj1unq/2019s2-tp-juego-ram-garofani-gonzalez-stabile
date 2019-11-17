import wollok.game.*
import objetos.mixins.*
import objetos.objects.*
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

class OmniObjeto mixed with NotCollectable {
    var property mposition // = game.origin()
    var property multiverse

    method position() = omniverse.position(mposition, multiverse)

    method mover(){}
}