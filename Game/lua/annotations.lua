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

---@param vKey integer
---@return boolean
function GameEngine:IsKeyDown(vKey) end

---@param color integer
function GameEngine:SetColor(color) end

---@param color integer
---@return boolean
function GameEngine:FillWindowRect(color) end

---@param text string
---@param x integer
---@param y integer
---@return integer
function GameEngine:DrawString(text, x, y) end

---@type GameEngine
Engine = Engine