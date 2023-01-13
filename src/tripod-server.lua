local COLORS    = math.random(1, 9)
local SPAWNED   = {}
local SPAMLIST  = {}


Citizen.CreateThread(function()
    StartAntiCheat()
end)



RegisterNetEvent("TRIPOD:BanFromClient")
AddEventHandler("TRIPOD:BanFromClient", function (ACTION ,REASON, DETAILS)
    local SRC = source
    if REASON ~= nil and ACTION ~= nil then
        if not TRIPOD_WHITELIST(SRC) then
            if REASON == "Anti Teleport" then
                if (not TRIPOD_ISNEARADMIN(SRC)) then
                    TRIPOD_ACTION(SRC, ACTION, REASON, DETAILS)
                    TRIPOD_ADD_SPAMLIST(SRC, ACTION, REASON, DETAILS)
                end
            else
                TRIPOD_ACTION(SRC, ACTION, REASON, DETAILS)
                TRIPOD_ADD_SPAMLIST(SRC, ACTION, REASON, DETAILS)
            end
        end
    else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "TRIPOD:BanFromClient : REASON or ACTION (Not Found)")
    end
end)

RegisterNetEvent("TRIPOD:BanForInject")
AddEventHandler("TRIPOD:BanForInject", function (REASON, DETAILS, RESOURCE)
    local SRC = source
    if REASON ~= nil and RESOURCE ~= nil then
        if not TRIPOD_WHITELIST(SRC) then
            TRIPOD_ACTION(SRC, TRIPOD.InjectPunishment, "Anti Inject", DETAILS)
        end
    else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "TRIPOD:BanForInject : REASON or RESOURCE (Not Found)")
    end
end)

RegisterNetEvent("TRIPOD:AntiInject")
AddEventHandler("TRIPOD:AntiInject", function(resource, info)
    local SRC = source
    if resource ~= nil and info ~= nil then
        TRIPOD_ACTION(SRC, TRIPOD.InjectPunishment, "Anti Inject", "Try For Inject in **"..resource.."** Type: "..info.."")
     end
end)

RegisterNetEvent("TRIPOD:CheckIsAdmin")
AddEventHandler("TRIPOD:CheckIsAdmin", function ()
    local SRC = source
    if TRIPOD_GETADMINS(SRC) then
        local DATA = {
            NAME = GetPlayerName(SRC),
            ID   = SRC
        }
        TriggerClientEvent("TRIPOD:AddAdminOption", SRC, DATA)
    end
end)

RegisterNetEvent("TRIPOD:MenuOpened")
AddEventHandler("TRIPOD:MenuOpened", function ()
    local SRC = source
    if not TRIPOD_GETADMINS(SRC) then
        TRIPOD_ACTION(SRC, TRIPOD.AdminMenu.MenuPunishment, "Anti Open Admin Menu", "Try For Open Admin Menu (Not Admin)")
    else
        local PlayerList = {}
        for _, value in pairs(GetPlayers()) do
            table.insert(PlayerList, {
                name = GetPlayerName(value),
                id   = value
            })
        end
        TriggerClientEvent("TRIPOD:GetPlayerList", SRC, PlayerList)
    end
end)

RegisterNetEvent("TRIPOD:DeleteEntitys")
AddEventHandler("TRIPOD:DeleteEntitys", function (TYPE)
    local SRC = source
    if TYPE ~= nil then
        if TRIPOD_GETADMINS(SRC) then
            if TYPE == "VEHCILE" then
                for _, VEH in ipairs(GetAllVehicles()) do
                    if DoesEntityExist(VEH) then
                        DeleteEntity(VEH)
                    end
                end
            elseif TYPE == "PEDS" then
                for _, PEDS in ipairs(GetAllPeds()) do
                    if DoesEntityExist(PEDS) then
                        DeleteEntity(PEDS)
                    end
                end
            elseif TYPE == "PROP" then
                for _, OBJ in ipairs(GetAllObjects()) do
                    if DoesEntityExist(OBJ) then
                        DeleteEntity(OBJ)
                    end
                end
            end
        else
            TRIPOD_ACTION(SRC, TRIPOD.AdminMenu.MenuPunishment, "Anti Delete Entity", "Try For Delete Entitys")
        end
    end
end)

RegisterNetEvent("TRIPOD:TeleportToPlayer")
AddEventHandler("TRIPOD:TeleportToPlayer", function (SV_ID)
    local SRC = source
    if tonumber(SRC) then
        if tonumber(SV_ID) then
            local TPED    = GetPlayerPed(SV_ID)
            local PED     = GetPlayerPed(SRC)
            local TCOORDS = GetEntityCoords(TPED)
            if TRIPOD_GETADMINS(SRC) then
                SetEntityCoords(PED, TCOORDS.x, TCOORDS.y, TCOORDS.z, true, true, true)
            else
                TRIPOD_ACTION(SRC, TRIPOD.AdminMenu.MenuPunishment, "Anti Teleport", "Try For Teleport to ped by admin menu (not admin)")
            end
        end
    end
end)

RegisterNetEvent("TRIPOD:GiveVehicleToPlayer")
AddEventHandler("TRIPOD:GiveVehicleToPlayer", function (VEH_NAME, SV_ID)
    local SRC = source
    if tonumber(SRC) then
        if tonumber(SV_ID) then
            local TPED    = GetPlayerPed(SV_ID)
            local TCOORDS = GetEntityCoords(TPED)
            local HEADING = GetEntityHeading(TPED)
            if TRIPOD_GETADMINS(SRC) then
                local VEH = CreateVehicle(GetHashKey(VEH_NAME), TCOORDS, HEADING, true, true)
                Wait(1000)
                SetPedIntoVehicle(TPED, VEH, -1)
            else
                TRIPOD_ACTION(SRC, TRIPOD.AdminMenu.MenuPunishment, "Anti Spawn Vehicle", "Try For Spawn Vehicle By Admin Menu (not admin)")
            end
        end
    end
end)

RegisterNetEvent("TRIPOD:GetScreenShot")
AddEventHandler("TRIPOD:GetScreenShot", function (P_ID)
    local SRC = source
    if tonumber(SRC) then
        if tonumber(P_ID) then
            if TRIPOD_GETADMINS(SRC) then
                if TRIPOD.ScreenShot.Log ~= "" and TRIPOD.ScreenShot.Log ~= nil then
                    TRIPOD_SCREENSHOT(P_ID, "By Admin Menu", "By "..GetPlayerName(SRC).."", "WARN")
                end
            else
                TRIPOD_ACTION(SRC, TRIPOD.AdminMenu.MenuPunishment, "Anti Get ScreenShot", "Try For Get Screen Shot By Menu (not admin)")
            end
        end
    end
end)

RegisterNetEvent("TRIPOD:BanByMenu")
AddEventHandler("TRIPOD:BanByMenu", function (P_ID)
    local SRC = source
    local Target = P_ID
    if tonumber(SRC) then
        if tonumber(Target) then
            if TRIPOD_GETADMINS(SRC) then
                TRIPOD_ACTION(Target, "BAN", "Ban By Admin Menu", "Player Ban By Menu : **"..GetPlayerName(SRC).."**")
            else
                TRIPOD_ACTION(SRC, TRIPOD.AdminMenu.MenuPunishment, "Anti Ban Players", "Try For Ban Player By Admin Menu (not admin)")
            end
        end
    end
end)

RegisterServerEvent("TRIPOD:ReqSpectate")
AddEventHandler("TRIPOD:ReqSpectate", function(id)
    local SRC = source
    local Target = id
    local TPED   = GetPlayerPed(Target)
    local COORDS = GetEntityCoords(TPED)
    if tonumber(SRC) then
        if tonumber(Target) then
            if TRIPOD_GETADMINS(SRC) then
                TriggerClientEvent("TRIPOD:SpectatePlayer", SRC, Target, COORDS)
            else
                TRIPOD_ACTION(SRC, TRIPOD.AdminMenu.MenuPunishment, "Anti Spectate Players", "Try For Spectate Player By Admin Menu (not admin)")
            end
        end
    end
end)
--【 𝗦𝘂𝗽𝗲𝗿𝗝𝘂𝗺𝗽 𝗖𝗵𝗲𝗰𝗸 】--
RegisterNetEvent("TRIPOD:CheckJumping")
AddEventHandler("TRIPOD:CheckJumping", function (ACTION ,REASON, DETAILS)
    local SRC = source
    if IsPlayerUsingSuperJump(SRC) and tonumber(SRC) then
        if not TRIPOD_WHITELIST(SRC) then
            TRIPOD_ACTION(SRC, ACTION, REASON, DETAILS)
        end
    end
end)

