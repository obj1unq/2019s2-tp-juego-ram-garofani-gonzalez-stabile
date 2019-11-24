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
	const property listaFichas = []	

    method position(_position) { mposition = _position }
    
    method trigger(destino, direction){
        cuatro.ponerFicha(owner.grabed())
		pedo.jugar()
    }	
}


object pedo mixed with NotCollectable{
	const property grabed = new PilaDeFichas(owner = self,mposition = game.at(3,8), multiverse = 4,imagenFicha = "assets/ficha-jerry-a.png")
	const property image = "assets/fart.png"
	var multiverse = 4
	var position =  game.at(3,8)
    method multiverse(value) { multiverse = value }
    method position() = omniverse.position(position, multiverse)

    method jugar(){
    	self.irPosicionJugada()
    	cuatro.ponerFicha(grabed)
    }
    
    method irPosicionJugada(){   
    	var random = (3).randomUpTo(9).roundUp(0)    	
    	if(cuatro.esColumnaLibre(random,position.y())){
    		position = game.at(random, position.y())
    		grabed.mposition(game.at(random, position.y()))    		
    	}else{
    		self.irPosicionJugada()
    	}
    }
    
    method colisionasteCon(alguien){}
    
 }
 
 object cuatro{
 	const property fichasJugadas = []
 	method ponerFicha(jugador){
		if(jugador.position().x() < 3 or jugador.position().x() > 9){
			self.error("Las fichas van dentro del tablero.")
		}
		if(self.getVisualsColumnaActual(jugador.position().x(),jugador.position().y()).size() == 6){
			self.error("Aca no entran mas fichas.")
		}
		jugador.listaFichas().add(game.at(jugador.position().x() , self.posicionLibreEnColumna(jugador).y() ))
		
		game.addVisual(new Ficha(player = self , 
							     position = jugador.listaFichas().last(), 
								 image = jugador.imagenFicha()
		))			
		
		self.jugadaGanadora(jugador)	
	}
	
	method getVisualsColumnaActual(posX,posY){
		return self.todasLasFichasJugadas().filter{ 
	            pos => pos.x() == posX
	            and pos.y().between(0, posY + 3)
	            }
	}
	
	method todasLasFichasJugadas(){
		return rick.grabed().listaFichas() + pedo.grabed().listaFichas()
	}
	
	method posicionLibreEnColumna(jugador) {
		var column = self.getVisualsColumnaActual(jugador.position().x(), jugador.position().y())
		return game.at(jugador.position().x(), column.size() + 2)
	}
	
	method jugadaGanadora(jugador){
		jugador.listaFichas().forEach{ ficha => 	
			if(	self.ganoHorizontal(ficha,jugador) or
				self.ganoVertical(ficha,jugador) or
				self.ganoDiagonalArriba(ficha,jugador) or
				self.ganoDiagonalAbajo(ficha,jugador)){
					game.say(rick,"GANE!!!!!!")
					game.schedule(3000,{game.stop()})
				}
			}
	}
	
	method ganoHorizontal(ficha,jugador) {
		return 	jugador.listaFichas().contains(game.at(ficha.x(), ficha.y())) and 
				jugador.listaFichas().contains(game.at(ficha.x() + 1, ficha.y())) and
				jugador.listaFichas().contains(game.at(ficha.x() + 2, ficha.y())) and
				jugador.listaFichas().contains(game.at(ficha.x() + 3, ficha.y()))   
	}
	method ganoVertical(ficha,jugador) {
		return 	jugador.listaFichas().contains(game.at(ficha.x(), ficha.y())) and 
				jugador.listaFichas().contains(game.at(ficha.x(), ficha.y() + 1)) and
				jugador.listaFichas().contains(game.at(ficha.x(), ficha.y() + 2)) and
				jugador.listaFichas().contains(game.at(ficha.x(), ficha.y() + 3))  
	}
	method ganoDiagonalArriba(ficha,jugador) {
		return 	jugador.listaFichas().contains(game.at(ficha.x(), ficha.y())) and 
				jugador.listaFichas().contains(game.at(ficha.x() + 1 , ficha.y() + 1)) and
				jugador.listaFichas().contains(game.at(ficha.x() + 2 , ficha.y() + 2)) and
				jugador.listaFichas().contains(game.at(ficha.x() + 3 , ficha.y() + 3))  
	}
	method ganoDiagonalAbajo(ficha,jugador) {
		return 	jugador.listaFichas().contains(game.at(ficha.x(),ficha.y())) and 
				jugador.listaFichas().contains(game.at(ficha.x() + 1 ,ficha.y() - 1)) and
				jugador.listaFichas().contains(game.at(ficha.x() + 2 ,ficha.y() - 2)) and
				jugador.listaFichas().contains(game.at(ficha.x() + 3 ,ficha.y() - 3))
	}	
	
	method esColumnaLibre(posX,posY){
 		var column = self.getVisualsColumnaActual(posX,posY)
		return column.size() < 6
 	}
 }