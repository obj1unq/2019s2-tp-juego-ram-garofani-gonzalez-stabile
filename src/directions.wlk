import wollok.game.*

object up {
    
    method position(visual) { 
        visual.position(visual.position().up(1))
        visual.direction(self)
    }

	method imageRick() = "assets/RickBack.png"

	method imageEnemy(numeroEnemigo) = ( "assets/Enemy_" + numeroEnemigo ) + "_Back.png"

	method newMposition(objeto) {
		if (objeto.mposition().y() == game.height() - 2) objeto.direction(down) else objeto.mposition(objeto.mposition().up(1))
	}

}

object down {

    method position(visual) { 
        visual.position(visual.position().down(1))
        visual.direction(self)
    }
	method imageRick() = "assets/RickFront.png"

	method imageEnemy(numeroEnemigo) = ( "assets/Enemy_" + numeroEnemigo ) + "_Front.png"

	method newMposition(objeto) {
		if (objeto.mposition().y() == 0) objeto.direction(up) else objeto.mposition(objeto.mposition().down(1))
	}

}

object left {

    method position(visual) { 
        visual.position(visual.position().left(1))
        visual.direction(self)
    }

	method imageRick() = "assets/RickLeft.png"

	method imageEnemy(numeroEnemigo) = ( "assets/Enemy_" + numeroEnemigo ) + "_Left.png"

	method newMposition(objeto) {
		if (objeto.mposition().x() == 0) objeto.direction(right) else objeto.mposition(objeto.mposition().left(1))
	}

}

object right {

    method position(visual) { 
        visual.position(visual.position().right(1))
        visual.direction(self)
    }

	method imageRick() = "assets/RickRight.png"

	method imageEnemy(numeroEnemigo) = ( "assets/Enemy_" + numeroEnemigo ) + "_Rigth.png"

	method newMposition(objeto) {
		if (objeto.mposition().x() == game.width() - 1) objeto.direction(left) else objeto.mposition(objeto.mposition().right(1))
	}

}

