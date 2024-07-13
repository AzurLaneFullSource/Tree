ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleEnmeyHpBarView")

var0_0.Battle.BattleEnmeyHpBarView = var1_0
var1_0.__name = "BattleEnmeyHpBarView"

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._monsterTF = arg1_1
	arg0_1.orgPos = arg1_1.anchoredPosition
	arg0_1.HidePos = arg0_1.orgPos + Vector2(0, 100)
	arg0_1._hpBarTF = arg1_1:Find("hpbar")
	arg0_1._hpBar = arg0_1._hpBarTF.gameObject
	arg0_1._hpBarProgress = arg0_1._hpBarTF:GetComponent(typeof(Image))
	arg0_1._hpBarText = arg0_1._hpBarTF:Find("Text"):GetComponent(typeof(Text))
	arg0_1._nameTF = arg1_1:Find("nameContain/name")
	arg0_1._lvText = arg1_1:Find("nameContain/Text"):GetComponent(typeof(Text))
	arg0_1._level = arg1_1:Find("level")
	arg0_1._typeIcon = arg1_1:Find("typeIcon/icon"):GetComponent(typeof(Image))
	arg0_1._eliteLabel = arg1_1:Find("grade/elite")
	arg0_1._generalLabel = arg1_1:Find("grade/general")
	arg0_1._flag = true
	arg0_1._isExistBoos = false

	arg0_1:Show(false)
end

function var1_0.GetCurrentTarget(arg0_2)
	return arg0_2._targetUnit
end

function var1_0.Show(arg0_3, arg1_3)
	if arg0_3._curActive ~= arg1_3 then
		arg0_3._curActive = arg1_3

		if arg1_3 then
			arg0_3._monsterTF.anchoredPosition = arg0_3.orgPos
		else
			arg0_3._monsterTF.anchoredPosition = arg0_3.HidePos
		end
	end
end

function var1_0.SetIconType(arg0_4, arg1_4)
	if arg0_4._eliteType == arg1_4 then
		return
	end

	arg0_4._eliteType = arg1_4

	setActive(arg0_4._generalLabel, not arg1_4)
	setActive(arg0_4._eliteLabel, arg1_4)
end

function var1_0.SwitchTarget(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in pairs(arg2_5) do
		if iter1_5:IsBoss() then
			arg0_5._isExistBoos = true

			break
		end
	end

	if arg0_5._flag == false or arg0_5._isExistBoos == true then
		arg0_5:Show(false)

		return
	end

	arg0_5._targetUnit = arg1_5

	arg0_5:Show(true)

	local var0_5 = arg1_5:GetHPRate()

	arg0_5._hpBarProgress.fillAmount = var0_5

	arg0_5:UpdateHpText(arg1_5)
	arg0_5:SetIconType(arg1_5:GetTemplate().icon_type ~= 0)

	local var1_5 = var0_0.Battle.BattleDataFunction.GetEnemyTypeDataByType(arg1_5:GetTemplate().type).type
	local var2_5 = GetSpriteFromAtlas("shiptype", shipType2Battleprint(var1_5))

	arg0_5._typeIcon.sprite = var2_5

	arg0_5._typeIcon:SetNativeSize()
	changeToScrollText(arg0_5._nameTF, arg1_5._tmpData.name)

	arg0_5._lvText.text = " Lv." .. arg1_5:GetLevel()
end

function var1_0.UpdateHpText(arg0_6)
	local var0_6, var1_6 = arg0_6._targetUnit:GetHP()

	arg0_6._hpBarText.text = tostring(math.floor(var0_6) .. "/" .. math.floor(var1_6))
end

function var1_0.UpdateHpBar(arg0_7)
	if arg0_7._flag == false or arg0_7._isExistBoos == true then
		return
	end

	LeanTween.cancel(arg0_7._hpBar)

	local var0_7 = arg0_7._targetUnit:GetHPRate()

	arg0_7:UpdateHpText(target)

	local var1_7 = arg0_7._hpBarProgress.fillAmount

	if var0_7 < var1_7 then
		LeanTween.value(arg0_7._hpBar, var1_7, var0_7, 0.5):setOnUpdate(System.Action_float(function(arg0_8)
			arg0_7._hpBarProgress.fillAmount = arg0_8
		end))
	else
		arg0_7._hpBarProgress.fillAmount = var0_7
	end

	if var0_7 == 0 then
		arg0_7:RemoveUnit()
	end
end

function var1_0.RemoveUnit(arg0_9, arg1_9)
	arg0_9._targetUnit = nil
	arg0_9._flag = false

	local function var0_9()
		arg0_9._flag = true

		arg0_9:Show(false)
	end

	if arg1_9 then
		arg0_9._deathTimer = pg.TimeMgr.GetInstance():AddBattleTimer("death", 0, 1, function()
			var0_9()
			pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_9._deathTimer)
		end)
	else
		var0_9()
	end
end

function var1_0.Dispose(arg0_12)
	arg0_12:Show(false)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_12._deathTimer)
	LeanTween.cancel(arg0_12._hpBar)

	arg0_12._hpBarProgress = nil
	arg0_12._hpBar = nil
	arg0_12._hpBarTF = nil
	arg0_12._monsterTF = nil
	arg0_12._monster = nil
end
