-- flat.moon
-- SFZILabs 2020

Service = setmetatable {}, __index: (K) => game\GetService K

JSON =
    parse: (s) -> Service.HttpService\JSONDecode s
    stringify: (o) -> Service.HttpService\JSONEncode o

keys = (t) -> [i for i in pairs t]
hasKeys = (t, T) ->
    for i, v in pairs T
        switch type v
            when 'function'
                return unless v T[i], i, T
            when 'table'
                return unless hasKeys T[i], v
            else
                return unless t[i] != v
    true

isObject = (t) -> #t != #keys t
isArray = (t) -> #t == #keys t

class Namespace
    new: (@File, @Name) =>
        @Data = @File.Data[@Name] or {}

    _prewrite: =>
        if 0 == #keys @Data
            @File.Data[@Name] = nil
        else @File.Data[@Name] = @Data

    set: (Key, Value) =>
        if isArray @Data
            if 'number' != type Key
                @Data = {}
        @Data[Key] = Value
        @_prewrite!

    get: (Key) => @Data[Key]

    indexOf: (V) => return i for i, v in pairs @Data when V == v
    find: (T) => return v for v in pairs @Data when hasKeys v, T

    push: (T) =>
        unless isArray @Data
            @Data = {}
        table.insert @Data, T
        @_prewrite!

    pop: =>
        unless isArray @Data
            @Data = {}
        X = table.remove @Data, #@Data
        @_prewrite!
        X

    keys: => keys @Data
    length: => #@keys!
    
    shift: =>
        unless isArray @Data
            @Data = {}
        X = table.remove @Data
        @_prewrite!
        X

    unshift: (T) =>
        unless isArray @Data
            @Data = {}
        table.insert @Data, 1, T
        @_prewrite!

    delete: =>
        @Data = {}
        @_prewrite!

    setState: (@Data) => @_prewrite!
    getState: => @Data

class Flatfile
    :Namespace
    new: (@Path) =>
        assert @valid!, 'flatfile: the provided path is invalid!'
        @read!

    namespace: (Name, Class = Namespace) =>
        Class @, tostring Name

    delete: (Name) => @Data[Name] = nil

    valid: => pcall isfile, @Path

    read: =>
        Data = if isfile @Path
            readfile @Path

        if Data
            @Data = JSON.parse Data
        else @Data = {}
    
    write: =>
        empty = 0 == #keys @Data
        if empty
            if isfile @Path
                delfile @Path
        else
            writefile @Path, JSON.stringify @Data
