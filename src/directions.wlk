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
    method newPosition(objeto) { 
        if (objeto.position().y() == game.height()-1) 
            objeto.tipoMovimiento(down)
        else 
            objeto.position(objeto.position().up(1))
    }
}
object down{
    method newPosition(objeto) { 
        if (objeto.position().y() == 0 ) 
            objeto.tipoMovimiento(up)
        else 
            objeto.position(objeto.position().down(1))
    }
}
object left{
    method newPosition(objeto) { 
        if (objeto.position().y() == game.width()-1) 
            objeto.tipoMovimiento(right)
        else 
            objeto.position(objeto.position().left(1))
    }
}
object right{
    method newPosition(objeto) { 
        if (objeto.position().y() == 0 ) 
            objeto.tipoMovimiento(left)
        else 
            objeto.position(objeto.position().right(1))
    }
}