RegisterNetEvent("TRIPOD:ScreenShotFromClient")
AddEventHandler("TRIPOD:ScreenShotFromClient", function (URL, REASON, DETAILS)
    local SRC = source
    if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
        local NAME    = GetPlayerName(SRC)
        local COORDS  = GetEntityCoords(GetPlayerPed(SRC))
        local STEAM   = "Not Found"
        local DISCORD = "Not Found"
        local FIVEML  = "Not Found"
        local LIVE    = "Not Found"
        local XBL     = "Not Found"
        local ISP     = "Not Found"
        local CITY    = "Not Found"
        local COUNTRY = "Not Found"
        local PROXY   = "Not Found"
        local HOSTING = "Not Found"
        local IP      = GetPlayerEndpoint(SRC)
        IP = (string.gsub(string.gsub(string.gsub(IP,  "-", ""), ",", ""), " ", ""):lower())
        local g, f = IP:find(string.lower("192.168"))
        if g or f then
           IP = "178.131.122.181"
        end
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end
        if DISCORD ~= "Not Found" then
            DISCORD = "<@"..DISCORD..">"
        else
            DISCORD = "Not Found"
        end
        PerformHttpRequest("http://ip-api.com/json/"..IP.."?fields=66846719", function(ERROR, DATA, RESULT)
            if DATA ~= nil then
                local TABLE = json.decode(DATA)
                if TABLE ~= nil then
                    ISP     = TABLE["isp"]
                    CITY    = TABLE["city"]
                    COUNTRY = TABLE["country"]
                    if TABLE["proxy"] == true then
                        PROXY   =  "ON"
                    else
                        PROXY   = "OFF"
                    end
                    if TABLE["hosting"] == true then
                        HOSTING   =  "ON"
                    else
                        HOSTING   = "OFF"
                    end
                        if URL ~= nil then
                           PerformHttpRequest(TRIPOD.ScreenShot.Log, function(ERROR, DATA, RESULT)
                            end, "POST", json.encode({
                                embeds = {
                                    {
                                        author = {
                                            name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                            url = "https://discord.gg/",
                                            icon_url = ""
                                        },
                                        image =  {
                                            url = URL,
                                        },
                                        footer = {
                                            text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                            icon_url = "",
                                        },
                                        title = ""..Emoji.VPN.." ScreenShot "..Emoji.VPN.."",
                                        description = "**Player:** "..NAME.."\n**Reason:** "..REASON.."\n**Details:** "..DETAILS.."\n**Coords:** "..COORDS.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                        color = 10181046
                                    }
                                }
                            }), {
                                ["Content-Type"] = "application/json"
                            })
                        end
                    end
                end
            end)
        else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "TRIPOD:ScreenShotFromClient (SRC not found)")
    end
end)

--【 𝗗𝗿𝗼𝗽𝗣𝗹𝗮𝘆𝗲𝗿 𝗘𝘃𝗲𝗻𝘁 】--
AddEventHandler("playerDropped", function(REASON)
    local SRC = source
    print("^"..COLORS.."TRIPOD^0: ^1Player ^3"..GetPlayerName(SRC).." ^1Disconnected ...  |  Reason : ^0(^6"..REASON.."^0)^0")
    if GetPlayerName(SRC) and REASON ~= nil then
        TRIPOD_SENDLOG(SRC, TRIPOD.Log.Disconnect, "DISCONNECT", REASON)
     else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "playerDropped : REASON or SRC (Not Found)")
    end
end)

