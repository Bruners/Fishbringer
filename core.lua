FishbringerDB = {}
local media = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0", true)
local L = LibStub and LibStub:GetLibrary("AceLocale-3.0"):GetLocale("Fishbringer")
local media_fonts, media_fonts_text, font, db

-- zone madness
local zones = {
	[L["Dun Morogh"]] = -70, 
	[L["Durotar"]] = -70, 
	[L["Elwynn Forest"]] = -70, 
	[L["Mulgore"]] = -70,
	[L["Eversong Forest"]] = -70, 
	[L["Azuremyst Isle"]] = -70, 
	[L["Teldrassil"]]  = -70, 
	[L["Tirisfal Glades"]] = -70, 
	[L["Orgrimmar"]] = -20, 
	[L["Ironforge"]] = -20, 
	[L["Stormwind City"]] = -20, 
	[L["Thunder Bluff"]] = -20, 
	[L["Silvermoon City"]] = -20, 
	[L["The Exodar"]] = -20, 
	[L["Darnassus"]] = -20, 
	[L["Undercity"]] = -20, 
	[L["The Barrens"]] = -20, 
	[L["Blackfathom Deeps"]] = -20, 
	[L["Bloodmyst Isle"]] = -20, 
	[L["Darkshore"]] = -20, 
	[L["The Deadmines"]] = -20, 
	[L["Ghostlands"]] = -20, 
	[L["Loch Modan"]] = -20, 
	[L["Silverpine Forest"]] = -20, 
	[L["The Wailing Caverns"]] = -20, 
	[L["Westfall"]] = -20, 
	[L["Ashenvale"]] = 55, 
	[L["Duskwood"]] = 55, 
	[L["Hillsbrad Foothills"]] = 55, 
	[L["Redridge Mountains"]] = 55, 
	[L["Stonetalon Mountains"]] = 55, 
	[L["Wetlands"]] = 55, 
	[L["Alterac Mountains"]] = 130, 
	[L["Arathi Highlands"]] = 130, 
	[L["Desolace"]] = 130, 
	[L["Dustwallow Marsh"]] = 130, 
	[L["Scarlet Monastery"]] = 130, 
	[L["Stranglethorn Vale"]] = 130, 
	[L["Swamp of Sorrows"]] = 130, 
	[L["Thousand Needles"]] = 130, 
	[L["Azshara"]] = 205, 
	[L["Felwood"]] = 205,
	[L["Feralas"]] = 205, 
	[L["The Hinterlands"]] = 205, 
	[L["Maraudon"]] = 205, 
	[L["Moonglade"]] = 205,
	[L["Tanaris"]] = 205, 
	[L["The Temple of Atal'Hakkar"]] = 205, 
	[L["Un'Goro Crater"]] = 205, 
	[L["Western Plaguelands"]] = 205,
	[L["Hellfire Peninsula"]] = 280, 
	[L["Shadowmoon Valley"]] = 280,
	[L["Zangarmarsh"]] = 305, 
	[L["Burning Steppes"]] = 330, 
	[L["Deadwind Pass"]] = 330, 
	[L["Eastern Plaguelands"]] = 330, 
	[L["Scholomance"]] = 330, 
	[L["Silithus"]] = 330, 
	[L["Stratholme"]] = 330, 
	[L["Winterspring"]] = 330, 
	[L["Zul'Gurub"]] = 330, 
	[L["Terokkar Forest"]] = 355,
	[L["Nagrand"]] = 380, 
	[L["Netherstorm"]] = 380,
	[L["Borean Tundra"]] = 380, 
	[L["Dragonblight"]] = 380, 
	[L["Grizzly Hills"]] = 380,
	[L["Howling Fjord"]] = 380, 
	[L["Crystalsong Forest"]] = 405,
	[L["Dalaran"]] = 430, 
	[L["Sholazar Basin"]] = 430, 
	[L["The Frozen Sea"]] = 480,
}
local subzones = {
	[L["Jaguero Isle"]] = 205,
	[L["Forge Camp: Hate"]] = 280,
	[L["Bay of Storms"]] = 330, 
	[L["Hetaera's Clutch"]] = 330, 
	[L["Scalebeard's Cave"]] = 330, 
	[L["Jademir Lake"]] = 330, 
	[L["Marshlight Lake"]] = 355, 
	[L["Sporewind Lake"]] = 355,
	[L["Serpent Lake"]] = 355, 
	[L["Lake Sunspring"]] = 395,
	[L["Skysong Lake"]] = 395, 
	[L["Blackwind Lake"]] = 405,
	[L["Lake Ere'Noru"]] = 405, 
	[L["Lake Jorune"]] = 405,
	[L["Terrok's Rest"]] = 405, 
	[L["Skettis"]] = 405,
}

