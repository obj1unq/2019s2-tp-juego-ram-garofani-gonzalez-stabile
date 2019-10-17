import Directions.*
class Movimientos{
	const property disponibles = [MovVertical,MovHorizontal,MovEle]
	const property movimientoActual
	
	method mover(objeto){
		movimientoActual.mover(objeto)	
	}	
}

object MovVertical{
	method mover(objeto){		
		var dir = objeto.direction()
		if(dir == directionDown){
			self.moverHaciaAbajo(objeto)
		}else{
			self.moverHaciaArriba(objeto)
		}			
	}	
	
	method moverHaciaAbajo(objeto){
		if(objeto.position().y() > 0){
			objeto.position(objeto.position().down(1))
			objeto.direction(directionDown)
		}else{
			self.moverHaciaArriba(objeto)
		}
	}
	
	method moverHaciaArriba(objeto){
		if(objeto.position().y() < 10){
			objeto.position(objeto.position().up(1))
			objeto.direction(directionUp)
		}else{
			self.moverHaciaAbajo(objeto)
		}
	}
}

object MovHorizontal{
	method mover(objeto){		
		var dir = objeto.direction()
		if(dir == directionLeft){
			self.moverHaciaIzquierda(objeto)
		}else{
			self.moverHaciaDerecha(objeto)
		}			
	}	
	
	method moverHaciaIzquierda(objeto){
		if(objeto.position().x() > 0){
			objeto.position(objeto.position().left(1))
			objeto.direction(directionLeft)
		}else{
			self.moverHaciaDerecha(objeto)
		}
	}
	
	method moverHaciaDerecha(objeto){
		if(objeto.position().x() < 10){
			objeto.position(objeto.position().right(1))
			objeto.direction(directionRight)
		}else{
			self.moverHaciaIzquierda(objeto)
		}
	}
}

object MovEle{
	method mover(objeto){MovHorizontal.mover(objeto)}
}
