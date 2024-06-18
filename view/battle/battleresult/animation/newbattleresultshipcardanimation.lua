local var0_0 = class("NewBattleResultShipCardAnimation")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1)
	arg0_1.isExpMode = arg2_1
	arg0_1.maxOutput = arg6_1
	arg0_1.ship = arg3_1
	arg0_1.newShip = arg4_1
	arg0_1.statistic = arg5_1 or {}
	arg0_1.label1 = arg1_1:Find("atk"):GetComponent(typeof(Text))
	arg0_1.label2 = arg1_1:Find("killCount"):GetComponent(typeof(Text))
	arg0_1.damagebar = arg1_1:Find("dmg/bar"):GetComponent(typeof(Image))
end

function var0_0.SetUp(arg0_2, arg1_2)
	arg0_2:Clear()

	if arg0_2.isExpMode then
		arg0_2:DoExpAnimation(arg1_2)
	else
		arg0_2:DoOutputAnimation(arg1_2)
	end
end

function var0_0.DoExpAnimation(arg0_3, arg1_3)
	parallelAsync({
		function(arg0_4)
			arg0_3:ExpAnimation(arg0_4)
		end,
		function(arg0_5)
			arg0_3:LevelAnimation(arg0_5)
		end,
		function(arg0_6)
			arg0_3:ExpBarAnimation(arg0_6)
		end
	}, arg1_3)
end

function var0_0.ExpAnimation(arg0_7, arg1_7)
	local var0_7 = NewBattleResultUtil.GetShipExpOffset(arg0_7.ship, arg0_7.newShip)

	LeanTween.value(arg0_7.label1.gameObject, 0, var0_7, 1):setOnUpdate(System.Action_float(function(arg0_8)
		arg0_7.label1.text = "EXP" .. "<color=#FFDE38>+" .. math.ceil(arg0_8) .. "</color>"
	end)):setOnComplete(System.Action(arg1_7))
end

function var0_0.LevelAnimation(arg0_9, arg1_9)
	local var0_9 = arg0_9.ship.level
	local var1_9 = arg0_9.newShip.level

	if var0_9 == var1_9 then
		arg0_9.label2.text = "Lv." .. var1_9

		arg1_9()

		return
	end

	LeanTween.value(arg0_9.label2.gameObject, var0_9, var1_9, 1):setOnUpdate(System.Action_float(function(arg0_10)
		arg0_9.label2.text = "Lv." .. math.ceil(arg0_10)
	end)):setOnComplete(System.Action(arg1_9))
end

local function var1_0(arg0_11, arg1_11)
	local var0_11 = arg0_11.ship:getExp()
	local var1_11 = arg0_11.newShip:getExp()
	local var2_11 = getExpByRarityFromLv1(arg0_11.newShip:getConfig("rarity"), arg0_11.newShip.level)

	LeanTween.value(arg0_11.damagebar.gameObject, var0_11, var1_11, 1):setOnUpdate(System.Action_float(function(arg0_12)
		arg0_11.damagebar.fillAmount = arg0_12 / var2_11
	end)):setOnComplete(System.Action(arg1_11))
end

local function var2_0(arg0_13, arg1_13)
	local var0_13 = arg0_13.ship:getExp()
	local var1_13 = getExpByRarityFromLv1(arg0_13.ship:getConfig("rarity"), arg0_13.ship.level)

	LeanTween.value(arg0_13.damagebar.gameObject, var0_13 / var1_13, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_14)
		arg0_13.damagebar.fillAmount = arg0_14
	end)):setOnComplete(System.Action(arg1_13))
end

local function var3_0(arg0_15, arg1_15)
	local var0_15 = arg0_15.newShip:getExp()
	local var1_15 = getExpByRarityFromLv1(arg0_15.newShip:getConfig("rarity"), arg0_15.newShip.level)

	LeanTween.value(arg0_15.damagebar.gameObject, 0, var0_15 / var1_15, 0.5):setOnUpdate(System.Action_float(function(arg0_16)
		arg0_15.damagebar.fillAmount = arg0_16
	end)):setOnComplete(System.Action(arg1_15))
end

local function var4_0(arg0_17, arg1_17)
	local var0_17 = arg0_17.ship.level
	local var1_17 = arg0_17.newShip.level - (var0_17 + 1)

	LeanTween.value(arg0_17.damagebar.gameObject, 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_18)
		arg0_17.damagebar.fillAmount = arg0_18
	end)):setRepeat(var1_17):setOnComplete(System.Action(arg1_17))
end

local function var5_0(arg0_19, arg1_19)
	local var0_19 = arg0_19.ship.level
	local var1_19 = arg0_19.newShip.level
	local var2_19 = {}

	table.insert(var2_19, function(arg0_20)
		var2_0(arg0_19, arg0_20)
	end)

	if var0_19 + 1 ~= var1_19 then
		table.insert(var2_19, function(arg0_21)
			var4_0(arg0_19, arg0_21)
		end)
	end

	table.insert(var2_19, function(arg0_22)
		var3_0(arg0_19, arg0_22)
	end)
	seriesAsync(var2_19, arg1_19)
end

function var0_0.ExpBarAnimation(arg0_23, arg1_23)
	if arg0_23.ship.level == arg0_23.newShip.level then
		var1_0(arg0_23, arg1_23)
	else
		var5_0(arg0_23, arg1_23)
	end
end

function var0_0.DoOutputAnimation(arg0_24, arg1_24)
	parallelAsync({
		function(arg0_25)
			arg0_24:KillCntAnimation(arg0_25)
		end,
		function(arg0_26)
			arg0_24:OutputAnimation(arg0_26)
		end,
		function(arg0_27)
			arg0_24:OutputBarAnimation(arg0_27)
		end
	}, arg1_24)
end

function var0_0.KillCntAnimation(arg0_28, arg1_28)
	local var0_28 = 0
	local var1_28 = arg0_28.statistic.kill_count or 0

	LeanTween.value(arg0_28.label2.gameObject, var0_28, var1_28, 1):setOnUpdate(System.Action_float(function(arg0_29)
		arg0_28.label2.text = math.ceil(arg0_29)
	end)):setOnComplete(System.Action(arg1_28))
end

function var0_0.OutputAnimation(arg0_30, arg1_30)
	local var0_30 = 0
	local var1_30 = arg0_30.statistic.output or 0

	LeanTween.value(arg0_30.label1.gameObject, var0_30, var1_30, 1):setOnUpdate(System.Action_float(function(arg0_31)
		arg0_30.label1.text = math.ceil(arg0_31)
	end)):setOnComplete(System.Action(arg1_30))
end

function var0_0.OutputBarAnimation(arg0_32, arg1_32)
	local var0_32 = 0
	local var1_32 = (arg0_32.statistic.output or 0) / arg0_32.maxOutput

	LeanTween.value(arg0_32.damagebar.gameObject, var0_32, var1_32, 1):setOnUpdate(System.Action_float(function(arg0_33)
		arg0_32.damagebar.fillAmount = arg0_33
	end)):setOnComplete(System.Action(arg1_32))
end

function var0_0.Clear(arg0_34)
	for iter0_34, iter1_34 in ipairs({
		"label1",
		"label2",
		"damagebar"
	}) do
		local var0_34 = arg0_34[iter1_34].gameObject

		if LeanTween.isTweening(var0_34) then
			LeanTween.cancel(var0_34)
		end
	end
end

function var0_0.Dispose(arg0_35)
	arg0_35:Clear()
end

return var0_0
