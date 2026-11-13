"""Minimal TrueType outline extractor (stdlib only): text -> SVG path data.
Handles simple and composite glyphs, cmap format 4, hmtx advances, legacy kern."""
import struct, sys

class TTF:
    def __init__(self, path):
        self.d = open(path, 'rb').read()
        n = struct.unpack('>H', self.d[4:6])[0]
        self.t = {}
        for i in range(n):
            tag, _, off, ln = struct.unpack('>4sIII', self.d[12+16*i:28+16*i])
            self.t[tag.decode()] = (off, ln)
        o = self.t['head'][0]
        self.upm = struct.unpack('>H', self.d[o+18:o+20])[0]
        self.locfmt = struct.unpack('>h', self.d[o+50:o+52])[0]
        o = self.t['maxp'][0]; self.ng = struct.unpack('>H', self.d[o+4:o+6])[0]
        o = self.t['hhea'][0]; self.nhm = struct.unpack('>H', self.d[o+34:o+36])[0]
        self._cmap(); self._loca(); self._kern()
    def u16(self, o): return struct.unpack('>H', self.d[o:o+2])[0]
    def i16(self, o): return struct.unpack('>h', self.d[o:o+2])[0]
    def _cmap(self):
        base = self.t['cmap'][0]; self.cm = {}
        for i in range(self.u16(base+2)):
            pid, eid, off = struct.unpack('>HHI', self.d[base+4+8*i:base+12+8*i])
            st = base+off
            if self.u16(st) == 4 and pid == 3:
                segx2 = self.u16(st+6); ends = st+14; starts = ends+segx2+2
                deltas = starts+segx2; ros = deltas+segx2
                for s in range(segx2//2):
                    e = self.u16(ends+2*s); b = self.u16(starts+2*s)
                    dl = self.i16(deltas+2*s); ro = self.u16(ros+2*s)
                    for c in range(b, e+1):
                        if c == 0xFFFF: continue
                        if ro == 0: g = (c+dl) & 0xFFFF
                        else:
                            a = ros+2*s+ro+2*(c-b); g = self.u16(a)
                            if g: g = (g+dl) & 0xFFFF
                        self.cm[c] = g
                return
    def _loca(self):
        o = self.t['loca'][0]
        if self.locfmt == 0: self.loca = [self.u16(o+2*i)*2 for i in range(self.ng+1)]
        else: self.loca = [struct.unpack('>I', self.d[o+4*i:o+4*i+4])[0] for i in range(self.ng+1)]
    def _kern(self):
        self.kp = {}
        if 'kern' not in self.t: return
        o = self.t['kern'][0]; n = self.u16(o+2); p = o+4
        for _ in range(n):
            ln = self.u16(p+2); cov = self.u16(p+4)
            if cov >> 8 == 0:
                np_ = self.u16(p+6)
                for k in range(np_):
                    a, b, v = struct.unpack('>HHh', self.d[p+14+6*k:p+20+6*k]); self.kp[(a, b)] = v
            p += ln
    def adv(self, g):
        o = self.t['hmtx'][0]; g = min(g, self.nhm-1); return self.u16(o+4*g)
    def contours(self, g):
        go = self.t['glyf'][0]; a, b = self.loca[g], self.loca[g+1]
        if a == b: return []
        p = go+a; nc = self.i16(p)
        if nc < 0:  # composite
            out = []; p += 10
            while True:
                fl, gi = struct.unpack('>HH', self.d[p:p+4]); p += 4
                if fl & 1: dx, dy = struct.unpack('>hh', self.d[p:p+4]); p += 4
                else: dx, dy = struct.unpack('>bb', self.d[p:p+2]); p += 2
                sx = sy = 1.0; sxy = syx = 0.0
                if fl & 8: sx = sy = self.i16(p)/16384; p += 2
                elif fl & 0x40: sx, sy = self.i16(p)/16384, self.i16(p+2)/16384; p += 4
                elif fl & 0x80: sx, sxy, syx, sy = [self.i16(p+2*i)/16384 for i in range(4)]; p += 8
                for c in self.contours(gi):
                    out.append([(x*sx+y*syx+dx, x*sxy+y*sy+dy, on) for x, y, on in c])
                if not fl & 0x20: break
            return out
        ends = [self.u16(p+10+2*i) for i in range(nc)]; npts = ends[-1]+1
        p = p+10+2*nc; il = self.u16(p); p += 2+il
        flags = []
        while len(flags) < npts:
            f = self.d[p]; p += 1; flags.append(f)
            if f & 8:
                r = self.d[p]; p += 1; flags += [f]*r
        def coords(short, same):
            nonlocal p; v = 0; out = []
            for f in flags:
                if f & short:
                    dv = self.d[p]; p += 1; v += dv if f & same else -dv
                elif not f & same:
                    v += self.i16(p); p += 2
                out.append(v)
            return out
        xs = coords(2, 16); ys = coords(4, 32)
        out = []; s = 0
        for e in ends:
            out.append([(xs[i], ys[i], flags[i] & 1) for i in range(s, e+1)]); s = e+1
        return out

def glyph_path(contours, ox, oy, sc):
    P = lambda x, y: f"{ox + x*sc:.2f} {oy - y*sc:.2f}"
    d = []
    for c in contours:
        if not c: continue
        n = len(c)
        # start at an on-curve point (or midpoint of two offs)
        si = next((i for i, pt in enumerate(c) if pt[2]), None)
        if si is None:
            x = (c[0][0]+c[1][0])/2; y = (c[0][1]+c[1][1])/2; c = [(x, y, 1)] + c; n += 1; si = 0
        pts = c[si:] + c[:si]
        d.append("M" + P(pts[0][0], pts[0][1]))
        i = 1; prev_off = None
        for k in range(1, n+1):
            x, y, on = pts[k % n]
            if on:
                if prev_off: d.append("Q" + P(*prev_off) + " " + P(x, y)); prev_off = None
                else: d.append("L" + P(x, y))
            else:
                if prev_off:
                    mx, my = (prev_off[0]+x)/2, (prev_off[1]+y)/2
                    d.append("Q" + P(*prev_off) + " " + P(mx, my))
                prev_off = (x, y)
        d.append("Z")
    return "".join(d)

def text_path(font, text, size, x=0, baseline=0, tracking=0):
    f = TTF(font); sc = size/f.upm; d = []; cx = x; prev = None
    for ch in text:
        g = f.cm.get(ord(ch), 0)
        if prev is not None: cx += f.kp.get((prev, g), 0)*sc
        d.append(glyph_path(f.contours(g), cx, baseline, sc))
        cx += f.adv(g)*sc + tracking; prev = g
    return "".join(d), cx - x - tracking

if __name__ == "__main__":
    d, w = text_path(sys.argv[1], sys.argv[2], float(sys.argv[3]))
    print(w); print(d[:200])
