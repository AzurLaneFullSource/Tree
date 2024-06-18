local var0_0 = class("NewBattleResultPlayerAniamtion")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1.playerLv = arg1_1
	arg0_1.playerExp = arg2_1
	arg0_1.playerExpBar = arg3_1
	arg0_1.newPlayer = arg4_1
	arg0_1.oldPlayer = arg5_1
end

function var0_0.SetUp(arg0_2, arg1_2)
	parallelAsync({
		function(arg0_3)
			arg0_2:LevelAnimation(arg0_3)
		end,
		function(arg0_4)
			arg0_2:ExpAnimation(arg0_4)
		end,
		function(arg0_5)
			arg0_2:ExpBarAnimation(arg0_5)
		end
	}, arg1_2)
end

function var0_0.LevelAnimation(arg0_6, arg1_6)
	local var0_6 = arg0_6.oldPlayer.level
	local var1_6 = arg0_6.newPlayer.level

	if var0_6 == var1_6 then
		arg0_6.playerLv.text = "Lv." .. var1_6

		arg1_6()

		return
	end

	LeanTween.value(arg0_6.playerLv.gameObject, var0_6, var1_6, 1.5):setOnUpdate(System.Action_float(function(arg0_7)
		arg0_6.playerLv.text = "Lv." .. math.ceil(arg0_7)
	end)):setOnComplete(System.Action(arg1_6))
end

function var0_0.ExpAnimation(arg0_8, arg1_8)
	local var0_8 = NewBattleResultUtil.GetPlayerExpOffset(arg0_8.oldPlayer, arg0_8.newPlayer)

	LeanTween.value(arg0_8.playerExp.gameObject, 0, var0_8, 1.5):setOnUpdate(System.Action_float(function(arg0_9)
		arg0_8.playerExp.text = "+" .. math.ceil(arg0_9)
	end)):setOnComplete(System.Action(arg1_8))
end

local function var1_0(arg0_10, arg1_10)
	local var0_10 = arg0_10.oldPlayer.exp
	local var1_10 = arg0_10.newPlayer.exp
	local var2_10 = getConfigFromLevel1(pg.user_level, arg0_10.newPlayer.level).exp_interval

	LeanTween.value(arg0_10.playerExpBar.gameObject, var0_10, var1_10, 1.5):setOnUpdate(System.Action_float(function(arg0_11)
		arg0_10.playerExpBar.fillAmount = arg0_11 / var2_10
	end)):setOnComplete(System.Action(arg1_10))
end

local function var2_0(arg0_12, arg1_12)
	local var0_12 = arg0_12.oldPlayer.exp
	local var1_12 = getConfigFromLevel1(pg.user_level, arg0_12.oldPlayer.level).exp_interval

	LeanTween.value(arg0_12.playerExpBar.gameObject, var0_12 / var1_12, 1, 1):setOnUpdate(System.Action_float(function(arg0_13)
		arg0_12.playerExpBar.fillAmount = arg0_13
	end)):setOnComplete(System.Action(arg1_12))
end

local function var3_0(arg0_14, arg1_14)
	local var0_14 = arg0_14.newPlayer.exp
	local var1_14 = getConfigFromLevel1(pg.user_level, arg0_14.newPlayer.level).exp_interval

	LeanTween.value(arg0_14.playerExpBar.gameObject, 0, var0_14 / var1_14, 1):setOnUpdate(System.Action_float(function(arg0_15)
		arg0_14.playerExpBar.fillAmount = arg0_15
	end)):setOnComplete(System.Action(arg1_14))
end

local function var4_0(arg0_16, arg1_16)
	local var0_16 = arg0_16.oldPlayer.level
	local var1_16 = arg0_16.newPlayer.level - (var0_16 + 1)

	LeanTween.value(arg0_16.playerExpBar.gameObject, 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_17)
		arg0_16.playerExpBar.fillAmount = arg0_17
	end)):setRepeat(var1_16):setOnComplete(System.Action(arg1_16))
end

local function var5_0(arg0_18, arg1_18)
	local var0_18 = arg0_18.oldPlayer.level
	local var1_18 = arg0_18.newPlayer.level
	local var2_18 = {}

	table.insert(var2_18, function(arg0_19)
		var2_0(arg0_18, arg0_19)
	end)

	if var0_18 + 1 ~= var1_18 then
		table.insert(var2_18, function(arg0_20)
			var4_0(arg0_18, arg0_20)
		end)
	end

	table.insert(var2_18, function(arg0_21)
		var3_0(arg0_18, arg0_21)
	end)
	seriesAsync(var2_18, arg1_18)
end

function var0_0.ExpBarAnimation(arg0_22, arg1_22)
	if arg0_22.oldPlayer.level == arg0_22.newPlayer.level then
		var1_0(arg0_22, arg1_22)
	else
		var5_0(arg0_22, arg1_22)
	end
end

function var0_0.Dispose(arg0_23)
	for iter0_23, iter1_23 in ipairs({
		"playerLv",
		"playerExp",
		"playerExpBar"
	}) do
		local var0_23 = arg0_23[iter1_23].gameObject

		if LeanTween.isTweening(var0_23) then
			LeanTween.cancel(var0_23)
		end
	end
end

return var0_0
