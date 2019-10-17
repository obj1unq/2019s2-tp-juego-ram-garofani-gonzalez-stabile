import personajes.*
import wollok.game.*
import Movimientos.*
object nivel{ 
	var property actual //= disponibles.get(1)
	const property disponibles = new Dictionary()
	method init(){
		disponibles.put( 1, new Nivel(
		  fondo = new Fondo(image = "assets/ram-fondo3.png"),
		  character = rick,
		  objetos = [gun] + self.getListOfEnemies(),
		  siguienteNivel = 2 ))
		disponibles.put( 3, new Nivel(
		  fondo = new Fondo(image = "assets/ram-fondo1.png"),
		  character = rick,
		  objetos = [gun] + self.getListOfEnemies(),
		  siguienteNivel = 1 ))
		disponibles.put( 2, new Nivel(
		  fondo = new Fondo(image = "assets/ram-fondo2.png"),
		  character = rick,
		  objetos = [gun] + self.getListOfEnemies(),
		  siguienteNivel = 3 ))
	}
	
	method getListOfEnemies(){		
		var enemies = []
		new Range(start = 1, end = self.numberOfEnemies()).forEach { 
			 value => enemies.add(self.createNewEnemy(value))
		}
		return enemies
	}
	
	method numberOfEnemies() = new Range(start = 1, end = 4).anyOne()
	
	method createNewEnemy(number){
		return new Enemigo(	tipoMovimiento = self.getRandomMovementType(),
							numeroEnemigo = number,
						 	position = game.at(new Range(start = 1, end = 10).anyOne(),new Range(start = 1, end = 10).anyOne())
		)
	}
	
	method getRandomMovementType(){
		return (new Movimientos()).disponibles().anyOne()
	}
}

class Nivel{
	const fondo 
	const character 
	const property objetos = []
	var visibles = []
	const property siguienteNivel 

	method show(){
		visibles = [fondo, character] + objetos 
		console.println(visibles)
		visibles.forEach{v => game.addVisual(v)}
	}
	method hide(){
		//game.allVisuals() No funca
		visibles.forEach{v => game.removeVisual(v)}
	}
}
