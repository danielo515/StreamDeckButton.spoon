local _hx_hidden = {__id__=true, hx__closures=true, super=true, prototype=true, __fields__=true, __ifields__=true, __class__=true, __properties__=true, __fields__=true, __name__=true}

_hx_array_mt = {
    __newindex = function(t,k,v)
        local len = t.length
        t.length =  k >= len and (k + 1) or len
        rawset(t,k,v)
    end
}

function _hx_is_array(o)
    return type(o) == "table"
        and o.__enum__ == nil
        and getmetatable(o) == _hx_array_mt
end



function _hx_tab_array(tab, length)
    tab.length = length
    return setmetatable(tab, _hx_array_mt)
end



function _hx_print_class(obj, depth)
    local first = true
    local result = ''
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            if first then
                first = false
            else
                result = result .. ', '
            end
            if _hx_hidden[k] == nil then
                result = result .. k .. ':' .. _hx_tostring(v, depth+1)
            end
        end
    end
    return '{ ' .. result .. ' }'
end

function _hx_print_enum(o, depth)
    if o.length == 2 then
        return o[0]
    else
        local str = o[0] .. "("
        for i = 2, (o.length-1) do
            if i ~= 2 then
                str = str .. "," .. _hx_tostring(o[i], depth+1)
            else
                str = str .. _hx_tostring(o[i], depth+1)
            end
        end
        return str .. ")"
    end
end

function _hx_tostring(obj, depth)
    if depth == nil then
        depth = 0
    elseif depth > 5 then
        return "<...>"
    end

    local tstr = _G.type(obj)
    if tstr == "string" then return obj
    elseif tstr == "nil" then return "null"
    elseif tstr == "number" then
        if obj == _G.math.POSITIVE_INFINITY then return "Infinity"
        elseif obj == _G.math.NEGATIVE_INFINITY then return "-Infinity"
        elseif obj == 0 then return "0"
        elseif obj ~= obj then return "NaN"
        else return _G.tostring(obj)
        end
    elseif tstr == "boolean" then return _G.tostring(obj)
    elseif tstr == "userdata" then
        local mt = _G.getmetatable(obj)
        if mt ~= nil and mt.__tostring ~= nil then
            return _G.tostring(obj)
        else
            return "<userdata>"
        end
    elseif tstr == "function" then return "<function>"
    elseif tstr == "thread" then return "<thread>"
    elseif tstr == "table" then
        if obj.__enum__ ~= nil then
            return _hx_print_enum(obj, depth)
        elseif obj.toString ~= nil and not _hx_is_array(obj) then return obj:toString()
        elseif _hx_is_array(obj) then
            if obj.length > 5 then
                return "[...]"
            else
                local str = ""
                for i=0, (obj.length-1) do
                    if i == 0 then
                        str = str .. _hx_tostring(obj[i], depth+1)
                    else
                        str = str .. "," .. _hx_tostring(obj[i], depth+1)
                    end
                end
                return "[" .. str .. "]"
            end
        elseif obj.__class__ ~= nil then
            return _hx_print_class(obj, depth)
        else
            local buffer = {}
            local ref = obj
            if obj.__fields__ ~= nil then
                ref = obj.__fields__
            end
            for k,v in pairs(ref) do
                if _hx_hidden[k] == nil then
                    _G.table.insert(buffer, _hx_tostring(k, depth+1) .. ' : ' .. _hx_tostring(obj[k], depth+1))
                end
            end

            return "{ " .. table.concat(buffer, ", ") .. " }"
        end
    else
        _G.error("Unknown Lua type", 0)
        return ""
    end
end

function _hx_error(obj)
    if obj.value then
        _G.print("runtime error:\n " .. _hx_tostring(obj.value));
    else
        _G.print("runtime error:\n " .. tostring(obj));
    end

    if _G.debug and _G.debug.traceback then
        _G.print(debug.traceback());
    end
end


local function _hx_obj_newindex(t,k,v)
    t.__fields__[k] = true
    rawset(t,k,v)
end

local _hx_obj_mt = {__newindex=_hx_obj_newindex, __tostring=_hx_tostring}

local function _hx_a(...)
  local __fields__ = {};
  local ret = {__fields__ = __fields__};
  local max = select('#',...);
  local tab = {...};
  local cur = 1;
  while cur < max do
    local v = tab[cur];
    __fields__[v] = true;
    ret[v] = tab[cur+1];
    cur = cur + 2
  end
  return setmetatable(ret, _hx_obj_mt)
end

local function _hx_e()
  return setmetatable({__fields__ = {}}, _hx_obj_mt)
end

local function _hx_o(obj)
  return setmetatable(obj, _hx_obj_mt)
end

local function _hx_new(prototype)
  return setmetatable({__fields__ = {}}, {__newindex=_hx_obj_newindex, __index=prototype, __tostring=_hx_tostring})
end

function _hx_field_arr(obj)
    res = {}
    idx = 0
    if obj.__fields__ ~= nil then
        obj = obj.__fields__
    end
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            res[idx] = k
            idx = idx + 1
        end
    end
    return _hx_tab_array(res, idx)
end

local _hxClasses = {}
local Int = _hx_e();
local Dynamic = _hx_e();
local Float = _hx_e();
local Bool = _hx_e();
local Class = _hx_e();
local Enum = _hx_e();

local _hx_exports = _hx_exports or {}
local Array = _hx_e()
__json2object_reader_BaseParser = _hx_e()
local JsonParser_1 = _hx_e()
local JsonParser_2 = _hx_e()
local JsonWriter_1 = _hx_e()
local JsonWriter_2 = _hx_e()
local Math = _hx_e()
local Reflect = _hx_e()
local String = _hx_e()
local Std = _hx_e()
local StringBuf = _hx_e()
local Type = _hx_e()
__haxe_IMap = _hx_e()
__haxe_Exception = _hx_e()
__haxe_Log = _hx_e()
__haxe_NativeStackTrace = _hx_e()
__haxe_ValueException = _hx_e()
__haxe_ds_Either = _hx_e()
__haxe_ds_StringMap = _hx_e()
__haxe_iterators_ArrayIterator = _hx_e()
__haxe_iterators_ArrayKeyValueIterator = _hx_e()
__hxjsonast_Error = _hx_e()
__hxjsonast_Json = _hx_e()
__hxjsonast_JsonValue = _hx_e()
__hxjsonast_JObjectField = _hx_e()
__hxjsonast_Parser = _hx_e()
__hxjsonast_Position = _hx_e()
__json2object_Error = _hx_e()
__json2object_InternalError = _hx_e()
__json2object_PositionUtils = _hx_e()
__lua_Boot = _hx_e()
__lua_UserData = _hx_e()
__lua_StringMap = _hx_e()
__lua_Thread = _hx_e()
__streamDeckButton_Utils = _hx_e()
__streamDeckButton__Messages_Messages_Fields_ = _hx_e()
__streamDeckButton_State = _hx_e()
__streamDeckButton__StreamDeckButton_StoredSettings_Impl_ = _hx_e()
local obj = _hx_e()

local _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw
local _hx_pcall_default = {};
local _hx_pcall_break = {};

Array.new = function() 
  local self = _hx_new(Array.prototype)
  Array.super(self)
  return self
end
Array.super = function(self) 
  _hx_tab_array(self, 0);
