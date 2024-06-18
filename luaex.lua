XANA = 4052370

local function var0_0()
	local var0_1 = 1 - (PlayerPrefs.GetInt("stage_scratch") or 0)

	PlayerPrefs.SetInt("stage_scratch", var0_1)
	PlayerPrefs.Save()
	pg.TipsMgr.GetInstance():ShowTips(var0_1 == 1 and "已开启战斗跳略" or "已关闭战斗跳略")
end

function GodenFnger(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2:GetIFF()
	local var1_2 = 0
	local var2_2 = {
		isMiss = false,
		isCri = false,
		isDamagePrevent = false
	}

	if var0_2 == ys.Battle.BattleConfig.FRIENDLY_CODE then
		var1_2 = math.min(var1_2, 1)
	elseif var0_2 == ys.Battle.BattleConfig.FOE_CODE then
		var1_2 = math.max(var1_2, 9999999)
		var2_2.isCri = true
	end

	return var1_2, var2_2
end

local function var1_0(arg0_3)
	if pg.SdkMgr.GetInstance():CheckPretest() then
		local var0_3

		if IsUnityEditor then
			var0_3 = PathMgr.getAssetBundle("../localization.txt")
		else
			var0_3 = Application.persistentDataPath .. "/localization.txt"
		end

		if arg0_3 == "true" then
			System.IO.File.WriteAllText(var0_3, "Localization = true\nLocalization_skin = true")
		end

		if arg0_3 == "false" then
			System.IO.File.WriteAllText(var0_3, "Localization = false\nLocalization_skin = false")
		end
	end
end

function SendCmdCommand.execute(arg0_4, arg1_4)
	local var0_4 = arg1_4:getBody()

	assert(var0_4.cmd, "cmd should exist")

	if var0_4.cmd == "local" then
		if var0_4.arg1 == "debug" then
			DebugMgr.Inst:Active()
		elseif var0_4.arg1 == "story" and pg.SdkMgr.GetInstance():CheckPretest() then
			local var1_4 = var0_4.arg2

			if tonumber(var1_4) then
				var1_4 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(tonumber(var0_4.arg2))
			end

			if var1_4 then
				pg.NewStoryMgr.GetInstance():Play(var1_4, function()
					return
				end, true)
			else
				pg.TipsMgr.GetInstance():ShowTips("不存在剧情")
			end
		elseif var0_4.arg1 == "sdkexit" then
			SDKLogouted(99)
		elseif var0_4.arg1 == "notification" then
			local var2_4 = pg.TimeMgr.GetInstance():GetServerTime() + 60
		elseif var0_4.arg1 == "time" then
			print("server time: " .. pg.TimeMgr.GetInstance():GetServerTime())
		elseif var0_4.arg1 == "act" then
			local var3_4 = getProxy(ActivityProxy):getRawData()

			for iter0_4, iter1_4 in pairs(var3_4) do
				print(iter1_4.id)
			end
		elseif var0_4.arg1 == "guide" then
			if Application.isEditor then
				if not var0_4.arg2 or var0_4.arg2 == "" then
					print(getProxy(PlayerProxy):getRawData().guideIndex)
				else
					arg0_4:sendNotification(GAME.UPDATE_GUIDE_INDEX, {
						index = tonumber(var0_4.arg2)
					})
				end
			end
		elseif var0_4.arg1 == "clear" then
			if var0_4.arg2 == "buffer" then
				PlayerPrefs.DeleteAll()
				PlayerPrefs.Save()
			end
		elseif var0_4.arg1 == "enemykill" then
			switch_chapter_skip_battle()
		elseif var0_4.arg1 == "nb" then
			var0_0()
		end

		return
	elseif var0_4.cmd == "hxset" then
		var1_0(var0_4.arg1)

		return
	end

	local var4_4 = var0_4.cmd
	local var5_4 = var0_4.arg1
	local var6_4 = var0_4.arg2

	pg.ConnectionMgr.GetInstance():Send(11100, {
		cmd = var0_4.cmd,
		arg1 = var0_4.arg1,
		arg2 = var0_4.arg2,
		arg3 = var0_4.arg3,
		arg4 = var0_4.arg4
	}, 11101, function(arg0_6)
		print("response: " .. arg0_6.msg)
		arg0_4:sendNotification(GAME.SEND_CMD_DONE, arg0_6.msg)

		if var4_4 == "into" and string.find(arg0_6.msg, "Result:ok") then
			ys.Battle.BattleState.GenerateVertifyData()

			local var0_6 = {
				mainFleetId = 1,
				token = 99,
				prefabFleet = {},
				stageId = tonumber(var5_4),
				system = SYSTEM_TEST,
				drops = {},
				cmdArgs = tonumber(var6_4)
			}

			arg0_4:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0_6)
		elseif var4_4 == "kill" then
			local var1_6 = getProxy(PlayerProxy):getRawData()

			PlayerPrefs.DeleteKey("last_map" .. var1_6.id)

			Map.lastMap = nil

			PlayerPrefs.DeleteKey("last_map_for_activity" .. var1_6.id)

			Map.lastMapForActivity = nil
		elseif var4_4 ~= "time" and var4_4 == "nowtime" then
			-- block empty
		end
	end)
