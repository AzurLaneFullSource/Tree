HXSet = {}

local var0_0 = HXSet

var0_0.codeModeKey = "hx_code_mode"

if PLATFORM_CODE == PLATFORM_CH then
	var0_0.codeMode = false
	var0_0.antiSkinMode = true
else
	var0_0.codeMode = true
	var0_0.antiSkinMode = true
end

var0_0.nameCodeMap = {}
var0_0.nameEquipCodeMap = {}
var0_0.nameCodeMap_EN = {
	IJN = "IJN"
}

function var0_0.init()
	for iter0_1, iter1_1 in ipairs(pg.name_code.all) do
		local var0_1 = pg.name_code[iter1_1]
		local var1_1

		if var0_1.type == 1 then
			var1_1 = var0_0.nameCodeMap
		elseif var0_1.type == 2 then
			var1_1 = var0_0.nameEquipCodeMap
		else
			assert(false)
		end

		var1_1[var0_1.name] = var0_1.code
	end

	if pg.gameset.code_switch.key_value == 1 and PlayerPrefs.HasKey(var0_0.codeModeKey) then
		var0_0.codeMode = PlayerPrefs.GetInt(var0_0.codeModeKey) == 1
	end

	if PLATFORM_CODE == PLATFORM_CH then
		local var2_1

		if IsUnityEditor then
			var2_1 = PathMgr.getAssetBundle("../localization.txt")
		else
			var2_1 = Application.persistentDataPath .. "/localization.txt"
		end

		if PathMgr.FileExists(var2_1) then
			local var3_1 = PathMgr.ReadAllLines(var2_1)

			if string.gsub(var3_1[0], "%w+%s*=%s*", "") == "true" then
				var0_0.codeMode = true
			end

			local var4_1 = "Localization_skin = false"

			if var3_1.Length <= 1 then
				local var5_1 = {
					var3_1[0],
					var4_1
				}
			else
				var4_1 = var3_1[1]
			end

			if string.gsub(var4_1, "[_%w]+%s*=%s*", "") == "true" then
				var0_0.antiSkinMode = true
			end
		else
			System.IO.File.WriteAllText(var2_1, "Localization = false\nLocalization_skin = false")
		end
	end

	var0_0.update()
end

function var0_0.calcLocalizationUse()
	if PLATFORM_CODE == PLATFORM_CH then
		local var0_2 = "localization_use"

		if PlayerPrefs.HasKey(var0_2) then
			PlayerPrefs.DeleteKey(var0_2)
		end

		local var1_2 = pg.TimeMgr.GetInstance()
		local var2_2 = getProxy(PlayerProxy):getData().id
		local var3_2 = "localization_time_1_" .. var2_2
		local var4_2 = PlayerPrefs.GetInt(var3_2, 0)

		if var0_0.codeMode and not var1_2:IsSameDay(var4_2, var1_2:GetServerTime()) then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = CC_TYPE_99
			})
			PlayerPrefs.SetInt(var3_2, var1_2:GetServerTime())
		end

		local var5_2 = "localization_time_2_" .. var2_2
		local var6_2 = PlayerPrefs.GetInt(var5_2, 0)

		if var0_0.antiSkinMode and not var1_2:IsSameDay(var6_2, var1_2:GetServerTime()) then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = CC_TYPE_100
			})
			PlayerPrefs.SetInt(var5_2, var1_2:GetServerTime())
		end
	end
end

function var0_0.switchCodeMode()
	if pg.gameset.code_switch.key_value == 1 or var0_0.codeMode then
		var0_0.codeMode = not var0_0.codeMode

		PlayerPrefs.SetInt(var0_0.codeModeKey, var0_0.codeMode and 1 or 0)
		PlayerPrefs.Save()
		var0_0.update()
		originalPrint("anti hx mode: " .. (var0_0.codeMode and "on" or "off"))
	end
end

function var0_0.isHXNation(arg0_4)
	var0_0.nationHX = var0_0.nationHX or {
		[Nation.US] = true,
		[Nation.JP] = true,
		[Nation.DE] = true,
		[Nation.CN] = true,
		[Nation.ITA] = true,
		[Nation.SN] = true,
		[Nation.MNF] = true,
		[Nation.META] = true
	}

	return var0_0.nationHX[arg0_4]
