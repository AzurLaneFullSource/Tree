ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = class("BattleBossCharacter", var0.Battle.BattleEnemyCharacter)

var0.Battle.BattleBossCharacter = var2
var2.__name = "BattleBossCharacter"

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.Dispose(arg0)
	if not arg0._chargeTimer.paused then
		arg0._chargeTimer:Stop()
	end

	if arg0._castClock then
		arg0._castClock:Dispose()

		arg0._castClock = nil
	end

	if arg0._aimBiarBar then
		local var0 = arg0._aimBiarBar:GetGO()

		arg0._factory:GetHPBarPool():DestroyObj(var0)
		arg0._aimBiarBar:Dispose()

		arg0._aimBiarBar = nil
	end

	LeanTween.cancel(arg0._HPBar)
	var2.super.Dispose(arg0)
end

function var2.Update(arg0)
	var2.super.Update(arg0)
	arg0:UpdateCastClockPosition()

	if arg0._armor then
		arg0:UpdateCastClock()
	end

	arg0:UpdateBarrierClockPosition()

	if arg0._barrier then
		arg0:updateBarrierClock()
	end
end

function var2.UpdateVigilantBarPosition(arg0)
	local var0 = arg0._referenceVector + arg0._hpBarOffset

	arg0._vigilantBar:UpdateVigilantBarPosition(var0)
end

function var2.RegisterWeaponListener(arg0, arg1)
	var2.super.RegisterWeaponListener(arg0, arg1)
	arg1:RegisterEventListener(arg0, var1.WEAPON_INTERRUPT, arg0.onWeaponInterrupted)
end

function var2.UnregisterWeaponListener(arg0, arg1)
	var2.super.UnregisterWeaponListener(arg0, arg1)
	arg1:UnregisterEventListener(arg0, var1.WEAPON_INTERRUPT)
end

function var2.AddHPBar(arg0, arg1, arg2)
	arg0._HPBar = arg1
	arg0._HPBarTf = arg1.transform

	arg1:SetActive(true)
	arg0._unitData:RegisterEventListener(arg0, var1.UPDATE_HP, arg0.OnUpdateHP)

	arg0._HPBarCountText = arg0._HPBarTf:Find("HPBarCount"):GetComponent(typeof(Text))
	arg0._activeVernier = arg2

	arg0:SetTemplateInfo()
	arg0:initBarComponent()
	arg0:SetHPBarCountText(arg0._HPBarTotalCount)

	arg0._cacheHP = arg0._unitData:GetMaxHP()

	arg0:UpdateHpBar()
	arg0:initBarrierBar()
end

function var2.SetTemplateInfo(arg0)
	local var0 = arg0._unitData:GetTemplate()
	local var1 = ""

	if var0 then
		var1 = var0.name
	end

	changeToScrollText(arg0._HPBarTf:Find("BossName"), var1)

	arg0._HPBarTf:Find("BossLv"):GetComponent(typeof(Text)).text = "Lv." .. arg0._unitData:GetLevel()

	local var2 = pg.enemy_data_by_type[var0.type].type
	local var3 = GetSpriteFromAtlas("shiptype", shipType2Battleprint(var2))

	setImageSprite(arg0._HPBarTf:Find("BossIcon/typeIcon/icon"), var3, true)

	local var4 = var0.Battle.BattleResourceManager.GetInstance():GetCharacterSquareIcon(arg0._bossIcon)

	setImageSprite(findTF(arg0._HPBarTf, "BossIcon/icon"), var4)

	arg0._armorBar = arg0._HPBarTf:Find("ArmorBar")
	arg0._armorProgress = arg0._HPBarTf:Find("ArmorBar/armorProgress"):GetComponent(typeof(Image))

	SetActive(arg0._armorBar, false)

	arg0._barrierBar = arg0._HPBarTf:Find("ShieldBar")
	arg0._barrierProgress = arg0._barrierBar:Find("shieldProgress"):GetComponent(typeof(Image))

	SetActive(arg0._barrierBar, false)
end

function var2.SetBossData(arg0, arg1)
	arg0._bossBarInfoList = {}
	arg0._HPBarTotalCount = arg1.hpBarNum or 1
	arg0._hideBarNum = arg1.hideBarNum
	arg0._bossIcon = arg0:GetUnitData():GetTemplate().icon
	arg0._bossIndex = arg1.bossCount
end

function var2.GetBossIndex(arg0)
	return arg0._bossIndex
end

