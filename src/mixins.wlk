import wollok.game.*

mixin Collectable{
	
	method isFicha() = false
	
    method colisionasteCon(alguien){
        game.say(alguien,self.quote())
    }

    method quote() = [
            "Hare guiso de lentejas con esto!",
            "Wubba lubba dub dub",
            "A veces la ciencia es mas arte que ciencia",
            "No so fast!"
        ].anyOne()

    method esObstaculo() = false

    method isCollectable() = true

    method isPortal() = false

    method verificarInventariable(owner) { }

    method addCollition() {}

    method mover(){}

}

mixin NotCollectable{
	
    method esObstaculo() = false

    method isCollectable() = false

    method isPortal() = false

    method addCollition() {}

    method mover() {}

    method alcanzado(visual) {}

}
