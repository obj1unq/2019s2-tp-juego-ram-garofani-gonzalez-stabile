import Fichas.*
import personajes.*
import wollok.game.*

class PilaDeFichasDeRick inherits OmniObjeto mixed with Collectable{
    const property image = "assets/ficha-morty-a.png"
    //const property imagen = "assets/ficha-morty-a.png"

    method position(_position) { mposition = _position }

    method trigger(destino, direction){
        console.println("Hola Grabriel!")
    }

	method ponerFicha(){
		game.addVisual(new Ficha( player = self , position = game.at(self.position().x() , self.puedePonerFicha() ), image = "assets/FichaAmarilla.png" ))
	}
	
	method puedePonerFicha() {
		var column = game.allVisuals().filter{ visual => visual.position().x() == self.position().x()}
		
		return column.size()
	}	

}

