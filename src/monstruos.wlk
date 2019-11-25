import wollok.game.*
import omniverse.*
import rick.*
import directions.*
import objects.*

class Enemigo inherits OmniObjeto{
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

    method takePortal() {
        game.colliders(self).find{ visible => visible.isPortal() }.travel(self)
    }

    method addDefaultCollition() { game.onCollideDo(self, { algo => algo.colisionasteCon(self)}) }

    method modificarVida(param) {}
}

class Monstruo inherits Enemigo{

    override method schedule() { game.schedule(1000, { self.mover() }) }

    override method addCollition() {}

    override method damage() = super() -1
}

class Healer inherits Enemigo{

    override method damage() = +1

    override method addCollition() {}
}

class Tropper inherits Enemigo{
    const intervalo = 4
    var count = intervalo

    override method damage() = -10 

    override method alcanzado(visual){ }

    override method addCollition() { self.addDefaultCollition() }

    override method mover() {
        super()
        self.countDownOrShot()
    }

    method countDownOrShot() {
        if (count == 0) {
            self.shot()
            count = intervalo
        } else {
            count -= 1
        }
    }

    method shot() {
            new Ray( direction = direction, alcance = 3,
                     mposition = mposition, multiverse = multiverse,
                     damage = self.damage() ).shot()
    }
}

class Venom inherits Enemigo{

    override method damage() = -4

    override method addCollition() { self.addDefaultCollition() }

    // hunt rick if in same multiverse
    override method mover(){
        if (self.rickInSelfMultiverse())
            direction = if (self.rickAtRightOrLeft())
                        { if (self.rickAtRight()) right else left } 
                    else 
                        { if (self.rickAtUp()) up else down }

        direction.toNewMposition(self)
        self.schedule()
    }

    method rickInSelfMultiverse() = rick.multiverse() == self.multiverse()

    method rickAtRight() = self.deltaToRick().x() > 0

    method rickAtUp() = self.deltaToRick().y() > 0

    method rickAtRightOrLeft() = self.deltaToRick().x().abs() > self.deltaToRick().y().abs() 

    method deltaToRick() = game.at(rick.mposition().x() - mposition.x(),
                                   rick.mposition().y() - mposition.y() )

    override method schedule() { game.schedule(700, { self.mover() }) }

}
