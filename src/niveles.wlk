import personajes.*
import wollok.game.*

const niveles = [
	 new Nivel(
	  fondo = new Fondo(image = "assets/ram-fondo3.png", _universo = 1),
	  character = rick,
	  objetos = [gun],
	  siguienteNivel = 2 )
	, new Nivel(
	  fondo = new Fondo(image = "assets/ram-fondo1.png", _universo = 2),
	  character = rick,
	  objetos = [gun],
	  siguienteNivel = 1 )
	, new Nivel(
	  fondo = new Fondo(image = "assets/ram-fondo2.png", _universo = 3),
	  character = rick,
	  objetos = [gun],
	  siguienteNivel = 3 )
	  ]

class Nivel{
	const fondo 
	const character 
	const objetos = []
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
