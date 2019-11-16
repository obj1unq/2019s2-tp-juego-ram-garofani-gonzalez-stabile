import wollok.game.*
import niveles.*

//Super refac MUCHO codigo repetido

mixin Common{

    method inEdge(objeto)

    method toNewMposition(objeto) { if (self.inEdge(objeto)) self.reverse(objeto) else objeto.moveTo(objeto.direction()) }

    method reverse(objeto) { objeto.direction(self.oposite()) }

    method oposite()

}

object up mixed with Common{

    override method inEdge(objeto) = objeto.mposition().y() == game.height()-2

    override method oposite() = down

    method imageRick() = "assets/RickBack.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Back.png"

    method nextPosition(_position) {
        const nextPosition = game.at(_position.x(), (_position.y() + 1).min(game.height()))
         if(niveles.puedeMoverSiguientePosicion(nextPosition))
            return nextPosition
         else
            return _position
    }

}
object down mixed with Common{

    override method inEdge(objeto) = objeto.mposition().y() == 0

    override method oposite() = up

    method imageRick() = "assets/RickFront.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Front.png"

    method nextPosition(_position) {
        const nextPosition = game.at(_position.x(), (_position.y() - 1).max(0))
         if(niveles.puedeMoverSiguientePosicion(nextPosition))
            return nextPosition
         else
            return _position
    }
}
object left mixed with Common{

    override method inEdge(objeto) = objeto.mposition().x() == 0

    override method oposite() = right

    method imageRick() = "assets/RickLeft.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Left.png"

    method nextPosition(_position) {
        const nextPosition = game.at((_position.x() - 1).max(0), _position.y())
         if(niveles.puedeMoverSiguientePosicion(nextPosition))
            return nextPosition
         else
            return _position
    }
}
object right mixed with Common{

    override method inEdge(objeto) = objeto.mposition().x() == game.width()-1

    override method oposite() = left

    method imageRick() = "assets/RickRight.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Rigth.png"

    method nextPosition(_position) {
        const nextPosition = game.at((_position.x() + 1).min(game.width()), _position.y())
         if(niveles.puedeMoverSiguientePosicion(nextPosition))
            return nextPosition
         else
            return _position
    }
}
