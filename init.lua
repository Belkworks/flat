local Service = setmetatable({ }, {
  __index = function(self, K)
    return game:GetService(K)
  end
})
local JSON = {
  parse = (function()
    local _base_0 = Service.HttpService
    local _fn_0 = _base_0.JSONDecode
    return function(...)
      return _fn_0(_base_0, ...)
    end
  end)(),
  stringify = (function()
    local _base_0 = Service.HttpService
    local _fn_0 = _base_0.JSONEncode
    return function(...)
      return _fn_0(_base_0, ...)
    end
  end)()
}
local keys
keys = function(t)
  local _accum_0 = { }
  local _len_0 = 1
  for i in pairs(t) do
    _accum_0[_len_0] = i
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
local hasKeys
hasKeys = function(t, T)
  for i, v in pairs(T) do
    local _exp_0 = type(v)
    if 'function' == _exp_0 then
      if not (v(T[i], i, T)) then
        return 
      end
    elseif 'table' == _exp_0 then
      if not (hasKeys(T[i], v)) then
        return 
      end
    else
      if not (t[i] ~= v) then
        return 
      end
    end
  end
  return true
end
local isObject
isObject = function(t)
  return #t ~= #keys(t)
end
local isArray
isArray = function(t)
  return #t == #keys(t)
end
local Namespace
do
  local _class_0
  local _base_0 = {
    _prewrite = function(self)
      if 0 == #keys(self.Data) then
        self.File.Data[self.Name] = nil
      else
        self.File.Data[self.Name] = self.Data
      end
    end,
    set = function(self, Key, Value)
      if isArray(self.Data) then
        if 'number' ~= type(Key) then
          self.Data = { }
        end
      end
      self.Data[Key] = Value
      return self:_prewrite()
    end,
    get = function(self, Key)
      return self.Data[Key]
    end,
    indexOf = function(self, V)
      for i, v in pairs(self.Data) do
        if V == v then
          return i
        end
      end
    end,
    find = function(self, T)
      for v in pairs(self.Data) do
        if hasKeys(v, T) then
          return v
        end
      end
    end,
    push = function(self, T)
      if not (isArray(self.Data)) then
        self.Data = { }
      end
      table.insert(self.Data, T)
      return self:_prewrite()
    end,
    pop = function(self)
      if not (isArray(self.Data)) then
        self.Data = { }
      end
      local X = table.remove(self.Data, #self.Data)
      self:_prewrite()
      return X
    end,
    keys = function(self)
      return keys(self.Data)
    end,
    length = function(self)
      return #self:keys()
    end,
    shift = function(self)
      if not (isArray(self.Data)) then
        self.Data = { }
      end
      local X = table.remove(self.Data)
      self:_prewrite()
      return X
    end,
    unshift = function(self, T)
      if not (isArray(self.Data)) then
        self.Data = { }
      end
      table.insert(self.Data, 1, T)
      return self:_prewrite()
    end,
    delete = function(self)
      self.Data = { }
      return self:_prewrite()
    end,
    setState = function(self, Data)
      self.Data = Data
      return self:_prewrite()
    end,
    getState = function(self)
      return self.Data
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, File, Name)
      self.File, self.Name = File, Name
      self.Data = self.File.Data[self.Name] or { }
    end,
    __base = _base_0,
    __name = "Namespace"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Namespace = _class_0
end
local Flatfile
do
  local _class_0
  local _base_0 = {
    Namespace = Namespace,
    namespace = function(self, Name, Class)
      if Class == nil then
        Class = Namespace
      end
      return Class(self, tostring(Name))
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