end

function var0_0.update()
	local var0_5 = var0_0.codeMode and {} or var0_0.nameCodeMap
	local var1_5 = var0_0.codeMode and {} or var0_0.nameEquipCodeMap
	local var2_5 = var0_0.codeMode and {} or var0_0.nameCodeMap_EN
	local var3_5 = pg.ship_data_statistics

	pg._ship_data_statistics = var3_5
	pg.ship_data_statistics = setmetatable({}, {
		__index = function(arg0_6, arg1_6)
			local var0_6 = var3_5[arg1_6]

			if var0_6 == nil then
				return var0_6
			elseif var0_6.name == nil then
				arg0_6[arg1_6] = var0_6

				return arg0_6[arg1_6]
			end

			arg0_6[arg1_6] = {}

			if var0_0.isHXNation(var0_6.nationality) and var0_5[var0_6.name] then
				arg0_6[arg1_6].name = var0_5[var0_6.name]
			end

			if var0_6.english_name and #var0_6.english_name > 0 then
				arg0_6[arg1_6].english_name = var0_6.english_name

				for iter0_6, iter1_6 in pairs(var2_5) do
					arg0_6[arg1_6].english_name = string.gsub(arg0_6[arg1_6].english_name or "", iter0_6, iter1_6)
				end
			end

			setmetatable(arg0_6[arg1_6], {
				__index = var0_6
			})

			return arg0_6[arg1_6]
		end
	})

	local var4_5 = pg.fleet_tech_ship_class

	pg.fleet_tech_ship_class = setmetatable({}, {
		__index = function(arg0_7, arg1_7)
			local var0_7 = var4_5[arg1_7]

			if var0_7 == nil then
				return var0_7
			elseif var0_7.name == nil then
				arg0_7[arg1_7] = var0_7

				return arg0_7[arg1_7]
			end

			local var1_7, var2_7 = string.gsub(var0_7.name, "级", "")

			if var0_0.isHXNation(var0_7.nation) and var0_5[var1_7] then
				arg0_7[arg1_7] = setmetatable({
					name = var0_5[var1_7] .. (var2_7 > 0 and "级" or "")
				}, {
					__index = var0_7
				})
			else
				arg0_7[arg1_7] = var0_7
			end

			return arg0_7[arg1_7]
		end
	})

	local var5_5 = pg.enemy_data_statistics

	pg.enemy_data_statistics = setmetatable({}, {
		__index = function(arg0_8, arg1_8)
			local var0_8 = var5_5[arg1_8]

			if var0_8 == nil then
				return var0_8
			elseif var0_8.name == nil then
				arg0_8[arg1_8] = var0_8

				return arg0_8[arg1_8]
			end

			if var0_0.isHXNation(var0_8.nationality) and var0_5[var0_8.name] then
				arg0_8[arg1_8] = setmetatable({
					name = var0_5[var0_8.name]
				}, {
					__index = var0_8
				})
			else
				arg0_8[arg1_8] = var0_8
			end

			return arg0_8[arg1_8]
		end
	})

	local var6_5 = pg.equip_data_statistics

	pg._equip_data_statistics = var6_5
	pg.equip_data_statistics = setmetatable({}, {
		__index = function(arg0_9, arg1_9)
			local var0_9 = var6_5[arg1_9]

			if var0_9 == nil then
				return var0_9
			elseif var0_9.name == nil then
				arg0_9[arg1_9] = var0_9

				return arg0_9[arg1_9]
			end

			if var1_5[var0_9.name] then
				arg0_9[arg1_9] = setmetatable({
					name = var1_5[var0_9.name]
				}, {
					__index = var0_9
				})
			else
				arg0_9[arg1_9] = var0_9
			end

			return arg0_9[arg1_9]
		end
	})

	local var7_5 = pg.island_unit_character

	pg.island_unit_character = setmetatable({}, {
		__index = function(arg0_10, arg1_10)
			local var0_10 = var7_5[arg1_10]

			if var0_10 == nil then
				return var0_10
			elseif var0_10.name == nil then
				arg0_10[arg1_10] = var0_10

				return arg0_10[arg1_10]
			end

			arg0_10[arg1_10] = {}

			if var0_5[var0_10.name] then
				arg0_10[arg1_10].name = var0_5[var0_10.name]
			end

			setmetatable(arg0_10[arg1_10], {
				__index = var0_10
			})

			return arg0_10[arg1_10]
		end
	})
