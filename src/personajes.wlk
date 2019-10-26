import wollok.game.*
import niveles.*
import Directions.*
import Movimientos.*
object rick{
	//var property image = "assets/r-face-smile.png"
	var position = game.at(1,1)
	var grabed = nada 
	var direction = directionDown
	
	method image(){
		return direction.imageRick()
	}
	
	method position() = return position

	method position(_position,rickDirection) { 
		direction = rickDirection
		position = _position
		grabed.position(position)
	}

	method travel() { game.colliders(self).find{
		visible=> visible.isPortal() }.travel()
	}

	method trigger() { grabed.trigger() }

	method grab() { 
		grabed = game.colliders(self).head()
	}

	method ungrab() { 
		grabed = nada
	}
	
	method colisionasteCon(alguien){
	}
}

object nada{
	var property position = null
	method trigger(){}
}

object gun{
	var property image = "assets/gun.png"
	var property position = game.at(5,5)
	const property isPortal = false

	method trigger(){
		game.addVisual(new Portal(position = self.position()))
	}
	
	method mover(){}
	
	method colisionasteCon(alguien){
		game.say(alguien,"Al fin, mi pistola de portales")
	}
}

class Portal{
	var property position
	const property image = "assets/portal.gif"
	const property isPortal = true
	
	method travel() { 
		nivel.actual().hide()
		nivel.actual(nivel.disponibles().get(self.getNextLevel()))
		nivel.actual().show()
	}
	
	method getNextLevel(){
		return (nivel.actual()).siguienteNivel()
	}
	
	method colisionasteCon(alguien){}

}

class Fondo{ var property image = "assets/ram-fondo3.png"
		var property position = game.origin()
}

class Enemigo{
	var property numeroEnemigo
	//var property image = ""
	var property position = game.origin()
	var property direction = directionDown
	var property tipoMovimiento
	
	method mover(){
		tipoMovimiento.mover(self)
	}
	
	method image(){
		return direction.imageEnemy(numeroEnemigo)
	}
	
	method colisionasteCon(alguien){
		game.say(alguien,"Perdi!!!!!")
		game.schedule(3000,{game.stop()})
	}
}

