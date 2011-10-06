from sys import stdout
names = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

def opentag(path):
    return '''<a xml:id="id%s" l="%s" p="/%s" t="%s" d="%s">''' % (
        path,
        len(path),
        '/'.join(names[int(c)] for c in path),
        ' '.join(names[int(c)] for c in path),
        3*(' '.join(names[int(c)] for c in path)),
        )

def index(level, base=10, path=''):
    if not level:
        return
    for n in range(base):
        c = "%s%s"%(path,n)
        yield opentag(c)
        for p in index(level-1, base, c):
            yield p
        yield '</a>'

stdout.write('<a xmlns:xml="http://www.w3.org/XML/1998/namespace" xml:id="site" l="0" p="/" t="Site" d="Site site site">')
for t in index(5, base=10):
    stdout.write(t + '\n')
stdout.write('</a>')
