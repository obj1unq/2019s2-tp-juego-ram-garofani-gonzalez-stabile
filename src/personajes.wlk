import wollok.game.*
import niveles.*

object r{
	var property image = "assets/r-face-smile.png"
	var position = game.at(1,1)
	var grabed = nada 

	method position() = return position

	method position(_position) { 
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

object g{
	var property image = "assets/gun.png"
	var property position = game.at(5,5)
	const property isPortal = false

	method trigger(){
		game.addVisual(new P(position = self.position()))
	}
}

class P{
	var property position
	const property image = "assets/portal.gif"
	const property isPortal = true
	
	method travel() { 
		nivel.actual().hide()
		nivel.actual(nivel.disponibles().get(2))
		nivel.actual().show()
	}

}

class Fondo{ var property image = "assets/ram-fondo3.png"
		var property position = game.origin()
}
