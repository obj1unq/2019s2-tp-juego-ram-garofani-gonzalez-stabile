import Fichas.*
import rick.*
import omniverse.*
import mixins.*
import wollok.game.*

class PilaDeFichasDeRick inherits OmniObjeto mixed with Collectable{
    const property imagen = "assets/ficha-morty-a.png"

    method position(_position) { mposition = _position }


    method trigger(destino, direction){
        self.ponerFicha()
    }

	method ponerFicha(){
		game.addVisual(new Ficha( 	player = self , 
									position = game.at(self.position().x() , self.posicionLibreEnColumna().y() ), 
									image = "assets/ficha-morty-a.png"
		))
		pc.ponerFicha()
		//validar jugada individual
				
	}
	
	method posicionLibreEnColumna() {
		var column = game.allVisuals().filter{ 
            visual => visual.position().x() == self.position().x() 
            and visual.position().y().between(0, self.position().y() + 3)}
		return game.at(self.position().x(), column.size())
	}		
}

object pc {
	const random = {3.randomUpTo(7).roundUp()}
	var property position = game.at(random.apply(), random.apply())
	
	method ponerFicha(){
		
		 game.addVisual(new Ficha( player = self , 
		 					position = game.at(random.apply(), self.posicionLibreEnColumna().y()), 
		 					image = "assets/ficha-jerry-a.png"
		 ))
	}
	
	method posicionLibreEnColumna() {
		var column = game.allVisuals().filter{ 
            visual => visual.position().x() == self.position().x() 
            and visual.position().y().between(0, self.position().y() + 3)}
		return game.at(self.position().x(), column.size())
	}
}

