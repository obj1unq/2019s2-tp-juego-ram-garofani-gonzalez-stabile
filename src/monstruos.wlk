import wollok.game.*
import omniverse.*

class Enemigo inherits OmniObjeto {
    var property numeroEnemigo
    var property direction

    override method imagen() = direction.imageEnemy(numeroEnemigo)

    method moveTo(_direction) { self.mposition(_direction.nextPosition(self.mposition())) }

    override method mover(){
        direction.toNewMposition(self)
        self.schedule()
    }

    method schedule() { game.schedule(500, { self.mover() }) }

    method damage() = -2

    method colisionasteCon(alguien){
        alguien.modificarVida(self.damage())
    }

    method alcanzado(visual){ game.removeVisual(self) }

    method takePortal() {}

}

class Monstruo inherits Enemigo{

    override method schedule() { game.schedule(1000, { self.mover() }) }

    override method damage() = super() -1
}

class Healer inherits Enemigo{

    override method damage() = +1

}

class Tropper inherits Enemigo{

    override method damage() = -10 

    override method alcanzado(visual){ }

}

class Venom inherits Enemigo{

    override method damage() = -4

}
