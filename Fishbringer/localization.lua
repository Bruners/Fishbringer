local AL3 = LibStub("AceLocale-3.0")
local debug = false
--@debug@
debug = true
--@end-debug@

local L = AL3:NewLocale("Fishbringer", "enUS", true, debug)
if L then
--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, table-name="L")@
if GetLocale() == "enUS" or GetLocale() == "enGB" then return end
end

local L = AL3:NewLocale("Fishbringer", "deDE")
if L then
--@localization(locale="deDE", format="lua_additive_table", table-name="L", handle-unlocalized="comment")@
return
end

local L = AL3:NewLocale("Fishbringer", "esES") or AL3:NewLocale("Fishbringer", "esMX")
if L then
--@localization(locale="esES", format="lua_additive_table", table-name="L", handle-unlocalized="comment")@
return
end

local L = AL3:NewLocale("Fishbringer", "frFR")
if L then
--@localization(locale="frFR", format="lua_additive_table", table-name="L", handle-unlocalized="comment")@
return
end

local L = AL3:NewLocale("Fishbringer", "koKR")
if L then
--@localization(locale="koKR", format="lua_additive_table", table-name="L", handle-unlocalized="comment")@
return
end

local L = AL3:NewLocale("Fishbringer", "ruRU")
if L then
--@localization(locale="ruRU", format="lua_additive_table", table-name="L", handle-unlocalized="comment")@
return
end

local L = AL3:NewLocale("Fishbringer", "zhCN")
if L then
--@localization(locale="zhCN", format="lua_additive_table", table-name="L", handle-unlocalized="comment")@
return
end

local L = AL3:NewLocale("Fishbringer", "zhTW")
if L then
--@localization(locale="zhTW", format="lua_additive_table", table-name="L", handle-unlocalized="comment")@
return
end