--【 𝗪𝗲𝗮𝗽𝗼𝗻 𝗘𝘃𝗲𝗻𝘁 】--
AddEventHandler("giveWeaponEvent", function(SRC, DATA)
    if TRIPOD.AntiAddWeapon then
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            if not TRIPOD_WHITELIST(SRC) then
                CancelEvent()
                TRIPOD_ACTION(SRC, TRIPOD.WeaponPunishment, "Anti Add Weapon", "Try for add weapon for player")
            end
        else
            TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

--【 𝗥𝗲𝗺𝗼𝘃𝗲 𝗪𝗲𝗮𝗽𝗼𝗻 】--
AddEventHandler("RemoveWeaponEvent", function(SRC, DATA)
    if TRIPOD.AntiRemoveWeapon then
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            if not TRIPOD_WHITELIST(SRC) then
                CancelEvent()
                TRIPOD_ACTION(SRC, TRIPOD.WeaponPunishment, "Anti Remove Weapon", "Try for remove weapon for player")
            end
        else
            TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

--【 𝗥𝗲𝗺𝗼𝘃𝗲 𝗔𝗹𝗹 𝗪𝗲𝗮𝗽𝗼𝗻 】--
AddEventHandler("RemoveAllWeaponsEvent",function(SRC, DATA)
    if TRIPOD.AntiRemoveWeapon then
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            if not TRIPOD_WHITELIST(SRC) then
                CancelEvent()
                TRIPOD_ACTION(SRC, TRIPOD.WeaponPunishment, "Anti Remove All Weapon", "Try for remove all weapon for player")
            end
        else
            TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "giveWeaponEvent : SRC (Not Found)")
        end
    end
end)

RegisterNetEvent("TRIPOD:AddToSpawnList")
AddEventHandler("TRIPOD:AddToSpawnList", function()
    local SRC = tonumber(source)
    if SRC ~= nil then
        if SPAWNED[SRC] == nil then
            SPAWNED[SRC] = true
        end
    end
end)

--【 𝗧𝗿𝗶𝗴𝗴𝗲𝗿 𝗠𝗮𝗻𝗮𝗴𝗲𝗺𝗲𝗻𝘁 】--
local EVENTS = {}
local isSpamTrigger = false
if TRIPOD.AntiSpamTigger then
	for i = 1, #SpamCheck do
		local TNAME  =  SpamCheck[i].EVENT
		local MTIME  =  SpamCheck[i].MAX_TIME
		RegisterNetEvent(TNAME)
		AddEventHandler(TNAME, function()
            local SRC = source
			if EVENTS[TNAME] == nil then
				EVENTS[TNAME] = {
					count = 1,
					time = os.time()
				}
			else
				EVENTS[TNAME].count = EVENTS[TNAME].count + 1
			end
				if EVENTS[TNAME].count > MTIME then
					local distime = os.time() - EVENTS[TNAME].time
					if distime >= 10 then
						EVENTS[TNAME].count = 1
					else
						isSpamTrigger = true
					end
					if GetPlayerName(source) and isSpamTrigger then
                        TRIPOD_ACTION(SRC, TRIPOD.TriggerPunishment, "Anti Spam Trigger", "Try For Spam Trigger : `"..TNAME.."`")
                        CancelEvent()
					end
				end
		end)
	end
end

--【 𝗖𝗼𝗺𝗺𝗮𝗻𝗱 𝗠𝗮𝗻𝗮𝗴𝗲𝗺𝗲𝘁 】--
local SERVER_CMDS = {}
for index, bcmd in ipairs(Commands) do
    RegisterCommand(bcmd, function (SRC, ARGS)
        if TRIPOD.AntiBlackListCommands then
            TRIPOD_ACTION(SRC, TRIPOD.TriggerPunishment, "Anti Black List Commands", "Try For Use Black List Command : **"..bcmd.."**")
            return
        end
    end)
end

--【 𝗖𝗵𝗮𝘁 𝗠𝗮𝗻𝗮𝗴𝗲𝗺𝗲𝗻𝘁 】--
local MESSAGE = {}
AddEventHandler("chatMessage", function(SRC, NA, WORD)
    local HWID = SRC
    if TRIPOD.AntiBlackListWord then
        for _, S in pairs(Words) do
            for S in WORD:lower():gmatch("%s?"..string.lower(S).."%s") do
                TRIPOD_ACTION(SRC, TRIPOD.WordPunishment, "Anti Bad Word", "Try say : **"..WORD.."**")
                return
            end
        end
    end
    if TRIPOD.AntiSpamChat then
        if MESSAGE[HWID] ~= nil then
            MESSAGE[HWID].COUNT = MESSAGE[HWID].COUNT + 1
            if os.time() - MESSAGE[HWID].TIME >= TRIPOD.CoolDownSec then
                MESSAGE[HWID] = nil
            else
                TriggerClientEvent("chatMessage", SRC, "[TRIPOD]", {255, 0, 0}, "You are spam message for "..MESSAGE[HWID].COUNT..", Please Wait for "..TRIPOD.CoolDownSec.." secend")
                if MESSAGE[HWID].COUNT >= TRIPOD.MaxMessage then
                    TRIPOD_ACTION(SRC, TRIPOD.ChatPunishment, "Anti Spam Chat", "Try For Spam in chat : **"..WORD.."**")
                    return
                end
            end
        else
            MESSAGE[HWID] = {
                COUNT = 1,
                TIME  = os.time()
            }
        end
    end
end)

if TRIPOD.AntiBlackListTrigger then
    for i = 1 , #Events do
        RegisterNetEvent(Events[i])
        AddEventHandler(Events[i], function()
			local SRC = source
			local ENAME = Events[i]
	        TRIPOD_ACTION(SRC, TRIPOD.TriggerPunishment, "Anti Black List Trigger", "Try For Run Black List Trigger : "..ENAME.."")
            CancelEvent()
		end)
    end
end

--【 𝗔𝗻𝘁𝗶 𝗖𝗵𝗮𝗻𝗴𝗲 𝗣𝗲𝗿𝗺 】--
AddEventHandler("db:updateUser", function(data)
    local SRC = source
	if TRIPOD.AntiChangePerm then
		if not data.playerName or not data.dateofbirth then
            TRIPOD_ACTION(SRC, TRIPOD.PermPunishment, "Anti Change Perm", "Try Change Perm, Data = `"..json.encode(data).."`")
            CancelEvent()
		end
	end
end)

--【 𝗔𝗻𝘁𝗶 𝗘𝘅𝗽𝗹𝗼𝘀𝗶𝗼𝗻 】--
local EXPLOSION = {}
AddEventHandler("explosionEvent", function(SRC, DATA)
    if tonumber(SRC) then
        local HWID = GetPlayerToken(SRC, 0)
        if DATA ~= nil then
     --【 𝗕𝗹𝗮𝗰𝗸 𝗟𝗶𝘀𝘁 𝗠𝗮𝗻𝗮𝗴𝗲 】--
     local TABLE = Explosion[DATA.explosionType]
     if TABLE ~= nil then
         local NAME = TABLE.NAME
        if TABLE.Log then
            TRIPOD_SENDLOG(SRC, TRIPOD.Log.Exoplosion, "EXPLOSION", NAME)
          end
        if TABLE.Punishment ~= nil and TABLE.Punishment ~= false  then
            if TABLE.Punishment == "WARN" then
                TRIPOD_ACTION(SRC, TABLE.Punishment, "Anti Explosion", "Try For Create Black List Explosion : **"..NAME.."**")
                CancelEvent()
            elseif TABLE.Punishment == "KICK" then
                TRIPOD_ACTION(SRC, TABLE.Punishment, "Anti Explosion", "Try For Create Black List Explosion : **"..NAME.."**")
                CancelEvent()
            elseif TABLE.Punishment == "BAN" then
                TRIPOD_ACTION(SRC, TABLE.Punishment, "Anti Explosion", "Try For Create Black List Explosion : **"..NAME.."**")
                CancelEvent()
            end
        end
     end
     --【 𝗦𝗽𝗮𝗺 𝗖𝗵𝗲𝗰𝗸 】--
     if TRIPOD.AntiExplosionSpam then
        if EXPLOSION[HWID] ~= nil then
            EXPLOSION[HWID].COUNT = EXPLOSION[HWID].COUNT + 1
            if os.time() - EXPLOSION[HWID].TIME <= 10 then
                EXPLOSION[HWID] = nil
            else
                if EXPLOSION[HWID].COUNT >= TRIPOD.MaxExplosion then
                    TRIPOD_ACTION(SRC, TRIPOD.ExplosionSpamPunishment, "Anti Spam Explosion", "Try For Spam Explosion Type: "..DATA.explosionType.." for "..EXPLOSION[HWID].COUNT.." times.")
                    CancelEvent()
                end
            end
         else
            EXPLOSION[HWID] = {
                COUNT = 1,
                TIME  = os.time()
            }
         end
     end
        else
            CancelEvent()
        end
    else
        CancelEvent()
    end
end)


--【 𝗔𝗻𝘁𝗶 𝗣𝗹𝗮𝘆 𝗦𝗼𝘂𝗻𝗱 】--
if GetResourceState("interact-sound") == "started" then
    AddEventHandler("InteractSound_SV:PlayWithinDistance", function(maxDistance, soundFile, soundVolume)
        local SRC = source
        if TRIPOD.AntiPlaySound then
            if maxDistance == 10000 and soundFile == "handcuff" then
                TRIPOD_ACTION(SRC, TRIPOD.SoundPunishment, "Anti Play Sound", "Try For Play **handcuff** sound in **"..maxDistance.."** Distance")
                CancelEvent()
            elseif maxDistance == 1000 and soundFile == "Cuff" then
                TRIPOD_ACTION(SRC, TRIPOD.SoundPunishment, "Anti Play Sound", "Try For Play **Cuff** sound in **"..maxDistance.."** Distance")
                CancelEvent()
            elseif maxDistance == 103232 and soundFile == "lock" then
                TRIPOD_ACTION(SRC, TRIPOD.SoundPunishment, "Anti Play Sound", "Try For Play **Lock** sound in **"..maxDistance.."** Distance")
                CancelEvent()
            elseif maxDistance == 10 and soundFile == "szajbusek" then
                TRIPOD_ACTION(SRC, TRIPOD.SoundPunishment, "Anti Play Sound", "Try For Play **szajbusek** sound in **"..maxDistance.."** Distance")
                CancelEvent()
            elseif maxDistance == 5 and soundFile == "alarm" then
                TRIPOD_ACTION(SRC, TRIPOD.SoundPunishmentt, "Anti Play Sound", "Try For Play **alarm** sound in **"..maxDistance.."** Distance")
                CancelEvent()
            elseif maxDistance == 13232 and soundFile == "pasysound" then
                TRIPOD_ACTION(SRC, TRIPOD.SoundPunishment, "Anti Play Sound", "Try For Play **pasysound** sound in **"..maxDistance.."** Distance")
                CancelEvent()
            elseif maxDistance == 5000 and soundFile == "demo" then
                TRIPOD_ACTION(SRC, TRIPOD.SoundPunishment, "Anti Play Sound", "Try For Play **pasysound** sound in **"..maxDistance.."** Distance")
                CancelEvent() 
            end
        end
    end) 
end

--【 𝗔𝗻𝘁𝗶 𝗧𝗮𝘇𝗲 𝗣𝗹𝗮𝘆𝗲𝗿"𝘀 】--
local TAZE = {}
AddEventHandler("weaponDamageEvent", function(SRC, DATA)
    if TRIPOD.AntiTazePlayers then
        local HWID = GetPlayerToken(SRC, 0)
        if DATA.weaponType == 911657153 then
            if TAZE[HWID] ~= nil then
                TAZE[HWID].COUNT = TAZE[HWID].COUNT + 1
                if os.time() - TAZE[HWID].TIME <= 10 then
                    TAZE[HWID] = nil
                else
                    if TAZE[HWID].COUNT >= TRIPOD.MaxTazeSpam then
                        TRIPOD_ACTION(SRC, TRIPOD.TazePunishment, "Anti Spam Tazer", "Try For Spam Tazer for **"..TAZE[HWID].COUNT.."** times.")
                        CancelEvent()
                    end
                end
            else
                TAZE[HWID] = {
                    COUNT = 1,
                    TIME  = os.time()
                }
            end
        end
    end
end)

--【 𝗔𝗻𝘁𝗶 𝗖𝗹𝗲𝗮𝗿 𝗣𝗲𝗱 𝗧𝗮𝘀𝗸𝘀 】--
local FREEZE = {}
AddEventHandler("clearPedTasksEvent", function(SRC, DATA)
    local HWID = GetPlayerToken(SRC, 0)
    if TRIPOD.AntiClearPedTasks then
        if FREEZE[HWID] ~= nil then
            FREEZE[HWID].COUNT = FREEZE[HWID].COUNT + 1
            if os.time() - FREEZE[HWID].TIME <= 10 then
                FREEZE[HWID] = nil
            else
                if FREEZE[HWID].COUNT >= TRIPOD.MaxClearPedTasks then
                    TRIPOD_ACTION(SRC, TRIPOD.CPTPunishment, "Anti Clear Ped Tasks", "Try Clear Ped Tasks for "..FREEZE[HWID].TIME..".")
                    CancelEvent()
                end
            end
        else
            FREEZE[HWID] = {
                COUNT = 1,
                TIME  = os.time()
            }
        end
    end
end)

--【 𝗔𝗻𝘁𝗶 𝗕𝗿𝗶𝗻𝗴 𝗔𝗹𝗹 𝗣𝗹𝗮𝘆𝗲𝗿"𝘀 】--
RegisterNetEvent("esx_ambulancejob:syncDeadBody")
AddEventHandler("esx_ambulancejob:syncDeadBody", function(PED, TARGET)
	if TRIPOD.AntiBringAll then
        TRIPOD_ACTION(SRC, TRIPOD.BringAllPunishment, "Anti Bring All Players", "Try For Bring All Players")
        CancelEvent()
	end
end)

AddEventHandler("onResourceStarting", function(RES)
	TRIPOD_REFRESHCMD()
end)
AddEventHandler("onResourceStop", function(RES)
    TRIPOD_REFRESHCMD()
end)

--【 𝗖𝗼𝗻𝗻𝗲𝗰𝘁𝗶𝗻𝗴 𝗘𝘃𝗲𝗻𝘁 】--
AddEventHandler("playerConnecting", function (name, setKickReason, deferrals)
    local SRC      = source
    local IP      = GetPlayerEndpoint(SRC)
    local STEAM   = "Not Found"
    local DISCORD = "Not Found"
    local FIVEML  = "Not Found"
    local LIVE    = "Not Found"
    local XBL     = "Not Found"
    local ISP     = "Not Found"
    local CITY    = "Not Found"
    local COUNTRY = "Not Found"
    local PROXY   = "Not Found"
    local HOSTING = "Not Found"
    local LON     = "Not Found"
    local LAT     = "Not Found"
    local HWID    = GetPlayerToken(SRC, 0)
    IP = (string.gsub(string.gsub(string.gsub(IP,  "-", ""), ",", ""), " ", ""):lower())
    local g, f = IP:find(string.lower("192.168"))
    if g or f then
        IP = "178.131.122.181"
    end
    for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
        if DATA:match("steam") then
            STEAM = DATA
        elseif DATA:match("discord") then
            DISCORD = DATA:gsub("discord:", "")
        elseif DATA:match("license") then
            FIVEML = DATA
        elseif DATA:match("live") then
            LIVE = DATA
        elseif DATA:match("xbl") then
            XBL = DATA
        end
    end
    print("^"..COLORS.."TRIPOD^0: ^2Player ^3"..name.." ^2Connecting ...^0")
    --【 𝗕𝗮𝗻 𝗣𝗹𝗮𝘆𝗲𝗿 】--
    local BANFILE = LoadResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json")
    if BANFILE ~= nil then
        local TABLE = json.decode(BANFILE)
        if TABLE ~= nil and type(TABLE) == "table" then
            if tonumber(SRC) ~= nil then
                local STEAM   = "Not Found"
                local DISCORD = "Not Found"
                local FIVEML  = "Not Found"
                local LIVE    = "Not Found"
                local XBL     = "Not Found"
                local IP = GetPlayerEndpoint(SRC)
                local BANID   =  "Not Found"
                local REASON  = "Not Found"
                local BANNED  = false
                IP = (string.gsub(string.gsub(string.gsub(IP,  "-", ""), ",", ""), " ", ""):lower())
                local g, f = IP:find(string.lower("192.168"))
                if g or f then
                    IP = "178.131.122.181"
                end
                for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
                    if DATA:match("steam") then
                        STEAM = DATA
                    elseif DATA:match("discord") then
                        DISCORD = DATA:gsub("discord:", "")
                    elseif DATA:match("license") then
                        FIVEML = DATA
                    elseif DATA:match("live") then
                        LIVE = DATA
                    elseif DATA:match("xbl") then
                        XBL = DATA
                    end
                end
                for i = 0, GetNumPlayerTokens(SRC) do
                    for _, BANLIST in ipairs(TABLE)	do
                        if
                        BANLIST.STEAM == STEAM or
                        BANLIST.DISCORD == DISCORD or
                        BANLIST.LICENSE == FIVEML or
                        BANLIST.LIVE == LIVE or
                        BANLIST.XBL == XBL or
                        BANLIST.HWID ==  GetPlayerToken(SRC, i) or
                        BANLIST.IP == IP then
                            BANID  = BANLIST.BANID
                            REASON = BANLIST.REASON
                            BANNED  = true
                            setKickReason( "\n["..Emoji.tripod.."TRIPOD"..Emoji.tripod.."]\n".. TRIPOD.Message.Ban .."\nReason: "..BANLIST.REASON.."\nBan ID: "..BANLIST.BANID.."")
                            CancelEvent()
                            break
                        end
                    end
                end
                if BANNED then
                    print("^"..COLORS.."TRIPOD^0: ^1Player ^3"..GetPlayerName(SRC).." ^3Try For Join But ^0| ^3Ban ID: ^3 "..BANID.."^0")
                    TRIPOD_SENDLOG(SRC, TRIPOD.Log.Connect, "TFJ", BANID, REASON)
                end
            end
        else
            TRIPOD_RELOADFILE()
        end
    else
        TRIPOD_RELOADFILE()
    end
    --【 𝗕𝗹𝗮𝗰𝗸 𝗟𝗶𝘀𝘁 𝗡𝗮𝗺𝗲 】--
    if TRIPOD.Connection.AntiBlackListName == true then
        name = (string.gsub(string.gsub(string.gsub(name,  "-", ""), ",", ""), " ", ""):lower())
        for index, value in ipairs(Names) do
            local g, f = name:find(string.lower(value))
            if g or f  then
                print("^"..COLORS.."TRIPOD^0: ^1Player ^3"..name.." ^3Try For Join ^0| ^3Black List Word in name: ^3 "..value.."^0")
                TRIPOD_SENDLOG(SRC, TRIPOD.Log.Connect, "BLN", "Black List Name", "We are Found "..value.." in the name off this player")
                setKickReason( "\n["..Emoji.tripod.."TRIPOD"..Emoji.tripod.."]\nYou Can not Join Server:\n We Are Find ("..value..") in your Name Please Remove That Or Change Your Name ☺️")
                CancelEvent()
            end
        end
    end
    deferrals.defer()
    --【 𝗔𝗻𝘁𝗶 𝗩𝗣𝗡 】--
    if TRIPOD.Connection.AntiVPN then
        PerformHttpRequest("http://ip-api.com/json/"..IP.."?fields=66846719", function(ERROR, DATA, RESULT)
            if DATA ~= nil then
                local TABLE = json.decode(DATA)
                if TABLE ~= nil then
                    ISP     = TABLE["isp"]
                    CITY    = TABLE["city"]
                    COUNTRY = TABLE["country"]
                    if TABLE["proxy"] == true then
                        PROXY   =  "ON"
                    else
                        PROXY   = "OFF"
                    end
                    if TABLE["hosting"] == true then
                        HOSTING   =  "ON"
                    else
                        HOSTING   = "OFF"
                    end
                    LON     = TABLE["lon"]
                    LAT     = TABLE["lat"]
                    if PROXY == "ON" or HOSTING == "ON" then
                       local card = {
                        type = "AdaptiveCard",
                        version = "1.2",
                        body = { {
                          type = "Image",
                          url = "https://cache.ip-api.com/"..LON..","..LAT..",10",
                          horizontalAlignment = "Center"
                        }, {
                            type = "TextBlock",
                            text = ""..Emoji.tripod.."  TRIPOD  "..Emoji.tripod.."",
                            wrap = true,
                            horizontalAlignment = "Center",
                            separator = true,
                            height = "stretch",
                            fontType = "Default",
                            size = "Large",
                            weight = "Bolder",
                            color = "Light"
                        }, {
                            type = "TextBlock",
                            text = "Your VPN is on Plase Turn off that\nIP: "..IP.."\nVPN: "..PROXY.."\nHosting: "..HOSTING.."\nISP: "..ISP.."\nCountry: "..COUNTRY.."\nCity: "..CITY.."",
                            wrap = true,
                            horizontalAlignment = "Center",
                            separator = true,
                            height = "stretch",
                            fontType = "Default",
                            size = "Medium",
                            weight = "Bolder",
                            color = "Light"
                        },
                      }
                    }
                    print("^"..COLORS.."TRIPOD^0: ^1Player ^3"..GetPlayerName(SRC).." ^3Try For Join ^0| ^3VPN Availble ^3 ISP: "..ISP.."/ Country:"..COUNTRY.."/ City: "..CITY.."^0")
                    TRIPOD_SENDLOG(SRC, TRIPOD.Log.Connect, "VPN")
                    deferrals.presentCard(card, "XD")
                    Wait(15000)
                    deferrals.done("["..Emoji.tripod.."TRIPOD"..Emoji.tripod.."]\nPlease Turn off your vpn and rejoin !")
                else
                    local NEW_HWID = GetPlayerToken(SRC, 0)
                        if NEW_HWID == nil then
                            deferrals.done("["..Emoji.tripod.."TRIPOD"..Emoji.tripod.."]\nYour HWID (FiveM Token) not find please restart your fivem !")
                        else
                            TRIPOD_SENDLOG(SRC, TRIPOD.Log.Connect, "CONNECT")
                            deferrals.update("\n["..Emoji.tripod.."TRIPOD"..Emoji.tripod.."] Your Information\nName: "..name.."\nLicense : "..FIVEML.."\nSteam : "..STEAM.."\nDiscord ID: "..DISCORD.."\nLive ID: "..LIVE.."\nXbox ID: "..XBL.."\nIP: "..IP.."\nHWID : "..NEW_HWID.."")
                            Wait(2000)
                            deferrals.done()
                        end
                    end
                else
                    TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "playerConnecting (TABLE Not Found)")
                end
            else
                TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "playerConnecting (DATA Not Found)")
            end
        end)
    else
        TRIPOD_SENDLOG(SRC, TRIPOD.Log.Connect, "CONNECT")
        deferrals.update("\n["..Emoji.tripod.."TRIPOD"..Emoji.tripod.."] Your Information\nName: "..name.."\nLicense : "..FIVEML.."\nSteam : "..STEAM.."\nDiscord ID: "..DISCORD.."\nLive ID: "..LIVE.."\nXbox ID: "..XBL.."\nIP: "..IP.."\nHWID : "..HWID.."")
        Wait(2000)
        deferrals.done()
    end
