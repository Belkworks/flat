
# Flat
*A simple flatfile.*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
Flatfile = NEON:github('belkworks', 'flat')
```

## Example
```lua
file = Flatfile('test.json')

friends = file:namespace('logs')

friends:set('bob', true)
friends:set('alice', false)

friends:write()
```
