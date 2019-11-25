import wollok.game.*
import barra.*
import objects.*
import mixins.*
import misc.*
import omniverse.*
import directions.*
import niveles.*

object rick inherits OmniObjeto(mposition = game.at(1, 1), multiverse = 1) mixed with NotCollectable {

	var property grabed = nada
	var property direction = down
	const indicador = indicadorDeVida
	const mochila = []

	override method imagen() = direction.imageRick()

	override method multiverse(_multiverse) {
		multiverse = _multiverse
		grabed.multiverse(multiverse)
	}

	method position(_mposition) {
		mposition = _mposition
		grabed.position(mposition)
	}

	method takePortal() {
		const portal = game.colliders(self).find{ visual => visual.isPortal() }
		omniverse.current(portal.exit().multiverse())
		portal.travel(self)
		barra.acomodar(mochila) // acomoda las referencias de la mochila al nuevo multiverso//refac
	}

	method colisionasteCon(alguien) {
	}

	override method alcanzado(ray) {
		self.modificarVida(ray.damage())
	}

	method trigger(destino) {
		grabed.trigger(destino, direction)
	}

	method manipularObjetos(extremo) {
		// self.verificarSiHayCollectable()
		if (self.hayObjetoParaAgarrar()) self.grab() else self.sacar(extremo)
	}

	method sacar(extremo) {
		self.puedoSacarObjetosDeLaMochila()
		grabed = self.getObjectFromBag(extremo)
		barra.acomodar(mochila)
		grabed.position(mposition)
	}

	method grab() {
		grabed = game.colliders(self).find{ visual => visual.isCollectable() }
		mochila.add(grabed)
		barra.acomodar(mochila)
		self.ungrab()
	}

	method hayObjetoParaAgarrar() = game.colliders(self).any{ visual => visual.isCollectable() }

	method verificarSiHayCollectable() {
		if (not self.hayObjetoParaAgarrar()) {
			game.errorReporter(self)
			self.error("No hay que agarrar")
		}
	}

	method puedoSacarObjetosDeLaMochila() {
		if (mochila.size() <= 0) self.error("No hay nada en la mochila")
	}

	method ungrab() {
		grabed = nada
	}

	method modificarVida(deltaDeVida) {
		indicador.cambiar(deltaDeVida)
		if (deltaDeVida > 0) game.say(self, "Gracias!!!") else // aca feedback visual
		game.say(self, "Outch!!!!!")
		if (indicador.esCero()) {
			game.say(self, "Perdi!!!!!\nBye Bye!")
				// pensar ir a pantalla con estadisticas
			game.schedule(10000, { game.stop()})
		}
	}

	method ponerseLentes() {
		niveles.mostrarBloquesEnAreasProhibidas()
		niveles.ponerPortalFinal()
	}

	method tieneElObjetoEnLaMochila(objeto) {
		return mochila.contains(objeto)
	}

	method activarPortalFinal() {
		if (!self.encontreElPortalFinal()) {
			self.error("El portal final no esta aqui")
		;
        }
		game.removeVisual(finalPortal)
		game.say(self, "Empieza el final!")
		multiverse = 4
		omniverse.current(multiverse)
		barra.acomodar(mochila)
	}

	method encontreElPortalFinal() {
		return game.colliders(self).contains(finalPortal)
	}

	method moveTo(_direction) { // se mueve sin condicion
		self.position(_direction.nextPosition(self.position()))
		self.direction(_direction)
	}

	method rotarSentidoHorario() {
		self.direction(direction.siguiente())
	}

	method rotarSentidoAntiHorario() {
		self.direction(direction.anterior())
	}

	method getObjectFromBag(extremo) { // refac
		const obj = extremo.getObject(mochila)
		mochila.remove(obj)
		return obj
	}

	method ganaste(rescatado) {
		game.say(rescatado, "Gracias Rick ME SALVASTE!!!!!!")
	}

}

object nada mixed with NotCollectable {

	var property position = null
	var property multiverse = null

	method trigger(destino, direction) {
	}

	method colisionasteCon(alguien) {
	}

	method verificarInventariable(owner) {
		game.errorReporter(owner)
		self.error("Nada que guardar!")
	}

}