end)

--【 𝗘𝗻𝘁𝗶𝘁𝘆 𝗠𝗮𝗻𝗮𝗴𝗲𝗺𝗲𝗻𝘁 】--
local SV_VEHICLES = {}
local SV_PEDS = {}
local SV_OBJECT = {}

AddEventHandler("entityCreated", function(ENTITY)
    if DoesEntityExist(ENTITY) then
        local TYPE        = GetEntityType(ENTITY)
        local OWNER       = NetworkGetFirstEntityOwner(ENTITY)
        local POPULATION  = GetEntityPopulationType(entity)
        local MODEL       = GetEntityModel(ENTITY)
        local HWID        = GetPlayerToken(OWNER, 0)
        --【 𝗕𝗹𝗮𝗰𝗸 𝗟𝗶𝘀𝘁 𝗠𝗮𝗻𝗮𝗴𝗲 】--
        if POPULATION == 7 then
            if TRIPOD.AntiBlackListObject and TYPE == 3 then
                for index, value in ipairs(Objects) do
                    if MODEL == GetHashKey(value) then
                        if DoesEntityExist(ENTITY) then
                            DeleteEntity(ENTITY)
                            Wait(1000)
                            TRIPOD_ACTION(OWNER, TRIPOD.EntityPunishment, "Anti Spawn Object", "Try For Spawn Object")
                        end
                    end
                end
            end
            if TRIPOD.AntiBlackListPed and TYPE == 1 then
                for index, value in ipairs(Peds) do
                    if MODEL == GetHashKey(value) then
                        if DoesEntityExist(ENTITY) then
                            DeleteEntity(ENTITY)
                            Wait(1000)
                            TRIPOD_ACTION(OWNER, TRIPOD.EntityPunishment, "Anti Spawn Ped", "Try For Spawn Ped")
                        end
                    end
                end
            end
            if TRIPOD.AntiBlackListVehicle and TYPE == 2 then
                for index, value in ipairs(Vehicle) do
                    if MODEL == GetHashKey(value) then
                        if DoesEntityExist(ENTITY) then
                            DeleteEntity(ENTITY)
                            Wait(1000)
                            TRIPOD_ACTION(OWNER, TRIPOD.EntityPunishment, "Anti Spawn Vehicle", "Try For Spawn Vehicle")
                        end
                    end
                end
            end
            --【 𝗦𝗽𝗮𝗺 𝗠𝗮𝗻𝗮𝗴𝗲𝗺𝗲𝗻𝘁 】--
            if TYPE == 2 and TRIPOD.AntiSpamVehicle then
                if SV_VEHICLES[HWID] ~= nil then
                    SV_VEHICLES[HWID].COUNT = SV_VEHICLES[HWID].COUNT + 1
                    if os.time() - SV_VEHICLES[HWID].TIME >= 10 then
                        SV_VEHICLES[HWID] = nil
                    else
                        if SV_VEHICLES[HWID].COUNT >= TRIPOD.MaxVehicle then
                            for _, vehilce in ipairs(GetAllVehicles()) do
                                local ENO = NetworkGetFirstEntityOwner(vehilce)
                                if ENO == OWNER then
                                    if DoesEntityExist(vehilce) then
                                       DeleteEntity(vehilce)
                                    end
                                end
                            end
                            TRIPOD_ACTION(OWNER, TRIPOD.SpamPunishment, "Anti Spam Vehicle", "Try For Spam "..SV_VEHICLES[HWID].COUNT.."")
                        end
                    end
                else
                    SV_VEHICLES[HWID] = {
                        COUNT = 1,
                        TIME  = os.time()
                    }
                end
            elseif TYPE == 1 and TRIPOD.AntiSpamPed then
                if SV_PEDS[HWID] ~= nil then
                    SV_PEDS[HWID].COUNT = SV_PEDS[HWID].COUNT + 1
                    if os.time() - SV_PEDS[HWID].TIME >= 10 then
                        SV_PEDS[HWID] = nil
                    else
                        for _, peds in ipairs(GetAllPeds()) do
                            local ENO = NetworkGetFirstEntityOwner(peds)
                            if ENO == OWNER then
                                if DoesEntityExist(peds) then
                                    DeleteEntity(peds)
                                end
                            end
                        end
                        if SV_PEDS[HWID].COUNT >= TRIPOD.MaxPed then
                            TRIPOD_ACTION(OWNER, TRIPOD.SpamPunishment, "Anti Spam Ped", "Try For Spam "..SV_PEDS[HWID].COUNT.."")  
                        end
                    end
                else
                    SV_PEDS[HWID] = {
                        COUNT = 1,
                        TIME  = os.time()
                    }
                end
            elseif TYPE == 3 and TRIPOD.AntiSpamObject then
                if SV_OBJECT[HWID] ~= nil then
                    SV_OBJECT[HWID].COUNT = SV_OBJECT[HWID].COUNT + 1
                    if os.time() - SV_OBJECT[HWID].TIME >= 10 then
                        SV_OBJECT[HWID] = nil
                    else
                        if SV_OBJECT[HWID].COUNT >= TRIPOD.MaxObject then
                            for _, objects in ipairs(GetAllObjects()) do
                                local ENO = NetworkGetFirstEntityOwner(objects)
                                if ENO == OWNER then
                                    if DoesEntityExist(objects) then
                                        DeleteEntity(objects)
                                    end
                                end
                            end
                            TRIPOD_ACTION(OWNER, TRIPOD.SpamPunishment, "Anti Spam Object", "Try For Spam "..SV_OBJECT[HWID].COUNT.." Objects")
                        end
                    end
                else
                    SV_OBJECT[HWID] = {
                        COUNT = 1,
                        TIME  = os.time()
                    }
                end
            end
        end
    end
end)

