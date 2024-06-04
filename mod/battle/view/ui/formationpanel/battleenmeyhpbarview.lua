ys = ys or {}

local var0 = ys
local var1 = class("BattleEnmeyHpBarView")

var0.Battle.BattleEnmeyHpBarView = var1
var1.__name = "BattleEnmeyHpBarView"

function var1.Ctor(arg0, arg1)
	arg0._monsterTF = arg1
	arg0.orgPos = arg1.anchoredPosition
	arg0.HidePos = arg0.orgPos + Vector2(0, 100)
	arg0._hpBarTF = arg1:Find("hpbar")
	arg0._hpBar = arg0._hpBarTF.gameObject
	arg0._hpBarProgress = arg0._hpBarTF:GetComponent(typeof(Image))
	arg0._hpBarText = arg0._hpBarTF:Find("Text"):GetComponent(typeof(Text))
	arg0._nameTF = arg1:Find("nameContain/name")
	arg0._lvText = arg1:Find("nameContain/Text"):GetComponent(typeof(Text))
	arg0._level = arg1:Find("level")
	arg0._typeIcon = arg1:Find("typeIcon/icon"):GetComponent(typeof(Image))
	arg0._eliteLabel = arg1:Find("grade/elite")
	arg0._generalLabel = arg1:Find("grade/general")
	arg0._flag = true
	arg0._isExistBoos = false

	arg0:Show(false)
end

function var1.GetCurrentTarget(arg0)
	return arg0._targetUnit
end

function var1.Show(arg0, arg1)
	if arg0._curActive ~= arg1 then
		arg0._curActive = arg1

		if arg1 then
			arg0._monsterTF.anchoredPosition = arg0.orgPos
		else
			arg0._monsterTF.anchoredPosition = arg0.HidePos
		end
	end
end

function var1.SetIconType(arg0, arg1)
	if arg0._eliteType == arg1 then
		return
	end

	arg0._eliteType = arg1

	setActive(arg0._generalLabel, not arg1)
	setActive(arg0._eliteLabel, arg1)
end

function var1.SwitchTarget(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg2) do
		if iter1:IsBoss() then
			arg0._isExistBoos = true

			break
		end
	end

	if arg0._flag == false or arg0._isExistBoos == true then
		arg0:Show(false)

		return
	end

	arg0._targetUnit = arg1

	arg0:Show(true)

	local var0 = arg1:GetHPRate()

	arg0._hpBarProgress.fillAmount = var0

	arg0:UpdateHpText(arg1)
	arg0:SetIconType(arg1:GetTemplate().icon_type ~= 0)

	local var1 = var0.Battle.BattleDataFunction.GetEnemyTypeDataByType(arg1:GetTemplate().type).type
	local var2 = GetSpriteFromAtlas("shiptype", shipType2Battleprint(var1))

	arg0._typeIcon.sprite = var2

	arg0._typeIcon:SetNativeSize()
	changeToScrollText(arg0._nameTF, arg1._tmpData.name)

	arg0._lvText.text = " Lv." .. arg1:GetLevel()
end

function var1.UpdateHpText(arg0)
	local var0, var1 = arg0._targetUnit:GetHP()

	arg0._hpBarText.text = tostring(math.floor(var0) .. "/" .. math.floor(var1))
end

function var1.UpdateHpBar(arg0)
	if arg0._flag == false or arg0._isExistBoos == true then
		return
	end

	LeanTween.cancel(arg0._hpBar)

	local var0 = arg0._targetUnit:GetHPRate()

	arg0:UpdateHpText(target)

	local var1 = arg0._hpBarProgress.fillAmount

	if var0 < var1 then
		LeanTween.value(arg0._hpBar, var1, var0, 0.5):setOnUpdate(System.Action_float(function(arg0)
			arg0._hpBarProgress.fillAmount = arg0
		end))
	else
		arg0._hpBarProgress.fillAmount = var0
	end

	if var0 == 0 then
		arg0:RemoveUnit()
	end
end

function var1.RemoveUnit(arg0, arg1)
	arg0._targetUnit = nil
	arg0._flag = false

	local function var0()
		arg0._flag = true

		arg0:Show(false)
	end

	if arg1 then
		arg0._deathTimer = pg.TimeMgr.GetInstance():AddBattleTimer("death", 0, 1, function()
			var0()
			pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._deathTimer)
		end)
	else
		var0()
	end
end

function var1.Dispose(arg0)
	arg0:Show(false)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._deathTimer)
	LeanTween.cancel(arg0._hpBar)

	arg0._hpBarProgress = nil
	arg0._hpBar = nil
	arg0._hpBarTF = nil
	arg0._monsterTF = nil
	arg0._monster = nil
end
