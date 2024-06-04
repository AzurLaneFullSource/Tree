local var0 = class("NewBattleResultShipCardAnimation")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0.isExpMode = arg2
	arg0.maxOutput = arg6
	arg0.ship = arg3
	arg0.newShip = arg4
	arg0.statistic = arg5 or {}
	arg0.label1 = arg1:Find("atk"):GetComponent(typeof(Text))
	arg0.label2 = arg1:Find("killCount"):GetComponent(typeof(Text))
	arg0.damagebar = arg1:Find("dmg/bar"):GetComponent(typeof(Image))
end

function var0.SetUp(arg0, arg1)
	arg0:Clear()

	if arg0.isExpMode then
		arg0:DoExpAnimation(arg1)
	else
		arg0:DoOutputAnimation(arg1)
	end
end

function var0.DoExpAnimation(arg0, arg1)
	parallelAsync({
		function(arg0)
			arg0:ExpAnimation(arg0)
		end,
		function(arg0)
			arg0:LevelAnimation(arg0)
		end,
		function(arg0)
			arg0:ExpBarAnimation(arg0)
		end
	}, arg1)
end

function var0.ExpAnimation(arg0, arg1)
	local var0 = NewBattleResultUtil.GetShipExpOffset(arg0.ship, arg0.newShip)

	LeanTween.value(arg0.label1.gameObject, 0, var0, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.label1.text = "EXP" .. "<color=#FFDE38>+" .. math.ceil(arg0) .. "</color>"
	end)):setOnComplete(System.Action(arg1))
end

function var0.LevelAnimation(arg0, arg1)
	local var0 = arg0.ship.level
	local var1 = arg0.newShip.level

	if var0 == var1 then
		arg0.label2.text = "Lv." .. var1

		arg1()

		return
	end

	LeanTween.value(arg0.label2.gameObject, var0, var1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.label2.text = "Lv." .. math.ceil(arg0)
	end)):setOnComplete(System.Action(arg1))
end

local function var1(arg0, arg1)
	local var0 = arg0.ship:getExp()
	local var1 = arg0.newShip:getExp()
	local var2 = getExpByRarityFromLv1(arg0.newShip:getConfig("rarity"), arg0.newShip.level)

	LeanTween.value(arg0.damagebar.gameObject, var0, var1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.damagebar.fillAmount = arg0 / var2
	end)):setOnComplete(System.Action(arg1))
end

local function var2(arg0, arg1)
	local var0 = arg0.ship:getExp()
	local var1 = getExpByRarityFromLv1(arg0.ship:getConfig("rarity"), arg0.ship.level)

	LeanTween.value(arg0.damagebar.gameObject, var0 / var1, 1, 0.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.damagebar.fillAmount = arg0
	end)):setOnComplete(System.Action(arg1))
end

local function var3(arg0, arg1)
	local var0 = arg0.newShip:getExp()
	local var1 = getExpByRarityFromLv1(arg0.newShip:getConfig("rarity"), arg0.newShip.level)

	LeanTween.value(arg0.damagebar.gameObject, 0, var0 / var1, 0.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.damagebar.fillAmount = arg0
	end)):setOnComplete(System.Action(arg1))
end

local function var4(arg0, arg1)
	local var0 = arg0.ship.level
	local var1 = arg0.newShip.level - (var0 + 1)

	LeanTween.value(arg0.damagebar.gameObject, 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.damagebar.fillAmount = arg0
	end)):setRepeat(var1):setOnComplete(System.Action(arg1))
end

local function var5(arg0, arg1)
	local var0 = arg0.ship.level
	local var1 = arg0.newShip.level
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
	if arg0.ship.level == arg0.newShip.level then
		var1(arg0, arg1)
	else
		var5(arg0, arg1)
	end
end

function var0.DoOutputAnimation(arg0, arg1)
	parallelAsync({
		function(arg0)
			arg0:KillCntAnimation(arg0)
		end,
		function(arg0)
			arg0:OutputAnimation(arg0)
		end,
		function(arg0)
			arg0:OutputBarAnimation(arg0)
		end
	}, arg1)
end

function var0.KillCntAnimation(arg0, arg1)
	local var0 = 0
	local var1 = arg0.statistic.kill_count or 0

	LeanTween.value(arg0.label2.gameObject, var0, var1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.label2.text = math.ceil(arg0)
	end)):setOnComplete(System.Action(arg1))
end

function var0.OutputAnimation(arg0, arg1)
	local var0 = 0
	local var1 = arg0.statistic.output or 0

	LeanTween.value(arg0.label1.gameObject, var0, var1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.label1.text = math.ceil(arg0)
	end)):setOnComplete(System.Action(arg1))
end

function var0.OutputBarAnimation(arg0, arg1)
	local var0 = 0
	local var1 = (arg0.statistic.output or 0) / arg0.maxOutput

	LeanTween.value(arg0.damagebar.gameObject, var0, var1, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.damagebar.fillAmount = arg0
	end)):setOnComplete(System.Action(arg1))
end

function var0.Clear(arg0)
	for iter0, iter1 in ipairs({
		"label1",
		"label2",
		"damagebar"
	}) do
		local var0 = arg0[iter1].gameObject

		if LeanTween.isTweening(var0) then
			LeanTween.cancel(var0)
		end
	end
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
