import wollok.game.*
import omniverse.*
import mixins.*

object indicadorDeVida mixed with NotCollectable{
    var property cantidad = 10

    method cambiar(delta) { cantidad = (cantidad + delta).max(0).min(10) }

    method esCero() = cantidad == 0

    method image() = "assets/indicador"+ cantidad.toString() + ".png"

    method position() = game.at(12,13)

}

object indicadorDeMDestino mixed with NotCollectable{
    var property numero = 0

    method image() = "assets/"+ numero.toString() + ".png"

    method position() = game.at(12,13)

}

object barra mixed with NotCollectable{
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

