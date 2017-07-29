class window.Rez
  @scale:(n)=>
    n * _rez.scale
  @rez_scale:(n)=>
    ((100 / 1920) * n)/100

rez = [
  { w: 1024, h: 576 , scale: Rez.rez_scale(1024) },
  { w: 1152, h: 648 , scale: Rez.rez_scale(1152) },
  { w: 1280, h: 720 , scale: Rez.rez_scale(1280) },
  { w: 1366, h: 768 , scale: Rez.rez_scale(1366) },
  { w: 1600, h: 900 , scale: Rez.rez_scale(1600) },
  { w: 1920, h: 1080, scale: Rez.rez_scale(1920) }
]
window._rez = rez[2]

window.rs = (v)->
  Rez.scale(v)

window.rsto = (v)->
  v.scale.setTo _rez.scale
