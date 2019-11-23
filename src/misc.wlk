import wollok.game.*
import mixins.*

object inicio{
	method getObject(mochila) = mochila.head()
}

object fin{
	method getObject(mochila) = mochila.last()
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