end
Array.__name__ = true
Array.prototype = _hx_e();
Array.prototype.concat = function(self,a) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  local _g1 = 0;
  while (_g1 < a.length) do 
    local i = a[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  do return _g end
end
Array.prototype.join = function(self,sep) 
  local tbl = ({});
  local _g_current = 0;
  while (_g_current < self.length) do 
    _g_current = _g_current + 1;
    _G.table.insert(tbl, Std.string(self[_g_current - 1]));
  end;
  do return _G.table.concat(tbl, sep) end
end
Array.prototype.pop = function(self) 
  if (self.length == 0) then 
    do return nil end;
  end;
  local ret = self[self.length - 1];
  self[self.length - 1] = nil;
  self.length = self.length - 1;
  do return ret end
end
Array.prototype.push = function(self,x) 
  self[self.length] = x;
  do return self.length end
end
Array.prototype.reverse = function(self) 
  local tmp;
  local i = 0;
  while (i < Std.int(self.length / 2)) do 
    tmp = self[i];
    self[i] = self[(self.length - i) - 1];
    self[(self.length - i) - 1] = tmp;
    i = i + 1;
  end;
end
Array.prototype.shift = function(self) 
  if (self.length == 0) then 
    do return nil end;
  end;
  local ret = self[0];
  if (self.length == 1) then 
    self[0] = nil;
  else
    if (self.length > 1) then 
      self[0] = self[1];
      _G.table.remove(self, 1);
    end;
  end;
  local tmp = self;
  tmp.length = tmp.length - 1;
  do return ret end
end
Array.prototype.slice = function(self,pos,_end) 
  if ((_end == nil) or (_end > self.length)) then 
    _end = self.length;
  else
    if (_end < 0) then 
      _end = _G.math.fmod((self.length - (_G.math.fmod(-_end, self.length))), self.length);
    end;
  end;
  if (pos < 0) then 
    pos = _G.math.fmod((self.length - (_G.math.fmod(-pos, self.length))), self.length);
  end;
  if ((pos > _end) or (pos > self.length)) then 
    do return _hx_tab_array({}, 0) end;
  end;
  local ret = _hx_tab_array({}, 0);
  local _g = pos;
  local _g1 = _end;
  while (_g < _g1) do 
    _g = _g + 1;
    ret:push(self[_g - 1]);
  end;
  do return ret end
end
Array.prototype.sort = function(self,f) 
  local i = 0;
  local l = self.length;
  while (i < l) do 
    local swap = false;
    local j = 0;
    local max = (l - i) - 1;
    while (j < max) do 
      if (f(self[j], self[j + 1]) > 0) then 
        local tmp = self[j + 1];
        self[j + 1] = self[j];
        self[j] = tmp;
        swap = true;
      end;
      j = j + 1;
    end;
    if (not swap) then 
      break;
    end;
    i = i + 1;
  end;
end
Array.prototype.splice = function(self,pos,len) 
  if ((len < 0) or (pos > self.length)) then 
    do return _hx_tab_array({}, 0) end;
  else
    if (pos < 0) then 
      pos = self.length - (_G.math.fmod(-pos, self.length));
    end;
  end;
  len = Math.min(len, self.length - pos);
  local ret = _hx_tab_array({}, 0);
  local _g = pos;
  local _g1 = pos + len;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    ret:push(self[i]);
    self[i] = self[i + len];
  end;
  local _g = pos + len;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    self[i] = self[i + len];
  end;
  self.length = self.length - len;
  do return ret end
end
Array.prototype.toString = function(self) 
  local tbl = ({});
  _G.table.insert(tbl, "[");
  _G.table.insert(tbl, self:join(","));
  _G.table.insert(tbl, "]");
  do return _G.table.concat(tbl, "") end
end
Array.prototype.unshift = function(self,x) 
  local len = self.length;
  local _g = 0;
  while (_g < len) do 
    _g = _g + 1;
    local i = _g - 1;
    self[len - i] = self[(len - i) - 1];
  end;
  self[0] = x;
end
Array.prototype.insert = function(self,pos,x) 
  if (pos > self.length) then 
    pos = self.length;
  end;
  if (pos < 0) then 
    pos = self.length + pos;
    if (pos < 0) then 
      pos = 0;
    end;
  end;
  local cur_len = self.length;
  while (cur_len > pos) do 
    self[cur_len] = self[cur_len - 1];
    cur_len = cur_len - 1;
  end;
  self[pos] = x;
end
Array.prototype.remove = function(self,x) 
  local _g = 0;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (self[i] == x) then 
      local _g = i;
      local _g1 = self.length - 1;
      while (_g < _g1) do 
        _g = _g + 1;
        local j = _g - 1;
        self[j] = self[j + 1];
      end;
      self[self.length - 1] = nil;
      self.length = self.length - 1;
      do return true end;
    end;
  end;
  do return false end
end
Array.prototype.contains = function(self,x) 
  local _g = 0;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    if (self[_g - 1] == x) then 
      do return true end;
    end;
  end;
  do return false end
end
Array.prototype.indexOf = function(self,x,fromIndex) 
  local _end = self.length;
  if (fromIndex == nil) then 
    fromIndex = 0;
  else
    if (fromIndex < 0) then 
      fromIndex = self.length + fromIndex;
      if (fromIndex < 0) then 
        fromIndex = 0;
      end;
    end;
  end;
  local _g = fromIndex;
  while (_g < _end) do 
    _g = _g + 1;
    local i = _g - 1;
    if (x == self[i]) then 
      do return i end;
    end;
  end;
  do return -1 end
end
Array.prototype.lastIndexOf = function(self,x,fromIndex) 
  if ((fromIndex == nil) or (fromIndex >= self.length)) then 
    fromIndex = self.length - 1;
  else
    if (fromIndex < 0) then 
      fromIndex = self.length + fromIndex;
      if (fromIndex < 0) then 
        do return -1 end;
      end;
    end;
  end;
  local i = fromIndex;
  while (i >= 0) do 
    if (self[i] == x) then 
      do return i end;
    else
      i = i - 1;
    end;
  end;
  do return -1 end
end
Array.prototype.copy = function(self) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  do return _g end
end
Array.prototype.map = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(f(i));
  end;
  do return _g end
end
Array.prototype.filter = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    if (f(i)) then 
      _g:push(i);
    end;
  end;
  do return _g end
end
Array.prototype.iterator = function(self) 
  do return __haxe_iterators_ArrayIterator.new(self) end
end
Array.prototype.keyValueIterator = function(self) 
  do return __haxe_iterators_ArrayKeyValueIterator.new(self) end
end
Array.prototype.resize = function(self,len) 
  if (self.length < len) then 
    self.length = len;
  else
    if (self.length > len) then 
      local _g = len;
      local _g1 = self.length;
      while (_g < _g1) do 
        _g = _g + 1;
        self[_g - 1] = nil;
      end;
      self.length = len;
    end;
  end;
end

Array.prototype.__class__ =  Array

__json2object_reader_BaseParser.new = function(errors,putils,errorType) 
  local self = _hx_new(__json2object_reader_BaseParser.prototype)
  __json2object_reader_BaseParser.super(self,errors,putils,errorType)
  return self
end
__json2object_reader_BaseParser.super = function(self,errors,putils,errorType) 
  self.errors = errors;
  self.putils = putils;
  self.errorType = errorType;
end
__json2object_reader_BaseParser.__name__ = true
__json2object_reader_BaseParser.prototype = _hx_e();
__json2object_reader_BaseParser.prototype.fromJson = function(self,jsonString,filename) 
  if (filename == nil) then 
    filename = "";
  end;
  self.putils = __json2object_PositionUtils.new(jsonString);
  self.errors = _hx_tab_array({}, 0);
  local _hx_status, _hx_result = pcall(function() 
  
      self:loadJson(__hxjsonast_Parser.new(jsonString, filename):doParse());
    return _hx_pcall_default
  end)
  if not _hx_status and _hx_result == "_hx_pcall_break" then
  elseif not _hx_status then 
    local _g = _hx_result;
    local _g1 = __haxe_Exception.caught(_g):unwrap();
    if (__lua_Boot.__instanceof(_g1, __hxjsonast_Error)) then 
      local e = _g1;
      self.errors:push(__json2object_Error.ParserError(e.message, self.putils:convertPosition(e.pos)));
    else
      _G.error(_g,0);
    end;
  elseif _hx_result ~= _hx_pcall_default then
    return _hx_result
  end;
  do return self.value end
end
__json2object_reader_BaseParser.prototype.loadJson = function(self,json,variable) 
  if (variable == nil) then 
    variable = "";
  end;
  local pos = self.putils:convertPosition(json.pos);
  local _g = json.value;
  local tmp = _g[1];
  if (tmp) == 0 then 
    self:loadJsonString(_g[2], pos, variable);
  elseif (tmp) == 1 then 
    self:loadJsonNumber(_g[2], pos, variable);
  elseif (tmp) == 2 then 
    self:loadJsonObject(_g[2], pos, variable);
  elseif (tmp) == 3 then 
    self:loadJsonArray(_g[2], pos, variable);
  elseif (tmp) == 4 then 
    self:loadJsonBool(_g[2], pos, variable);
  elseif (tmp) == 5 then 
    self:loadJsonNull(pos, variable); end;
  do return self.value end
end
__json2object_reader_BaseParser.prototype.loadJsonNull = function(self,pos,variable) 
  self:onIncorrectType(pos, variable);
end
__json2object_reader_BaseParser.prototype.loadJsonString = function(self,s,pos,variable) 
  self:onIncorrectType(pos, variable);
end
__json2object_reader_BaseParser.prototype.loadJsonNumber = function(self,f,pos,variable) 
  self:onIncorrectType(pos, variable);
end
__json2object_reader_BaseParser.prototype.loadJsonBool = function(self,b,pos,variable) 
  self:onIncorrectType(pos, variable);
end
__json2object_reader_BaseParser.prototype.loadJsonArray = function(self,a,pos,variable) 
  self:onIncorrectType(pos, variable);
end
__json2object_reader_BaseParser.prototype.loadJsonObject = function(self,o,pos,variable) 
  self:onIncorrectType(pos, variable);
end
__json2object_reader_BaseParser.prototype.loadObjectField = function(self,loadJsonFn,field,name,assigned,defaultValue,pos) 
  local _hx_status, _hx_result = pcall(function() 
  
      local ret = loadJsonFn(field.value, field.name);
      assigned.h[name] = true;
      do return ret end;
    return _hx_pcall_default
  end)
  if not _hx_status and _hx_result == "_hx_pcall_break" then
  elseif not _hx_status then 
    local _g = _hx_result;
    local _g = __haxe_Exception.caught(_g):unwrap();
    if (__lua_Boot.__instanceof(_g, __json2object_InternalError)) then 
      local e = _g;
      if (e ~= __json2object_InternalError.ParsingThrow) then 
        _G.error(__haxe_Exception.thrown(e),0);
      end;
    else
      self.errors:push(__json2object_Error.CustomFunctionException(_g, pos));
    end;
  elseif _hx_result ~= _hx_pcall_default then
    return _hx_result
  end;
  do return defaultValue end
end
__json2object_reader_BaseParser.prototype.objectSetupAssign = function(self,assigned,keys,values) 
  local _g = 0;
  local _g1 = keys.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    local key = keys[i];
    local value = values[i];
    if (value == nil) then 
      assigned.h[key] = __haxe_ds_StringMap.tnull;
    else
      assigned.h[key] = value;
    end;
  end;
end
__json2object_reader_BaseParser.prototype.objectErrors = function(self,assigned,pos) 
  local lastPos = self.putils:convertPosition(__hxjsonast_Position.new(pos.file, pos.max - 1, pos.max - 1));
  local s = assigned:keys();
  while (s:hasNext()) do 
    local s = s:next();
    local ret = assigned.h[s];
    if (ret == __haxe_ds_StringMap.tnull) then 
      ret = nil;
    end;
    if (not ret) then 
      self.errors:push(__json2object_Error.UninitializedVariable(s, lastPos));
    end;
  end;
end
__json2object_reader_BaseParser.prototype.onIncorrectType = function(self,pos,variable) 
  self:parsingThrow();
end
__json2object_reader_BaseParser.prototype.parsingThrow = function(self) 
  if (self.errorType ~= 0) then 
    _G.error(__haxe_Exception.thrown(__json2object_InternalError.ParsingThrow),0);
  end;
end

__json2object_reader_BaseParser.prototype.__class__ =  __json2object_reader_BaseParser

JsonParser_1.new = function(errors,putils,errorType) 
  local self = _hx_new(JsonParser_1.prototype)
  JsonParser_1.super(self,errors,putils,errorType)
  return self
end
JsonParser_1.super = function(self,errors,putils,errorType) 
  if (errorType == nil) then 
    errorType = 0;
  end;
  __json2object_reader_BaseParser.super(self,errors,putils,errorType);
end
JsonParser_1.__name__ = true
JsonParser_1.prototype = _hx_e();
JsonParser_1.prototype.onIncorrectType = function(self,pos,variable) 
  self.errors:push(__json2object_Error.IncorrectType(variable, "lua.StringMap<lua.StringMap<String>>", pos));
  __json2object_reader_BaseParser.prototype.onIncorrectType(self,pos,variable);
end
JsonParser_1.prototype.loadJsonNull = function(self,pos,variable) 
  self.value = nil;
end
JsonParser_1.prototype.loadJsonObject = function(self,o,pos,variable) 
  local assigned = __haxe_ds_StringMap.new();
  self:objectSetupAssign(assigned, _hx_tab_array({[0]="h"}, 1), _hx_tab_array({[0]=false}, 1));
  self.value = self:getAuto();
  local _g = 0;
  while (_g < o.length) do 
    local field = o[_g];
    _g = _g + 1;
    if (field.name == "h") then 
      self.value.h = self:loadObjectField(_hx_bind(JsonParser_2.new(self.errors, self.putils, 1),JsonParser_2.new(self.errors, self.putils, 1).loadJson), field, "h", assigned, self.value.h, pos);
    else
      self.errors:push(__json2object_Error.UnknownVariable(field.name, self.putils:convertPosition(field.namePos)));
    end;
  end;
  self:objectErrors(assigned, pos);
end
JsonParser_1.prototype.getAuto = function(self) 
  local value = Type.createEmptyInstance(__lua_StringMap);
  value.h = JsonParser_2.new(_hx_tab_array({}, 0), self.putils, 0):loadJson(__hxjsonast_Json.new(__hxjsonast_JsonValue.JNull, __hxjsonast_Position.new("", 0, 1)));
  do return value end
end

JsonParser_1.prototype.__class__ =  JsonParser_1
JsonParser_1.__super__ = __json2object_reader_BaseParser
setmetatable(JsonParser_1.prototype,{__index=__json2object_reader_BaseParser.prototype})

JsonParser_2.new = function(errors,putils,errorType) 
  local self = _hx_new(JsonParser_2.prototype)
  JsonParser_2.super(self,errors,putils,errorType)
  return self
end
JsonParser_2.super = function(self,errors,putils,errorType) 
  if (errorType == nil) then 
    errorType = 0;
  end;
  __json2object_reader_BaseParser.super(self,errors,putils,errorType);
end
JsonParser_2.__name__ = true
JsonParser_2.prototype = _hx_e();
JsonParser_2.prototype.onIncorrectType = function(self,pos,variable) 
  self.errors:push(__json2object_Error.IncorrectType(variable, "lua.Table<String, lua.StringMap<String>>", pos));
  __json2object_reader_BaseParser.prototype.onIncorrectType(self,pos,variable);
end
JsonParser_2.prototype.loadJsonNull = function(self,pos,variable) 
  self.value = nil;
end
JsonParser_2.prototype.loadJsonObject = function(self,o,pos,variable) 
  local assigned = __haxe_ds_StringMap.new();
  self:objectSetupAssign(assigned, _hx_tab_array({}, 0), _hx_tab_array({}, 0));
  self.value = self:getAuto();
  local _g = 0;
  while (_g < o.length) do 
    local field = o[_g];
    _g = _g + 1;
    self.errors:push(__json2object_Error.UnknownVariable(field.name, self.putils:convertPosition(field.namePos)));
  end;
  self:objectErrors(assigned, pos);
end
JsonParser_2.prototype.getAuto = function(self) 
  do return Type.createEmptyInstance(_G.table) end
end

JsonParser_2.prototype.__class__ =  JsonParser_2
JsonParser_2.__super__ = __json2object_reader_BaseParser
setmetatable(JsonParser_2.prototype,{__index=__json2object_reader_BaseParser.prototype})

JsonWriter_1.new = function(ignoreNullOptionals) 
  local self = _hx_new(JsonWriter_1.prototype)
  JsonWriter_1.super(self,ignoreNullOptionals)
  return self
end
JsonWriter_1.super = function(self,ignoreNullOptionals) 
  if (ignoreNullOptionals == nil) then 
    ignoreNullOptionals = false;
  end;
  self.ignoreNullOptionals = ignoreNullOptionals;
end
JsonWriter_1.__name__ = true
JsonWriter_1.prototype = _hx_e();
JsonWriter_1.prototype.buildIndent = function(self,space,level) 
  if (level == 0) then 
    do return "" end;
  end;
  local buff_b = ({});
  local _g = 0;
  while (_g < level) do 
    _g = _g + 1;
    _G.table.insert(buff_b, Std.string(space));
  end;
  do return _G.table.concat(buff_b) end
end
JsonWriter_1.prototype._write = function(self,o,space,level,indentFirst,onAllOptionalNull) 
  if (indentFirst == nil) then 
    indentFirst = false;
  end;
  if (level == nil) then 
    level = 0;
  end;
  if (space == nil) then 
    space = "";
  end;
  local indent = self:buildIndent(space, level);
  local firstIndent = (function() 
    local _hx_1
    if (indentFirst) then 
    _hx_1 = indent; else 
    _hx_1 = ""; end
    return _hx_1
  end )();
  if (o == nil) then 
    do return Std.string(firstIndent) .. Std.string("null") end;
  end;
  local decl = _hx_tab_array({[0]=Std.string(Std.string(Std.string(indent) .. Std.string(space)) .. Std.string("\"h\": ")) .. Std.string(JsonWriter_2.new(self.ignoreNullOptionals):_write(o.h, space, level + 1, false, onAllOptionalNull))}, 1);
  if (self.ignoreNullOptionals) then 
    local skips = _hx_tab_array({[0]=false}, 1);
    if (skips:indexOf(false) == -1) then 
      decl = (function() 
        local _hx_2
        if (onAllOptionalNull ~= nil) then 
        _hx_2 = _hx_tab_array({[0]=onAllOptionalNull()}, 1); else 
        _hx_2 = _hx_tab_array({}, 0); end
        return _hx_2
      end )();
    else
      local _g = _hx_tab_array({}, 0);
      local _g1 = 0;
      local _g2 = decl.length;
      local _hx_continue_1 = false;
      while (_g1 < _g2) do repeat 
        _g1 = _g1 + 1;
        local i = _g1 - 1;
        local decl1;
        if (skips[i]) then 
          break;
        else
          decl1 = decl[i];
        end;
        _g:push(decl1);until true
        if _hx_continue_1 then 
        _hx_continue_1 = false;
        break;
        end;
        
      end;
      decl = _g;
    end;
  end;
  local newLine = (function() 
    local _hx_3
    if ((space ~= "") and (decl.length > 0)) then 
    _hx_3 = "\n"; else 
    _hx_3 = ""; end
    return _hx_3
  end )();
  local json = Std.string(Std.string(firstIndent) .. Std.string("{")) .. Std.string(newLine);
  json = Std.string(json) .. Std.string((Std.string(decl:join(Std.string(",") .. Std.string(newLine))) .. Std.string(newLine)));
  json = Std.string(json) .. Std.string((Std.string(indent) .. Std.string("}")));
  do return json end
end
JsonWriter_1.prototype.write = function(self,o,space) 
  if (space == nil) then 
    space = "";
  end;
  do return self:_write(o, space, 0, false) end
end

JsonWriter_1.prototype.__class__ =  JsonWriter_1

JsonWriter_2.new = function(ignoreNullOptionals) 
  local self = _hx_new(JsonWriter_2.prototype)
  JsonWriter_2.super(self,ignoreNullOptionals)
  return self
end
JsonWriter_2.super = function(self,ignoreNullOptionals) 
  if (ignoreNullOptionals == nil) then 
    ignoreNullOptionals = false;
  end;
  self.ignoreNullOptionals = ignoreNullOptionals;
end
JsonWriter_2.__name__ = true
JsonWriter_2.prototype = _hx_e();
JsonWriter_2.prototype.buildIndent = function(self,space,level) 
  if (level == 0) then 
    do return "" end;
  end;
  local buff_b = ({});
  local _g = 0;
  while (_g < level) do 
    _g = _g + 1;
    _G.table.insert(buff_b, Std.string(space));
  end;
  do return _G.table.concat(buff_b) end
end
JsonWriter_2.prototype._write = function(self,o,space,level,indentFirst,onAllOptionalNull) 
  if (indentFirst == nil) then 
    indentFirst = false;
  end;
  if (level == nil) then 
    level = 0;
  end;
  if (space == nil) then 
    space = "";
  end;
  local indent = self:buildIndent(space, level);
  local firstIndent = (function() 
    local _hx_1
    if (indentFirst) then 
    _hx_1 = indent; else 
    _hx_1 = ""; end
    return _hx_1
  end )();
  if (o == nil) then 
    do return Std.string(firstIndent) .. Std.string("null") end;
  end;
  local decl = _hx_tab_array({}, 0);
  if (self.ignoreNullOptionals) then 
    local skips = _hx_tab_array({}, 0);
    if (skips:indexOf(false) == -1) then 
      decl = (function() 
        local _hx_2
        if (onAllOptionalNull ~= nil) then 
        _hx_2 = _hx_tab_array({[0]=onAllOptionalNull()}, 1); else 
        _hx_2 = _hx_tab_array({}, 0); end
        return _hx_2
      end )();
    else
      local _g = _hx_tab_array({}, 0);
      local _g1 = 0;
      local _g2 = decl.length;
      local _hx_continue_1 = false;
      while (_g1 < _g2) do repeat 
        _g1 = _g1 + 1;
        local i = _g1 - 1;
        local decl1;
        if (skips[i]) then 
          break;
        else
          decl1 = decl[i];
        end;
        _g:push(decl1);until true
        if _hx_continue_1 then 
        _hx_continue_1 = false;
        break;
        end;
        
      end;
      decl = _g;
    end;
  end;
  local newLine = (function() 
    local _hx_3
    if ((space ~= "") and (decl.length > 0)) then 
    _hx_3 = "\n"; else 
    _hx_3 = ""; end
    return _hx_3
  end )();
  local json = Std.string(Std.string(firstIndent) .. Std.string("{")) .. Std.string(newLine);
  json = Std.string(json) .. Std.string((Std.string(decl:join(Std.string(",") .. Std.string(newLine))) .. Std.string(newLine)));
  json = Std.string(json) .. Std.string((Std.string(indent) .. Std.string("}")));
  do return json end
end

JsonWriter_2.prototype.__class__ =  JsonWriter_2

Math.new = {}
Math.__name__ = true
Math.isNaN = function(f) 
  do return f ~= f end;
end
Math.isFinite = function(f) 
  if (f > -_G.math.huge) then 
    do return f < _G.math.huge end;
  else
    do return false end;
  end;
end
Math.min = function(a,b) 
  if (Math.isNaN(a) or Math.isNaN(b)) then 
    do return (0/0) end;
  else
    do return _G.math.min(a, b) end;
  end;
end

Reflect.new = {}
Reflect.__name__ = true
Reflect.field = function(o,field) 
  if (_G.type(o) == "string") then 
    if (field == "length") then 
      do return _hx_wrap_if_string_field(o,'length') end;
    else
      do return String.prototype[field] end;
    end;
  else
    local _hx_status, _hx_result = pcall(function() 
    
        do return o[field] end;
      return _hx_pcall_default
    end)
    if not _hx_status and _hx_result == "_hx_pcall_break" then
    elseif not _hx_status then 
      local _g = _hx_result;
      do return nil end;
    elseif _hx_result ~= _hx_pcall_default then
      return _hx_result
    end;
  end;
end

String.new = function(string) 
  local self = _hx_new(String.prototype)
  String.super(self,string)
  self = string
  return self
end
String.super = function(self,string) 
end
String.__name__ = true
String.__index = function(s,k) 
  if (k == "length") then 
    do return _G.string.len(s) end;
  else
    local o = String.prototype;
    local field = k;
    if ((function() 
      local _hx_1
      if ((_G.type(o) == "string") and ((String.prototype[field] ~= nil) or (field == "length"))) then 
      _hx_1 = true; elseif (o.__fields__ ~= nil) then 
      _hx_1 = o.__fields__[field] ~= nil; else 
      _hx_1 = o[field] ~= nil; end
      return _hx_1
    end )()) then 
      do return String.prototype[k] end;
    else
      if (String.__oldindex ~= nil) then 
        if (_G.type(String.__oldindex) == "function") then 
          do return String.__oldindex(s, k) end;
        else
          if (_G.type(String.__oldindex) == "table") then 
            do return String.__oldindex[k] end;
          end;
        end;
        do return nil end;
      else
        do return nil end;
      end;
    end;
  end;
end
String.indexOfEmpty = function(s,startIndex) 
  local length = _G.string.len(s);
  if (startIndex < 0) then 
    startIndex = length + startIndex;
    if (startIndex < 0) then 
      startIndex = 0;
    end;
  end;
  if (startIndex > length) then 
    do return length end;
  else
    do return startIndex end;
  end;
end
String.fromCharCode = function(code) 
  do return _G.string.char(code) end;
end
String.prototype = _hx_e();
String.prototype.toUpperCase = function(self) 
  do return _G.string.upper(self) end
end
String.prototype.toLowerCase = function(self) 
  do return _G.string.lower(self) end
end
String.prototype.indexOf = function(self,str,startIndex) 
  if (startIndex == nil) then 
    startIndex = 1;
  else
    startIndex = startIndex + 1;
  end;
  if (str == "") then 
    do return String.indexOfEmpty(self, startIndex - 1) end;
  end;
  local r = _G.string.find(self, str, startIndex, true);
  if ((r ~= nil) and (r > 0)) then 
    do return r - 1 end;
  else
    do return -1 end;
  end;
end
String.prototype.lastIndexOf = function(self,str,startIndex) 
  local ret = -1;
  if (startIndex == nil) then 
    startIndex = #self;
  end;
  while (true) do 
    local startIndex1 = ret + 1;
    if (startIndex1 == nil) then 
      startIndex1 = 1;
    else
      startIndex1 = startIndex1 + 1;
    end;
    local p;
    if (str == "") then 
      p = String.indexOfEmpty(self, startIndex1 - 1);
    else
      local r = _G.string.find(self, str, startIndex1, true);
      p = (function() 
        local _hx_1
        if ((r ~= nil) and (r > 0)) then 
        _hx_1 = r - 1; else 
        _hx_1 = -1; end
        return _hx_1
      end )();
    end;
    if (((p == -1) or (p > startIndex)) or (p == ret)) then 
      break;
    end;
    ret = p;
  end;
  do return ret end
end
String.prototype.split = function(self,delimiter) 
  local idx = 1;
  local ret = _hx_tab_array({}, 0);
  while (idx ~= nil) do 
    local newidx = 0;
    if (#delimiter > 0) then 
      newidx = _G.string.find(self, delimiter, idx, true);
    else
      if (idx >= #self) then 
        newidx = nil;
      else
        newidx = idx + 1;
      end;
    end;
    if (newidx ~= nil) then 
      ret:push(_G.string.sub(self, idx, newidx - 1));
      idx = newidx + #delimiter;
    else
      ret:push(_G.string.sub(self, idx, #self));
      idx = nil;
    end;
  end;
  do return ret end
end
String.prototype.toString = function(self) 
  do return self end
end
String.prototype.substring = function(self,startIndex,endIndex) 
  if (endIndex == nil) then 
    endIndex = #self;
  end;
  if (endIndex < 0) then 
    endIndex = 0;
  end;
  if (startIndex < 0) then 
    startIndex = 0;
  end;
  if (endIndex < startIndex) then 
    do return _G.string.sub(self, endIndex + 1, startIndex) end;
  else
    do return _G.string.sub(self, startIndex + 1, endIndex) end;
  end;
end
String.prototype.charAt = function(self,index) 
  do return _G.string.sub(self, index + 1, index + 1) end
end
String.prototype.charCodeAt = function(self,index) 
  do return _G.string.byte(self, index + 1) end
end
String.prototype.substr = function(self,pos,len) 
  if ((len == nil) or (len > (pos + #self))) then 
    len = #self;
  else
    if (len < 0) then 
      len = #self + len;
    end;
  end;
  if (pos < 0) then 
    pos = #self + pos;
  end;
  if (pos < 0) then 
    pos = 0;
  end;
  do return _G.string.sub(self, pos + 1, pos + len) end
end

String.prototype.__class__ =  String

Std.new = {}
Std.__name__ = true
Std.string = function(s) 
  do return _hx_tostring(s, 0) end;
end
Std.int = function(x) 
  if (not Math.isFinite(x) or Math.isNaN(x)) then 
    do return 0 end;
  else
    do return _hx_bit_clamp(x) end;
  end;
end
Std.parseInt = function(x) 
  if (x == nil) then 
    do return nil end;
  end;
  local hexMatch = _G.string.match(x, "^[ \t\r\n]*([%-+]*0[xX][%da-fA-F]*)");
  if (hexMatch ~= nil) then 
    local sign;
    local _g = _G.string.byte(hexMatch, 1);
    if (_g) == 43 then 
      sign = 1;
    elseif (_g) == 45 then 
      sign = -1;else
    sign = 0; end;
    local pos = (function() 
      local _hx_1
      if (sign == 0) then 
      _hx_1 = 2; else 
      _hx_1 = 3; end
      return _hx_1
    end )();
    local len = nil;
    len = #hexMatch;
    if (pos < 0) then 
      pos = #hexMatch + pos;
    end;
    if (pos < 0) then 
      pos = 0;
    end;
    do return (function() 
      local _hx_2
      if (sign == -1) then 
      _hx_2 = -1; else 
      _hx_2 = 1; end
      return _hx_2
    end )() * _G.tonumber(_G.string.sub(hexMatch, pos + 1, pos + len), 16) end;
  else
    local intMatch = _G.string.match(x, "^ *[%-+]?%d*");
    if (intMatch ~= nil) then 
      do return _G.tonumber(intMatch) end;
    else
      do return nil end;
    end;
  end;
end

StringBuf.new = function() 
  local self = _hx_new(StringBuf.prototype)
  StringBuf.super(self)
  return self
end
StringBuf.super = function(self) 
  self.b = ({});
  self.length = 0;
end
StringBuf.__name__ = true
StringBuf.prototype = _hx_e();

StringBuf.prototype.__class__ =  StringBuf

Type.new = {}
Type.__name__ = true
Type.createEmptyInstance = function(cl) 
  local ret = ({});
  _G.setmetatable(ret, _hx_o({__fields__={__index=true},__index=cl.prototype}));
  do return ret end;
end

__haxe_IMap.new = {}
__haxe_IMap.__name__ = true

__haxe_Exception.new = function(message,previous,native) 
  local self = _hx_new(__haxe_Exception.prototype)
  __haxe_Exception.super(self,message,previous,native)
  return self
end
__haxe_Exception.super = function(self,message,previous,native) 
  self.__skipStack = 0;
  self.__exceptionMessage = message;
  self.__previousException = previous;
  if (native ~= nil) then 
    self.__nativeException = native;
    self.__nativeStack = __haxe_NativeStackTrace.exceptionStack();
  else
    self.__nativeException = self;
    self.__nativeStack = __haxe_NativeStackTrace.callStack();
    self.__skipStack = 1;
  end;
end
__haxe_Exception.__name__ = true
__haxe_Exception.caught = function(value) 
  if (__lua_Boot.__instanceof(value, __haxe_Exception)) then 
    do return value end;
  else
    do return __haxe_ValueException.new(value, nil, value) end;
  end;
end
__haxe_Exception.thrown = function(value) 
  if (__lua_Boot.__instanceof(value, __haxe_Exception)) then 
    do return value:get_native() end;
  else
    local e = __haxe_ValueException.new(value);
    e.__skipStack = e.__skipStack + 1;
    do return e end;
  end;
end
__haxe_Exception.prototype = _hx_e();
__haxe_Exception.prototype.unwrap = function(self) 
  do return self.__nativeException end
end
__haxe_Exception.prototype.get_native = function(self) 
  do return self.__nativeException end
end

__haxe_Exception.prototype.__class__ =  __haxe_Exception

__haxe_Log.new = {}
__haxe_Log.__name__ = true
__haxe_Log.formatOutput = function(v,infos) 
  local str = Std.string(v);
  if (infos == nil) then 
    do return str end;
  end;
  local pstr = Std.string(Std.string(infos.fileName) .. Std.string(":")) .. Std.string(infos.lineNumber);
  if (infos.customParams ~= nil) then 
    local _g = 0;
    local _g1 = infos.customParams;
    while (_g < _g1.length) do 
      local v = _g1[_g];
      _g = _g + 1;
      str = Std.string(str) .. Std.string((Std.string(", ") .. Std.string(Std.string(v))));
    end;
  end;
  do return Std.string(Std.string(pstr) .. Std.string(": ")) .. Std.string(str) end;
end
__haxe_Log.trace = function(v,infos) 
  local str = __haxe_Log.formatOutput(v, infos);
  _hx_print(str);
end

__haxe_NativeStackTrace.new = {}
__haxe_NativeStackTrace.__name__ = true
__haxe_NativeStackTrace.saveStack = function(exception) 
end
__haxe_NativeStackTrace.callStack = function() 
  local _g = debug.traceback();
  if (_g == nil) then 
    do return _hx_tab_array({}, 0) end;
  else
    local idx = 1;
    local ret = _hx_tab_array({}, 0);
    while (idx ~= nil) do 
      local newidx = 0;
      if (#"\n" > 0) then 
        newidx = _G.string.find(_g, "\n", idx, true);
      else
        if (idx >= #_g) then 
          newidx = nil;
        else
          newidx = idx + 1;
        end;
      end;
      if (newidx ~= nil) then 
        ret:push(_G.string.sub(_g, idx, newidx - 1));
        idx = newidx + #"\n";
      else
        ret:push(_G.string.sub(_g, idx, #_g));
        idx = nil;
      end;
    end;
    do return ret:slice(3) end;
  end;
end
__haxe_NativeStackTrace.exceptionStack = function() 
  do return _hx_tab_array({}, 0) end;
end

__haxe_ValueException.new = function(value,previous,native) 
  local self = _hx_new(__haxe_ValueException.prototype)
  __haxe_ValueException.super(self,value,previous,native)
  return self
end
__haxe_ValueException.super = function(self,value,previous,native) 
  __haxe_Exception.super(self,Std.string(value),previous,native);
  self.value = value;
end
__haxe_ValueException.__name__ = true
__haxe_ValueException.prototype = _hx_e();
__haxe_ValueException.prototype.unwrap = function(self) 
  do return self.value end
end

__haxe_ValueException.prototype.__class__ =  __haxe_ValueException
__haxe_ValueException.__super__ = __haxe_Exception
setmetatable(__haxe_ValueException.prototype,{__index=__haxe_Exception.prototype})
_hxClasses["haxe.ds.Either"] = { __ename__ = true, __constructs__ = _hx_tab_array({[0]="Left","Right"},2)}
__haxe_ds_Either = _hxClasses["haxe.ds.Either"];
__haxe_ds_Either.Left = function(v) local _x = _hx_tab_array({[0]="Left",0,v,__enum__=__haxe_ds_Either}, 3); return _x; end 
__haxe_ds_Either.Right = function(v) local _x = _hx_tab_array({[0]="Right",1,v,__enum__=__haxe_ds_Either}, 3); return _x; end 

__haxe_ds_StringMap.new = function() 
  local self = _hx_new(__haxe_ds_StringMap.prototype)
  __haxe_ds_StringMap.super(self)
  return self
end
__haxe_ds_StringMap.super = function(self) 
  self.h = ({});
end
__haxe_ds_StringMap.__name__ = true
__haxe_ds_StringMap.__interfaces__ = {__haxe_IMap}
__haxe_ds_StringMap.prototype = _hx_e();
__haxe_ds_StringMap.prototype.keys = function(self) 
  local _gthis = self;
  local next = _G.next;
  local cur = next(self.h, nil);
  do return _hx_o({__fields__={next=true,hasNext=true},next=function(self) 
    local ret = cur;
    cur = next(_gthis.h, cur);
    do return ret end;
  end,hasNext=function(self) 
    do return cur ~= nil end;
  end}) end
end

__haxe_ds_StringMap.prototype.__class__ =  __haxe_ds_StringMap

__haxe_iterators_ArrayIterator.new = function(array) 
  local self = _hx_new(__haxe_iterators_ArrayIterator.prototype)
  __haxe_iterators_ArrayIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayIterator.super = function(self,array) 
  self.current = 0;
  self.array = array;
end
__haxe_iterators_ArrayIterator.__name__ = true
__haxe_iterators_ArrayIterator.prototype = _hx_e();
__haxe_iterators_ArrayIterator.prototype.hasNext = function(self) 
  do return self.current < self.array.length end
end
__haxe_iterators_ArrayIterator.prototype.next = function(self) 
  do return self.array[(function() 
  local _hx_obj = self;
  local _hx_fld = 'current';
  local _ = _hx_obj[_hx_fld];
  _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
   return _;
   end)()] end
end

__haxe_iterators_ArrayIterator.prototype.__class__ =  __haxe_iterators_ArrayIterator

__haxe_iterators_ArrayKeyValueIterator.new = function(array) 
  local self = _hx_new(__haxe_iterators_ArrayKeyValueIterator.prototype)
  __haxe_iterators_ArrayKeyValueIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayKeyValueIterator.super = function(self,array) 
  self.array = array;
end
__haxe_iterators_ArrayKeyValueIterator.__name__ = true
__haxe_iterators_ArrayKeyValueIterator.prototype = _hx_e();

__haxe_iterators_ArrayKeyValueIterator.prototype.__class__ =  __haxe_iterators_ArrayKeyValueIterator

__hxjsonast_Error.new = function(message,pos) 
  local self = _hx_new(__hxjsonast_Error.prototype)
  __hxjsonast_Error.super(self,message,pos)
  return self
end
__hxjsonast_Error.super = function(self,message,pos) 
  self.message = message;
  self.pos = pos;
end
__hxjsonast_Error.__name__ = true
__hxjsonast_Error.prototype = _hx_e();

__hxjsonast_Error.prototype.__class__ =  __hxjsonast_Error

__hxjsonast_Json.new = function(value,pos) 
  local self = _hx_new(__hxjsonast_Json.prototype)
  __hxjsonast_Json.super(self,value,pos)
  return self
end
__hxjsonast_Json.super = function(self,value,pos) 
  self.value = value;
  self.pos = pos;
end
__hxjsonast_Json.__name__ = true
__hxjsonast_Json.prototype = _hx_e();

__hxjsonast_Json.prototype.__class__ =  __hxjsonast_Json
_hxClasses["hxjsonast.JsonValue"] = { __ename__ = true, __constructs__ = _hx_tab_array({[0]="JString","JNumber","JObject","JArray","JBool","JNull"},6)}
__hxjsonast_JsonValue = _hxClasses["hxjsonast.JsonValue"];
__hxjsonast_JsonValue.JString = function(s) local _x = _hx_tab_array({[0]="JString",0,s,__enum__=__hxjsonast_JsonValue}, 3); return _x; end 
__hxjsonast_JsonValue.JNumber = function(s) local _x = _hx_tab_array({[0]="JNumber",1,s,__enum__=__hxjsonast_JsonValue}, 3); return _x; end 
__hxjsonast_JsonValue.JObject = function(fields) local _x = _hx_tab_array({[0]="JObject",2,fields,__enum__=__hxjsonast_JsonValue}, 3); return _x; end 
__hxjsonast_JsonValue.JArray = function(values) local _x = _hx_tab_array({[0]="JArray",3,values,__enum__=__hxjsonast_JsonValue}, 3); return _x; end 
__hxjsonast_JsonValue.JBool = function(b) local _x = _hx_tab_array({[0]="JBool",4,b,__enum__=__hxjsonast_JsonValue}, 3); return _x; end 
__hxjsonast_JsonValue.JNull = _hx_tab_array({[0]="JNull",5,__enum__ = __hxjsonast_JsonValue},2)


__hxjsonast_JObjectField.new = function(name,namePos,value) 
  local self = _hx_new(__hxjsonast_JObjectField.prototype)
  __hxjsonast_JObjectField.super(self,name,namePos,value)
  return self
end
__hxjsonast_JObjectField.super = function(self,name,namePos,value) 
  self.name = name;
  self.namePos = namePos;
  self.value = value;
end
__hxjsonast_JObjectField.__name__ = true
__hxjsonast_JObjectField.prototype = _hx_e();

__hxjsonast_JObjectField.prototype.__class__ =  __hxjsonast_JObjectField

__hxjsonast_Parser.new = function(source,filename) 
  local self = _hx_new(__hxjsonast_Parser.prototype)
  __hxjsonast_Parser.super(self,source,filename)
  return self
end
__hxjsonast_Parser.super = function(self,source,filename) 
  self.source = source;
  self.filename = filename;
  self.pos = 0;
end
__hxjsonast_Parser.__name__ = true
__hxjsonast_Parser.prototype = _hx_e();
__hxjsonast_Parser.prototype.doParse = function(self) 
  local result = self:parseRec();
  local c;
  while (true) do 
    local index = (function() 
    local _hx_obj = self;
    local _hx_fld = 'pos';
    local _ = _hx_obj[_hx_fld];
    _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
     return _;
     end)();
    c = _G.string.byte(self.source, index + 1);
    if (not (c ~= nil)) then 
      break;
    end;
    if (c) == 9 or (c) == 10 or (c) == 13 or (c) == 32 then else
    self:invalidChar(); end;
  end;
  do return result end
end
__hxjsonast_Parser.prototype.parseRec = function(self) 
  while (true) do 
    local index = (function() 
    local _hx_obj = self;
    local _hx_fld = 'pos';
    local _ = _hx_obj[_hx_fld];
    _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
     return _;
     end)();
    local c = _G.string.byte(self.source, index + 1);
    if (c) == 9 or (c) == 10 or (c) == 13 or (c) == 32 then 
    elseif (c) == 34 then 
      local save = self.pos;
      do return __hxjsonast_Json.new(__hxjsonast_JsonValue.JString(self:parseString()), __hxjsonast_Position.new(self.filename, save - 1, self.pos)) end;
    elseif (c) == 45 or (c) == 48 or (c) == 49 or (c) == 50 or (c) == 51 or (c) == 52 or (c) == 53 or (c) == 54 or (c) == 55 or (c) == 56 or (c) == 57 then 
      local start = self.pos - 1;
      local minus = c == 45;
      local digit = not minus;
      local zero = c == 48;
      local point = false;
      local e = false;
      local pm = false;
      local _end = false;
      while (true) do 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        local _g = _G.string.byte(self.source, index + 1);
        if (_g) == 43 or (_g) == 45 then 
          if (not e or pm) then 
            self:invalidNumber(start);
          end;
          digit = false;
          pm = true;
        elseif (_g) == 46 then 
          if ((minus or point) or e) then 
            self:invalidNumber(start);
          end;
          digit = false;
          point = true;
        elseif (_g) == 48 then 
          if (zero and not point) then 
            self:invalidNumber(start);
          end;
          if (minus) then 
            minus = false;
            zero = true;
          end;
          digit = true;
        elseif (_g) == 49 or (_g) == 50 or (_g) == 51 or (_g) == 52 or (_g) == 53 or (_g) == 54 or (_g) == 55 or (_g) == 56 or (_g) == 57 then 
          if (zero and not point) then 
            self:invalidNumber(start);
          end;
          if (minus) then 
            minus = false;
          end;
          digit = true;
          zero = false;
        elseif (_g) == 69 or (_g) == 101 then 
          if ((minus or zero) or e) then 
            self:invalidNumber(start);
          end;
          digit = false;
          e = true;else
        if (not digit) then 
          self:invalidNumber(start);
        end;
        self.pos = self.pos - 1;
        _end = true; end;
        if (_end) then 
          break;
        end;
      end;
      local _this = self.source;
      local pos = start;
      local len = self.pos - start;
      if ((len == nil) or (len > (start + #_this))) then 
        len = #_this;
      else
        if (len < 0) then 
          len = #_this + len;
        end;
      end;
      if (start < 0) then 
        pos = #_this + start;
      end;
      if (pos < 0) then 
        pos = 0;
      end;
      do return __hxjsonast_Json.new(__hxjsonast_JsonValue.JNumber(_G.string.sub(_this, pos + 1, pos + len)), __hxjsonast_Position.new(self.filename, start, self.pos)) end;
    elseif (c) == 91 then 
      local values = _hx_tab_array({}, 0);
      local comma = nil;
      local startPos = self.pos - 1;
      while (true) do 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        local _g = _G.string.byte(self.source, index + 1);
        if (_g) == 9 or (_g) == 10 or (_g) == 13 or (_g) == 32 then 
        elseif (_g) == 44 then 
          if (comma) then 
            comma = false;
          else
            self:invalidChar();
          end;
        elseif (_g) == 93 then 
          if (comma == false) then 
            self:invalidChar();
          end;
          do return __hxjsonast_Json.new(__hxjsonast_JsonValue.JArray(values), __hxjsonast_Position.new(self.filename, startPos, self.pos)) end;else
        if (comma) then 
          self:invalidChar();
        end;
        self.pos = self.pos - 1;
        values:push(self:parseRec());
        comma = true; end;
      end;
    elseif (c) == 102 then 
      local save = self.pos;
      local tmp;
      local tmp1;
      local tmp2;
      local index = (function() 
      local _hx_obj = self;
      local _hx_fld = 'pos';
      local _ = _hx_obj[_hx_fld];
      _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
       return _;
       end)();
      if (_G.string.byte(self.source, index + 1) == 97) then 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        tmp2 = _G.string.byte(self.source, index + 1) ~= 108;
      else
        tmp2 = true;
      end;
      if (not tmp2) then 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        tmp1 = _G.string.byte(self.source, index + 1) ~= 115;
      else
        tmp1 = true;
      end;
      if (not tmp1) then 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        tmp = _G.string.byte(self.source, index + 1) ~= 101;
      else
        tmp = true;
      end;
      if (tmp) then 
        self.pos = save;
        self:invalidChar();
      end;
      do return __hxjsonast_Json.new(__hxjsonast_JsonValue.JBool(false), __hxjsonast_Position.new(self.filename, save - 1, self.pos)) end;
    elseif (c) == 110 then 
      local save = self.pos;
      local tmp;
      local tmp1;
      local index = (function() 
      local _hx_obj = self;
      local _hx_fld = 'pos';
      local _ = _hx_obj[_hx_fld];
      _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
       return _;
       end)();
      if (_G.string.byte(self.source, index + 1) == 117) then 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        tmp1 = _G.string.byte(self.source, index + 1) ~= 108;
      else
        tmp1 = true;
      end;
      if (not tmp1) then 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        tmp = _G.string.byte(self.source, index + 1) ~= 108;
      else
        tmp = true;
      end;
      if (tmp) then 
        self.pos = save;
        self:invalidChar();
      end;
      do return __hxjsonast_Json.new(__hxjsonast_JsonValue.JNull, __hxjsonast_Position.new(self.filename, save - 1, self.pos)) end;
    elseif (c) == 116 then 
      local save = self.pos;
      local tmp;
      local tmp1;
      local index = (function() 
      local _hx_obj = self;
      local _hx_fld = 'pos';
      local _ = _hx_obj[_hx_fld];
      _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
       return _;
       end)();
      if (_G.string.byte(self.source, index + 1) == 114) then 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        tmp1 = _G.string.byte(self.source, index + 1) ~= 117;
      else
        tmp1 = true;
      end;
      if (not tmp1) then 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        tmp = _G.string.byte(self.source, index + 1) ~= 101;
      else
        tmp = true;
      end;
      if (tmp) then 
        self.pos = save;
        self:invalidChar();
      end;
      do return __hxjsonast_Json.new(__hxjsonast_JsonValue.JBool(true), __hxjsonast_Position.new(self.filename, save - 1, self.pos)) end;
    elseif (c) == 123 then 
      local fields = Array.new();
      local names_h = ({});
      local field = nil;
      local fieldPos = nil;
      local comma = nil;
      local startPos = self.pos - 1;
      while (true) do 
        local index = (function() 
        local _hx_obj = self;
        local _hx_fld = 'pos';
        local _ = _hx_obj[_hx_fld];
        _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
         return _;
         end)();
        local _g = _G.string.byte(self.source, index + 1);
        if (_g) == 9 or (_g) == 10 or (_g) == 13 or (_g) == 32 then 
        elseif (_g) == 34 then 
          if ((field ~= nil) or comma) then 
            self:invalidChar();
          end;
          local fieldStartPos = self.pos - 1;
          field = self:parseString();
          fieldPos = __hxjsonast_Position.new(self.filename, fieldStartPos, self.pos);
          if (names_h[field] ~= nil) then 
            _G.error(__haxe_Exception.thrown(__hxjsonast_Error.new(Std.string(Std.string("Duplicate field name \"") .. Std.string(field)) .. Std.string("\""), fieldPos)),0);
          else
            names_h[field] = true;
          end;
        elseif (_g) == 44 then 
          if (comma) then 
            comma = false;
          else
            self:invalidChar();
          end;
        elseif (_g) == 58 then 
          if (field == nil) then 
            self:invalidChar();
          end;
          fields:push(__hxjsonast_JObjectField.new(field, fieldPos, self:parseRec()));
          field = nil;
          fieldPos = nil;
          comma = true;
        elseif (_g) == 125 then 
          if ((field ~= nil) or (comma == false)) then 
            self:invalidChar();
          end;
          do return __hxjsonast_Json.new(__hxjsonast_JsonValue.JObject(fields), __hxjsonast_Position.new(self.filename, startPos, self.pos)) end;else
        self:invalidChar(); end;
      end;else
    self:invalidChar(); end;
  end;
end
__hxjsonast_Parser.prototype.parseString = function(self) 
  local start = self.pos;
  local buf = nil;
  while (true) do 
    local index = (function() 
    local _hx_obj = self;
    local _hx_fld = 'pos';
    local _ = _hx_obj[_hx_fld];
    _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
     return _;
     end)();
    local c = _G.string.byte(self.source, index + 1);
    if (c == 34) then 
      break;
    end;
    if (c == 92) then 
      if (buf == nil) then 
        buf = StringBuf.new();
      end;
      local s = self.source;
      local len = (self.pos - start) - 1;
      local part;
      if (len == nil) then 
        local pos = start;
        local len = nil;
        len = #s;
        if (pos < 0) then 
          pos = #s + pos;
        end;
        if (pos < 0) then 
          pos = 0;
        end;
        part = _G.string.sub(s, pos + 1, pos + len);
      else
        local pos = start;
        local len1 = len;
        if ((len == nil) or (len > (pos + #s))) then 
          len1 = #s;
        else
          if (len < 0) then 
            len1 = #s + len;
          end;
        end;
        if (pos < 0) then 
          pos = #s + pos;
        end;
        if (pos < 0) then 
          pos = 0;
        end;
        part = _G.string.sub(s, pos + 1, pos + len1);
      end;
      _G.table.insert(buf.b, part);
      local buf1 = buf;
      buf1.length = buf1.length + #part;
      local index = (function() 
      local _hx_obj = self;
      local _hx_fld = 'pos';
      local _ = _hx_obj[_hx_fld];
      _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
       return _;
       end)();
      c = _G.string.byte(self.source, index + 1);
      local c1 = c;
      if (c1) == 34 or (c1) == 47 or (c1) == 92 then 
        _G.table.insert(buf.b, _G.string.char(c));
        local buf = buf;
        buf.length = buf.length + 1;
      elseif (c1) == 98 then 
        _G.table.insert(buf.b, _G.string.char(8));
        local buf = buf;
        buf.length = buf.length + 1;
      elseif (c1) == 102 then 
        _G.table.insert(buf.b, _G.string.char(12));
        local buf = buf;
        buf.length = buf.length + 1;
      elseif (c1) == 110 then 
        _G.table.insert(buf.b, _G.string.char(10));
        local buf = buf;
        buf.length = buf.length + 1;
      elseif (c1) == 114 then 
        _G.table.insert(buf.b, _G.string.char(13));
        local buf = buf;
        buf.length = buf.length + 1;
      elseif (c1) == 116 then 
        _G.table.insert(buf.b, _G.string.char(9));
        local buf = buf;
        buf.length = buf.length + 1;
      elseif (c1) == 117 then 
        local _this = self.source;
        local pos = self.pos;
        local len = 4;
        if (4 > (pos + #_this)) then 
          len = #_this;
        end;
        if (pos < 0) then 
          pos = #_this + pos;
        end;
        if (pos < 0) then 
          pos = 0;
        end;
        local uc = Std.parseInt(Std.string("0x") .. Std.string(_G.string.sub(_this, pos + 1, pos + len)));
        self.pos = self.pos + 4;
        _G.table.insert(buf.b, _G.string.char(uc));
        local buf = buf;
        buf.length = buf.length + 1;else
      _G.error(__haxe_Exception.thrown(__hxjsonast_Error.new(Std.string("Invalid escape sequence \\") .. Std.string(_G.string.char(c)), __hxjsonast_Position.new(self.filename, self.pos - 2, self.pos))),0); end;
      start = self.pos;
    else
      if (c == nil) then 
        self.pos = self.pos - 1;
        _G.error(__haxe_Exception.thrown(__hxjsonast_Error.new("Unclosed string", __hxjsonast_Position.new(self.filename, start - 1, self.pos))),0);
      end;
    end;
  end;
  if (buf == nil) then 
    local _this = self.source;
    local pos = start;
    local len = (self.pos - start) - 1;
    if ((len == nil) or (len > (pos + #_this))) then 
      len = #_this;
    else
      if (len < 0) then 
        len = #_this + len;
      end;
    end;
    if (pos < 0) then 
      pos = #_this + pos;
    end;
    if (pos < 0) then 
      pos = 0;
    end;
    do return _G.string.sub(_this, pos + 1, pos + len) end;
  else
    local s = self.source;
    local len = (self.pos - start) - 1;
    local part;
    if (len == nil) then 
      local pos = start;
      local len = nil;
      len = #s;
      if (pos < 0) then 
        pos = #s + pos;
      end;
      if (pos < 0) then 
        pos = 0;
      end;
      part = _G.string.sub(s, pos + 1, pos + len);
    else
      local pos = start;
      local len1 = len;
      if ((len == nil) or (len > (pos + #s))) then 
        len1 = #s;
      else
        if (len < 0) then 
          len1 = #s + len;
        end;
      end;
      if (pos < 0) then 
        pos = #s + pos;
      end;
      if (pos < 0) then 
        pos = 0;
      end;
      part = _G.string.sub(s, pos + 1, pos + len1);
    end;
    _G.table.insert(buf.b, part);
    local buf1 = buf;
    buf1.length = buf1.length + #part;
    do return _G.table.concat(buf.b) end;
  end;
end
__hxjsonast_Parser.prototype.invalidChar = function(self) 
  self.pos = self.pos - 1;
  local index = self.pos;
  _G.error(__haxe_Exception.thrown(__hxjsonast_Error.new(Std.string("Invalid character: ") .. Std.string(_G.string.sub(self.source, index + 1, index + 1)), __hxjsonast_Position.new(self.filename, self.pos, self.pos + 1))),0);
end
__hxjsonast_Parser.prototype.invalidNumber = function(self,start) 
  local _this = self.source;
  local startIndex = start;
  local endIndex = self.pos;
  if (endIndex == nil) then 
    endIndex = #_this;
  end;
  if (endIndex < 0) then 
    endIndex = 0;
  end;
  if (start < 0) then 
    startIndex = 0;
  end;
  _G.error(__haxe_Exception.thrown(__hxjsonast_Error.new(Std.string("Invalid number: ") .. Std.string(((function() 
    local _hx_1
    if (endIndex < startIndex) then 
    _hx_1 = _G.string.sub(_this, endIndex + 1, startIndex); else 
    _hx_1 = _G.string.sub(_this, startIndex + 1, endIndex); end
    return _hx_1
  end )())), __hxjsonast_Position.new(self.filename, start, self.pos))),0);
end

__hxjsonast_Parser.prototype.__class__ =  __hxjsonast_Parser

__hxjsonast_Position.new = function(file,min,max) 
  local self = _hx_new(__hxjsonast_Position.prototype)
  __hxjsonast_Position.super(self,file,min,max)
  return self
end
__hxjsonast_Position.super = function(self,file,min,max) 
  self.file = file;
  self.min = min;
  self.max = max;
end
__hxjsonast_Position.__name__ = true
__hxjsonast_Position.prototype = _hx_e();

__hxjsonast_Position.prototype.__class__ =  __hxjsonast_Position
_hxClasses["json2object.Error"] = { __ename__ = true, __constructs__ = _hx_tab_array({[0]="IncorrectType","IncorrectEnumValue","InvalidEnumConstructor","UninitializedVariable","UnknownVariable","ParserError","CustomFunctionException"},7)}
__json2object_Error = _hxClasses["json2object.Error"];
__json2object_Error.IncorrectType = function(variable,expected,pos) local _x = _hx_tab_array({[0]="IncorrectType",0,variable,expected,pos,__enum__=__json2object_Error}, 5); return _x; end 
__json2object_Error.IncorrectEnumValue = function(value,expected,pos) local _x = _hx_tab_array({[0]="IncorrectEnumValue",1,value,expected,pos,__enum__=__json2object_Error}, 5); return _x; end 
__json2object_Error.InvalidEnumConstructor = function(value,expected,pos) local _x = _hx_tab_array({[0]="InvalidEnumConstructor",2,value,expected,pos,__enum__=__json2object_Error}, 5); return _x; end 
__json2object_Error.UninitializedVariable = function(variable,pos) local _x = _hx_tab_array({[0]="UninitializedVariable",3,variable,pos,__enum__=__json2object_Error}, 4); return _x; end 
__json2object_Error.UnknownVariable = function(variable,pos) local _x = _hx_tab_array({[0]="UnknownVariable",4,variable,pos,__enum__=__json2object_Error}, 4); return _x; end 
__json2object_Error.ParserError = function(message,pos) local _x = _hx_tab_array({[0]="ParserError",5,message,pos,__enum__=__json2object_Error}, 4); return _x; end 
__json2object_Error.CustomFunctionException = function(e,pos) local _x = _hx_tab_array({[0]="CustomFunctionException",6,e,pos,__enum__=__json2object_Error}, 4); return _x; end 
_hxClasses["json2object.InternalError"] = { __ename__ = true, __constructs__ = _hx_tab_array({[0]="AbstractNoJsonRepresentation","CannotGenerateSchema","HandleExpr","ParsingThrow","UnsupportedAbstractEnumType","UnsupportedEnumAbstractValue","UnsupportedMapKeyType","UnsupportedSchemaObjectType","UnsupportedSchemaType"},9)}
__json2object_InternalError = _hxClasses["json2object.InternalError"];
__json2object_InternalError.AbstractNoJsonRepresentation = function(name) local _x = _hx_tab_array({[0]="AbstractNoJsonRepresentation",0,name,__enum__=__json2object_InternalError}, 3); return _x; end 
__json2object_InternalError.CannotGenerateSchema = function(name) local _x = _hx_tab_array({[0]="CannotGenerateSchema",1,name,__enum__=__json2object_InternalError}, 3); return _x; end 
__json2object_InternalError.HandleExpr = _hx_tab_array({[0]="HandleExpr",2,__enum__ = __json2object_InternalError},2)

__json2object_InternalError.ParsingThrow = _hx_tab_array({[0]="ParsingThrow",3,__enum__ = __json2object_InternalError},2)

__json2object_InternalError.UnsupportedAbstractEnumType = function(name) local _x = _hx_tab_array({[0]="UnsupportedAbstractEnumType",4,name,__enum__=__json2object_InternalError}, 3); return _x; end 
__json2object_InternalError.UnsupportedEnumAbstractValue = function(name) local _x = _hx_tab_array({[0]="UnsupportedEnumAbstractValue",5,name,__enum__=__json2object_InternalError}, 3); return _x; end 
__json2object_InternalError.UnsupportedMapKeyType = function(name) local _x = _hx_tab_array({[0]="UnsupportedMapKeyType",6,name,__enum__=__json2object_InternalError}, 3); return _x; end 
__json2object_InternalError.UnsupportedSchemaObjectType = function(name) local _x = _hx_tab_array({[0]="UnsupportedSchemaObjectType",7,name,__enum__=__json2object_InternalError}, 3); return _x; end 
__json2object_InternalError.UnsupportedSchemaType = function(type) local _x = _hx_tab_array({[0]="UnsupportedSchemaType",8,type,__enum__=__json2object_InternalError}, 3); return _x; end 

__json2object_PositionUtils.new = function(content) 
  local self = _hx_new(__json2object_PositionUtils.prototype)
  __json2object_PositionUtils.super(self,content)
  return self
end
__json2object_PositionUtils.super = function(self,content) 
  self.linesInfo = Array.new();
  local s = 0;
  local e = 0;
  local i = 0;
  local lineCount = 0;
  while (i < #content) do 
    local _g = _G.string.sub(content, i + 1, i + 1);
    if (_g) == "\n" then 
      e = i;
      self.linesInfo:push(_hx_o({__fields__={number=true,start=true,['end']=true},number=lineCount,start=s,['end']=e}));
      lineCount = lineCount + 1;
      i = i + 1;
      s = i;
    elseif (_g) == "\r" then 
      e = i;
      local index = i + 1;
      if (_G.string.sub(content, index + 1, index + 1) == "\n") then 
        e = e + 1;
      end;
      self.linesInfo:push(_hx_o({__fields__={number=true,start=true,['end']=true},number=lineCount,start=s,['end']=e}));
      lineCount = lineCount + 1;
      i = e + 1;
      s = i;else
    i = i + 1; end;
  end;
  self.linesInfo:push(_hx_o({__fields__={number=true,start=true,['end']=true},number=lineCount,start=s,['end']=i}));
end
__json2object_PositionUtils.__name__ = true
__json2object_PositionUtils.prototype = _hx_e();
__json2object_PositionUtils.prototype.convertPosition = function(self,position) 
  local min = position.min;
  local max = position.max;
  local pos = _hx_o({__fields__={file=true,min=true,max=true,lines=true},file=position.file,min=min + 1,max=max + 1,lines=_hx_tab_array({}, 0)});
  local bounds_min = 0;
  local bounds_max = self.linesInfo.length - 1;
  if (min > self.linesInfo[0]["end"]) then 
    while (bounds_max > bounds_min) do 
      local i = Std.int((bounds_min + bounds_max) / 2);
      local line = self.linesInfo[i];
      if (line.start == min) then 
        bounds_min = i;
        bounds_max = i;
      end;
      if (line["end"] < min) then 
        bounds_min = i + 1;
      end;
      if ((line.start > min) or ((line["end"] >= min) and (line.start < min))) then 
        bounds_max = i;
      end;
    end;
  end;
  local _g = bounds_min;
  local _g1 = self.linesInfo.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local line = self.linesInfo[_g - 1];
    if ((line.start <= min) and (line["end"] >= max)) then 
      pos.lines:push(_hx_o({__fields__={number=true,start=true,['end']=true},number=line.number + 1,start=(min - line.start) + 1,['end']=(max - line.start) + 1}));
      break;
    end;
    if ((line.start <= min) and (min <= line["end"])) then 
      pos.lines:push(_hx_o({__fields__={number=true,start=true,['end']=true},number=line.number + 1,start=(min - line.start) + 1,['end']=line["end"] + 1}));
    end;
    if ((line.start <= max) and (max <= line["end"])) then 
      pos.lines:push(_hx_o({__fields__={number=true,start=true,['end']=true},number=line.number + 1,start=line.start + 1,['end']=(max - line.start) + 1}));
    end;
    if ((line.start >= max) or (line["end"] >= max)) then 
      break;
    end;
  end;
  do return pos end
end

__json2object_PositionUtils.prototype.__class__ =  __json2object_PositionUtils

__lua_Boot.new = {}
__lua_Boot.__name__ = true
__lua_Boot.__instanceof = function(o,cl) 
  if (cl == nil) then 
    do return false end;
  end;
  local cl1 = cl;
  if (cl1) == Array then 
    do return __lua_Boot.isArray(o) end;
  elseif (cl1) == Bool then 
    do return _G.type(o) == "boolean" end;
  elseif (cl1) == Dynamic then 
    do return o ~= nil end;
  elseif (cl1) == Float then 
    do return _G.type(o) == "number" end;
  elseif (cl1) == Int then 
    if (_G.type(o) == "number") then 
      do return _hx_bit_clamp(o) == o end;
    else
      do return false end;
    end;
  elseif (cl1) == String then 
    do return _G.type(o) == "string" end;
  elseif (cl1) == _G.table then 
    do return _G.type(o) == "table" end;
  elseif (cl1) == __lua_Thread then 
    do return _G.type(o) == "thread" end;
  elseif (cl1) == __lua_UserData then 
    do return _G.type(o) == "userdata" end;else
  if (((o ~= nil) and (_G.type(o) == "table")) and (_G.type(cl) == "table")) then 
    local tmp;
    if (__lua_Boot.__instanceof(o, Array)) then 
      tmp = Array;
    else
      if (__lua_Boot.__instanceof(o, String)) then 
        tmp = String;
      else
        local cl = o.__class__;
        tmp = (function() 
          local _hx_1
          if (cl ~= nil) then 
          _hx_1 = cl; else 
          _hx_1 = nil; end
          return _hx_1
        end )();
      end;
    end;
    if (__lua_Boot.extendsOrImplements(tmp, cl)) then 
      do return true end;
    end;
    if ((function() 
      local _hx_2
      if (cl == Class) then 
      _hx_2 = o.__name__ ~= nil; else 
      _hx_2 = false; end
      return _hx_2
    end )()) then 
      do return true end;
    end;
    if ((function() 
      local _hx_3
      if (cl == Enum) then 
      _hx_3 = o.__ename__ ~= nil; else 
      _hx_3 = false; end
      return _hx_3
    end )()) then 
      do return true end;
    end;
    do return o.__enum__ == cl end;
  else
    do return false end;
  end; end;
end
__lua_Boot.isArray = function(o) 
  if (_G.type(o) == "table") then 
    if ((o.__enum__ == nil) and (_G.getmetatable(o) ~= nil)) then 
      do return _G.getmetatable(o).__index == Array.prototype end;
    else
      do return false end;
    end;
  else
    do return false end;
  end;
end
__lua_Boot.extendsOrImplements = function(cl1,cl2) 
  while (true) do 
    if ((cl1 == nil) or (cl2 == nil)) then 
      do return false end;
    else
      if (cl1 == cl2) then 
        do return true end;
      else
        if (cl1.__interfaces__ ~= nil) then 
          local intf = cl1.__interfaces__;
          local _g = 1;
          local _g1 = _hx_table.maxn(intf) + 1;
          while (_g < _g1) do 
            _g = _g + 1;
            local i = _g - 1;
            if (__lua_Boot.extendsOrImplements(intf[i], cl2)) then 
              do return true end;
            end;
          end;
        end;
      end;
    end;
    cl1 = cl1.__super__;
  end;
end

__lua_UserData.new = {}
__lua_UserData.__name__ = true

__lua_StringMap.new = function() 
  local self = _hx_new(__lua_StringMap.prototype)
  __lua_StringMap.super(self)
  return self
end
__lua_StringMap.super = function(self) 
  self.h = ({});
end
__lua_StringMap.__name__ = true
__lua_StringMap.__interfaces__ = {__haxe_IMap}
__lua_StringMap.prototype = _hx_e();
__lua_StringMap.prototype.set = function(self,key,value) 
  if (value == nil) then 
    self.h[key] = __lua_StringMap.tnull;
  else
    self.h[key] = value;
  end;
end
__lua_StringMap.prototype.get = function(self,key) 
  local ret = self.h[key];
  if (ret == __lua_StringMap.tnull) then 
    do return nil end;
  end;
  do return ret end
end
__lua_StringMap.prototype.keys = function(self) 
  local _gthis = self;
  local next = _G.next;
  local cur = next(self.h, nil);
  do return _hx_o({__fields__={next=true,hasNext=true},next=function(self) 
    local ret = cur;
    cur = next(_gthis.h, cur);
    do return ret end;
  end,hasNext=function(self) 
    do return cur ~= nil end;
  end}) end
end
__lua_StringMap.prototype.iterator = function(self) 
  local _gthis = self;
  local it = self:keys();
  do return _hx_o({__fields__={hasNext=true,next=true},hasNext=function(self) 
    do return it:hasNext() end;
  end,next=function(self) 
    do return _gthis.h[it:next()] end;
  end}) end
end

__lua_StringMap.prototype.__class__ =  __lua_StringMap

__lua_Thread.new = {}
__lua_Thread.__name__ = true

__streamDeckButton_Utils.new = {}
__streamDeckButton_Utils.__name__ = true
__streamDeckButton_Utils.loadImageAsBase64 = function(imagePath) 
  local image = hs.image.imageFromPath(imagePath);
  if (image ~= nil) then 
    do return image:encodeAsURLString() end;
  end;
  do return nil end;
end

__streamDeckButton__Messages_Messages_Fields_.new = {}
__streamDeckButton__Messages_Messages_Fields_.__name__ = true
__streamDeckButton__Messages_Messages_Fields_.parseMessage = function(message) 
  local parsed = hs.json.decode(message);
  if (parsed == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Invalid JSON: ") .. Std.string(message)) end;
  end;
  if (parsed.event == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing event: ") .. Std.string(message)) end;
  end;
  if (parsed.context == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing context: ") .. Std.string(message)) end;
  end;
  if (parsed.payload == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing payload: ") .. Std.string(message)) end;
  end;
  if (parsed.payload.coordinates == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing coordinates: ") .. Std.string(message)) end;
  end;
  if (parsed.payload.coordinates.column == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing column: ") .. Std.string(message)) end;
  end;
  if (parsed.payload.coordinates.row == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing row: ") .. Std.string(message)) end;
  end;
  if (parsed.payload.isInMultiAction == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing isInMultiAction: ") .. Std.string(message)) end;
  end;
  if (parsed.payload.settings == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing settings: ") .. Std.string(message)) end;
  end;
  if (parsed.payload.settings.id == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing id: ") .. Std.string(message)) end;
  end;
  if (parsed.payload.settings.remoteServer == nil) then 
    do return __haxe_ds_Either.Left(Std.string("Missing remoteServer: ") .. Std.string(message)) end;
  end;
  do return __haxe_ds_Either.Right(_hx_o({__fields__={event=true,context=true,payload=true},event=parsed.event,context=parsed.context,payload=_hx_o({__fields__={coordinates=true,isInMultiAction=true,settings=true},coordinates=_hx_o({__fields__={column=true,row=true},column=parsed.payload.coordinates.column,row=parsed.payload.coordinates.row}),isInMultiAction=parsed.payload.isInMultiAction,settings=_hx_o({__fields__={id=true,remoteServer=true},id=parsed.payload.settings.id,remoteServer=parsed.payload.settings.remoteServer})})})) end;
end
__streamDeckButton__Messages_Messages_Fields_.getTitleMessage = function(context,title) 
  do return ({event = "setTitle", context = context, payload = ({title = title, target = 0})}) end;
end
__streamDeckButton__Messages_Messages_Fields_.getImageMessage = function(context,imagePath) 
  local imageBase64 = __streamDeckButton_Utils.loadImageAsBase64(imagePath);
  if (imageBase64 ~= nil) then 
    do return ({event = "setImage", context = context, payload = ({image = imageBase64, target = 0, state = 0})}) end;
  else
    hs.alert.show(Std.string("Image not loaded: ") .. Std.string(imagePath));
    do return nil end;
  end;
end

__streamDeckButton_State.new = function(data) 
  local self = _hx_new(__streamDeckButton_State.prototype)
  __streamDeckButton_State.super(self,data)
  return self
end
__streamDeckButton_State.super = function(self,data) 
  self.data = data;
end
__streamDeckButton_State.__name__ = true
__streamDeckButton_State.getInstance = function() 
  if (__streamDeckButton_State.inst == nil) then 
    do return __streamDeckButton_State.init() end;
  end;
  do return __streamDeckButton_State.inst end;
end
__streamDeckButton_State.init = function() 
  if (__streamDeckButton_State.inst ~= nil) then 
    do return __streamDeckButton_State.inst end;
  end;
  local rawData = hs.settings.get(__streamDeckButton_State.namespace);
  __streamDeckButton_State.inst = __streamDeckButton_State.new((function() 
    local _hx_1
    if (rawData == nil) then 
    _hx_1 = __lua_StringMap.new(); else 
    _hx_1 = __streamDeckButton_State.jsonReader:fromJson(rawData, "settings"); end
    return _hx_1
  end )());
  do return __streamDeckButton_State.inst end;
end
__streamDeckButton_State.prototype = _hx_e();
__streamDeckButton_State.prototype.store = function(self) 
  hs.settings.set(__streamDeckButton_State.namespace, __streamDeckButton_State.jsonWritter:write(self.data));
  __haxe_Log.trace("Saved it", _hx_o({__fields__={fileName=true,lineNumber=true,className=true,methodName=true},fileName="src/streamDeckButton/State.hx",lineNumber=46,className="streamDeckButton.State",methodName="store"}));
end
__streamDeckButton_State.prototype.get = function(self,id) 
  do return self.data:get(id) end
end
__streamDeckButton_State.prototype.exists = function(self,id) 
  do return self.data.h[id] ~= nil end
end
__streamDeckButton_State.prototype.addContext = function(self,id,context) 
  local check = self.data:get(id);
  local existingContexts;
  if (check == nil) then 
    local newContext = __lua_StringMap.new();
    self.data:set(id, newContext);
    existingContexts = newContext;
  else
    existingContexts = check;
  end;
  existingContexts:set("context", context);
  self:store();
end

__streamDeckButton_State.prototype.__class__ =  __streamDeckButton_State

__streamDeckButton__StreamDeckButton_StoredSettings_Impl_.new = {}
__streamDeckButton__StreamDeckButton_StoredSettings_Impl_.__name__ = true
__streamDeckButton__StreamDeckButton_StoredSettings_Impl_.get = function(this1,key) 
  local _hx_continue_1 = false;
  while (true) do repeat 
    local value = Reflect.field(this1, key);
    if (value == nil) then 
      this1[key] = ({});
      break;
    end;
    do return value end;until true
    if _hx_continue_1 then 
    _hx_continue_1 = false;
    break;
    end;
    
  end;
end

obj.new = function() 
  local self = _hx_new(obj.prototype)
  obj.super(self)
  return self
end
obj.super = function(self) 
  self.willAppearSubscribers = _hx_e();
  self.keyDownSubscribers = _hx_e();
  self.contexts = nil;
  self.logger = hs.logger.new("StreamDeckButton", "debug");
  self.homepage = "https://github.com/danielo515/StreamDeckButton.spoon";
  self.license = "MIT - https://opensource.org/licenses/MIT";
  self.author = "Danielo Rodríguez <rdanielo@gmail.com>";
  self.version = "3.0.0";
  self.settingsPath = "streamDeckButton";
  self.name = "StreamDeckButton";
end
_hx_exports["StreamDeckButton"] = obj
obj.__name__ = true
obj.init = function() 
end
obj.prototype = _hx_e();
obj.prototype.getSettings = function(self) 
  local readSettings = hs.settings.get(self.name);
  do return (function() 
    local _hx_1
    if (readSettings ~= nil) then 
    _hx_1 = readSettings; else 
    _hx_1 = ({}); end
    return _hx_1
  end )() end
end
obj.prototype.storeInSettings = function(self,id,context) 
  local settings = self:getSettings();
  local value = Reflect.field(settings, id);
  local this1;
  if (value == nil) then 
    settings[id] = ({});
    local this2 = settings;
    local value = Reflect.field(this2, id);
    if (value == nil) then 
      this2[id] = ({});
      this1 = __streamDeckButton__StreamDeckButton_StoredSettings_Impl_.get(this2, id);
    else
      this1 = value;
    end;
  else
    this1 = value;
  end;
  this1[context] = context;
  hs.settings.set(self.name, settings);
  self.logger.df("Settings: %s", Std.string(settings));
end
obj.prototype.onKeyDown = function(self,id,callback) 
  if ((id == nil) or (callback == nil)) then 
    do return end;
  end;
  if (Reflect.field(self.keyDownSubscribers, id) == nil) then 
    self.keyDownSubscribers[id] = _hx_tab_array({}, 0);
  end;
  Reflect.field(self.keyDownSubscribers, id):push(callback);
end
obj.prototype.onWillAppear = function(self,id,callback) 
  if ((id == nil) or (callback == nil)) then 
    do return end;
  end;
  if (Reflect.field(self.willAppearSubscribers, id) == nil) then 
    self.willAppearSubscribers[id] = _hx_tab_array({}, 0);
  end;
  Reflect.field(self.willAppearSubscribers, id):push(callback);
end
obj.prototype.msgHandler = function(self,message) 
  self.logger.d("Received message");
  local params = __streamDeckButton__Messages_Messages_Fields_.parseMessage(message);
  __haxe_Log.trace(params, _hx_o({__fields__={fileName=true,lineNumber=true,className=true,methodName=true},fileName="src/streamDeckButton/StreamDeckButton.hx",lineNumber=98,className="streamDeckButton.StreamDeckButton",methodName="msgHandler"}));
  local tmp = params[1];
  if (tmp) == 0 then 
    self.logger.e("Error parsing message: %s", params[2]);
    do return "" end;
  elseif (tmp) == 1 then 
    local _g = params[2];
    local _g1 = _g.context;
    local _g = _g.payload.settings;
    if (self.contexts == nil) then 
      self.logger.e("Contexts is null");
      do return "" end;
    end;
    local value = self.contexts;
    if (value ~= nil) then 
      if (not value:exists(_g.id)) then 
        self:setTitle(_g1, "Initializing");
        self.logger.f("new id found: %s with this context: %s", _g.id, _g1);
      end;
      value:addContext(_g.id, _g1);
    end; end;
  do return "" end
end
obj.prototype.setTitle = function(self,context,title) 
  local _v_ = self.server;
  if (_v_ ~= nil) then 
    _v_:send(hs.json.encode(__streamDeckButton__Messages_Messages_Fields_.getTitleMessage(context, title)));
  end;
end
obj.prototype.setImage = function(self,id,imagePath) 
  local _gthis = self;
  local tmp;
  if (id ~= nil) then 
    local _v_ = self.contexts;
    local value = (function() 
      local _hx_1
      if (_v_ == nil) then 
      _hx_1 = nil; else 
      _hx_1 = _v_:exists(id); end
      return _hx_1
    end )();
    tmp = not ((function() 
      local _hx_2
      if (value == nil) then 
      _hx_2 = false; else 
      _hx_2 = value; end
      return _hx_2
    end )());
  else
    tmp = true;
  end;
  if (tmp) then 
    self.logger.ef("setImage: id is null or contexts[id] is null", id);
    do return end;
  end;
  local value = self.contexts;
  if (value ~= nil) then 
    (function(ctx) 
      local ctxs = ctx:get(id);
      if (ctxs == nil) then 
        _gthis.logger.ef("setImage for %s leads to no context", id);
        do return end;
      end;
      local context = ctxs:iterator();
      while (context:hasNext()) do 
        local message = __streamDeckButton__Messages_Messages_Fields_.getImageMessage(context:next(), imagePath);
        if (message == nil) then 
          _gthis.logger.ef("Error generating image message for %s", imagePath);
          do return end;
        end;
        local _v_ = _gthis.server;
        if (_v_ ~= nil) then 
          _v_:send(hs.json.encode(message));
        end;
      end;
    end)(value);
  end;
end
obj.prototype.start = function(self,port) 
  self.contexts = __streamDeckButton_State.getInstance();
  self.server = hs.httpserver.new(false, true);
  local value = self.server;
  if (value ~= nil) then 
    value:setPort(port);
    value:setName(self.name);
    value:setCallback(function() 
      do return "" end;
    end);
    value:websocket("/ws", _hx_bind(self,self.msgHandler));
    value:start();
    self.logger.f("Server started %s", value);
  end;
end

obj.prototype.__class__ =  obj
if _hx_bit_raw then
    _hx_bit_clamp = function(v)
    if v <= 2147483647 and v >= -2147483648 then
        if v > 0 then return _G.math.floor(v)
        else return _G.math.ceil(v)
        end
    end
    if v > 2251798999999999 then v = v*2 end;
    if (v ~= v or math.abs(v) == _G.math.huge) then return nil end
    return _hx_bit_raw.band(v, 2147483647 ) - math.abs(_hx_bit_raw.band(v, 2147483648))
    end
else
    _hx_bit_clamp = function(v)
        if v < -2147483648 then
            return -2147483648
        elseif v > 2147483647 then
            return 2147483647
        elseif v > 0 then
            return _G.math.floor(v)
        else
            return _G.math.ceil(v)
        end
    end
end;



_hx_array_mt.__index = Array.prototype

local _hx_static_init = function()
  
  String.__name__ = true;
  Array.__name__ = true;__haxe_ds_StringMap.tnull = ({});
  
  __lua_StringMap.tnull = ({});
  
  __streamDeckButton_State.namespace = "StreamDeckButton-hx";
  
  __streamDeckButton_State.jsonWritter = JsonWriter_1.new();
  
  __streamDeckButton_State.jsonReader = JsonParser_1.new();
  
  
end

_hx_bind = function(o,m)
  if m == nil then return nil end;
  local f;
  if o._hx__closures == nil then
    _G.rawset(o, '_hx__closures', {});
  else
    f = o._hx__closures[m];
  end
  if (f == nil) then
    f = function(...) return m(o, ...) end;
    o._hx__closures[m] = f;
  end
  return f;
end

_hx_print = print or (function() end)

_hx_table = {}
_hx_table.pack = _G.table.pack or function(...)
    return {...}
end
_hx_table.unpack = _G.table.unpack or _G.unpack
_hx_table.maxn = _G.table.maxn or function(t)
  local maxn=0;
  for i in pairs(t) do
    maxn=type(i)=='number'and i>maxn and i or maxn
  end
  return maxn
end;

_hx_wrap_if_string_field = function(o, fld)
  if _G.type(o) == 'string' then
    if fld == 'length' then
      return _G.string.len(o)
    else
      return String.prototype[fld]
    end
  else
    return o[fld]
  end
end

_hx_static_init();
return _hx_exports
