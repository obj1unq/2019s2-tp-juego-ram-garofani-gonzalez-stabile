import wollok.game.*
import niveles.*
import Directions.*
import Movimientos.*

object omniverse{
    var property current = 0
    method position(pos, multiverse) = game.at(pos.x() + game.width() * (multiverse - current), pos.y() + game.height() * (multiverse - current))
}

object rick{
	var position = game.at(1,1)
        var multiverse = 0
	var grabed = nada 
	var direction = directionDown
	
	method image() =  direction.imageRick()
	
        method multiverse(value) { 
            multiverse = value 
            grabed.multiverse(multiverse)
        }
        
	method position() = omniverse.position(position, multiverse)

	method position(_position) { 
		position = _position
		grabed.position(position)
	}

        method direction(_direction) { direction = _direction }

	method travel() { game.colliders(self).find{
		visible => visible.isPortal() }.travel(self)
	}

	method trigger() { grabed.trigger() }

	method grab() { 
		grabed = game.colliders(self).head()
	}

	method ungrab() { 
		grabed = nada
	}

        method mover() {}
}

object none{
        const property image = ""
        const property position = game.at(0,0)
        method mover() {}
}

object nada{
	var property position = null
	method trigger(){}
}

object gun{
	var property image = "assets/gun.png"
	var property position = game.at(5,5)
        var multiverse = 0
	const property isPortal = false

        method multiverse(value) { multiverse = value }
        
	method position() = omniverse.position(position, multiverse)

	method trigger(){
            const portal = new Portal(position = position, multiverse = multiverse, exit = 
                           new Portal(position = position, multiverse = multiverse + 1, exit = null))
            portal.exit().exit(portal)
            game.addVisual(portal)
            game.addVisual(portal.exit())
	}
	
	method mover(){}
}


class Portal{
	const property position 
        const property multiverse 
	const property image = "assets/portal.gif"
	const property isPortal = true
        var property exit

	method position() = return omniverse.position(position, multiverse)

	
	method travel(traveler) { 
            omniverse.current(exit.multiverse())
            traveler.multiverse(exit.multiverse())
            traveler.position(exit.position())
		//nivel.actual().hide()
		//nivel.actual(nivel.disponibles().get(self.getNextLevel()))
		//nivel.actual().show()
	}
	
        /*
	method getNextLevel(){
		return (nivel.actual()).siguienteNivel()
	} */

}

class Fondo{ var property image = "assets/ram-fondo3.png"
	var position = game.origin()
        var multiverse 
        method multiverse(value) { multiverse = value }
	method position() = return omniverse.position(position, multiverse)
}

class Enemigo{
	var property numeroEnemigo
	//var property image = ""
	var property direction = directionDown  // property to make Movimientos work
	var property tipoMovimiento
	
	var property position = game.origin() // property to make Movimientos work

        var multiverse 

        method multiverse(value) { multiverse = value }

	method position() = return omniverse.position(position, multiverse)

        method direction(_direction) { direction = _direction } 

	method mover(){
		tipoMovimiento.mover(self)
	}
	
	method image(){
		return direction.imageEnemy(numeroEnemigo)
	}
}

