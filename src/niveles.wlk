import personajes.*
import wollok.game.*
import movimientos.*

object random{
    method up(n1,n2) = (n1-1).randomUpTo(n2).roundUp(0)
}

object niveles{
    const property catalogo = [
		 new Nivel(
		  fondo = new Fondo(multiverse = 0, image = "assets/ram-fondo3.png"),
		  objetos = [rick, gun] + self.getListOfEnemies(),
		  siguienteNivel = null ),
                 new Nivel(
		  fondo = new Fondo(multiverse = 1,image = "assets/ram-fondo1.png"),
		  objetos = self.getListOfEnemies(),
		  siguienteNivel = null ),
                 new Nivel(
		  fondo = new Fondo(multiverse = 2,image = "assets/ram-fondo2.png"),
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

    method getListOfEnemies(){ //Refac: var             
            var enemies = []
            (1..self.numberOfEnemies()).forEach { value => enemies.add(self.createNewEnemy(value)) }
            return enemies
    }
    
    method createNewEnemy(number){
            return new Enemigo(
                tipoMovimiento = self.getRandomMovementType(),
                numeroEnemigo = number,
                multiverse = random.up(0,2),
                //position = game.at(new Range(start = 1, end = 10).anyOne(),new Range(start = 1, end = 10).anyOne())
                position = game.at(random.up(0,9), random.up(0,9))
            )
    }
    
    method getRandomMovementType(){
            return (new Movimientos()).disponibles().anyOne()
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
