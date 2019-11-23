import Fichas.*
import rick.*
import omniverse.*
import mixins.*
import wollok.game.*
import directions.*
import monstruos.*


class PilaDeFichas inherits OmniObjeto mixed with Collectable{
    const property imagen = "assets/ficha-morty-a.png"
    const owner
    var property imagenFicha = ""
	var listaFichas = []
	
	override method esPilaDeFichas() = true
	
	method jugadaGanadora(){
		var gano = false
		listaFichas.forEach{ ficha => 	
			if(	self.ganoHorizontal(ficha) or
				self.ganoVertical(ficha) or
				self.ganoDiagonalArriba(ficha) or
				self.ganoDiagonalAbajo(ficha)){
					gano = true
				}
			}			
		if(gano){ 
			game.say(owner,"GANE!!!!!!")
			game.schedule(3000,{game.stop()})
		}
	}
    method position(_position) { mposition = _position }
    
    method trigger(destino, direction){
    	
    	// si tengo mas de 6 visuals (fichas ) en columna Y (algo) 
        self.ponerFicha()
        self.jugadaGanadora()
        
    }

	method ponerFicha(){
		if(self.position().x() < 3 or self.position().x() > 9){
			self.error("Las fichas van dentro del tablero.")
		}
		if(self.getVisualsColumnaActual(self.position().x()).size() == 6){
			self.error("Aca no entran mas fichas.")
		}
		listaFichas.add(game.at(self.position().x() , self.posicionLibreEnColumna().y() ))
		game.addVisual(new Ficha(player = self , 
							     position = listaFichas.last(), 
								 image = imagenFicha
		))
				
	}
	
	method posicionLibreEnColumna() {
		var column = self.getVisualsColumnaActual(self.position().x())
		return game.at(self.position().x(), column.size() + 2)
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
	
	method getVisualsColumnaActual(col){
		return game.allVisuals().filter{ 
	            visual => visual.position().x() == col 
	            and visual.position().y().between(0, self.position().y() + 3)
	            and visual.esFicha()}
	}
	method esColumnaLibre(col){
 		var column = self.getVisualsColumnaActual(col)
		return column.size() < 6
 	} 

	
}


object pedo mixed with NotCollectable{
	var grabed = new PilaDeFichas(owner = self,mposition = game.at(3,8), multiverse = 4,imagenFicha = "assets/ficha-jerry-a.png")
	const property image = "assets/fart.png"
	var multiverse = 4
	var position =  game.at(3,8)
    method multiverse(value) { multiverse = value }
    method position() = omniverse.position(position, multiverse)

    method jugar(){
    	self.irPosicionJugada()
    	grabed.trigger(position,up)
    }
    
    method irPosicionJugada(){   
    	var random = (3).randomUpTo(9).roundUp(0)    	
    	if(grabed.esColumnaLibre(random)){
    		position = game.at(random, position.y())
    		grabed.mposition(game.at(random, position.y()))    		
    	}else{
    		self.irPosicionJugada()
    	}
    }
    
    method colisionasteCon(alguien){}
 	
 	
 }