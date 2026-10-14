-- K5-HUB IRONSOUL V3 loader
-- Jalankan manual melalui executor. Tidak memasang auto-execute saat player baru masuk.
local BASE = "https://raw.githubusercontent.com/frilshiaputri-cmd/All-code/main/V3/"

local function fetchModule(path)
    local ok, source = pcall(function()
        return game:HttpGet(BASE .. path)
    end)
    if not ok or type(source) ~= "string" or source == "" then
        error("[K5-HUB V3] Gagal mengambil " .. path .. ": " .. tostring(source))
    end
    local compile, result = pcall(function()
        return loadstring(source)
    end)
    if not compile or type(result) ~= "function" then
        error("[K5-HUB V3] Gagal menyiapkan " .. path .. ": " .. tostring(result))
    end
    return result
end

local ok, settings = pcall(function()
    return fetchModule("Config/Settings.lua")()
end)
if not ok or type(settings) ~= "table" then
    error("[K5-HUB V3] Pengaturan gagal dimuat: " .. tostring(settings))
end

getgenv().IronSoulConfig = settings
print("[K5-HUB V3] Config dimuat. Menjalankan AutoRedeem secara manual...")
fetchModule("Systems/AutoRedeem.lua")()
