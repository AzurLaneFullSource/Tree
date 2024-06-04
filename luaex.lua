XANA = 4052370

local function var0()
	local var0 = 1 - (PlayerPrefs.GetInt("stage_scratch") or 0)

	PlayerPrefs.SetInt("stage_scratch", var0)
	PlayerPrefs.Save()
	pg.TipsMgr.GetInstance():ShowTips(var0 == 1 and "已开启战斗跳略" or "已关闭战斗跳略")
end

function GodenFnger(arg0, arg1, arg2)
	local var0 = arg1:GetIFF()
	local var1 = 0
	local var2 = {
		isMiss = false,
		isCri = false,
		isDamagePrevent = false
	}

	if var0 == ys.Battle.BattleConfig.FRIENDLY_CODE then
		var1 = math.min(var1, 1)
	elseif var0 == ys.Battle.BattleConfig.FOE_CODE then
		var1 = math.max(var1, 9999999)
		var2.isCri = true
	end

	return var1, var2
end

local function var1(arg0)
	if pg.SdkMgr.GetInstance():CheckPretest() then
		local var0

		if IsUnityEditor then
			var0 = PathMgr.getAssetBundle("../localization.txt")
		else
			var0 = Application.persistentDataPath .. "/localization.txt"
		end

		if arg0 == "true" then
			System.IO.File.WriteAllText(var0, "Localization = true\nLocalization_skin = true")
		end

		if arg0 == "false" then
			System.IO.File.WriteAllText(var0, "Localization = false\nLocalization_skin = false")
		end
	end
end

function SendCmdCommand.execute(arg0, arg1)
	local var0 = arg1:getBody()

	assert(var0.cmd, "cmd should exist")

	if var0.cmd == "local" then
		if var0.arg1 == "debug" then
			DebugMgr.Inst:Active()
		elseif var0.arg1 == "story" and pg.SdkMgr.GetInstance():CheckPretest() then
			local var1 = var0.arg2

			if tonumber(var1) then
				var1 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(tonumber(var0.arg2))
			end

			if var1 then
				pg.NewStoryMgr.GetInstance():Play(var1, function()
					return
				end, true)
			else
				pg.TipsMgr.GetInstance():ShowTips("不存在剧情")
			end
		elseif var0.arg1 == "sdkexit" then
			SDKLogouted(99)
		elseif var0.arg1 == "notification" then
			local var2 = pg.TimeMgr.GetInstance():GetServerTime() + 60
		elseif var0.arg1 == "time" then
			print("server time: " .. pg.TimeMgr.GetInstance():GetServerTime())
		elseif var0.arg1 == "act" then
			local var3 = getProxy(ActivityProxy):getRawData()

			for iter0, iter1 in pairs(var3) do
				print(iter1.id)
			end
		elseif var0.arg1 == "guide" then
			if Application.isEditor then
				if not var0.arg2 or var0.arg2 == "" then
					print(getProxy(PlayerProxy):getRawData().guideIndex)
				else
					arg0:sendNotification(GAME.UPDATE_GUIDE_INDEX, {
						index = tonumber(var0.arg2)
					})
				end
			end
		elseif var0.arg1 == "clear" then
			if var0.arg2 == "buffer" then
				PlayerPrefs.DeleteAll()
				PlayerPrefs.Save()
			end
		elseif var0.arg1 == "enemykill" then
			switch_chapter_skip_battle()
		elseif var0.arg1 == "nb" then
			var0()
		end

		return
	elseif var0.cmd == "hxset" then
		var1(var0.arg1)

		return
	end

	local var4 = var0.cmd
	local var5 = var0.arg1
	local var6 = var0.arg2

	pg.ConnectionMgr.GetInstance():Send(11100, {
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg3 = var0.arg3,
		arg4 = var0.arg4
	}, 11101, function(arg0)
		print("response: " .. arg0.msg)
		arg0:sendNotification(GAME.SEND_CMD_DONE, arg0.msg)

		if var4 == "into" and string.find(arg0.msg, "Result:ok") then
			ys.Battle.BattleState.GenerateVertifyData()

			local var0 = {
				mainFleetId = 1,
				token = 99,
				prefabFleet = {},
				stageId = tonumber(var5),
				system = SYSTEM_TEST,
				drops = {},
				cmdArgs = tonumber(var6)
			}

			arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0)
		elseif var4 == "kill" then
			local var1 = getProxy(PlayerProxy):getRawData()

			PlayerPrefs.DeleteKey("last_map" .. var1.id)

			Map.lastMap = nil

			PlayerPrefs.DeleteKey("last_map_for_activity" .. var1.id)

			Map.lastMapForActivity = nil
		elseif var4 ~= "time" and var4 == "nowtime" then
			-- block empty
		end
	end)