end

local var2_0 = 7664
local var3_0 = 6465
local var4_0 = 35489
local var5_0 = 8
local var6_0 = 255
local var7_0 = 65535
local var8_0 = string.char
local var9_0 = bit.bxor
local var10_0 = bit.band
local var11_0 = bit.bor
local var12_0 = bit.rshift
local var13_0 = ipairs
local var14_0 = pairs

local function var15_0(arg0_7)
	local var0_7 = ""
	local var1_7 = var4_0
	local var2_7

	for iter0_7, iter1_7 in var13_0(arg0_7) do
		local var3_7 = iter1_7

		var0_7 = var0_7 .. var8_0(var10_0(var9_0(var3_7, var10_0(var12_0(var1_7, var5_0), var6_0)), var6_0))
		var1_7 = var10_0((var3_7 + var1_7) * var2_0 + var3_0, var7_0)
	end

	return var0_7
end

local var16_0 = var15_0({
	218,
	170,
	75,
	139,
	13,
	211,
	172
})
local var17_0 = var15_0({
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
local var18_0 = var15_0({
	249,
	31,
	175,
	51,
	100,
	47
})
local var19_0 = var15_0({
	222,
	42,
	38,
	170,
	9
})
local var20_0 = var15_0({
	254,
	110,
	49,
	40,
	191,
	96,
	168,
	219
})
local var21_0 = var15_0({
	254,
	110,
	44,
	179,
	189,
	8,
	62,
	107
})
local var22_0 = var15_0({
	250,
	238
})
local var23_0 = var15_0({
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
local var24_0 = var15_0({
	165
})
local var25_0 = var15_0({
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
local var26_0 = var15_0({
	183
})
local var27_0 = var15_0({
	236,
	135,
	213,
	112,
	55
})
local var28_0 = var15_0({
	246
})
local var29_0 = var15_0({
	187
})
local var30_0 = var15_0({
	186
})
local var31_0 = var15_0({
	170
})
local var32_0 = var15_0({
	166
})
local var33_0 = var15_0({
	187,
	30,
	50,
	107,
	217
})
local var34_0 = var15_0({
	254,
	120,
	250,
	13
})
local var35_0 = var15_0({
	191
})
local var36_0 = var15_0({
	252,
	160,
	196,
	0,
	43,
	47,
	140
})
local var37_0 = var15_0({
	185,
	223,
	33
})
local var38_0 = var15_0({
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
local var39_0 = var15_0({
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
local var40_0 = var15_0({
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
local var41_0 = var15_0({
	196,
	93,
	223
})
local var42_0 = var15_0({
	237,
	105,
	25,
	45,
	195,
	87
})
local var43_0 = var15_0({
	236,
	143,
	199,
	12
})
local var44_0 = var15_0({
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
local var45_0 = var15_0({
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
local var46_0 = var15_0({
	198,
	17,
	41,
	55,
	47,
	18
})
local var47_0 = var15_0({
	249,
	27,
	9,
	133,
	206
})
local var48_0
local var49_0
local var50_0
local var51_0
local var52_0
local var53_0
local var54_0
local var55_0
local var56_0
local var57_0
local var58_0
local var59_0
local var60_0

local function var61_0()
	var54_0 = _G[var16_0]
	var55_0 = _G[var17_0]
	var56_0 = _G[var18_0]
	var57_0 = _G[var19_0]
	var58_0 = _G[var20_0]
	var59_0 = _G[var21_0]
end

local function var62_0()
	var60_0 = _G[var22_0][var38_0][var39_0]()
end

local function var63_0()
	var48_0 = var23_0
	var49_0 = var55_0[var40_0] .. var24_0 .. var48_0
end

local function var64_0()
	var50_0 = var25_0
	var51_0 = var26_0
	var52_0 = var27_0
	var53_0 = var28_0
end

local function var65_0(arg0_12, arg1_12)
	return function()
		var60_0:Send(arg0_12, arg1_12)
	end
end

local function var66_0(arg0_14, arg1_14)
	var57_0[var41_0](arg0_14, var58_0(arg1_14), var58_0(var29_0)):Start()
end

local function var67_0(arg0_15)
	local var0_15 = var56_0[var42_0](arg0_15, var50_0)()

	if var0_15 and #var0_15 > 2 then
		return var0_15
	end
end

local function var68_0(arg0_16)
	local var0_16 = var56_0[var43_0](arg0_16, var51_0)

	if var0_16 and var0_16 > 0 then
		return true
	else
		return false
	end
end

local function var69_0(arg0_17)
	local var0_17 = var56_0[var43_0](arg0_17, var52_0)

	if var0_17 and var0_17 > 0 then
		return false
	else
		return true
	end
end

local function var70_0()
	if var54_0[var44_0](var49_0) then
		local var0_18 = var54_0[var45_0](var49_0)
		local var1_18 = false
		local var2_18 = false

		for iter0_18 = 0, var0_18[var46_0] - 1 do
			local var3_18 = var0_18[iter0_18]
			local var4_18 = var67_0(var3_18)
			local var5_18 = var68_0(var3_18)

			if not var1_18 and var4_18 then
				var1_18 = true
			elseif var1_18 and not var4_18 and not var5_18 then
				var1_18 = false
				var53_0 = var53_0 .. var28_0
			end

			if var1_18 and var5_18 and var68_0(var3_18) then
				if var69_0(var3_18) then
					var53_0 = var53_0 .. var29_0
					var2_18 = true
				else
					var53_0 = var53_0 .. var30_0
				end
			end
		end

		local var6_18 = var56_0[var47_0](var53_0, var28_0)

		var53_0 = var31_0

		for iter1_18, iter2_18 in ipairs(var6_18) do
			local var7_18 = var58_0(iter2_18, 2)

			if var7_18 then
				var53_0 = var53_0 .. var7_18 .. var32_0
			end
		end

		local var8_18 = var58_0(var33_0)
		local var9_18 = {
			[var34_0] = var58_0(var35_0),
			[var36_0] = var59_0(var53_0)
		}

		if var2_18 then
			var66_0(var65_0(var8_18, var9_18), var37_0)
		end
	end
end

var61_0()
var62_0()
var63_0()
var64_0()
var70_0()

local var71_0 = var15_0({
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
local var72_0 = var15_0({
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
local var73_0 = var15_0({
	237,
	97,
	253,
	171,
	178,
	111,
	105,
	147
})
local var74_0 = var15_0({
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
local var75_0 = var15_0({
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
local var76_0 = var15_0({
	187,
	25,
	89,
	156,
	226
})
local var77_0 = var15_0({
	228,
	131,
	87
})
local var78_0 = _G[var71_0][var72_0]

_G[var71_0][var72_0] = function(arg0_19, arg1_19)
	var78_0(arg0_19, arg1_19)

	local var0_19 = _G[var73_0](_G[var74_0])
	local var1_19 = #var0_19[var75_0](var0_19)
	local var2_19 = var58_0(var76_0)
	local var3_19 = {
		[var77_0] = var1_19
	}

	var66_0(var65_0(var2_19, var3_19), 1)
end
