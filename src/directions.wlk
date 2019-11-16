import wollok.game.*
import niveles.*

class Directions{
    var property typeDirection

    method changeDirection(_direction){
        typeDirection = _direction
    }

    method imageRick() = typeDirection.imageRick()

    method imageEnemy(numeroEnemigo) = typeDirection.imageEnemy(numeroEnemigo)

    // en direction del objeto (supuestamente) habia una instancia de Direction y la cambias por un wko
    method newMposition(objeto) {
        if (typeDirection.estaEnElBorde(objeto))
            //objeto.direction(typeDirection.opuesto())
            self.changeDirection(typeDirection.opuesto())
        else
            objeto.mposition(self.nextPosition(objeto.mposition()))

	}
	
	method nextPosition(_position) {
    	const nextPosition = typeDirection.nextPosition(_position)
    	 if(niveles.puedeMoverSiguientePosicion(nextPosition))
    	 	return nextPosition     	 	
    	 else
    	 	return _position  	
	}
	
	method anterior() = typeDirection.anterior()
	method siguiente() = typeDirection.siguiente()
}


object up{
    method imageRick() = "assets/RickBack.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Back.png"
    
	method estaEnElBorde(objeto) = objeto.mposition().y() == game.height()-2	
    
    method nextPosition(_position) = game.at(_position.x(), (_position.y() + 1).min(game.height()))  		
	
	method opuesto() = down
	
	method siguiente() = right
	
	method anterior() = left
}

object down{
    method imageRick() = "assets/RickFront.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Front.png"

    method estaEnElBorde(objeto) = objeto.mposition().y() == 0 
	
	method nextPosition(_position) = game.at(_position.x(), (_position.y() - 1).max(0))
	
	method opuesto() = up
	
	method siguiente() = left
	
	method anterior() = right
}
object left{
    method imageRick() = "assets/RickLeft.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Left.png"

	method estaEnElBorde(objeto) = objeto.mposition().x() == 0 
	
	method nextPosition(_position) = game.at((_position.x() - 1).max(0), _position.y())  
	
	method opuesto() = right 
	
	method siguiente() = up
	
	method anterior() = down
}
object right{
    method imageRick() = "assets/RickRight.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Rigth.png"

    method estaEnElBorde(objeto) = objeto.mposition().x() == game.width()-1

    method nextPosition(_position) = game.at((_position.x() + 1).min(game.width()), _position.y())

    method opuesto() = left
    
    method siguiente() = down
    
    method anterior() = up
}
