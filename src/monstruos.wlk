import wollok.game.*
import omniverse.*

class Enemigo inherits OmniObjeto {
    var property numeroEnemigo
    var property direction// = down

    method image() = if (multiverse == omniverse.current() )
                            direction.imageEnemy(numeroEnemigo)
                     else "assets/nada.png"

    method moveTo(_direction) { self.mposition(_direction.nextPosition(self.mposition())) }

    override method mover(){
        direction.toNewMposition(self)
        game.schedule(500, { self.mover() })
    }

    method colisionasteCon(alguien){
        alguien.catched()
    }
}

class Monstruo inherits Enemigo{
    method alcanzado(visual){
        game.removeVisual(self)
    }

    override method mover(){
        direction.toNewMposition(self)
        game.schedule(1000, { self.mover() })
    }

}