--【 𝗙𝘂𝗻𝗰𝘁𝗶𝗼𝗻 】--
function StartAntiCheat()
        local tripod_config     =  LoadResourceFile(GetCurrentResourceName(), "configs/tripod-config.lua")
        local tripod_event      =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-event.lua")
        local tripod_explosions =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-explosions.lua")
        local tripod_name       =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-name.lua")
        local tripod_object     =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-object.lua")
        local tripod_peds       =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-peds.lua")
        local tripod_plate      =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-plate.lua")
        local tripod_vehicle    =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-vehicle.lua")
        local tripod_weapon     =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-weapon.lua")
        local tripod_words      =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-words.lua")
        local tripod_task       =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-task.lua")
        local tripod_anim       =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-anim.lua")
        local tripod_emoji      =  LoadResourceFile(GetCurrentResourceName(), "tables/tripod-emoji.lua")
        local tripod_white      =  LoadResourceFile(GetCurrentResourceName(), "whitelists/tripod-white.lua")
        if
        tripod_config and
        tripod_event and
        tripod_explosions and
        tripod_name and
        tripod_object and
        tripod_peds and
        tripod_plate and
        tripod_vehicle and
        tripod_weapon and
        tripod_words and
        tripod_white and
        tripod_task and
        tripod_anim and
        tripod_emoji
        then
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-config.lua     LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-event.lua      LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-explosions.lua LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-name.lua       LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-anim.lua       LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-task.lua       LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-emoji.lua      LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-object.lua     LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-peds.lua       LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-plate.lua      LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-vehicle.lua    LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-weapon.lua     LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-words.lua      LOADED !^0")
    print("^"..COLORS.."[TRIPOD]^0: ^2 tripod-white.lua      LOADED !^0")
    print("^"..COLORS.."")
        PerformHttpRequest("http://localhost:"..TRIPOD.ServerConfig.Port.."/info.json", function(ERROR, DATA, RESULT)
            if DATA ~= nil then
                local TABLE = json.decode(DATA)
                local ART1 = TABLE["server"]
                local ART2 = string.gsub(ART1, "FXServer", " ")
                local ART3 = string.gsub(ART2, "-master", " ")
                local ART4 = string.gsub(ART3, " SERVER", " ")	
                local ART5 = string.gsub(ART4, "v1.0.0.", " ")
                local ART6 = string.gsub(ART5, "win32", "")
                local ART7 = string.gsub(ART6, " ", "")
                print("^"..COLORS.."[TRIPOD]^0: ^3Server Build : "..ART7.."")
              PerformHttpRequest(TRIPOD.Log.Ban, function(ERROR, DATA, RESULT)
            end, "POST", json.encode({
                embeds = {
                    {
                        author = {
                            name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                            url = "https://discord.gg/",
                            icon_url = ""
                        },
                        footer = {
                            text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                            icon_url = "",
                        },
                        title = "TRIPOD "..TRIPOD.Version.."",
                        description = "**Current Version:** "..TRIPOD.Version.."\n**License:** "..TRIPOD.ServerConfig.Name.."\n**Server Build:** "..ART7.."\nStarted successfully...",
                        color = math.random(0, 16776960)
                    }
                }
            }), {
                ["Content-Type"] = "application/json"
            })
            else
                TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function StartAntiCheat (Server Port is wronge)")
            end
        end)
    else
        print("^"..COLORS.."[TRIPOD]^0: ^1 Some File Of your TRIPOD Not Found! Please Replice or Repair That^0")
        Wait(1000)
        print("^"..COLORS.."[TRIPOD]^0: ^1 Some File Of your TRIPOD Not Found! Please Replice or Repair That^0")
        Wait(1000)
        print("^"..COLORS.."[TRIPOD]^0: ^1 Some File Of your TRIPOD Not Found! Please Replice or Repair That^0")
        Wait(1000)
        print("^"..COLORS.."[TRIPOD]^0: ^1 Some File Of your TRIPOD Not Found! Please Replice or Repair That^0")
        Wait(1000)
        print("^"..COLORS.."[TRIPOD]^0: ^1 Some File Of your TRIPOD Not Found! Please Replice or Repair That^0")
        Wait(1000)
        print("^"..COLORS.."[TRIPOD]^0: ^1 Some File Of your TRIPOD Not Found! Please Replice or Repair That^0")
    end
