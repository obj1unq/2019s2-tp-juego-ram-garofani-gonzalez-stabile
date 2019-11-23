import wollok.game.*
import omniverse.*

class Enemigo inherits OmniObjeto {
    var property numeroEnemigo
    var property direction

    override method imagen() = direction.imageEnemy(numeroEnemigo)

    method moveTo(_direction) { self.mposition(_direction.nextPosition(self.mposition())) }

    override method mover(){
        direction.toNewMposition(self)
        game.schedule(500, { self.mover() })
    }

    method damage() = -2

    method colisionasteCon(alguien){
        alguien.modificarVida(self.damage())
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


