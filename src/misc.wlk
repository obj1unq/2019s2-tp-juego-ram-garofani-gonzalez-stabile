import wollok.game.*
import mixins.*

object inicio{
	method getObject(mochila) = mochila.head()
}

object fin{
	method getObject(mochila) = mochila.last()
}

object none mixed with NotCollectable{
    const property image = ""
    const property position = game.at(0,0)
}

