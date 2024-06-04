HXSet = {}

local var0 = HXSet

var0.codeModeKey = "hx_code_mode"

if PLATFORM_CODE == PLATFORM_CH then
	var0.codeMode = false
	var0.antiSkinMode = true
else
	var0.codeMode = true
	var0.antiSkinMode = true
end

var0.nameCodeMap = {}
var0.nameEquipCodeMap = {}
var0.nameCodeMap_EN = {
	IJN = "IJN"
}

function var0.init()
	for iter0, iter1 in pairs(pg.name_code) do
		local var0

		if iter1.type == 1 then
			var0 = var0.nameCodeMap
		elseif iter1.type == 2 then
			var0 = var0.nameEquipCodeMap
		else
			assert(false)
		end

		var0[iter1.name] = iter1.code
	end

	if pg.gameset.code_switch.key_value == 1 and PlayerPrefs.HasKey(var0.codeModeKey) then
		var0.codeMode = PlayerPrefs.GetInt(var0.codeModeKey) == 1
	end

	if PLATFORM_CODE == PLATFORM_CH then
		local var1

		if IsUnityEditor then
			var1 = PathMgr.getAssetBundle("../localization.txt")
		else
			var1 = Application.persistentDataPath .. "/localization.txt"
		end

		if PathMgr.FileExists(var1) then
			local var2 = PathMgr.ReadAllLines(var1)

			if string.gsub(var2[0], "%w+%s*=%s*", "") == "true" then
				var0.codeMode = true
			end

			local var3 = "Localization_skin = false"

			if var2.Length <= 1 then
				local var4 = {
					var2[0],
					var3
				}
			else
				var3 = var2[1]
			end

			if string.gsub(var3, "[_%w]+%s*=%s*", "") == "true" then
				var0.antiSkinMode = true
			end
		else
			System.IO.File.WriteAllText(var1, "Localization = false\nLocalization_skin = false")
		end
	end

	var0.update()
end

function var0.calcLocalizationUse()
	if PLATFORM_CODE == PLATFORM_CH then
		local var0 = "localization_use"

		if PlayerPrefs.HasKey(var0) then
			PlayerPrefs.DeleteKey(var0)
		end

		local var1 = pg.TimeMgr.GetInstance()
		local var2 = getProxy(PlayerProxy):getData().id
		local var3 = "localization_time_1_" .. var2
		local var4 = PlayerPrefs.GetInt(var3, 0)

		if var0.codeMode and not var1:IsSameDay(var4, var1:GetServerTime()) then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = CC_TYPE_99
			})
			PlayerPrefs.SetInt(var3, var1:GetServerTime())
		end

		local var5 = "localization_time_2_" .. var2
		local var6 = PlayerPrefs.GetInt(var5, 0)

		if var0.antiSkinMode and not var1:IsSameDay(var6, var1:GetServerTime()) then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = CC_TYPE_100
			})
			PlayerPrefs.SetInt(var5, var1:GetServerTime())
		end
	end
end

function var0.switchCodeMode()
	if pg.gameset.code_switch.key_value == 1 or var0.codeMode then
		var0.codeMode = not var0.codeMode

		PlayerPrefs.SetInt(var0.codeModeKey, var0.codeMode and 1 or 0)
		PlayerPrefs.Save()
		var0.update()
		originalPrint("anti hx mode: " .. (var0.codeMode and "on" or "off"))
	end
end

function var0.isHXNation(arg0)
	var0.nationHX = var0.nationHX or {
		[Nation.US] = true,
		[Nation.JP] = true,
		[Nation.DE] = true,
		[Nation.CN] = true,
		[Nation.ITA] = true,
		[Nation.SN] = true,
		[Nation.MNF] = true,
		[Nation.META] = true
	}

	return var0.nationHX[arg0]
end

