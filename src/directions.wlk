import wollok.game.*
import niveles.*

mixin Common {

	method inEdge(objeto)

	method toNewMposition(objeto) {
		if (self.inEdge(objeto)) self.reverse(objeto) else objeto.moveTo(objeto.direction())
	}

	method reverse(objeto) {
		objeto.direction(self.oposite())
	}

	method oposite()

	method next(position)

	method nextPosition(position) = if (niveles.puedeMover(self.next(position))) self.next(position) else position

}

object up mixed with Common {

	override method inEdge(objeto) = objeto.mposition().y() == game.height() - 2

	override method oposite() = down

	method siguiente() = right

	method anterior() = left

	method imageRick() = "assets/RickBack.png"

	method imageEnemy(numeroEnemigo) = "assets/Enemy_" + numeroEnemigo + "_Back.png"

	method imageRay() = "assets/v-ray-red.png"

	override method next(position) = game.at(position.x(), (position.y() + 1).min(game.height()))

}

object down mixed with Common {

	override method inEdge(objeto) = objeto.mposition().y() == 0

	override method oposite() = up

	method imageRick() = "assets/RickFront.png"

	method imageEnemy(numeroEnemigo) = "assets/Enemy_" + numeroEnemigo + "_Front.png"

	method imageRay() = "assets/v-ray-red.png"

	override method next(position) = game.at(position.x(), (position.y() - 1).max(0))

	method siguiente() = left

	method anterior() = right

}

object left mixed with Common {

	override method inEdge(objeto) = objeto.mposition().x() == 0

	override method oposite() = right

	method imageRick() = "assets/RickLeft.png"

	method imageEnemy(numeroEnemigo) = "assets/Enemy_" + numeroEnemigo + "_Left.png"

	method imageRay() = "assets/h-ray-red.png"

	override method next(position) = game.at((position.x() - 1).max(0), position.y())

	method siguiente() = up

	method anterior() = down

}

object right mixed with Common {

	override method inEdge(objeto) = objeto.mposition().x() == game.width() - 1

	override method oposite() = left

	method imageRick() = "assets/RickRight.png"

	method imageEnemy(numeroEnemigo) = "assets/Enemy_" + numeroEnemigo + "_Rigth.png"

	method imageRay() = "assets/h-ray-red.png"

	override method next(position) = game.at((position.x() + 1).min(game.width()), position.y())

	method siguiente() = down

	method anterior() = up

}