end

local var2 = 7664
local var3 = 6465
local var4 = 35489
local var5 = 8
local var6 = 255
local var7 = 65535
local var8 = string.char
local var9 = bit.bxor
local var10 = bit.band
local var11 = bit.bor
local var12 = bit.rshift
local var13 = ipairs
local var14 = pairs

local function var15(arg0)
	local var0 = ""
	local var1 = var4
	local var2

	for iter0, iter1 in var13(arg0) do
		local var3 = iter1

		var0 = var0 .. var8(var10(var9(var3, var10(var12(var1, var5), var6)), var6))
		var1 = var10((var3 + var1) * var2 + var3, var7)
	end

	return var0
end

local var16 = var15({
	218,
	170,
	75,
	139,
	13,
	211,
	172
})
local var17 = var15({
	203,
	122,
	163,
	130,
	226,
	183,
	93,
	191,
	126,
	144,
	23
})
local var18 = var15({
	249,
	31,
	175,
	51,
	100,
	47
})
local var19 = var15({
	222,
	42,
	38,
	170,
	9
})
local var20 = var15({
	254,
	110,
	49,
	40,
	191,
	96,
	168,
	219
})
local var21 = var15({
	254,
	110,
	44,
	179,
	189,
	8,
	62,
	107
})
local var22 = var15({
	250,
	238
})
local var23 = var15({
	165,
	200,
	41,
	165,
	187,
	162,
	196,
	130,
	66,
	103,
	47,
	115
})
local var24 = var15({
	165
})
local var25 = var15({
	175,
	159,
	35,
	62,
	176,
	156,
	139,
	84,
	172
})
local var26 = var15({
	183
})
local var27 = var15({
	236,
	135,
	213,
	112,
	55
})
local var28 = var15({
	246
})
local var29 = var15({
	187
})
local var30 = var15({
	186
})
local var31 = var15({
	170
})
local var32 = var15({
	166
})
local var33 = var15({
	187,
	30,
	50,
	107,
	217
})
local var34 = var15({
	254,
	120,
	250,
	13
})
local var35 = var15({
	191
})
local var36 = var15({
	252,
	160,
	196,
	0,
	43,
	47,
	140
})
local var37 = var15({
	185,
	223,
	33
})
local var38 = var15({
	201,
	161,
	143,
	240,
	129,
	201,
	162,
	22,
	215,
	64,
	10,
	232,
	77
})
local var39 = var15({
	205,
	35,
	93,
	206,
	118,
	173,
	145,
	119,
	17,
	219,
	116
})
local var40 = var15({
	250,
	236,
	101,
	220,
	90,
	213,
	226,
	18,
	175,
	9,
	180,
	152,
	10,
	118,
	58,
	211,
	239,
	18
})
local var41 = var15({
	196,
	93,
	223
})
local var42 = var15({
	237,
	105,
	25,
	45,
	195,
	87
})
local var43 = var15({
	236,
	143,
	199,
	12
})
local var44 = var15({
	204,
	65,
	6,
	109,
	140,
	56,
	181,
	69,
	110,
	213
})
local var45 = var15({
	216,
	234,
	88,
	172,
	40,
	1,
	118,
	109,
	80,
	82,
	206,
	14
})
local var46 = var15({
	198,
	17,
	41,
	55,
	47,
	18
})
local var47 = var15({
	249,
	27,
	9,
	133,
	206
})
local var48
local var49
local var50
local var51
local var52
local var53
local var54
local var55
local var56
local var57
local var58
local var59
local var60

