---@meta
---@class GameEngine
local GameEngine = {}

---@param title string
function GameEngine:SetTitle(title) end

---@param w integer
function GameEngine:SetWidth(w) end

---@param h integer
function GameEngine:SetHeight(h) end

---@param fps integer
function GameEngine:SetFrameRate(fps) end

---@return boolean
GameEngine.IsFullScreen = function() end

---@return integer
GameEngine.GetWidth = function() end

---@return integer
GameEngine.GetHeight = function() end

---@return integer
GameEngine.GetFrameRate = function() end

---@return integer
GameEngine.GetFrameDelay = function() end

---@param keyCode integer
---@return boolean
function GameEngine:IsKeyDown(keyCode) end

---@param color integer
function GameEngine:SetColor(color) end

---@param color integer
---@return boolean
function GameEngine:FillWindowRect(color) end

---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@return boolean
GameEngine.DrawLine = function(x1, y1, x2, y2) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@return boolean
GameEngine.DrawRect = function(l, t, r, b) end

---@overload fun(l:integer, t:integer, r:integer, b:integer)
---@overload fun(l:integer, t:integer, r:integer, b:integer, opacity:integer)
---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param opacity? integer
---@return boolean
GameEngine.FillRect = function(l, t, r, b, opacity) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param radius integer
---@return boolean
GameEngine.DrawRoundRect = function(l, t, r, b, radius) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param radius integer
---@return boolean
GameEngine.FillRoundRect = function(l, t, r, b, radius) end

---@param text string
---@param x integer
---@param y integer
---@return integer
function GameEngine:DrawString(text, x, y) end

---@type GameEngine
Engine = Engine