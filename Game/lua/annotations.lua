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
function GameEngine:IsFullScreen() end

---@return string
function GameEngine:GetTitle() end

---@return integer
function GameEngine:GetWidth() end

---@return integer
function GameEngine:GetHeight() end

---@return integer
function GameEngine:GetFrameRate() end

---@return integer
function GameEngine:GetFrameDelay() end

---@param keyCode integer
---@return boolean
function GameEngine:IsKeyDown(keyCode) end

---@param text string
---@param fontPtr Font
---@return SIZE
function GameEngine:CalculateTextDimensions(text, fontPtr)

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
function GameEngine.DrawLine(x1, y1, x2, y2) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@return boolean
function GameEngine:DrawRect(l, t, r, b) end

---@overload fun(l:integer, t:integer, r:integer, b:integer)
---@overload fun(l:integer, t:integer, r:integer, b:integer, opacity:integer)
---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param opacity? integer
---@return boolean
function GameEngine:FillRect(l, t, r, b, opacity) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param radius integer
---@return boolean
function GameEngine:DrawRoundRect(l, t, r, b, radius) end

---@param l integer
---@param t integer
---@param r integer
---@param b integer
---@param radius integer
---@return boolean
function GameEngine:FillRoundRect(l, t, r, b, radius) end

---@param text string
---@param x integer
---@param y integer
---@return integer
function GameEngine:DrawString(text, x, y) end

---@return Point
function GameEngine:GetWindowPosition() end

---@type GameEngine
Engine = {}