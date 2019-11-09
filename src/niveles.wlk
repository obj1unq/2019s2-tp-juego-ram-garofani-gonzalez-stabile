import personajes.*
import wollok.game.*
import directions.*
import movimientos.*
import cuatro.*
import zonasProhibidas.*
object random{
    method up(n1,n2) = (n1-1).randomUpTo(n2).roundUp(0)
}

object niveles{
    const property catalogo = [
		 new Nivel(
		 	fondo = new Fondo(multiverse = 0, image = "assets/ram-fondo3.png"),
		  	objetos = [barra, rick, portalgun, raygun ] + self.listOfEnemies(0) ),
         new Nivel(
		  	fondo = new Fondo(multiverse = 1,image = "assets/ram-fondo1.png"),
		  	objetos = self.listOfEnemies(1) ),
         new Nivel(
		  	fondo = new Fondo(multiverse = 2,image = "assets/ram-fondo2.png"),
		  	objetos = [llave] + self.listOfEnemies(2) ),
		 new Nivel(
		  	fondo = new Fondo(multiverse = 3,image = "assets/ram-fondo4.png"),
		  	objetos = [nightVisionGoggles],
		  	zonasProhibidas = zonasProhibidas.levelTres()),
         new Nivel(
		  	fondo = new Fondo(multiverse = 4,image = "assets/ram-fondo2.png"),
		  	objetos = [] )
		  ]
		  	
    var property actual = catalogo.first() 
    
    method presentar() { 
        self.presenteFondo()
        self.showAll()
        self.showBlocksInProhibitedAreas()
    }

    method presenteFondo() { catalogo.forEach{nivel => nivel.presentarFondo()} }

    method showAll() { catalogo.forEach{nivel => nivel.show()} }

    method numberOfEnemies() = random.up(1,4)

    method listOfEnemies(multiverse) = (1..self.numberOfEnemies()).fold([], { 
                                                     enemies, value => enemies.add(self.createNewEnemy(value, multiverse)) 
                                                     return enemies 
                                          })
    
    method createNewEnemy(number, multiverse){
            return new Enemigo(
                direction = self.getRandomMovementType(),
                numeroEnemigo = number,
                multiverse = multiverse, 
                mposition = game.at(new Range(start = 1, end = 10).anyOne(),new Range(start = 1, end = 10).anyOne())
                //mposition = game.at(random.up(0,12), random.up(0,12))
            )
    }
    
    method getRandomMovementType(){
            //return (new Movimientos()).disponibles().anyOne()
            return [up, down, left, right].anyOne()
    }
    
    method showBlocksInProhibitedAreas(){
    	catalogo.forEach{
    		nivel => nivel.presentarZonasProhibidas()
    	}    	
    }

    method estaFueraDeLosLimites(pos) = pos.x() < 0 or pos.x() > omniverse.ancho()-1 or pos.y() < 0 or pos.y() > omniverse.alto()-1

    method puedeMoverSiguientePosicion(pos) = 
            not self.estaFueraDeLosLimites(pos) and not self.esZonaProhibida(pos)
    
    method esZonaProhibida(pos){
    	return self.catalogo().get(omniverse.current()).zonasProhibidas().contains(game.at(pos.x(), pos.y()))
    }
    
    method mostrarBloquesEnAreasProhibidas(){
    	game.allVisuals().forEach { 
    		objeto => if(objeto.esObstaculo()) objeto.image("assets/blocks.png");    		
    	}  
    }
    
    method ponerCofre(){
    	game.addVisual(cofre) 
    }
}

class Nivel{
	const fondo 
	const property objetos = []

	const property zonasProhibidas = []
	
    method presentarFondo() { 
    	game.addVisual(fondo) 
    }

	method show(){
		objetos.forEach{v => game.addVisual(v)}
    }
    
    method presentarZonasProhibidas(){
    	zonasProhibidas.forEach{
            // aca no use addVisualIn, use addVisual
    		zona => game.addVisual(new Bloque(multiverse = 3, mposition = zona))                								
    	}
    }   
    
}
