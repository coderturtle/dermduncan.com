import math, sys, os
sys.path.insert(0, os.path.dirname(__file__))
from ttf2path import text_path
OUT = sys.argv[1]; os.makedirs(OUT, exist_ok=True)
FONT = "/System/Library/Fonts/Supplemental/Georgia Bold.ttf"

PAL = {
  "light": dict(a="#102E35", b="#BD7953", c="#88AFA5", d="#237875", ink="#102E35"),
  "dark":  dict(a="#D7E6E1", b="#CF8C66", c="#6E9C92", d="#3FA39C", ink="#E6EAEF"),
}
# Four-part mark: owner-supplied artwork (96-unit grid), recoloured to the brand
# palette. a = left (petrol), b = top (copper), c = right (sea glass), d = bottom (teal).
MARK = {
  "b": "M44.9 10.6 Q48 8.7 51.1 10.6 L67 20.5 Q70.8 23 67 25.4 L51 35.1 Q48 37 45 35.1 L29.2 25.4 Q25.5 22.9 29.2 20.5 Z",
  "a": "M21.6 30.4 L39.6 40.5 Q42.1 42.2 39.8 44.1 L21.4 61.2 Q17 65.3 12.8 61.1 Q11.9 60.2 11.9 58.4 L11.9 39.5 Q11.9 36.2 14.7 34.6 Z",
  "c": "M74.4 30.4 L56.4 40.5 Q53.9 42.2 56.2 44.1 L74.6 61.2 Q79 65.3 83.2 61.1 Q84.1 60.2 84.1 58.4 L84.1 39.5 Q84.1 36.2 81.3 34.6 Z",
  "d": "M44.9 51.7 Q48 49.6 51.1 51.7 L70.1 66.3 Q73.4 69 70 71.5 L51.2 84.4 Q48 86.5 44.8 84.4 L26 71.5 Q22.6 69 25.9 66.3 Z",
}
VB = "0 0 96 96"
def symbol_paths(cols, mono=None):
    return "\n  ".join(f'<path d="{MARK[k]}" fill="{mono or cols[k]}"/>' for k in "abcd")
def svg(w, h, body, title, vb=None):
    vb = vb or VB
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{vb}" width="{w}" height="{h}" role="img" aria-labelledby="t">\n'
            f'  <title id="t">{title}</title>\n  {body}\n</svg>\n')
def write(name, s): open(os.path.join(OUT, name), "w").write(s)

for mode, cols in PAL.items():
    write(f"dd-symbol-{mode}.svg", svg(96, 96, symbol_paths(cols), "Dermot Duncan"))
write("dd-symbol-mono.svg", svg(96, 96, symbol_paths(None, mono="currentColor").replace('currentColor','#102E35'), "Dermot Duncan"))
write("dd-symbol-mono-current.svg", svg(96, 96, symbol_paths(None, mono="currentColor"), "Dermot Duncan"))

# Horizontal wordmark: symbol + outlined "Dermot Duncan" (Georgia Bold outlines).
size = 30; d, tw = text_path(FONT, "Dermot Duncan", size, x=0, baseline=0)
def wordmark(cols, ink, mono=None):
    s = 64 / 77.8; W = 72.2 * s + 18 + tw + 4; H = 64
    body = (f'<g transform="scale({s:.4f}) translate(-11.9 -8.7)">{symbol_paths(cols, mono=mono)}</g>\n'
            f'  <path transform="translate({72.2*s+18:.1f} 42.5)" fill="{mono or ink}" d="{d}"/>')
    return svg(round(W), H, body, "Dermot Duncan", vb=f"0 0 {round(W)} {H}")
write("dd-wordmark-light.svg", wordmark(PAL["light"], PAL["light"]["ink"]))
write("dd-wordmark-dark.svg", wordmark(PAL["dark"], PAL["dark"]["ink"]))
write("dd-wordmark-mono.svg", wordmark(None, None, mono="#102E35"))

print("wordmark text width", round(tw,1))

# ---- Pixel-grid favicon (16-unit grid, integer coordinates: crisp at 16px and 32px) ----
# Hand-fitted simplification of the mark with gaps of at least one pixel at 16px.
FAV = {"b": "M8 0.5L12.5 3.25L8 6L3.5 3.25Z", "a": "M0.5 3.5L6 7.25L1.5 11.5L0.5 11Z",
       "c": "M15.5 3.5L10 7.25L14.5 11.5L15.5 11Z", "d": "M8 8.5L13 12L8 15.5L3 12Z"}
def fav16(style):
    return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16">'
            f'<title>Dermot Duncan</title><style>{style}</style>'
            '<g>' +
            "".join(f'<path class="{k}" d="{v}"/>' for k, v in FAV.items()) + '</g></svg>\n')
LIGHT = ".a{fill:#102E35}.b{fill:#BD7953}.c{fill:#88AFA5}.d{fill:#237875}"
DARK = ".a{fill:#D7E6E1}.b{fill:#CF8C66}.c{fill:#6E9C92}.d{fill:#3FA39C}"
write("favicon.svg", fav16(LIGHT + "@media (prefers-color-scheme:dark){" + DARK + "}"))
write("favicon-light.svg", fav16(LIGHT))
write("favicon-dark.svg", fav16(DARK))