function var0.update()
	local var0 = var0.codeMode and {} or var0.nameCodeMap
	local var1 = var0.codeMode and {} or var0.nameEquipCodeMap
	local var2 = var0.codeMode and {} or var0.nameCodeMap_EN
	local var3 = pg.ship_data_statistics

	pg.ship_data_statistics = setmetatable({}, {
		__index = function(arg0, arg1)
			local var0 = var3[arg1]

			if var0 == nil then
				return var0
			elseif var0.name == nil then
				arg0[arg1] = var0

				return arg0[arg1]
			end

			arg0[arg1] = {}

			if var0.isHXNation(var0.nationality) and var0[var0.name] then
				arg0[arg1].name = var0[var0.name]
			end

			if var0.english_name and #var0.english_name > 0 then
				arg0[arg1].english_name = var0.english_name

				for iter0, iter1 in pairs(var2) do
					arg0[arg1].english_name = string.gsub(arg0[arg1].english_name or "", iter0, iter1)
				end
			end

			setmetatable(arg0[arg1], {
				__index = var0
			})

			return arg0[arg1]
		end
	})

	local var4 = pg.fleet_tech_ship_class

	pg.fleet_tech_ship_class = setmetatable({}, {
		__index = function(arg0, arg1)
			local var0 = var4[arg1]

			if var0 == nil then
				return var0
			elseif var0.name == nil then
				arg0[arg1] = var0

				return arg0[arg1]
			end

			local var1, var2 = string.gsub(var0.name, "级", "")

			if var0.isHXNation(var0.nation) and var0[var1] then
				arg0[arg1] = setmetatable({
					name = var0[var1] .. (var2 > 0 and "级" or "")
				}, {
					__index = var0
				})
			else
				arg0[arg1] = var0
			end

			return arg0[arg1]
		end
	})

	local var5 = pg.enemy_data_statistics

	pg.enemy_data_statistics = setmetatable({}, {
		__index = function(arg0, arg1)
			local var0 = var5[arg1]

			if var0 == nil then
				return var0
			elseif var0.name == nil then
				arg0[arg1] = var0

				return arg0[arg1]
			end

			if var0.isHXNation(var0.nationality) and var0[var0.name] then
				arg0[arg1] = setmetatable({
					name = var0[var0.name]
				}, {
					__index = var0
				})
			else
				arg0[arg1] = var0
			end

			return arg0[arg1]
		end
	})

	local var6 = pg.equip_data_statistics

	pg.equip_data_statistics = setmetatable({}, {
		__index = function(arg0, arg1)
			local var0 = var6[arg1]

			if var0 == nil then
				return var0
			elseif var0.name == nil then
				arg0[arg1] = var0

				return arg0[arg1]
			end

			if var1[var0.name] then
				arg0[arg1] = setmetatable({
					name = var1[var0.name]
				}, {
					__index = var0
				})
			else
				arg0[arg1] = var0
			end

			return arg0[arg1]
		end
	})
end

function var0.hxLan(arg0, arg1)
	return string.gsub(arg0 or "", "{namecode:(%d+).-}", function(arg0)
		local var0 = pg.name_code[tonumber(arg0)]

		return var0 and ((var0.codeMode or arg1) and var0.name or var0.code)
	end)
end

function var0.isHx()
	return not var0.codeMode
end

function var0.isHxSkin()
	return not var0.antiSkinMode
end

function var0.isHxPropose()
	return not var0.codeMode and PLATFORM_CODE == PLATFORM_CH and LOCK_PROPOSE_SHIP
end

var0.hxPathList = {
	"live2d",
	"painting",
	"shipYardIcon",
	"paintingface",
	"char",
	"shipmodels",
	"technologycard",
	"shipdesignicon",
	"herohrzicon",
	"skinunlockanim"
}
var0.folderBundle = {
	"paintingface"
}

function var0.needShift(arg0)
	for iter0, iter1 in ipairs(var0.hxPathList) do
		if string.find(arg0, iter1) then
			return true
		end
	end

	return false
end

function var0.isFolderBundle(arg0)
	for iter0, iter1 in ipairs(var0.folderBundle) do
		if string.find(arg0, iter1) then
			return true
		end
	end

	return false
end

function var0.autoHxShift(arg0, arg1)
	if var0.isHx() then
		if string.find(arg0, "live2d") then
			if checkABExist(arg0 .. arg1 .. "_hx") then
				return arg0, arg1 .. "_hx"
			elseif pg.l2dhx[arg1] then
				return arg0, arg1 .. "_hx"
			end
		end

		if var0.needShift(arg0) then
			local var0 = arg0 .. arg1

			if checkABExist(var0 .. "_hx") then
				return arg0, arg1 .. "_hx"
			end
		end
	end

	return arg0, arg1
end

function var0.autoHxShiftPath(arg0, arg1, arg2)
	if var0.isHx() then
		if string.find(arg0, "live2d") then
			if arg2 then
				local var0 = string.gsub(arg0, "live2d/", "")

				if pg.l2dhx[var0] then
					return arg0 .. "_hx"
				end
			elseif checkABExist(arg0 .. "_hx") then
				return arg0 .. "_hx"
			else
				local var1 = string.gsub(arg0, "live2d/", "")

				if pg.l2dhx[var1] then
					return arg0 .. "_hx"
				end
			end
		end

		if var0.needShift(arg0) and checkABExist(arg0 .. "_hx") then
			if var0.isFolderBundle(arg0) then
				return arg0 .. "_hx", arg1
			elseif arg1 and #arg1 > 0 then
				return arg0 .. "_hx", arg1 .. "_hx"
			else
				return arg0 .. "_hx", arg1
			end
		end
	end

	return arg0, arg1
end

var0.init()