function var2.initBarComponent(arg0)
	arg0._stepHP = arg0:GetUnitData():GetMaxHP() / arg0._HPBarTotalCount

	local var0 = 1

	arg0._resTotalCount = 5
	arg0._bossBarInfoList = {}

	while var0 <= arg0._resTotalCount do
		local var1 = {}
		local var2 = "bloodBarContainer/hp_" .. var0
		local var3 = var2 .. "_delta"
		local var4 = arg0._HPBarTf:Find(var2)
		local var5 = arg0._HPBarTf:Find(var3)

		var1.progressImage = var4:GetComponent(typeof(Image))
		var1.deltaImage = var5:GetComponent(typeof(Image))
		var1.progressTF = var4.transform
		var1.deltaTF = var5.transform
		var1.progressImage.fillAmount = 1
		var1.deltaImage.fillAmount = 1
		arg0._bossBarInfoList[var0] = var1
		var0 = var0 + 1
	end

	arg0._topBarIndex = arg0._HPBarTf.childCount - 1
	arg0._currentFmod = math.fmod(arg0._HPBarTotalCount, arg0._resTotalCount)

	if arg0._currentFmod == 0 then
		arg0._currentFmod = arg0._resTotalCount
	end

	if arg0._HPBarTotalCount < 5 then
		local var6 = arg0._resTotalCount

		while var6 > arg0._HPBarTotalCount do
			local var7 = "bloodBarContainer/hp_" .. var6

			SetActive(arg0._HPBarTf:Find(var7), false)
			SetActive(arg0._HPBarTf:Find(var7 .. "_delta"), false)

			var6 = var6 - 1
		end
	else
		local var8 = arg0._resTotalCount

		while var8 > arg0._currentFmod do
			local var9 = "bloodBarContainer/hp_" .. var8

			arg0._HPBarTf:Find(var9).transform:SetSiblingIndex(0)
			arg0._HPBarTf:Find(var9 .. "_delta").transform:SetSiblingIndex(0)

			var8 = var8 - 1
		end
	end

	if arg0._activeVernier then
		arg0._vernier = arg0._HPBarTf:Find("vernier/tag")

		SetActive(arg0._HPBarTf:Find("vernier"), arg0._activeVernier)
	end

	arg0._chargeTimer = Timer.New(function()
		arg0._currentTween = arg0:generateTween()
	end, 1)
end

function var2.UpdateHpBar(arg0)
	local var0 = arg0._unitData:GetCurrentHP()

	if arg0._cacheHP == var0 then
		return
	end

	if not arg0._chargeTimer.paused then
		arg0._chargeTimer:Stop()
		arg0._chargeTimer:Stop()
		arg0._chargeTimer:Reset()
	end

	local var1, var2, var3 = arg0:GetCurrentFmod()

	arg0:SortBar(var1, var3)

	arg0._currentFmod = var1
	arg0._currentDivision = var3

	if var0 < arg0._cacheHP then
		if arg0._currentDivision ~= var3 then
			LeanTween.cancel(arg0._HPBar)
		end

		arg0._chargeTimer:Start()
	end

	arg0._bossBarInfoList[var1].progressImage.fillAmount = var2

	if arg0._activeVernier then
		arg0._vernier.anchorMin = Vector2(currentRate, 0.5)
		arg0._vernier.anchorMax = Vector2(currentRate, 0.5)
	end

	arg0:SetHPBarCountText(var3)

	arg0._cacheHP = var0
end

function var2.generateTween(arg0)
	local var0 = arg0._bossBarInfoList[arg0._currentFmod]
	local var1 = var0.deltaImage
	local var2 = var0.progressImage.fillAmount

	duration = duration or 0.7

	return (LeanTween.value(go(arg0._HPBar), var1.fillAmount, var2, 0.7):setOnUpdate(System.Action_float(function(arg0)
		var1.fillAmount = arg0
	end)))
end

function var2.GetCurrentFmod(arg0)
	local var0 = arg0._unitData:GetCurrentHP()
	local var1, var2 = math.modf(var0 / arg0._stepHP)
	local var3 = var1 + 1
	local var4 = math.fmod(var3, arg0._resTotalCount)

	if var4 == 0 then
		var4 = 5
	end

	return var4, var2, var3
end

function var2.SortBar(arg0, arg1, arg2)
	if arg1 == arg0._currentFmod then
		return
	elseif arg1 > arg0._currentFmod then
		local var0 = arg0._currentFmod

		arg0._bossBarInfoList[var0].progressImage.fillAmount = 1
		arg0._bossBarInfoList[var0].deltaImage.fillAmount = 1

		while var0 < arg1 do
			var0 = var0 + 1

			local var1 = arg0._bossBarInfoList[var0]

			var1.deltaTF:SetSiblingIndex(arg0._topBarIndex)
			var1.progressTF:SetSiblingIndex(arg0._topBarIndex)
			SetActive(var1.progressImage, true)
			SetActive(var1.deltaImage, true)
		end
	elseif arg1 < arg0._currentFmod then
		local var2 = arg0._currentFmod

		while arg1 < var2 do
			local var3 = arg0._bossBarInfoList[var2]

			var3.progressImage.fillAmount = 1
			var3.deltaImage.fillAmount = 1

			var3.progressTF:SetSiblingIndex(0)
			var3.deltaTF:SetSiblingIndex(0)

			if arg2 < arg0._resTotalCount then
				SetActive(var3.progressImage, false)
				SetActive(var3.deltaImage, false)
			end

			var2 = var2 - 1
		end
	end