end

function TRIPOD_ISNEARADMIN(SRC)
    if tonumber(SRC) ~= nil then
        local RESULT = false
        local P_DATA = GetPlayers()
        local MY_PED  = GetPlayerPed(SRC)
        local MY_POS  = GetEntityCoords(MY_PED)
        for index, value in ipairs(P_DATA) do
            local IS_ADMIN = TRIPOD_GETADMINS(value)
            if IS_ADMIN then
                local ADMIN_PED = GetPlayerPed(value)
                local ADMIN_POS = GetEntityCoords(ADMIN_PED)
                if #(MY_POS - ADMIN_POS) < 30 then
                    RESULT = true
                else
                    RESULT = false
                end
            end
        end
        return RESULT
    else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_WHITELIST (SRC Not Found)")
    end
end

function TRIPOD_WHITELIST(SRC)
    if tonumber(SRC) ~= nil then
        local IS_WHITELIST = false
        local STEAM   = "Not Found"
        local DISCORD = "Not Found"
        local FIVEML  = "Not Found"
        local LIVE    = "Not Found"
        local XBL     = "Not Found"
        local IP     = GetPlayerEndpoint(SRC)
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end
        for _, value in ipairs(WhiteList) do
            if value == STEAM or value == DISCORD or value == FIVEML or value == LIVE or value == XBL or value == IP then
                IS_WHITELIST = true
            end
        end
        return IS_WHITELIST
    else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_WHITELIST (SRC Not Found)")
    end
end

function TRIPOD_GETADMINS(SRC)
    if tonumber(SRC) ~= nil then
        local ISADMIN = false
        local STEAM   = "Not Found"
        local DISCORD = "Not Found"
        local FIVEML  = "Not Found"
        local LIVE    = "Not Found"
        local XBL     = "Not Found"
        local IP     = GetPlayerEndpoint(SRC)
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end
        for _, value in ipairs(Admins) do
            if value == STEAM or value == DISCORD or value == FIVEML or value == LIVE or value == XBL or value == IP then
                ISADMIN = true
            end
        end
        return ISADMIN
    else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_GETADMINS (SRC Not Found)")
    end
end

function TRIPOD_UNBANACCESS(SRC)
    if tonumber(SRC) ~= nil then
        local ISADMIN = false
        local STEAM   = "Not Found"
        local DISCORD = "Not Found"
        local FIVEML  = "Not Found"
        local LIVE    = "Not Found"
        local XBL     = "Not Found"
        local IP     = GetPlayerEndpoint(SRC)
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end
        for _, value in ipairs(UnBan) do
            if value == STEAM or value == DISCORD or value == FIVEML or value == LIVE or value == XBL or value == IP then
                ISADMIN = true
            end
        end
        return ISADMIN
    else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_UNBANACCESS (SRC Not Found)")
    end
end

function TRIPOD_ERROR(SERVER_NAME, ERROR)
    if SERVER_NAME ~= nil then
        if ERROR ~= nil then
            PerformHttpRequest(TRIPOD.Log.Error, function(ERROR, DATA, RESULT)
            end, "POST", json.encode({
                embeds = {
                    {
                        author = {
                            name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                            url = "https://discord.gg/",
                            icon_url = ""
                        },
                        footer = {
                            text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                            icon_url = "",
                        },
                        title = ""..Emoji.Warn.." Warning "..Emoji.Warn.."",
                        description = "**Error**: `"..ERROR.."`\n**License:** "..SERVER_NAME.."",
                        color = 1769216
                    }
                }
            }), {
                ["Content-Type"] = "application/json"
            })
            else
            TRIPOD_ERROR(SERVER_NAME, "function TRIPOD_ERROR (ERROR Not Found)")
        end
    else
        TRIPOD_ERROR(SERVER_NAME, "function TRIPOD_ERROR (SERVER_NAME Not Found)")
    end
end

function TRIPOD_BAN(SRC, REASON)
    local BANFILE = LoadResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json")
    if BANFILE ~= nil then
        local TABLE = json.decode(BANFILE)
        if TABLE and type(TABLE) == "table" then

            local STEAM   = "N/A"
            local DISCORD = "N/A"
            local FIVEML  = "N/A"
            local LIVE    = "N/A"
            local XBL     = "N/A"
            local IP = GetPlayerEndpoint(SRC)
            for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
                if DATA:match("steam") then
                    STEAM = DATA
                elseif DATA:match("discord") then
                    DISCORD = DATA:gsub("discord:", "")
                elseif DATA:match("license") then
                    FIVEML = DATA
                elseif DATA:match("live") then
                    LIVE = DATA
                elseif DATA:match("xbl") then
                    XBL = DATA
                end
            end
            local BANLIST = {
                ["STEAM"]   = STEAM,
                ["DISCORD"] = DISCORD,  
                ["LICENSE"] = FIVEML,
                ["LIVE"]    = LIVE,
                ["XBL"]     = XBL,
                ["IP"]      = IP,
				["HWID"]    = GetPlayerToken(SRC, 0),
				["BANID"] = "#"..math.random(tonumber(1000), tonumber(9999)).."",
				["REASON"] = REASON
            }
            Wait(1000)
            if not TRIPOD_INBANLIST(SRC) then
				table.insert(TABLE, BANLIST)
				SaveResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json", json.encode(TABLE, {indent = true}), tonumber("-1"))
			end
        else
            TRIPOD_RELOADFILE()
        end
    else
        TRIPOD_RELOADFILE()
    end
end

function TRIPOD:UNBAN(BanID)
    local p = promise.new()
    if tonumber(BanID) then
        local BANFILE = LoadResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json")
        if BANFILE ~= nil then
            local TABLE = json.decode(BANFILE)
            if TABLE ~= nil and type(TABLE) == "table" then
                for index, data in ipairs(TABLE)	do
                    if data.BANID == "#"..tonumber(BanID).."" then
                        table.remove(TABLE, index)
                        p:resolve(true)
                        Wait(0)
                        SaveResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json", json.encode(TABLE, {indent = true}), tonumber("-1"))
                    else
                        p:resolve(false)
                    end
                end
            else
                TRIPOD_RELOADFILE() p:resolve(false)
            end
        else
            TRIPOD_RELOADFILE() p:resolve(false)
        end
    end
    return Citizen.Await(p)
end

function TRIPOD_INBANLIST(SRC)
    local DEFULT = false
    local BANFILE = LoadResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json")
    if BANFILE ~= nil then
        local TABLE = json.decode(BANFILE)
        if TABLE ~= nil and type(TABLE) == "table" then
            if tonumber(SRC) ~= nil then
                local STEAM   = "Not Found"
                local DISCORD = "Not Found"
                local FIVEML  = "Not Found"
                local LIVE    = "Not Found"
                local XBL     = "Not Found"
                local IP      = GetPlayerEndpoint(SRC)
                for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
                    if DATA:match("steam") then
                        STEAM = DATA
                    elseif DATA:match("discord") then
                        DISCORD = DATA:gsub("discord:", "")
                    elseif DATA:match("license") then
                        FIVEML = DATA
                    elseif DATA:match("live") then
                        LIVE = DATA
                    elseif DATA:match("xbl") then
                        XBL = DATA
                    end
                end
                for i = 0, GetNumPlayerTokens(SRC) do
                    for _, BANLIST in ipairs(TABLE)	do
                        if
                        BANLIST.STEAM == STEAM or
                        BANLIST.DISCORD == DISCORD or
                        BANLIST.LICENSE == FIVEML or
                        BANLIST.LIVE == LIVE or
                        BANLIST.XBL == XBL or
                        BANLIST.HWID ==  GetPlayerToken(SRC, i) or
                        BANLIST.IP == IP then
                            DEFULT = true
                        end
                    end
                end
            end
        else
            TRIPOD_RELOADFILE()
        end
    else
        TRIPOD_RELOADFILE()
    end
    return DEFULT
end

function TRIPOD_RELOADFILE()
	local BANFILE = LoadResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json")
	if not BANFILE or BANFILE == "" then
		SaveResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json", "[]", tonumber("-1"))
		print("^"..COLORS.."TRIPOD^0: ^3Warning! ^0Your ^1TRIPOD.json ^0is missing, Regenerating your ^1TRIPOD.json ^0file!")
	else	
		local JSON_TABLE = json.decode(BANFILE)
		if JSON_TABLE == nil then
			print("\27[101;93m^"..COLORS.."TRIPOD:\27[0m^1Error Was Detection in line 317 plase connect our support team in TRIPOD Discord")
			TRIPODError("Error Was Detection in line **317**")
			print("\27[101;93m YOUR TEXT HERE \27[0m")
		end
		if not JSON_TABLE then
			SaveResourceFile(GetCurrentResourceName(), "banlist/TRIPOD.json", "[]", tonumber("-1"))
			JSON_TABLE = {}
			print("^"..COLORS.."TRIPOD^0: ^3Warning! ^0Your ^1TRIPOD.json ^0is corrupted, Regenerating your ^1TRIPOD.json ^0file!")
		end
	end
end

