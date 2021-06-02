if not NEON then
  if not isfile('neon/init.lua') then
    makefolder('neon')
    local raw = 'https://raw.githubusercontent.com/%s/%s/master/init.lua'
    writefile('neon/init.lua', game:HttpGet(raw:format('belkworks', 'neon')))
  end
  pcall(loadfile('neon/init.lua'))
end
assert(NEON, 'flat could not load NEON!')
local _ = NEON:github('belkworks', 'quick')
local Service, chain, get, keys
Service, chain, get, keys = _.Service, _.chain, _.get, _.keys
local JSON = {
  parse = function(s)
    return Service.HttpService:JSONDecode(s)
  end,
  stringify = function(o)
    return Service.HttpService:JSONEncode(o)
  end
}
local Flatfile
do
  local _class_0
  local _base_0 = {
    namespace = function(self, Name)
      local Value = get(self.Data, Name, { })
      do
        local _with_0 = chain(Value)
        _with_0.write = function(c, ...)
          local R = {
            c:value()
          }
          self.Data[Name] = Value
          self:write()
          return unpack(R)
        end
        return _with_0
      end
    end,
    delete = function(self, Name)
      self.Data[Name] = nil
    end,
    valid = function(self)
      return pcall(isfile, self.Path)
    end,
    read = function(self)
      local Data
      if isfile(self.Path) then
        Data = readfile(self.Path)
      end
      if Data then
        self.Data = JSON.parse(Data)
      else
        self.Data = { }
      end
    end,
    write = function(self)
      local empty = 0 == #keys(self.Data)
      if empty then
        if isfile(self.Path) then
          return delfile(self.Path)
        end
      else
        return writefile(self.Path, JSON.stringify(self.Data))
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, Path)
      self.Path = Path
      assert(self:valid(), 'flatfile: the provided path is invalid!')
      return self:read()
    end,
    __base = _base_0,
    __name = "Flatfile"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Flatfile = _class_0
  return _class_0
end
