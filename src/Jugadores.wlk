import Fichas.*
import wollok.game.*

object jugador{
	var property position = game.at(0,13)
	method ponerFicha(){
		game.addVisual(new Ficha( player = self , position = game.at(self.position().x() , self.puedePonerFicha() ), image = "assets/FichaAmarilla.png" ))
	}
	
	method puedePonerFicha() {
		var column = game.allVisuals().filter{ visual => visual.position().x() == self.position().x()}
		
		return column.size()
	}	
	
}