function TRIPOD_ACTION(SRC, ACTION, REASON, DETAILS)
    if REASON ~= nil and DETAILS ~= nil then
        if tonumber(SRC) ~= nil and tonumber(SRC) > 0 and GetPlayerName(SRC) ~= nil then
            if not TRIPOD_WHITELIST(SRC) and not TRIPOD_IS_SPAMLIST(SRC, ACTION, REASON, DETAILS) then
                if ACTION == "WARN" or ACTION == "KICK" or ACTION == "BAN" then
                    if TRIPOD.ScreenShot.Enable == true then
                        if TRIPOD.ScreenShot.Log ~= "" and TRIPOD.ScreenShot.Log ~= nil then
                            TRIPOD_SCREENSHOT(SRC, REASON, DETAILS, ACTION)
                        else
                            TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_ACTION (TRIPOD.ScreenShot.Log is nil)")
                        end
                    end
                    if ACTION == "WARN" then
                        TRIPOD_SENDLOG(SRC, TRIPOD.Log.Ban, ACTION, REASON, DETAILS)
                        TRIPOD_MEESAGE(SRC, ACTION, GetPlayerName(SRC), REASON)
                    elseif ACTION == "KICK" then
                        print("^"..COLORS.."TRIPOD^0: ^1Player ^3"..GetPlayerName(SRC).." ^3Kicked From Server ^0| ^3Reason: ^3 "..REASON.."^0")
                        TRIPOD_SENDLOG(SRC, TRIPOD.Log.Ban, ACTION, REASON, DETAILS)
                        TRIPOD_MEESAGE(SRC, ACTION, GetPlayerName(SRC), REASON)
                        DropPlayer(SRC, "\n["..Emoji.tripod.." TRIPOD "..Emoji.tripod.."]\n"..TRIPOD.Message.Kick.."\nReason: "..REASON.."")
                    elseif ACTION == "BAN" then
                        print("^"..COLORS.."TRIPOD^0: ^1Player ^3"..GetPlayerName(SRC).." ^1Banned From Server ^0| ^1Reason: ^3 "..REASON.."^0")
                        TRIPOD_SENDLOG(SRC, TRIPOD.Log.Ban, ACTION, REASON, DETAILS)
                        TRIPOD_MEESAGE(SRC, ACTION, GetPlayerName(SRC), REASON)
                        TRIPOD_BAN(SRC, REASON)
                        DropPlayer(SRC, "\n["..Emoji.tripod.." TRIPOD "..Emoji.tripod.."]\n".. TRIPOD.Message.Ban .."\nReason: "..REASON.."")
                    end
                else
	    	    	print("^"..COLORS.."TRIPOD^0: ^3Warning! ^0invalid type of punishment :^1"..ACTION.."^0!")
                end
            end
        end
    else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_ACTION (REASON and DETAILS Not Found)")
    end
end

function TRIPOD_MEESAGE(SRC, TYPE, NAME, REASON)
    if TYPE ~= nil then
        if NAME ~= nil then
            if REASON ~= nil then
                if TYPE == "WARN" then
                    if TRIPOD.PrivateWarn then
                        for _, playerId in ipairs(GetPlayers()) do
                           if TRIPOD_GETADMINS(playerId) then
                            TriggerClientEvent('chat:addMessage', playerId, {
                                template = '<div style="padding: 0.5vw; margiDATA: 0.5vw; background-image: url(https://cdn.discordapp.com/attachments/905814226118008923/1045778789537419284/red.png); border-radius: 13px;"><i class="far fa-newspaper"></i> '..Emoji.tripod..' TRIPOD '..Emoji.tripod..' :<br>  {1}</div>',
                                args = {"Console", ""..Emoji.Warn.." Warning | Player ^1".. NAME .."(".. SRC ..")^0 Cheating From Server : ^5".. REASON .. " " }
                            })
                           end
                        end
                    else
                        TriggerClientEvent('chat:addMessage', -1, {
                            template = '<div style="padding: 0.5vw; margiDATA: 0.5vw; background-image: url(https://cdn.discordapp.com/attachments/905814226118008923/1045778789537419284/red.png); border-radius: 13px;"><i class="far fa-newspaper"></i> '..Emoji.tripod..' TRIPOD '..Emoji.tripod..' :<br>  {1}</div>',
                            args = {"Console", ""..Emoji.Warn.." Warning | Player ^1".. NAME .."(".. SRC ..")^0 Cheating From Server : ^5".. REASON .. " " }
                        })
                    end
                    elseif TYPE == "KICK" then
                    TriggerClientEvent('chat:addMessage', -1, {
                        template = '<div style="padding: 0.5vw; margiDATA: 0.5vw; background-image: url(https://cdn.discordapp.com/attachments/905814226118008923/1045778771975880784/orenge.png); border-radius: 13px;"><i class="far fa-newspaper"></i> '..Emoji.tripod..' TRIPOD '..Emoji.tripod..' <br>  {1}</div>',
                        args = {"Console", ""..Emoji.Kick.." Kick | Player ^1".. NAME .."(".. SRC ..")^0 Cheating From Server : ^5".. REASON .. " " }
                    })
                    elseif TYPE == "BAN" then
                    TriggerClientEvent('chat:addMessage', -1, {
                        template = '<div style="padding: 0.5vw; margiDATA: 0.5vw; background-image: url(https://cdn.discordapp.com/attachments/905814226118008923/1045778782545518612/black.png); border-radius: 13px;"><i class="far fa-newspaper"></i> '..Emoji.tripod..' TRIPOD '..Emoji.tripod..' <br>  {1}</div>',
                        args = {"Console", ""..Emoji.Ban.." Banned | Player ^1".. NAME .."(".. SRC ..")^0 Cheating From Server : ^5".. REASON .. " " }
                    })
                end
            else
                TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_MEESAGE (REASON Not Found)")
            end
            else
            TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_MEESAGE (NAME Not Found)")
        end
    else
        TRIPOD_ERROR(TRIPOD.ServerConfig.Name, "function TRIPOD_MEESAGE (TYPE Not Found)")
    end
end

function TRIPOD_SENDLOG(SRC, URL, TYPE, REASON, DETAILS)
    if URL ~= nil and GetPlayerName(SRC) ~= nil and tonumber(SRC) then
        local NAME    = GetPlayerName(SRC)
        local COORDS  = GetEntityCoords(GetPlayerPed(SRC))
        local STEAM   = "Not Found"
        local DISCORD = "Not Found"
        local FIVEML  = "Not Found"
        local LIVE    = "Not Found"
        local XBL     = "Not Found"
        local ISP     = "Not Found"
        local CITY    = "Not Found"
        local COUNTRY = "Not Found"
        local PROXY   = "Not Found"
        local HOSTING = "Not Found"
        local LON     = "Not Found"
        local LAT     = "Not Found"
        local IP      = GetPlayerEndpoint(SRC)
        IP = (string.gsub(string.gsub(string.gsub(IP,  "-", ""), ",", ""), " ", ""):lower())
        local g, f = IP:find(string.lower("192.168"))
        if g or f then
           IP = "178.131.122.181"
        end
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end
        if DISCORD ~= "Not Found" then
            DISCORD = "<@"..DISCORD..">"
        else
            DISCORD = "Not Found"
        end
        PerformHttpRequest("http://ip-api.com/json/"..IP.."?fields=66846719", function(ERROR, DATA, RESULT)
            if DATA ~= nil then
                local TABLE = json.decode(DATA)
                if TABLE ~= nil then
                    ISP     = tostring(TABLE["isp"])
                    CITY    = tostring(TABLE["city"])
                    COUNTRY = tostring(TABLE["country"])
                    if TABLE["proxy"] == true then
                        PROXY   =  "ON"
                    else
                        PROXY   = "OFF"
                    end
                    if TABLE["hosting"] == true then
                        HOSTING   =  "ON"
                    else
                        HOSTING   = "OFF"
                    end
                    LON     = TABLE["lon"]
                    LAT     = TABLE["lat"]
                    if TYPE == "CONNECT" and CITY ~= nil then
                       PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "https://discord.gg/",
                                        icon_url = ""
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.Connect.." Connecting "..Emoji.Connect.."",
                                    description = "**Player:** "..NAME.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 1769216
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    elseif TYPE == "DISCONNECT" then
                        PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "https://discord.gg/",
                                        icon_url = ""
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.Disconnect.." Disconnect "..Emoji.Disconnect.."",
                                    description = "**Player:** "..NAME.."\n**Reason:**: "..REASON.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 16711680
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    elseif TYPE == "BAN" then
                        PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "https://discord.gg/",
                                        icon_url = ""
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.Ban.." Banned "..Emoji.Ban.."",
                                    description = "**Player:** "..NAME.."\n**Reason:**: "..REASON.."\n**Details:** "..DETAILS.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 16711680
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    elseif TYPE == "KICK" then
                        PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "https://discord.gg/",
                                        icon_url = ""
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.Kick.." Kicked "..Emoji.Kick.."",
                                    description = "**Player:** "..NAME.."\n**Reason:**: "..REASON.."\n**Details:** "..DETAILS.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 16760576
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    elseif TYPE == "WARN" then
                        PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "",
                                        icon_url = ""
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.Warn.." Warning "..Emoji.Warn.."",
                                    description = "**Player:** "..NAME.."\n**Reason:**: "..REASON.."\n**Details:** "..DETAILS.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 1769216
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    elseif TYPE == "EXPLOSION" then
                        PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "",
                                        icon_url = ""
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.Exoplosion.." Explosion "..Emoji.Exoplosion.."",
                                    description = "**Player:** "..NAME.."\n**Explosion Type:**: "..REASON.."\n**Coords:** "..COORDS.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 16711680
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    elseif TYPE == "TFJ" then
                        PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "",
                                        icon_url = ""
                                    },
                                    image =  {
                                        url = "https://cache.ip-api.com/"..LON..","..LAT..",10",
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.TFJ.." Try For Join "..Emoji.TFJ.."",
                                    description = "**Player:** "..NAME.."\n**Ban ID:** "..REASON.."\n**Details:** "..DETAILS.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 15844367
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    elseif TYPE == "BLN" then
                        PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "",
                                        icon_url = ""
                                    },
                                    image =  {
                                        url = "https://cache.ip-api.com/"..LON..","..LAT..",10",
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.BLN.." Black List Name Found ! "..Emoji.BLN.."",
                                    description = "**Player:** "..NAME.."\n**Reason:** "..REASON.."\n**Details:** "..DETAILS.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 16711680
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    elseif TYPE == "VPN" then
                        PerformHttpRequest(URL, function(ERROR, DATA, RESULT)
                        end, "POST", json.encode({
                            embeds = {
                                {
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        url = "",
                                        icon_url = ""
                                    },
                                    image =  {
                                        url = "https://cache.ip-api.com/"..LON..","..LAT..",10",
                                    },
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                    title = ""..Emoji.VPN.." VPN Blocked "..Emoji.VPN.."",
                                    description = "**Player:** "..NAME.."\n**Details:** Try For Join By VPN\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    color = 10181046
                                }
                            }
                        }), {
                            ["Content-Type"] = "application/json"
                        })
                    end
                else
                    TRIPOD_ERROR(TRIPOD.ServerConfig.Name, " TRIPOD_SENDLOG (in IP API DATA Not Found )")
                end
            end
        end)
    else
        print("^"..COLORS.."TRIPOD^0: ^3Your Discord Webhok Not Set for send it!")
    end
