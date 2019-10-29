import wollok.game.*

object directionDown{
	method imageRick() = "assets/RickFront.png"
	
	method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Front.png"
}

object directionUp{
	method imageRick() = "assets/RickBack.png"
	
	method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Back.png"
}

object directionLeft{
	method imageRick() = "assets/RickLeft.png"
	
	method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Left.png"
}

object directionRight{
	method imageRick() = "assets/RickRight.png"
	
	method imageEnemy(numeroEnemigo) = "assets/Enemy_"+numeroEnemigo+"_Rigth.png"
}

object up{
    method newMposition(objeto) { 
        if (objeto.mposition().y() == game.height()-1) 
            objeto.tipoMovimiento(down)
        else 
            objeto.mposition(objeto.mposition().up(1))
    }
}
object down{
    method newMposition(objeto) { 
        if (objeto.mposition().y() == 0 ) 
            objeto.tipoMovimiento(up)
        else 
            objeto.mposition(objeto.mposition().down(1))
    }
}
object left{
    method newMposition(objeto) { 
        if (objeto.mposition().x() == 0 ) 
            objeto.tipoMovimiento(right)
        else 
            objeto.mposition(objeto.mposition().left(1))
    }
}
object right{
    method newMposition(objeto) { 
        if (objeto.mposition().x() == game.width()-1) 
            objeto.tipoMovimiento(left)
        else 
            objeto.mposition(objeto.mposition().right(1))
    }
}
