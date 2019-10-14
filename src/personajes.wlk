import wollok.game.*
import niveles.*

const rick = new Rick(position = game.at(3,7), nroUniverso = 1)

class ObjetoDelMultiverso {
	var position
	var nroUniverso
        method position() = multiverso.at(position, nroUniverso)
	method position(_position) { position = _position }
	method position(_position, universo) { 
                nroUniverso = universo
		self.position(multiverso.at(_position, nroUniverso))
	}
}

object multiverso{
  var property enVista = null
  method add(visual) { game.addVisual(visual) } 
  method remove(visual) { game.removeVisual(visual) } 
  method at(x, y, z) = game.at(x + self.deltaX(z), y + self.deltaY(z)) 
  method at(position, z) = self.at(position.x(), position.y(), z  ) 
  method delta(universoLocal)  = universoLocal - self.enVista()
  method deltaX(universoLocal) = self.delta(universoLocal) * game.width()
  method deltaY(universoLocal) = self.delta(universoLocal) * game.height()
}

class Rick inherits ObjetoDelMultiverso{
	var property image = "assets/r-face-smile.png"
	const property isPortal = false
	var grabed = nada

	override method position(_position) { 
		super(_position)
		grabed.position(position)
        }
            
	/*
	method position(_position, _universo) { 
                nroUniverso = _universo
		self.position(multiverso.at(_position, nroUniverso))
	} */

	method travel() { game.colliders(self).find{
		visible=> visible.isPortal() }.travel(self)
	}

	method trigger(nroUniversoDestino) { grabed.trigger(nroUniversoDestino) }

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

object gun inherits ObjetoDelMultiverso{
	var property image = "assets/gun.png"
	const property isPortal = false

	method trigger(nroUniversoDestino){
		portal.createTo(position, nroUniverso, nroUniversoDestino)
	}
}

object portal{
	const positionRandom = { game.at( 0.randomUpTo(game.width()), 0.randomUpTo(game.height()) ) }
	method createTo(position, nroUniversoOrigen, nroUniversoDestino){
		const portal = new Portal(position = position, nroUniverso = nroUniversoOrigen , tween = 
			new Portal(position = positionRandom.apply(), nroUniverso = nroUniversoDestino, tween = portal)
			)
		multiverso.add(portal)
		multiverso.add(portal.tween())
	}
}

class Portal{
        const property nroUniverso = null
	const position
	const property image = "assets/portal.gif"
	const property isPortal = true
	const property tween = null

        method position() = multiverso.at(position, nroUniverso)

	method travel(visual) {
		visual.position(tween.position(), tween.nroUniverso())
	}
	method disapear(){
		multiverso.remove(tween)
		multiverso.remove(self)
	}

}

class Fondo{
	const image = null
	const _universo = null
	const position = multiverso.at(0, 0, _universo)
}
