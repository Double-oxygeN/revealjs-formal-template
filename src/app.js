import Reveal from 'reveal.js'
import Highlight from 'reveal.js/plugin/highlight/highlight.esm.js'
import MathPlugin from 'reveal.js/plugin/math/math.esm.js'

window.addEventListener('load', (ev) => {
  const deck = new Reveal({
    width: 1440,
    height: 1080,
    plugins: [ Highlight, MathPlugin ],
    controls: false,
    progress: false,
    slideNumber: 'c/t',
    center: true,
    transition: 'none',
    hideCursorTime: 3000,
    pdfMaxPagesPerSlide: 1,
    pdfSeparateFragments: false
  })
  deck.initialize()

  const revealElement = deck.getRevealElement()
  revealElement.addEventListener('mousedown', (ev) => {
    if (ev.button === 1) revealElement.classList.add('laser-pointer')
  })
  revealElement.addEventListener('mouseup', (ev) => {
    if (ev.button === 1) revealElement.classList.remove('laser-pointer')
  })
})