end

function TRIPOD_REFRESHCMD()
    local CMDS = GetRegisteredCommands()
    for index, CMD in ipairs(CMDS) do
        if SERVER_CMDS ~= nil then
            table.insert(SERVER_CMDS, CMD)
        else
            SERVER_CMDS = {}
            table.insert(SERVER_CMDS, CMD)
        end
    end
end

function TRIPOD_ISPLAYERLOAD(source)
    local SRC    = tonumber(source)
    local PED    = GetPlayerPed(SRC)
    local STATUS = false
    if SRC ~= nil then
       if DoesEntityExist(PED) then
            if SPAWNED[SRC] ~= nil then
                STATUS = true
            else
                STATUS = false
            end
            else
                STATUS = false
            end
        else
        STATUS = false
    end
    return STATUS
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for index in pairs (SPAMLIST) do
            SPAMLIST[index] = nil
        end
        Citizen.Wait(0)
    end
end)

function TRIPOD_ADD_SPAMLIST(SRC, ACTION, REASON, DETAILS)
    if tonumber(SRC) then
        if ACTION and REASON and DETAILS then
            if ACTION ~= "BAN" or ACTION ~= "KICK" then
                table.insert(SPAMLIST, {
                    ID      = SRC,
                    REASON  = REASON,
                    DETAILS = DETAILS,
                })
            end
        end
    end
end

function TRIPOD_IS_SPAMLIST(SRC, ACTION, REASON, DETAILS)
    local status = false
    if tonumber(SRC) then
        if SPAMLIST[SRC] ~= nil then
            for i = 1, #SPAMLIST do
               if SPAMLIST[i] ~= nil then
                if SPAMLIST[i].SRC == SRC then
                    if SPAMLIST[i].REASON == REASON and SPAMLIST[i].DETAILS == DETAILS then
                        status = true
                    else
                        status = false
                    end
                else
                    status = false
                end
                else
                status = false
               end
            end
        else
            status = false
        end
    end
    return status
end


function TRIPOD_SCREENSHOT(SRC, REASON, DETAILS, ACTION)
    if tonumber(SRC) ~= nil then
        if REASON ~= nil and DETAILS ~= nil and ACTION ~= nil then
        local COLORS = {
            WARN = 1769216,
            KICK = 16760576,
            BAN  = 16711680,
        }
        local SSO = {
            encoding = TRIPOD.ScreenShot.Format,
            quality  = TRIPOD.ScreenShot.Quality
        }
        local NAME    = GetPlayerName(SRC)
        local COORDS  = GetEntityCoords(GetPlayerPed(SRC))
        local PING    = GetPlayerPing(SRC)
        local STEAM   = "Not Found"
        local DISCORD = "Not Found"
        local FIVEML  = "Not Found"
        local LIVE    = "Not Found"
        local XBL     = "Not Found"
        local ISP     = "Not Found"
        local CITY    = "Not Found"
        local COUNTRY = "Not Found"
        local PROXY   = "Not Found"
        local HOSTING = "Not Found"
        local IP      = GetPlayerEndpoint(SRC)
        IP = (string.gsub(string.gsub(string.gsub(IP,  "-", ""), ",", ""), " ", ""):lower())
        local g, f = IP:find(string.lower("192.168"))
        if g or f then
           IP = "178.131.122.181"
        end
        for _, DATA in ipairs(GetPlayerIdentifiers(SRC)) do
            if DATA:match("steam") then
                STEAM = DATA
            elseif DATA:match("discord") then
                DISCORD = DATA:gsub("discord:", "")
            elseif DATA:match("license") then
                FIVEML = DATA
            elseif DATA:match("live") then
                LIVE = DATA
            elseif DATA:match("xbl") then
                XBL = DATA
            end
        end
        if DISCORD ~= "Not Found" then
            DISCORD = "<@"..DISCORD..">"
        else
            DISCORD = "Not Found"
        end
        PerformHttpRequest("http://ip-api.com/json/"..IP.."?fields=66846719", function(ERROR, DATA, RESULT)
            if DATA ~= nil then
                local TABLE = json.decode(DATA)
                    if TABLE ~= nil then
                        ISP     = TABLE["isp"]
                        CITY    = TABLE["city"]
                        COUNTRY = TABLE["country"]
                        if TABLE["proxy"] == true then
                            PROXY   =  "ON"
                        else
                            PROXY   = "OFF"
                        end
                        if TABLE["hosting"] == true then
                            HOSTING   =  "ON"
                        else
                            HOSTING   = "OFF"
                        end
                        exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(SRC, TRIPOD.ScreenShot.Log, SSO, {
                            username = ""..Emoji.tripod.." TRIPOD "..Emoji.tripod.."",
                            avatar_url = "",
                            embeds = {
                                {
                                    color = COLORS[ACTION],
                                    author = {
                                        name = ""..Emoji.tripod.."| TRIPOD™ | "..Emoji.tripod.."",
                                        icon_url = ""
                                    },
                                    title = "Screenshot",
                                    description = "**Player:** "..NAME.."\n**ID:** "..SRC.."\n**Reason:** "..REASON.."\n**Steam Hex:** "..STEAM.."\n**Discord:** "..DISCORD.."\n**License:** "..FIVEML.."\n**Live:** "..LIVE.."\n**Xbox:** "..XBL.."\n**ISP:** "..ISP.."\n**Country:** "..COUNTRY.."\n**City:** "..CITY.."\n**Ping:** ".. PING .."\n**IP:** "..IP.."\n**VPN:** "..PROXY.."\n**Hosting:** "..HOSTING.."",
                                    footer = {
                                        text = "TRIPOD V1 "..Emoji.tripod.." | "..os.date("%Y/%m/%d | %X").."",
                                        icon_url = "",
                                    },
                                }
                            }
                        })
                    end
                end
            end)
        end
    end
end

RegisterCommand('funban', function (source, args)
    local BAN_ID = args[1]
    if source == 0 then
        local unbaned = TRIPOD:UNBAN(BAN_ID)
        if unbaned then
            print("^"..COLORS.."[TRIPOD]^0: You unbanned ^2"..BAN_ID.."^0 !")
        else
            print("^"..COLORS.."[TRIPOD]^0: ^1 our unbanned failed !^0")    
        end
    else
        if TRIPOD_UNBANACCESS(source) then
            local unbaned = TRIPOD:UNBAN(BAN_ID)
            if unbaned then
                TriggerClientEvent("chatMessage", source, "[TRIPOD]", {255, 0, 0}, "You unbanned ^2"..BAN_ID.."^0 !")
            else
                TriggerClientEvent("chatMessage", source, "[TRIPOD]", {255, 0, 0}, "Your unbanned failed !")
            end
        else
            TriggerClientEvent("chatMessage", source, "[TRIPOD]", {255, 0, 0}, "You don't have access for unban players !")
        end
    end
end)
