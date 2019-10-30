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
		  fondo = new Fondo(multiverse = 1, image = "assets/ram-fondo3.png"),
		  objetos = [rick, gun] + self.getListOfEnemies(),
		  siguienteNivel = null ),
                 new Nivel(
		  fondo = new Fondo(multiverse = 2,image = "assets/ram-fondo1.png"),
		  objetos = self.getListOfEnemies(),
		  siguienteNivel = null ),
                 new Nivel(
		  fondo = new Fondo(multiverse = 3,image = "assets/ram-fondo2.png"),
		  objetos = self.getListOfEnemies(),
		  siguienteNivel = null )]
    var property actual = catalogo.first() 
    
    method presentar() { 
        self.presenteFondo()
        self.showAll()
    }

    method presenteFondo() { catalogo.forEach{nivel => nivel.presentarFondo()} }

    method showAll() { catalogo.forEach{nivel => nivel.show()} }

    method numberOfEnemies() = random.up(1,4)

    method getListOfEnemies() = (1..self.numberOfEnemies()).fold([], { enemies, value => enemies.add(self.createNewEnemy(value)) return enemies })
//    method getListOfEnemies(){ //Refac: var             
//            var enemies = []
//            (1..self.numberOfEnemies()).forEach { value => enemies.add(self.createNewEnemy(value)) }
//            return enemies
//    }
    
    method createNewEnemy(number){
            return new Enemigo(
                direction = self.getRandomMovementType(),
                numeroEnemigo = number,
                //multiverse = random.up(1,3),
                multiverse = new Range(start = 1, end = 3).anyOne(),
                mposition = game.at(new Range(start = 1, end = 10).anyOne(),new Range(start = 1, end = 10).anyOne())
                //mposition = game.at(random.up(0,12), random.up(0,12))
            )
    }
    
    method getRandomMovementType(){
            //return (new Movimientos()).disponibles().anyOne()
            return [up, down, left, right].anyOne()
    }
}

class Nivel{
	const fondo 
	const property objetos = []
	const property siguienteNivel // Refac: obsoleto?

        method presentarFondo() { 
            game.addVisual(fondo) 
        }

	method show(){
            objetos.forEach{v => game.addVisual(v)}
        }
}