-- Database default values
local defaults = {
	fishingSkill = 0, 
	fishingBuff = 0,
	fishCaught = 0,
	fishToCatch = 0,
	font = "Friz Quadrata TT",
}
local fishingSkill, fishingBuff, fishCaught, fishToCatch = 0
local fb = CreateFrame("frame")
fb:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
fb:RegisterEvent("ADDON_LOADED")

function fb:Print(...) print(name ..":", ...) end
 
function fb:ADDON_LOADED(event, addon)

	if addon:lower() ~= "fishbringer" then return end
	
	local name = string.format("%s - %s", UnitName"player", GetRealmName())
	if not FishbringerDB[name] then
		FishbringerDB[name] = defaults
		db = FishbringerDB[name]
		fb:Print(L["Pack yer bags, we be leavin' fer fishin'! /fbr help for info"])
	else
		db = FishbringerDB[name]
		for k, v in pairs(defaults) do
			if not db[k] or type(db[k]) ~= type(defaults[k]) then
				db[k] = v
			end
		end
	end
	
	fishingSkill = db.fishingSkill
	fishingBuff = db.fishingBuff
	fishCaught = db.fishCaught
	fishToCatch = db.fishToCatch
	font = db.font

	self:RegisterEvent"CHAT_MSG_SPELL_ITEM_ENCHANTMENTS"
	self:RegisterEvent"SKILL_LINES_CHANGED"
	self:RegisterEvent"LOOT_OPENED"
	self:RegisterEvent"ZONE_CHANGED_NEW_AREA"
	self:RegisterEvent"ZONE_CHANGED"
	self:RegisterEvent"UNIT_INVENTORY_CHANGED"

	
	-- Register callbacks for LSM
	if media then
		media.RegisterCallback(fb, "LibSharedMedia_Registered", "LibSharedMedia_Update")
		media.RegisterCallback(fb, "LibSharedMedia_SetGlobal", "LibSharedMedia_Update")
	end
	
	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
	
	if IsLoggedIn() then self:PLAYER_LOGIN() else self:RegisterEvent("PLAYER_LOGIN") end
end
 
function fb:PLAYER_LOGIN()
	fb:CheckPole()

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end
fb.PLAYER_ENTERING_WORLD = fb.PLAYER_LOGIN

function fb:CHAT_MSG_SPELL_ITEM_ENCHANTMENTS()
	fb:UpdateSkill()
end
fb.SKILL_LINES_CHANGED = fb.CHAT_MSG_SPELL_ITEM_ENCHANTMENTS

function fb:LOOT_OPENED()
	fb:UpdateFishes()
end

function fb:ZONE_CHANGED_NEW_AREA()
	fb:UpdateZone()
end
fb.ZONE_CHANGED = fb.ZONE_CHANGED_NEW_AREA

function fb:UNIT_INVENTORY_CHANGED()
	fb:CheckPole()
end


function fb:UpdateDatabase()
	local name = string.format("%s - %s", UnitName"player", GetRealmName())
	FishbringerDB[name].fishingSkill = fishingSkill
	FishbringerDB[name].fishingBuff = fishingBuff
	FishbringerDB[name].fishCaught = fishCaught
	FishbringerDB[name].fishToCatch = fishToCatch
	FishbringerDB[name].font = font
end

-- LSM callback handler
function fb:LibSharedMedia_Update(callback, type, handle)
	if media and type == "font" then
		Fishbringer.title:SetFont(media:Fetch("font", db.font), 16)
		Fishbringer.zone:SetFont(media:Fetch("font", db.font), 12)
		Fishbringer.catch:SetFont(media:Fetch("font", db.font), 14)
		Fishbringer.content:SetFont(media:Fetch("font", db.font), 12)
		Fishbringer.fish:SetFont(media:Fetch("font", db.font), 12)
	end
end

function fb:FishyFormula(r)
	if r <= 95 then
		return 1
	else
		return math.ceil((r - 95) / 25)
	end
end

function fb:UpdateFishes(skipLoot)
	if( IsFishingLoot() and not skipLoot) then
		fishCaught = fishCaught + 1
	end
	Fishbringer.fish:SetFormattedText(L["%d of %d fish caught"], fishCaught, fishToCatch)
	fb:UpdateDatabase()
end

function fb:Fishes(f)
	fishToCatch = f
	fishCaught = 0
 	fb:UpdateFishes(true)
end

