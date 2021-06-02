-- flat.moon
-- SFZILabs 2021

if not NEON
    if not isfile 'neon/init.lua'
        makefolder 'neon'
        raw = 'https://raw.githubusercontent.com/%s/%s/master/init.lua'
        writefile 'neon/init.lua',game\HttpGet raw\format 'belkworks','neon'

    pcall loadfile 'neon/init.lua'

assert NEON, 'flat could not load NEON!'

_ = NEON\github 'belkworks', 'quick'

import Service, chain, get, keys from _

JSON =
    parse: (s) -> Service.HttpService\JSONDecode s
    stringify: (o) -> Service.HttpService\JSONEncode o

class Flatfile
    new: (@Path) =>
        assert @valid!, 'flatfile: the provided path is invalid!'
        @read!

    namespace: (Name) =>
        Value = get @Data, Name, {}
        with chain Value
            .write = (c, ...) ->
                R = { c\value! }
                @Data[Name] = Value
                @write!
                unpack R

    delete: (Name) =>
        @Data[Name] = nil

    valid: =>
        pcall isfile, @Path

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
