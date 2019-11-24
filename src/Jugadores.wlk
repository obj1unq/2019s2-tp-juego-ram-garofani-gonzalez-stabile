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
    
    method position(_position) { mposition = _position }
    
    method trigger(destino, direction){
        cuatro.ponerFicha(owner)
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
    	self.irPosicionParaJugada()
    	cuatro.ponerFicha(self)
    }
    
    method irPosicionParaJugada(){   
    	var random = (3).randomUpTo(9).roundUp(0)    	
    	if(cuatro.esColumnaLibre(random,position.y())){
    		position = game.at(random, position.y())
    		grabed.mposition(game.at(random, position.y()))    		
    	}else{
    		self.irPosicionParaJugada()
    	}
    }
    
    method colisionasteCon(alguien){}
    
 }
 
 object cuatro{
 	const property fichasJugadas = []
 	var property winner 
 	method ponerFicha(jugador){
		if(jugador.position().x() < 3 or jugador.position().x() > 9){
			self.error("Las fichas van dentro del tablero.")
		}
		if(self.getVisualsColumnaActual(jugador.position().x(),jugador.position().y()).size() == 6){
			self.error("Aca no entran mas fichas.")
		}
		const pos = game.at(jugador.position().x() , self.posicionLibreEnColumna(jugador).y() )
		
		const ficha = new Ficha(player = jugador , 
							     position = pos, 
								 image = jugador.grabed().imagenFicha()								 
								 )
								 
		fichasJugadas.add(ficha)
		game.addVisual(ficha)	
		
		self.jugadaGanadora(jugador)
			
	}
	
	method mortyDestinyDependsOf(ganador){
		if (ganador == rick){
			winner = ganador
			game.say(morty,"Gracias Rick ME SALVASTE!!!!!!")
		}
	}
	method getVisualsColumnaActual(posX,posY){
		return fichasJugadas.filter{ 
	            ficha => ficha.position().x() == posX
	            and ficha.position().y().between(0, posY + 3)
	            }
	}
		
	method posicionLibreEnColumna(jugador) {
		var column = self.getVisualsColumnaActual(jugador.position().x(), jugador.position().y())
		return game.at(jugador.position().x(), column.size() + 2)
	}
	
	method jugadaGanadora(jugador){
		self.fichasJugadasPor_(jugador).forEach{ficha => 	
			if(	self.ganoHorizontal(ficha,jugador) or
				self.ganoVertical(ficha,jugador) or
				self.ganoDiagonalArriba(ficha,jugador) or
				self.ganoDiagonalAbajo(ficha,jugador)){
					game.say(jugador,"GANE!!!!!!")
					self.mortyDestinyDependsOf(jugador)
					game.schedule(3000,{game.stop()})
				}
		}
	}
	
	method fichasJugadasPor_(jugador){
		return fichasJugadas.filter{ficha => ficha.player() == jugador}
	}
	
	method estanLasFichasConPosiciones(jugador,posUno,posDos,posTres,posCuatro){
		return 
		self.fichasJugadasPor_(jugador).filter{
			ficha => ficha.position() == posUno or
					 ficha.position() == posDos or
					 ficha.position() == posTres or
					 ficha.position() == posCuatro				
		}.size() == 4
	}

	method ganoHorizontal(ficha,jugador) {
		return 	self.estanLasFichasConPosiciones(jugador,
				game.at(ficha.position().x(), ficha.position().y()),
				game.at(ficha.position().x() + 1, ficha.position().y()),
				game.at(ficha.position().x() + 2, ficha.position().y()),
				game.at(ficha.position().x() + 3, ficha.position().y()))
	}
	method ganoVertical(ficha,jugador) {
		return 	self.estanLasFichasConPosiciones(jugador,
				game.at(ficha.position().x(), ficha.position().y()),
				game.at(ficha.position().x(), ficha.position().y() + 1),
				game.at(ficha.position().x(), ficha.position().y() + 2),
				game.at(ficha.position().x(), ficha.position().y() + 3))
	}
	method ganoDiagonalArriba(ficha,jugador) {
		return 	self.estanLasFichasConPosiciones(jugador,
				game.at(ficha.position().x(), ficha.position().y()),
				game.at(ficha.position().x() + 1 , ficha.position().y() + 1),
				game.at(ficha.position().x() + 2 , ficha.position().y() + 2),
				game.at(ficha.position().x() + 3 , ficha.position().y() + 3))  
	}
	method ganoDiagonalAbajo(ficha,jugador) {
		return 	self.estanLasFichasConPosiciones(jugador,
				game.at(ficha.position().x(),ficha.position().y()),
				game.at(ficha.position().x() + 1 ,ficha.position().y() - 1),
				game.at(ficha.position().x() + 2 ,ficha.position().y() - 2),
				game.at(ficha.position().x() + 3 ,ficha.position().y() - 3))
	}	
	
	method esColumnaLibre(posX,posY){
 		var column = self.getVisualsColumnaActual(posX,posY)
		return column.size() < 6
 	}
  	
 }
 
 object morty mixed with NotCollectable{ 	
	var multiverse = 4
	var position =  game.at(11,0)
	method image(){
 		return 
 		if (cuatro.winner() == rick) { 
 			"assets/mortyfree.png"
 		}else{ 
 			"assets/mortyTrapped.png"
 		} 		
 	} 
	method multiverse(value) { multiverse = value }
    method position() = omniverse.position(position, multiverse)
    method colisionasteCon(alguien){}
    
 }