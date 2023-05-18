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
local Math = _hx_e()
local Reflect = _hx_e()
local String = _hx_e()
local Std = _hx_e()
__haxe_Log = _hx_e()
__haxe_ds_Either = _hx_e()
__haxe_iterators_ArrayIterator = _hx_e()
__haxe_iterators_ArrayKeyValueIterator = _hx_e()
__streamDeckButton_TableIterator = _hx_e()
__streamDeckButton__Data_Dict_Impl_ = _hx_e()
__streamDeckButton__Data_StoredSettings_Impl_ = _hx_e()
__streamDeckButton_Utils = _hx_e()
__streamDeckButton__Messages_Messages_Fields_ = _hx_e()
__streamDeckButton_State = _hx_e()
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

Math.new = {}
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

Std.new = {}
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

__haxe_Log.new = {}
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

__haxe_ds_Either.Left = function(v) local _x = _hx_tab_array({[0]="Left",0,v,__enum__=__haxe_ds_Either}, 3); return _x; end 
__haxe_ds_Either.Right = function(v) local _x = _hx_tab_array({[0]="Right",1,v,__enum__=__haxe_ds_Either}, 3); return _x; end 

__haxe_iterators_ArrayIterator.new = function(array) 
  local self = _hx_new(__haxe_iterators_ArrayIterator.prototype)
  __haxe_iterators_ArrayIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayIterator.super = function(self,array) 
  self.current = 0;
  self.array = array;
end
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

__haxe_iterators_ArrayKeyValueIterator.new = function(array) 
  local self = _hx_new()
  __haxe_iterators_ArrayKeyValueIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayKeyValueIterator.super = function(self,array) 
  self.array = array;
end

__streamDeckButton_TableIterator.new = {}
__streamDeckButton_TableIterator.keys = function(obj) 
  local next = _G.next;
  local cur = next(obj, nil);
  do return _hx_o({__fields__={next=true,hasNext=true},next=function(self) 
    local ret = cur;
    cur = next(obj, cur);
    do return ret end;
  end,hasNext=function(self) 
    do return cur ~= nil end;
  end}) end;
end
__streamDeckButton_TableIterator.iterator = function(obj) 
  local it = __streamDeckButton_TableIterator.keys(obj);
  do return _hx_o({__fields__={hasNext=true,next=true},hasNext=function(self) 
    do return it:hasNext() end;
  end,next=function(self) 
    do return h[it:next()] end;
  end}) end;
end

__streamDeckButton__Data_Dict_Impl_.new = {}
__streamDeckButton__Data_Dict_Impl_.iterator = function(this1) 
  do return __streamDeckButton_TableIterator.iterator(this1) end;
end

__streamDeckButton__Data_StoredSettings_Impl_.new = {}
__streamDeckButton__Data_StoredSettings_Impl_.get = function(this1,key) 
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

__streamDeckButton_Utils.new = {}
__streamDeckButton_Utils.loadImageAsBase64 = function(imagePath) 
  local image = hs.image.imageFromPath(imagePath);
  if (image ~= nil) then 
    do return image:encodeAsURLString() end;
  end;
  do return nil end;
end

__streamDeckButton__Messages_Messages_Fields_.new = {}
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
    _hx_1 = ({}); else 
    _hx_1 = rawData; end
    return _hx_1
  end )());
  do return __streamDeckButton_State.inst end;
end
__streamDeckButton_State.prototype = _hx_e();
__streamDeckButton_State.prototype.store = function(self) 
  local jsonData = hs.json.encode(self.data);
  hs.settings.set(__streamDeckButton_State.namespace, jsonData);
  __haxe_Log.trace("Saved it:", _hx_o({__fields__={fileName=true,lineNumber=true,className=true,methodName=true,customParams=true},fileName="src/streamDeckButton/State.hx",lineNumber=45,className="streamDeckButton.State",methodName="store",customParams=_hx_tab_array({[0]=jsonData}, 1)}));
end
__streamDeckButton_State.prototype.get = function(self,id) 
  local this1 = self.data;
  local value = Reflect.field(this1, id);
  if (value == nil) then 
    this1[id] = ({});
    do return __streamDeckButton__Data_StoredSettings_Impl_.get(this1, id) end;
  else
    do return value end;
  end;
end
__streamDeckButton_State.prototype.exists = function(self,id) 
  do return Reflect.field(self.data, id) ~= nil end
end
__streamDeckButton_State.prototype.addContext = function(self,id,context) 
  local this1 = self.data;
  local value = Reflect.field(this1, id);
  local check;
  if (value == nil) then 
    this1[id] = ({});
    check = __streamDeckButton__Data_StoredSettings_Impl_.get(this1, id);
  else
    check = value;
  end;
  check[context] = context;
  self:store();
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
  self.name = "StreamDeckButton";
end
_hx_exports["StreamDeckButton"] = obj
obj.init = function() 
end
obj.prototype = _hx_e();
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
  __haxe_Log.trace(params, _hx_o({__fields__={fileName=true,lineNumber=true,className=true,methodName=true},fileName="src/streamDeckButton/StreamDeckButton.hx",lineNumber=47,className="streamDeckButton.StreamDeckButton",methodName="msgHandler"}));
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
      local context = __streamDeckButton__Data_Dict_Impl_.iterator(ctxs);
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
  __streamDeckButton_State.namespace = "StreamDeckButton-hx";
  
  
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
