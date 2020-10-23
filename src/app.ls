require! {
  'reveal.js/dist/reveal.js': Reveal
  'reveal.js/plugin/highlight/highlight.js'
  'reveal.js/plugin/math/math.js'
}

window.addEventListener \load !->
  deck = new Reveal do
    width: 1_440px
    height: 1_080px
    plugins:
      * highlight
      * math
    controls: off
    progress: off
    slide-number: 'c/t'
    center: on
    transition: \none
    hide-cursor-time: 3_000ms
    pdf-max-pages-per-slide: 1page
    pdf-separate-fragments: off

  deck.initialize!

  reveal-element = deck.get-reveal-element!
    ..addEventListener \mousedown (ev) !->
      if ev.button == 1 then reveal-element.class-list.add \laser-pointer

    ..addEventListener \mouseup (ev) !->
      if ev.button == 1 then reveal-element.class-list.remove \laser-pointer
