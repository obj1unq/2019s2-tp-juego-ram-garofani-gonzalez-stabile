import Fichas.*
import personajes.*
import wollok.game.*

class PilaDeFichasDeRick inherits OmniObjeto mixed with Collectable{
    const property image = "assets/ficha-morty-a.png"

    method position(_position) { mposition = _position }


    method trigger(destino, direction){
        self.ponerFicha()
    }

	method ponerFicha(){
		game.addVisual(new Ficha( player = self , position = game.at(self.position().x() , self.posicionLibreEnColumna().y() ), image = "assets/ficha-morty-a.png" ))
	}
	
	method posicionLibreEnColumna() {
		var column = game.allVisuals().filter{ 
            visual => visual.position().x() == self.position().x() 
            and visual.position().y().between(0, self.position().y() - 1)}
		return game.at(self.position().x(), column.size())
	}	

	
}

