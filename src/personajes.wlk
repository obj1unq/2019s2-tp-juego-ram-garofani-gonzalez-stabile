import wollok.game.*
import niveles.*
import Directions.*
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

}

class Fondo{ var property image = "assets/ram-fondo3.png"
		var property position = game.origin()
}