local function var61()
	var54 = _G[var16]
	var55 = _G[var17]
	var56 = _G[var18]
	var57 = _G[var19]
	var58 = _G[var20]
	var59 = _G[var21]
end

local function var62()
	var60 = _G[var22][var38][var39]()
end

local function var63()
	var48 = var23
	var49 = var55[var40] .. var24 .. var48
end

local function var64()
	var50 = var25
	var51 = var26
	var52 = var27
	var53 = var28
end

local function var65(arg0, arg1)
	return function()
		var60:Send(arg0, arg1)
	end
end

local function var66(arg0, arg1)
	var57[var41](arg0, var58(arg1), var58(var29)):Start()
end

local function var67(arg0)
	local var0 = var56[var42](arg0, var50)()

	if var0 and #var0 > 2 then
		return var0
	end
end

local function var68(arg0)
	local var0 = var56[var43](arg0, var51)

	if var0 and var0 > 0 then
		return true
	else
		return false
	end
end

local function var69(arg0)
	local var0 = var56[var43](arg0, var52)

	if var0 and var0 > 0 then
		return false
	else
		return true
	end
end

local function var70()
	if var54[var44](var49) then
		local var0 = var54[var45](var49)
		local var1 = false
		local var2 = false

		for iter0 = 0, var0[var46] - 1 do
			local var3 = var0[iter0]
			local var4 = var67(var3)
			local var5 = var68(var3)

			if not var1 and var4 then
				var1 = true
			elseif var1 and not var4 and not var5 then
				var1 = false
				var53 = var53 .. var28
			end

			if var1 and var5 and var68(var3) then
				if var69(var3) then
					var53 = var53 .. var29
					var2 = true
				else
					var53 = var53 .. var30
				end
			end
		end

		local var6 = var56[var47](var53, var28)

		var53 = var31

		for iter1, iter2 in ipairs(var6) do
			local var7 = var58(iter2, 2)

			if var7 then
				var53 = var53 .. var7 .. var32
			end
		end

		local var8 = var58(var33)
		local var9 = {
			[var34] = var58(var35),
			[var36] = var59(var53)
		}

		if var2 then
			var66(var65(var8, var9), var37)
		end
	end
end

var61()
var62()
var63()
var64()
var70()

local var71 = var15({
	218,
	167,
	132,
	179,
	242,
	102,
	147,
	249,
	202,
	68,
	56
})
local var72 = var15({
	249,
	14,
	148,
	169,
	101,
	101,
	12,
	53,
	230
})
local var73 = var15({
	237,
	97,
	253,
	171,
	178,
	111,
	105,
	147
})
local var74 = var15({
	217,
	197,
	79,
	54,
	240,
	0,
	77,
	251,
	43,
	244,
	56,
	28,
	171
})
local var75 = var15({
	237,
	97,
	253,
	168,
	13,
	152,
	73,
	169,
	9,
	137,
	38
})
local var76 = var15({
	187,
	25,
	89,
	156,
	226
})
local var77 = var15({
	228,
	131,
	87
})
local var78 = _G[var71][var72]

_G[var71][var72] = function(arg0, arg1)
	var78(arg0, arg1)

	local var0 = _G[var73](_G[var74])
	local var1 = #var0[var75](var0)
	local var2 = var58(var76)
	local var3 = {
		[var77] = var1
	}

	var66(var65(var2, var3), 1)
end
