import wollok.game.*
import mixins.*
import barra.*
import objects.*

object omniverse {
    var property current = 5

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
    var property mposition
    var property multiverse

    method imagen()

    method position() = omniverse.position(mposition, multiverse)

    method image() = if (multiverse == omniverse.current() ) self.imagen() else "assets/nada.png"

    method addCollition() {}

    override method mover(){}
}
