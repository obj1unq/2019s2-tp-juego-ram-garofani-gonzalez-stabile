import personajes.*
import wollok.game.*

class Ficha{
	const property player	
	const property position
	const property imagen = ""
}

class PilaDeFichas inherits OmniObjeto mixed with Collectable{
	var jugador = rick
	var cantidad = 24
	const listaFichas = []
	const property image = "assets/ficha-morty-a.png"
	var property positionjugador = jugador.position()
	method position(_position) { mposition = _position }
	method trigger(destino, direction){
        self.colocarFichaEnTablero()
    }
	method colocarFichaEnTablero() {
		listaFichas.add(
			game.addVisual(	
				new Ficha(	
					player = jugador,
					position = game.at(self.positionjugador().x(), self.primerLugarVacioenColumna(self.positionjugador().x())),
					imagen = "assets/ficha-morty-a.png"
				)
			)
		)
		cantidad -= 1 	
	}
	
method primerLugarVacioenColumna(x){
	var columna = game.allVisuals().filter{ visual => visual.position().x() == self.position().x() }
	return (columna.size() - 1).max(0) 
}

//method jugadaGanadora(){
//	listaFichas.filter
//}
//method jugadaHorizontal(ficha){}
//method jugadaVertical(ficha){}
//method jugadaDiagonalDerecha(ficha){}
//method jugadaDiagonalIzquierda(ficha){}
}









