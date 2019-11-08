import wollok.game.*


object up{
    method imageRick() = "assets/RickBack.png"
	
    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Back.png"

    method newMposition(objeto) { 
        if (objeto.mposition().y() == game.height()-2) 
            objeto.direction(down)
        else 
            objeto.mposition(objeto.mposition().up(1))
    }
    
    method nextPosition(position) = game.at(position.x(), (position.y() + 1).min(game.height()))
}
object down{
    method imageRick() = "assets/RickFront.png"

    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Front.png"
    
    method newMposition(objeto) { 
        if (objeto.mposition().y() == 0 ) 
            objeto.direction(up)
        else 
            objeto.mposition(objeto.mposition().down(1))
    }
    
    method nextPosition(position) = game.at(position.x(), (position.y() - 1).max(0))
}
object left{
    method imageRick() = "assets/RickLeft.png"
	
    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Left.png"

    method newMposition(objeto) { 
        if (objeto.mposition().x() == 0 ) 
            objeto.direction(right)
        else 
            objeto.mposition(objeto.mposition().left(1))
    }
    
    method nextPosition(position) = game.at((position.x() - 1).max(0), position.y())
}
object right{
    method imageRick() = "assets/RickRight.png"
	
    method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Rigth.png"

    method newMposition(objeto) { 
        if (objeto.mposition().x() == game.width()-1) 
            objeto.direction(left)
        else 
            objeto.mposition(objeto.mposition().right(1))
    }
    
    method nextPosition(position) = game.at((position.x() + 1).min(game.width()), position.y())
}
