import personajes.*
import wollok.game.*
import directions.*
import movimientos.*

object random{
    method up(n1,n2) = (n1-1).randomUpTo(n2).roundUp(0)
}

object niveles{
    const property catalogo = [
		 new Nivel(
		 	fondo = new Fondo(multiverse = 0, image = "assets/ram-fondo3.png"),
		  	objetos = [rick, gun] + self.getListOfEnemies() ),
         new Nivel(
		  	fondo = new Fondo(multiverse = 1,image = "assets/ram-fondo1.png"),
		  	objetos = self.getListOfEnemies() ),
         new Nivel(
		  	fondo = new Fondo(multiverse = 2,image = "assets/ram-fondo2.png"),
		  	objetos = self.getListOfEnemies() ),
		 new Nivel(
		  	fondo = new Fondo(multiverse = 3,image = "assets/ram-fondo4.jpg"),
		  	objetos = [],
		  	zonasProhibidas = self.armarZonasProhibidasNivelTres() )
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

    method getListOfEnemies(){ //Refac: var             
            var enemies = []
            (1..self.numberOfEnemies()).forEach { value => enemies.add(self.createNewEnemy(value)) }
            return enemies
    }
    
    method createNewEnemy(number){
            return new Enemigo(
                direction = self.getRandomMovementType(),
                numeroEnemigo = number,
                //multiverse = random.up(0,2),
                multiverse = new Range(start = 0, end = 2).anyOne(),
                mposition = game.at(new Range(start = 1, end = 10).anyOne(),new Range(start = 1, end = 10).anyOne())
                //mposition = game.at(random.up(0,9), random.up(0,9))
            )
    }
    
    method getRandomMovementType(){
            //return (new Movimientos()).disponibles().anyOne()
            return [up, down, left, right].anyOne()
    }
    
    method armarZonasProhibidasNivelTres(){
    	return [
    				game.at(0,2),game.at(0,3),game.at(0,4),game.at(0,5),
					game.at(1,9),
					game.at(2,0),game.at(2,1),game.at(2,2),game.at(2,3),game.at(2,4),game.at(2,7),game.at(2,9),
					game.at(3,4),game.at(3,7),game.at(3,9),game.at(3,10),game.at(3,11),game.at(3,12),
					game.at(4,1),game.at(4,7),
					game.at(5,1),game.at(5,2),game.at(5,3),game.at(5,4),game.at(5,5),game.at(5,6),game.at(5,7),
					game.at(6,1),game.at(6,7),game.at(6,9),game.at(6,10),game.at(6,11),game.at(6,12),
					game.at(7,1),game.at(7,4),game.at(7,7),
					game.at(8,1),game.at(8,4),game.at(8,7),
					game.at(9,1),game.at(9,2),game.at(9,3),game.at(9,4),game.at(9,7),game.at(9,8),game.at(9,9),	
					game.at(10,12),
					game.at(11,3),game.at(11,6),game.at(11,7),game.at(11,8),game.at(11,9),game.at(11,10),game.at(11,11),game.at(11,12),
					game.at(12,0),game.at(12,3)
    		   ]
    }
    
    method showBlocksInProhibitedAreas(){
    	catalogo.forEach{
    		nivel => nivel.presentarZonasProhibidas()
    	}    	
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
                								//position = zona), 
                                                //zona)
    	}
    }
}
