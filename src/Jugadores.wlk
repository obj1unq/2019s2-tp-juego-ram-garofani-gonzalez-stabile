import Fichas.*
import personajes.*
import wollok.game.*

class PilaDeFichas inherits OmniObjeto mixed with Collectable{
    const property image = "assets/ficha-morty-a.png"

    method position(_position) { mposition = _position }


    method trigger(destino, direction){
        self.ponerFicha()
    }

	method ponerFicha(){
		game.addVisual(new Ficha( 	player = self , 
									position = game.at(self.position().x() , self.posicionLibreEnColumna().y() ), 
									image = "assets/ficha-morty-a.png"
		))
//		pc.ponerFicha()
		//validar jugada individual
				
	}
	
	method posicionLibreEnColumna() {
		var column = game.allVisuals().filter{ 
            visual => visual.position().x() == self.position().x() 
            and visual.position().y().between(0, self.position().y() + 3)}
		return game.at(self.position().x(), column.size())
	}		
}


object pedo mixed with NotCollectable{
	var grabbed = new PilaDeFichas(mposition = game.at(12,12), multiverse = 4)
	const property image = "assets/Enemy_6_Rigth.png"
	var property position = game.at(12,12)
    var multiverse = 4
    method multiverse(value) { multiverse = value }
    method position() = omniverse.position(position, multiverse)
	
}

//object pc {
//	const random = {3.randomUpTo(7).roundUp()}
//	var property position = game.at(random.apply(), random.apply())
//	
//	method ponerFicha(){
//		
//		 game.addVisual(new Ficha( player = self , 
//		 					position = game.at(random.apply(), self.posicionLibreEnColumna().y()), 
//		 					image = "assets/ficha-jerry-a.png"
//		 ))
//	}
//	
//	method posicionLibreEnColumna() {
//		var column = game.allVisuals().filter{ 
//            visual => visual.position().x() == self.position().x() 
//            and visual.position().y().between(0, self.position().y() + 3)}
//		return game.at(self.position().x(), column.size())
//	}
//}

