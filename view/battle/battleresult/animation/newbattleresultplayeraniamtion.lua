local var0 = class("NewBattleResultPlayerAniamtion")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.playerLv = arg1
	arg0.playerExp = arg2
	arg0.playerExpBar = arg3
	arg0.newPlayer = arg4
	arg0.oldPlayer = arg5
end

function var0.SetUp(arg0, arg1)
	parallelAsync({
		function(arg0)
			arg0:LevelAnimation(arg0)
		end,
		function(arg0)
			arg0:ExpAnimation(arg0)
		end,
		function(arg0)
			arg0:ExpBarAnimation(arg0)
		end
	}, arg1)
end

function var0.LevelAnimation(arg0, arg1)
	local var0 = arg0.oldPlayer.level
	local var1 = arg0.newPlayer.level

	if var0 == var1 then
		arg0.playerLv.text = "Lv." .. var1

		arg1()

		return
	end

	LeanTween.value(arg0.playerLv.gameObject, var0, var1, 1.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.playerLv.text = "Lv." .. math.ceil(arg0)
	end)):setOnComplete(System.Action(arg1))
end

function var0.ExpAnimation(arg0, arg1)
	local var0 = NewBattleResultUtil.GetPlayerExpOffset(arg0.oldPlayer, arg0.newPlayer)

	LeanTween.value(arg0.playerExp.gameObject, 0, var0, 1.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.playerExp.text = "+" .. math.ceil(arg0)
	end)):setOnComplete(System.Action(arg1))
end

local function var1(arg0, arg1)
	local var0 = arg0.oldPlayer.exp
	local var1 = arg0.newPlayer.exp
	local var2 = getConfigFromLevel1(pg.user_level, arg0.newPlayer.level).exp_interval

	LeanTween.value(arg0.playerExpBar.gameObject, var0, var1, 1.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.playerExpBar.fillAmount = arg0 / var2
	end)):setOnComplete(System.Action(arg1))
end

local function var2(arg0, arg1)
	local var0 = arg0.oldPlayer.exp
	local var1 = getConfigFromLevel1(pg.user_level, arg0.oldPlayer.level).exp_interval

	LeanTween.value(arg0.playerExpBar.gameObject, var0 / var1, 1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.playerExpBar.fillAmount = arg0
	end)):setOnComplete(System.Action(arg1))
end

local function var3(arg0, arg1)
	local var0 = arg0.newPlayer.exp
	local var1 = getConfigFromLevel1(pg.user_level, arg0.newPlayer.level).exp_interval

	LeanTween.value(arg0.playerExpBar.gameObject, 0, var0 / var1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.playerExpBar.fillAmount = arg0
	end)):setOnComplete(System.Action(arg1))
end

local function var4(arg0, arg1)
	local var0 = arg0.oldPlayer.level
	local var1 = arg0.newPlayer.level - (var0 + 1)

	LeanTween.value(arg0.playerExpBar.gameObject, 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.playerExpBar.fillAmount = arg0
	end)):setRepeat(var1):setOnComplete(System.Action(arg1))
end

local function var5(arg0, arg1)
	local var0 = arg0.oldPlayer.level
	local var1 = arg0.newPlayer.level
	local var2 = {}

	table.insert(var2, function(arg0)
		var2(arg0, arg0)
	end)

	if var0 + 1 ~= var1 then
		table.insert(var2, function(arg0)
			var4(arg0, arg0)
		end)
	end

	table.insert(var2, function(arg0)
		var3(arg0, arg0)
	end)
	seriesAsync(var2, arg1)
end

function var0.ExpBarAnimation(arg0, arg1)
	if arg0.oldPlayer.level == arg0.newPlayer.level then
		var1(arg0, arg1)
	else
		var5(arg0, arg1)
	end
end

function var0.Dispose(arg0)
	for iter0, iter1 in ipairs({
		"playerLv",
		"playerExp",
		"playerExpBar"
	}) do
		local var0 = arg0[iter1].gameObject

		if LeanTween.isTweening(var0) then
			LeanTween.cancel(var0)
		end
	end
end

return var0