function fb:UpdateSkill()
	local skillName, skillRank, skillModifier, skillMaxRank
	local fishingLocal,_,_,_,_,_,_,_,_ = GetSpellInfo(7620)
	local found = 0
	for i = 1,GetNumSkillLines() do
		skillName, _, _, skillRank, _, skillModifier, skillMaxRank, _, _, _, _, _, _= GetSkillLineInfo(i)
		if(skillName == fishingLocal) then 
			found = 1
			break
		end
	end
	
	if found == 1 then
		local fishNeeded = FishyFormula(skillRank)
		if skillRank < skillMaxRank then 
			Fishbringer.content:SetFormattedText(L["%d(+%d)/%d fishing skill\n%d fish needed at this level"], skillRank, skillModifier, skillMaxRank, fishNeeded)
		else
			Fishbringer.fish:Hide()
			Fishbringer.content:SetFormattedText(L["%d(+%d) fishing skill"], skillRank, skillModifier)
		end
		if fishingSkill ~= skillRank then
			fishingSkill = skillRank
			fb:Fishes(fishNeeded)
		end
		if fishingBuff ~= skillModifier then
			fishingBuff = skillModifier
			fb:UpdateZone()
		end
		fb:UpdateDatabase()
	end
end

function fb:UpdateZone()
	local t
	local z
	t = GetSubZoneText()
	z = subzones[t]
	if not z then 
		t = GetRealZoneText()
		z = zones[t]
	end
	if not z then
		z = 0
	end

	local maxi, chance
	maxi = z + 95
	if maxi == 95 then maxi = 0 end
	
	chance = (fishingSkill / maxi)
	--chance = ((fishingSkill + fishingBuff) - z)*0.01 + 0.05
	if z < 0 then z = 1 end
	if chance > 1.0 then
		chance = 1.0
	elseif chance < 0 then 
		chance = 0
	end
	local colour
	if chance == 0 then
		colour = "ffff2020"
	elseif chance <= 0.5 then 
		colour = "ffff8040"
	elseif chance < 1 then 
		colour = "ffffff00"
	else
		colour = "ff40bf40"
	end
	Fishbringer.zone:SetFormattedText(L["\124c%s%s\124r\n%d skill needed to fish\n(%d for 100%% catch rate)"], colour, t, z, maxi, chance*100)
	Fishbringer.catch:SetFormattedText(L["%d%% catch rate"], chance*100)
	Fishbringer.catchRate = chance*100
end

function fb:Toggle()
	if Fishbringer:IsShown() == 1 then 
		Fishbringer:Hide()
	else
		fb:UpdateSkill()
		fb:UpdateZone()
		Fishbringer:Show()
	end
end

function fb:CheckPole() 
	local fishingLocal = GetSpellInfo(7620)
	local usable = IsUsableSpell(fishingLocal)
	if usable then
		fb:UpdateSkill()
		fb:UpdateZone()
		Fishbringer:Show()
	else
		Fishbringer:Hide()
	end
end

function fb:CMD_HELP()
	fb:Print(L["To toggle Fishbringer equip a fishing pole or type "] .. SLASH_FISHBRINGER2)
	fb:Print(L["To set a different font face type: "].. SLASH_FISHBRINGER2 .. " font")
end

function fb:PrintFonts()
	local l = ""
	for i=1, #media_fonts_text do
		l = l .. media_fonts_text[i]
		if i ~= #media_fonts_text then
			l = l .. ", "
		end
	end
	fb:Print(L["Available fonts: "] .. l)
end

function fb:GetFonts()
	media_fonts_text = {}
	for i, k in ipairs(media_fonts) do
		if k == db.font then
			list = ("|cffffff00" .. k .. "|r")
		else
			list = k
		end
		table.insert(media_fonts_text, "|cff33ff99" .. i .. ".|r ".. list)
	end
end

-- Code inspired by Speedometer to change font face on the frame
function fb:CMD_FONT(v)
	if media then
		local list
		if not media_fonts then
			media_fonts = media:List("font")
		end
		if not media_fonts_text then
			fb:GetFonts()
		end
		v = string.lower(tostring(v))
		if v ~= "nil" and v ~= "" then
			local found = false
			for i, k in pairs(media_fonts) do
				if string.lower(k) == v then
					db.font = k
					Fishbringer.title:SetFont(media:Fetch("font", db.font), 16)
					Fishbringer.zone:SetFont(media:Fetch("font", db.font), 12)
					Fishbringer.catch:SetFont(media:Fetch("font", db.font), 14)
					Fishbringer.content:SetFont(media:Fetch("font", db.font), 12)
					Fishbringer.fish:SetFont(media:Fetch("font", db.font), 12)
					found = true
					break
				end
			end
			if found then
				fb:Print(L["Font changed to "] .. "|cffffff00" .. db.font .. "|r")
				fb:GetFonts()
				return
			end
		end
		fb:PrintFonts()
	else
		fb:help()
	end