end

function var0_0.hxLan(arg0_11, arg1_11)
	return string.gsub(arg0_11 or "", "{namecode:(%d+).-}", function(arg0_12)
		local var0_12 = pg.name_code[tonumber(arg0_12)]

		return var0_12 and ((var0_0.codeMode or arg1_11) and var0_12.name or var0_12.code)
	end)
end

function var0_0.isHx()
	return not var0_0.codeMode
end

function var0_0.isHxSkin()
	return not var0_0.antiSkinMode
end

function var0_0.isHxPropose()
	return not var0_0.codeMode and PLATFORM_CODE == PLATFORM_CH and LOCK_PROPOSE_SHIP
end

function var0_0.HxPath(arg0_16)
	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		local var0_16 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()
		local var1_16 = arg0_16 .. "_hx_ch" .. var0_16

		return checkABExist(var1_16) and var1_16 or arg0_16
	else
		return arg0_16
	end
end

var0_0.hxPathList = {
	"live2d",
	"painting",
	"shipYardIcon",
	"paintingface",
	"char",
	"shipmodels",
	"technologycard",
	"shipdesignicon",
	"herohrzicon",
	"skinunlockanim",
	"spinePainting"
}
var0_0.folderBundle = {
	"paintingface"
}

function var0_0.needShift(arg0_17)
	for iter0_17, iter1_17 in ipairs(var0_0.hxPathList) do
		if string.find(arg0_17, iter1_17) then
			return true
		end
	end

	return false
end

function var0_0.isFolderBundle(arg0_18)
	for iter0_18, iter1_18 in ipairs(var0_0.folderBundle) do
		if string.find(arg0_18, iter1_18) then
			return true
		end
	end

	return false
end

function var0_0.autoHxShift(arg0_19, arg1_19)
	if var0_0.isHx() then
		if string.find(arg0_19, "live2d") then
			if checkABExist(arg0_19 .. arg1_19 .. "_hx") then
				return arg0_19, arg1_19 .. "_hx"
			elseif pg.l2dhx[arg1_19] then
				return arg0_19, arg1_19 .. "_hx"
			end
		end

		if var0_0.needShift(arg0_19) then
			local var0_19 = arg0_19 .. arg1_19

			if checkABExist(var0_19 .. "_hx") then
				return arg0_19, arg1_19 .. "_hx"
			end
		end
	end

	return arg0_19, arg1_19
end

function var0_0.autoHxShiftPath(arg0_20, arg1_20, arg2_20)
	if var0_0.isHx() then
		if string.find(arg0_20, "live2d") then
			if arg2_20 then
				local var0_20 = string.gsub(arg0_20, "live2d/", "")

				if pg.l2dhx[var0_20] then
					return arg0_20 .. "_hx"
				end
			elseif checkABExist(arg0_20 .. "_hx") then
				return arg0_20 .. "_hx"
			else
				local var1_20 = string.gsub(arg0_20, "live2d/", "")

				if pg.l2dhx[var1_20] then
					return arg0_20 .. "_hx"
				end
			end
		end

		if var0_0.needShift(arg0_20) and checkABExist(arg0_20 .. "_hx") then
			if var0_0.isFolderBundle(arg0_20) then
				return arg0_20 .. "_hx", arg1_20
			elseif arg1_20 and #arg1_20 > 0 then
				return arg0_20 .. "_hx", arg1_20 .. "_hx"
			else
				return arg0_20 .. "_hx", arg1_20
			end
		end
	end

	return arg0_20, arg1_20
end

var0_0.init()
