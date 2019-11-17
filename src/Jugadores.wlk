import Fichas.*
import personajes.*
import wollok.game.*

class PilaDeFichas inherits OmniObjeto mixed with Collectable{
    const property image = "assets/ficha-morty-a.png"
	var listaFichas = []
	
	
	
	method jugadaGanadora(){
		var gano = false
		listaFichas.forEach{ ficha => 	if(	self.ganoHorizontal(ficha) or
											self.ganoVertical(ficha) or
											self.ganoDiagonalArriba(ficha) or
											self.ganoDiagonalAbajo(ficha)){
												gano = true
										}
							}
							
		if(gano){ 
			game.say(rick,"GANE!!!!!!")
			game.schedule(3000,{game.stop()})
		}
	}
    method position(_position) { mposition = _position }


    method trigger(destino, direction){
    	
    	// poner fichas solo si esta entre x (algo) y x (algo2) 
    	// si tengo mas de 6 visuals (fichas ) en columna Y (algo) 
        self.ponerFicha()
        self.jugadaGanadora()
    }

	method ponerFicha(){
		listaFichas.add(game.at(self.position().x() , self.posicionLibreEnColumna().y() ))
		game.addVisual(new Ficha( 	player = self , 
									position = listaFichas.last(), 
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

	method ganoHorizontal(ficha) {
		const xPosition = ficha.x()
		const yPosition = ficha.y()
		return 	listaFichas.contains(game.at(xPosition, yPosition)) and 
				listaFichas.contains(game.at(xPosition + 1, yPosition)) and
				listaFichas.contains(game.at(xPosition + 2, yPosition)) and
				listaFichas.contains(game.at(xPosition + 3, yPosition))   
	}


	method ganoVertical(ficha) {
		const xPosition = ficha.x()
		const yPosition = ficha.y()
		return 	listaFichas.contains(game.at(xPosition, yPosition)) and 
				listaFichas.contains(game.at(xPosition, yPosition + 1)) and
				listaFichas.contains(game.at(xPosition, yPosition + 2)) and
				listaFichas.contains(game.at(xPosition, yPosition + 3))  
	}
	method ganoDiagonalArriba(ficha) {
		const xPosition = ficha.x()
		const yPosition = ficha.y()
		return 	listaFichas.contains(game.at(xPosition, yPosition)) and 
				listaFichas.contains(game.at(xPosition + 1 , yPosition + 1)) and
				listaFichas.contains(game.at(xPosition + 2 , yPosition + 2)) and
				listaFichas.contains(game.at(xPosition + 3 , yPosition + 3))  
	}
	method ganoDiagonalAbajo(ficha) {
		const xPosition = ficha.x()
		const yPosition = ficha.y()
		return 	listaFichas.contains(game.at(xPosition,yPosition)) and 
				listaFichas.contains(game.at(xPosition + 1 ,yPosition - 1)) and
				listaFichas.contains(game.at(xPosition + 2 ,yPosition - 2)) and
				listaFichas.contains(game.at(xPosition + 3 ,yPosition - 3))
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

