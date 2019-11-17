import wollok.game.*
import personajes.*
import directions.*
import movimientos.*
import cuatro.*
import Jugadores.*
import areasProhibidas.*

object random{
    method up(n1,n2) = (n1-1).randomUpTo(n2).roundUp(0)
}


object niveles{
    const property catalogo = [
         new Nivel(
            fondo = new Fondo(mposition = game.origin(), multiverse = 0, image = "assets/ram-fondo3.png"),
            objetos = [] ) ,
         new Nivel(
            fondo = new Fondo(mposition = game.origin(), multiverse = 1,image = "assets/ram-fondo1.png"),
            objetos = [barra, rick, portalgun, raygun] + self.listOfMonstruos(1) ),
         new Nivel(
            fondo = new Fondo(mposition = game.origin(), multiverse = 2,image = "assets/ram-fondo2.png"),
            objetos = [llave] + self.listOfEnemies(2) ),
         new Nivel(
            fondo = new Fondo(mposition = game.origin(), multiverse = 3,image = "assets/ram-fondo4.png"),
            objetos = [nightVisionGoggles],
            zonasProhibidas = areasProhibidas.levelTres()),
         new Nivel(
            fondo = new Fondo(mposition = game.origin(), multiverse = 4,image = "assets/FondoCuatro.png"),
            objetos = [new PilaDeFichasDeRick(mposition = game.at(0,12), multiverse = 4)] )
          ]

    var property actual = catalogo.first()

    method presentar() {
        console.println("niveles.presentar")
        self.presenteFondo()
        self.showAll()
        self.showBlocksInProhibitedAreas()
    }

    method presenteFondo() { catalogo.forEach{nivel => nivel.presentarFondo()} }

    method showAll() {
        catalogo.forEach{nivel => nivel.show()}
    }

    method numberOfEnemies() = random.up(1,4)

    method listOfEnemies(multiverse) = (1..self.numberOfEnemies()).fold([], {
                                                     enemies, value => enemies.add(self.createNewEnemy(value, multiverse))
                                                     return enemies
                                          })

    method listOfMonstruos(multiverse) = (1..2).fold([], {
                                             enemies, value => enemies.add( self.createNewMonstruo(4, 1)) //refac numero numero
                                             return enemies
                              })

    method createNewEnemy(number, multiverse){
            return new Enemigo(
                direction = self.randomMovement(),
                numeroEnemigo = number,
                multiverse = multiverse,
                mposition = game.at(random.up(0,12), random.up(0,12))
            )
    }

    method createNewMonstruo(number, multiverse){
            return new Monstruo(direction = down, numeroEnemigo = number, mposition = game.at(random.up(1,11),12), multiverse = multiverse)
    }

    method randomMovement() = [up, down, left, right].anyOne()

    method showBlocksInProhibitedAreas(){
        catalogo.forEach{
            nivel => nivel.presentarZonasProhibidas()
        }
    }

    method estaFueraDeLosLimites(pos) = pos.x() < 0 or pos.x() > omniverse.ancho()-1 or pos.y() < 0 or pos.y() > omniverse.alto()-1

    method puedeMover(pos) = // not self.esZonaProhibida(pos)
            not self.estaFueraDeLosLimites(pos) and not self.esZonaProhibida(pos)

    method esZonaProhibida(pos){
        return self.catalogo().get(omniverse.current()).zonasProhibidas().contains(game.at(pos.x(), pos.y()))
    }

    method mostrarBloquesEnAreasProhibidas(){
        game.allVisuals().forEach {
            objeto => if(objeto.esObstaculo()) objeto.image("assets/blocks.png");   //refac este if puede volar con polimorfismo
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

    method show(){ // refac con presentarFondo()
        objetos.forEach{
            visual => game.addVisual(visual)
            visual.mover() //arrancar movil
        }
    }

    method presentarZonasProhibidas(){
        zonasProhibidas.forEach{
            // aca no use addVisualIn, use addVisual
            zona => game.addVisual(new Bloque(multiverse = 3, mposition = zona))  //refac hardcoded multiverse
        }
    }

}
