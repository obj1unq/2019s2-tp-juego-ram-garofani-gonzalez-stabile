import wollok.game.*
import niveles.*

const rick = new Rick()

object universo{
  var property enVista = null
  method add(visual) { game.addVisual(visual) } 
  method remove(visual) { game.removeVisual(visual) } 
  method at(x, y, z) = game.at(x + self.deltaX(z), y + self.deltaY(z)) 
  method at(position, z) = self.at(position.x(), position.y(), z  ) 
  method delta(universoLocal) = universoLocal - self.enVista()
  method deltaX(universoLocal) =   self.delta(universoLocal) * game.width()
  method deltaY(universoLocal) =   self.delta(universoLocal) * game.height()
}

class Rick{
	var property image = "assets/r-face-smile.png"
	const property isPortal = false
        var nroUniverso = 1 // C-137
	var position = universo.at(5, 5, nroUniverso)
	var grabed = nada

	method position() = position

	method position(_position) { 
		position = _position
		grabed.position(position)
        }
            
	method position(_position, _universo) { 
                nroUniverso = _universo
		self.position(universo.at(_position, nroUniverso))
	}

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

object gun{
	var property image = "assets/gun.png"
	const property isPortal = false
        var nroUniverso = 1 // C-137
	var property position = universo.at(5, 5, nroUniverso)

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
		universo.add(portal)
		universo.add(portal.tween())
	}
}

class Portal{
        const property nroUniverso = null
	const property position
	const property image = "assets/portal.gif"
	const property isPortal = true
	const property tween = null

	method travel(visual) {
		visual.position(tween.position(), tween.nroUniverso())
	}
	method disapear(){
		universo.remove(tween)
		universo.remove(self)
	}

}

class Fondo{
	const image = null
	const _universo = null
	const position = universo.at(0, 0, _universo)
}