end

Fishbringer = CreateFrame("Frame", "Fishbringer", UIParent)
Fishbringer:EnableMouse(true)
Fishbringer:SetMovable(true)
Fishbringer:SetUserPlaced(true)
Fishbringer:SetClampedToScreen(true)
Fishbringer:SetHeight(150)
Fishbringer:SetWidth(185)
Fishbringer:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4},})
Fishbringer:SetBackdropColor(0, 0, 0, 0)
Fishbringer:SetScript("OnMouseDown", function(self) if(IsAltKeyDown()) then self:SetBackdropColor(0, 0, 0, .6) self:StartMoving() end end)
Fishbringer:SetScript("OnMouseUp", function(self) 
	self:StopMovingOrSizing() self:SetBackdropColor(0, 0, 0, 0)
	local s = self:GetEffectiveScale()
	db.x = self:GetLeft() * s
	db.y = self:GetTop() * s 
end)
	
if db.x and db.y then
	local s = Fishbringer:GetEffectiveScale()
	Fishbringer:ClearAllPoints()
	Fishbringer:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db.x / s, db.y / s)
else
	Fishbringer:SetPoint("CENTER")
end
Fishbringer:Hide()

local title = Fishbringer:CreateFontString(nil, "OVERLAY")
title:SetHeight(15)
title:SetWidth(Fishbringer:GetWidth()-10)
title:SetPoint("TOPLEFT", Fishbringer, "TOPLEFT", 3, -10)
title:SetJustifyH("CENTER")
title:SetFont(media and media:Fetch("font", db.font) or font, 16)
title:SetShadowOffset(1, -1)
local name
if random(100) < 10 then 
	name = "Corrupted Fishbringer"
else
	name = "Fishbringer"
end
title:SetText(name)
Fishbringer.title = title

local zone = Fishbringer:CreateFontString(nil, "OVERLAY")
zone:SetHeight(50)
zone:SetWidth(Fishbringer:GetWidth()-10)
zone:SetPoint("TOP", Fishbringer.title, "BOTTOM", 0, 0)
zone:SetJustifyH("CENTER")
zone:SetFont(media and media:Fetch("font", db.font) or font, 12)
zone:SetShadowOffset(1, -1)
Fishbringer.zone = zone

local catch = Fishbringer:CreateFontString(nil, "OVERLAY")
catch:SetHeight(15)
catch:SetWidth(Fishbringer:GetWidth()-10)
catch:SetPoint("TOP", Fishbringer.zone, "BOTTOM", 0, 0)
catch:SetJustifyH("CENTER")
catch:SetFont(media and media:Fetch("font", db.font) or font, 14)
catch:SetShadowOffset(1, -1)
Fishbringer.catch = catch

local content = Fishbringer:CreateFontString(nil, "OVERLAY")
content:SetHeight(30)
content:SetWidth(Fishbringer:GetWidth()-10)
content:SetFont(media and media:Fetch("font", db.font) or font, 12)
content:SetShadowOffset(1, -1)
content:SetJustifyH("CENTER")
content:SetPoint("TOP", Fishbringer.catch, "BOTTOM", 0, 0)
Fishbringer.content = content

local fish = Fishbringer:CreateFontString(nil, "OVERLAY")
fish:SetHeight(15)
fish:SetWidth(Fishbringer:GetWidth()-10)
fish:SetFont(media and media:Fetch("font", db.font) or font, 12)
fish:SetShadowOffset(1, -1)
fish:SetJustifyH("CENTER")
fish:SetPoint("TOP", Fishbringer.content, "BOTTOM", 0, -7)
Fishbringer.fish = fish

-- Slashing
SlashCmdList["FISHBRINGER"] = function(arg1)
	local cmd, args = string.match(arg1, "^%s*(%w+)%s*(.*)$")
	local handler = cmd and fb["CMD_"..string.upper(cmd)]
	if handler then
		handler(fb, args)
	else
		fb:Toggle()
	end
end
SLASH_FISHBRINGER1 = "/fishbringer"
SLASH_FISHBRINGER2 = "/fbr"
-- Hail to Fishing Buddy!
if not select(4, GetAddOnInfo"Fishing Buddy") then
	SLASH_FISHBRINGER3 = "/fb"
end

