import personajes.*
import wollok.game.*

object nivel{ 
	var property actual //= disponibles.get(1)
	const property disponibles = new Dictionary()
	method init(){
		disponibles.put( 1, new Nivel(
		  fondo = new Fondo(image = "assets/ram-fondo3.png"),
		  character = rick,
		  objetos = [gun] ))
		disponibles.put( 3, new Nivel(
		  fondo = new Fondo(image = "assets/ram-fondo1.png"),
		  character = rick,
		  objetos = [] ))
		disponibles.put( 2, new Nivel(
		  fondo = new Fondo(image = "assets/ram-fondo2.png"),
		  character = rick,
		  objetos = [] ))
	}
}

class Nivel{
	const fondo 
	const character 
	const objetos = []
	var visibles = []

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