end

function var2.SetHPBarCountText(arg0, arg1)
	if arg0._hideBarNum then
		arg0._HPBarCountText.text = "X??"
	else
		arg0._HPBarCountText.text = "X " .. arg1
	end
end

function var2.UpdateHPBarPosition(arg0)
	if arg0._normalHPTF and not arg0._hideHP then
		arg0._hpBarPos:Copy(arg0._referenceVector):Add(arg0._hpBarOffset)

		arg0._normalHPTF.position = arg0._hpBarPos
	end
end

function var2.onWeaponPreCast(arg0, arg1)
	var2.super.onWeaponPreCast(arg0, arg1)

	local var0 = arg1.Data
	local var1 = var0.armor

	arg0:initArmorBar(var0.armor)

	if var1 and var1 ~= 0 then
		arg0:initCastClock(var0.time, arg1.Dispatcher)
	end
end

function var2.onWeaponPrecastFinish(arg0, arg1)
	var2.super.onWeaponPrecastFinish(arg0, arg1)

	local var0 = arg1.Data.armor
	local var1 = arg1.Dispatcher

	if arg0._castClock:GetCastingWeapon() == var1 and var0 and var0 ~= 0 then
		if arg0._armor <= 0 then
			arg0._castClock:Interrupt(true)
		else
			arg0._castClock:Interrupt(false)
		end

		arg0._armor = nil

		SetActive(arg0._armorBar, false)
	end
end

function var2.onWeaponInterrupted(arg0, arg1)
	arg0._unitData:StateChange(var0.Battle.UnitState.STATE_INTERRUPT)
end

function var2.initArmorBar(arg0, arg1)
	if arg1 and arg1 ~= 0 then
		arg0._armor = arg1
		arg0._totalArmor = arg1

		arg0:updateWeaponArmor()
		SetActive(arg0._armorBar, true)
	end
end

function var2.OnUpdateHP(arg0, arg1)
	local var0 = arg1.Data.preShieldHP

	if arg0._barrier and var0 < 0 then
		arg0._barrier = arg0._barrier + var0

		arg0:updateBarrierBar()
	end

	var2.super.OnUpdateHP(arg0, arg1)

	local var1 = arg1.Data.dHP

	if arg0._armor and var1 < 0 then
		arg0._armor = arg0._armor + var1

		arg0:updateWeaponArmor()
	end
end

function var2.updateWeaponArmor(arg0)
	arg0._armorProgress.fillAmount = arg0._armor / arg0._totalArmor
end

function var2.initCastClock(arg0, arg1, arg2)
	arg0._castClock:Casting(arg1, arg2)

	arg0._castFinishTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1
	arg0._castDuration = arg1
end

function var2.UpdateCastClock(arg0)
	arg0._castClock:UpdateCastClock()
end

function var2.updateComponentDiveInvisible(arg0)
	var2.super.updateComponentDiveInvisible(arg0)
	SetActive(arg0._HPBarTf, true)
end

function var2.updateComponentVisible(arg0)
	var2.super.updateComponentVisible(arg0)
	SetActive(arg0._HPBarTf, true)
end

function var2.initBarrierBar(arg0)
	arg0._unitData:RegisterEventListener(arg0, var1.BARRIER_STATE_CHANGE, arg0.onBarrierStateChange)
end

function var2.onBarrierStateChange(arg0, arg1)
	local var0 = arg1.Data.barrierDurability
	local var1 = arg1.Data.barrierDuration

	SetActive(arg0._barrierBar, var0 > 0)

	if var0 > 0 then
		arg0._totalBarrier = var0
		arg0._barrier = var0

		arg0:initBarrierClock(var1)
		arg0:updateBarrierBar()
		arg0:updateBarrierClock()
	else
		arg0._barrier = nil
		arg0._totalBarrier = nil

		arg0._barrierClock:Interrupt()
	end
end

function var2.updateBarrierBar(arg0)
	arg0._barrierProgress.fillAmount = arg0._barrier / arg0._totalBarrier
end

function var2.updateBarrierClock(arg0)
	arg0._barrierClock:UpdateBarrierClockProgress()
end

function var2.initBarrierClock(arg0, arg1)
	arg0._barrierClock:Shielding(arg1)
end

function var2.AddAimBiasBar(arg0, arg1)
	arg0._normalHPTF = arg1
	arg0._aimBiarBarTF = arg1:Find("biasBar")
	arg0._aimBiarBar = var0.Battle.BattleAimbiasBar.New(arg0._aimBiarBarTF)

	arg0._aimBiarBar:ConfigAimBias(arg0._unitData:GetAimBias())
	arg0._aimBiarBar:UpdateAimBiasProgress()
end

function var2.AddModel(arg0, arg1)
	var2.super.AddModel(arg0, arg1)
	arg0:UpdatePosition()
end
