ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = class("BattleBossCharacter", var0_0.Battle.BattleEnemyCharacter)

var0_0.Battle.BattleBossCharacter = var2_0
var2_0.__name = "BattleBossCharacter"

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.Dispose(arg0_2)
	if not arg0_2._chargeTimer.paused then
		arg0_2._chargeTimer:Stop()
	end

	if arg0_2._castClock then
		arg0_2._castClock:Dispose()

		arg0_2._castClock = nil
	end

	if arg0_2._aimBiarBar then
		local var0_2 = arg0_2._aimBiarBar:GetGO()

		arg0_2._factory:GetHPBarPool():DestroyObj(var0_2)
		arg0_2._aimBiarBar:Dispose()

		arg0_2._aimBiarBar = nil
	end

	LeanTween.cancel(arg0_2._HPBar)
	var2_0.super.Dispose(arg0_2)
end

function var2_0.Update(arg0_3)
	var2_0.super.Update(arg0_3)
	arg0_3:UpdateCastClockPosition()

	if arg0_3._armor then
		arg0_3:UpdateCastClock()
	end

	arg0_3:UpdateBarrierClockPosition()

	if arg0_3._barrier then
		arg0_3:updateBarrierClock()
	end
end

function var2_0.UpdateVigilantBarPosition(arg0_4)
	local var0_4 = arg0_4._referenceVector + arg0_4._hpBarOffset

	arg0_4._vigilantBar:UpdateVigilantBarPosition(var0_4)
end

function var2_0.RegisterWeaponListener(arg0_5, arg1_5)
	var2_0.super.RegisterWeaponListener(arg0_5, arg1_5)
	arg1_5:RegisterEventListener(arg0_5, var1_0.WEAPON_INTERRUPT, arg0_5.onWeaponInterrupted)
end

function var2_0.UnregisterWeaponListener(arg0_6, arg1_6)
	var2_0.super.UnregisterWeaponListener(arg0_6, arg1_6)
	arg1_6:UnregisterEventListener(arg0_6, var1_0.WEAPON_INTERRUPT)
end

function var2_0.AddHPBar(arg0_7, arg1_7, arg2_7)
	arg0_7._HPBar = arg1_7
	arg0_7._HPBarTf = arg1_7.transform

	arg1_7:SetActive(true)
	arg0_7._unitData:RegisterEventListener(arg0_7, var1_0.UPDATE_HP, arg0_7.OnUpdateHP)

	arg0_7._HPBarCountText = arg0_7._HPBarTf:Find("HPBarCount"):GetComponent(typeof(Text))
	arg0_7._activeVernier = arg2_7

	arg0_7:SetTemplateInfo()
	arg0_7:initBarComponent()
	arg0_7:SetHPBarCountText(arg0_7._HPBarTotalCount)

	arg0_7._cacheHP = arg0_7._unitData:GetMaxHP()

	arg0_7:UpdateHpBar()
	arg0_7:initBarrierBar()
end

function var2_0.SetTemplateInfo(arg0_8)
	local var0_8 = arg0_8._unitData:GetTemplate()
	local var1_8 = ""

	if var0_8 then
		var1_8 = var0_8.name
	end

	changeToScrollText(arg0_8._HPBarTf:Find("BossName"), var1_8)

	arg0_8._HPBarTf:Find("BossLv"):GetComponent(typeof(Text)).text = "Lv." .. arg0_8._unitData:GetLevel()

	local var2_8 = pg.enemy_data_by_type[var0_8.type].type
	local var3_8 = GetSpriteFromAtlas("shiptype", shipType2Battleprint(var2_8))

	setImageSprite(arg0_8._HPBarTf:Find("BossIcon/typeIcon/icon"), var3_8, true)

	local var4_8 = var0_0.Battle.BattleResourceManager.GetInstance():GetCharacterSquareIcon(arg0_8._bossIcon)

	setImageSprite(findTF(arg0_8._HPBarTf, "BossIcon/icon"), var4_8)

	arg0_8._armorBar = arg0_8._HPBarTf:Find("ArmorBar")
	arg0_8._armorProgress = arg0_8._HPBarTf:Find("ArmorBar/armorProgress"):GetComponent(typeof(Image))

	SetActive(arg0_8._armorBar, false)

	arg0_8._barrierBar = arg0_8._HPBarTf:Find("ShieldBar")
	arg0_8._barrierProgress = arg0_8._barrierBar:Find("shieldProgress"):GetComponent(typeof(Image))

	SetActive(arg0_8._barrierBar, false)
end

function var2_0.SetBossData(arg0_9, arg1_9)
	arg0_9._bossBarInfoList = {}
	arg0_9._HPBarTotalCount = arg1_9.hpBarNum or 1
	arg0_9._hideBarNum = arg1_9.hideBarNum
	arg0_9._bossIcon = arg0_9:GetUnitData():GetTemplate().icon
	arg0_9._bossIndex = arg1_9.bossCount
end

function var2_0.GetBossIndex(arg0_10)
	return arg0_10._bossIndex
end

function var2_0.initBarComponent(arg0_11)
	arg0_11._stepHP = arg0_11:GetUnitData():GetMaxHP() / arg0_11._HPBarTotalCount

	local var0_11 = 1

	arg0_11._resTotalCount = 5
	arg0_11._bossBarInfoList = {}

	while var0_11 <= arg0_11._resTotalCount do
		local var1_11 = {}
		local var2_11 = "bloodBarContainer/hp_" .. var0_11
		local var3_11 = var2_11 .. "_delta"
		local var4_11 = arg0_11._HPBarTf:Find(var2_11)
		local var5_11 = arg0_11._HPBarTf:Find(var3_11)

		var1_11.progressImage = var4_11:GetComponent(typeof(Image))
		var1_11.deltaImage = var5_11:GetComponent(typeof(Image))
		var1_11.progressTF = var4_11.transform
		var1_11.deltaTF = var5_11.transform
		var1_11.progressImage.fillAmount = 1
		var1_11.deltaImage.fillAmount = 1
		arg0_11._bossBarInfoList[var0_11] = var1_11
		var0_11 = var0_11 + 1
	end

	arg0_11._topBarIndex = arg0_11._HPBarTf.childCount - 1
	arg0_11._currentFmod = math.fmod(arg0_11._HPBarTotalCount, arg0_11._resTotalCount)

	if arg0_11._currentFmod == 0 then
		arg0_11._currentFmod = arg0_11._resTotalCount
	end

	if arg0_11._HPBarTotalCount < 5 then
		local var6_11 = arg0_11._resTotalCount

		while var6_11 > arg0_11._HPBarTotalCount do
			local var7_11 = "bloodBarContainer/hp_" .. var6_11

			SetActive(arg0_11._HPBarTf:Find(var7_11), false)
			SetActive(arg0_11._HPBarTf:Find(var7_11 .. "_delta"), false)

			var6_11 = var6_11 - 1
		end
	else
		local var8_11 = arg0_11._resTotalCount

		while var8_11 > arg0_11._currentFmod do
			local var9_11 = "bloodBarContainer/hp_" .. var8_11

			arg0_11._HPBarTf:Find(var9_11).transform:SetSiblingIndex(0)
			arg0_11._HPBarTf:Find(var9_11 .. "_delta").transform:SetSiblingIndex(0)

			var8_11 = var8_11 - 1
		end
	end

	if arg0_11._activeVernier then
		arg0_11._vernier = arg0_11._HPBarTf:Find("vernier/tag")

		SetActive(arg0_11._HPBarTf:Find("vernier"), arg0_11._activeVernier)
	end

	arg0_11._chargeTimer = Timer.New(function()
		arg0_11._currentTween = arg0_11:generateTween()
	end, 1)
end

function var2_0.UpdateHpBar(arg0_13)
	local var0_13 = arg0_13._unitData:GetCurrentHP()

	if arg0_13._cacheHP == var0_13 then
		return
	end

	if not arg0_13._chargeTimer.paused then
		arg0_13._chargeTimer:Stop()
		arg0_13._chargeTimer:Stop()
		arg0_13._chargeTimer:Reset()
	end

	local var1_13, var2_13, var3_13 = arg0_13:GetCurrentFmod()

	arg0_13:SortBar(var1_13, var3_13)

	arg0_13._currentFmod = var1_13
	arg0_13._currentDivision = var3_13

	if var0_13 < arg0_13._cacheHP then
		if arg0_13._currentDivision ~= var3_13 then
			LeanTween.cancel(arg0_13._HPBar)
		end

		arg0_13._chargeTimer:Start()
	end

	arg0_13._bossBarInfoList[var1_13].progressImage.fillAmount = var2_13

	if arg0_13._activeVernier then
		arg0_13._vernier.anchorMin = Vector2(var2_13, 0.5)
		arg0_13._vernier.anchorMax = Vector2(var2_13, 0.5)
	end

	arg0_13:SetHPBarCountText(var3_13)

	arg0_13._cacheHP = var0_13
end

function var2_0.generateTween(arg0_14)
	local var0_14 = arg0_14._bossBarInfoList[arg0_14._currentFmod]
	local var1_14 = var0_14.deltaImage
	local var2_14 = var0_14.progressImage.fillAmount

	duration = duration or 0.7

	return (LeanTween.value(go(arg0_14._HPBar), var1_14.fillAmount, var2_14, 0.7):setOnUpdate(System.Action_float(function(arg0_15)
		var1_14.fillAmount = arg0_15
	end)))
end

function var2_0.GetCurrentFmod(arg0_16)
	local var0_16 = arg0_16._unitData:GetCurrentHP()
	local var1_16, var2_16 = math.modf(var0_16 / arg0_16._stepHP)
	local var3_16 = var1_16 + 1
	local var4_16 = math.fmod(var3_16, arg0_16._resTotalCount)

	if var4_16 == 0 then
		var4_16 = 5
	end

	return var4_16, var2_16, var3_16
end

function var2_0.SortBar(arg0_17, arg1_17, arg2_17)
	if arg1_17 == arg0_17._currentFmod then
		return
	elseif arg1_17 > arg0_17._currentFmod then
		local var0_17 = arg0_17._currentFmod

		arg0_17._bossBarInfoList[var0_17].progressImage.fillAmount = 1
		arg0_17._bossBarInfoList[var0_17].deltaImage.fillAmount = 1

		while var0_17 < arg1_17 do
			var0_17 = var0_17 + 1

			local var1_17 = arg0_17._bossBarInfoList[var0_17]

			var1_17.deltaTF:SetSiblingIndex(arg0_17._topBarIndex)
			var1_17.progressTF:SetSiblingIndex(arg0_17._topBarIndex)
			SetActive(var1_17.progressImage, true)
			SetActive(var1_17.deltaImage, true)
		end
	elseif arg1_17 < arg0_17._currentFmod then
		local var2_17 = arg0_17._currentFmod

		while arg1_17 < var2_17 do
			local var3_17 = arg0_17._bossBarInfoList[var2_17]

			var3_17.progressImage.fillAmount = 1
			var3_17.deltaImage.fillAmount = 1

			var3_17.progressTF:SetSiblingIndex(0)
			var3_17.deltaTF:SetSiblingIndex(0)

			if arg2_17 < arg0_17._resTotalCount then
				SetActive(var3_17.progressImage, false)
				SetActive(var3_17.deltaImage, false)
			end

			var2_17 = var2_17 - 1
		end
	end
end

function var2_0.SetHPBarCountText(arg0_18, arg1_18)
	if arg0_18._hideBarNum then
		arg0_18._HPBarCountText.text = "X??"
	else
		arg0_18._HPBarCountText.text = "X " .. arg1_18
	end
end

function var2_0.UpdateHPBarPosition(arg0_19)
	if arg0_19._normalHPTF and not arg0_19._hideHP then
		arg0_19._hpBarPos:Copy(arg0_19._referenceVector):Add(arg0_19._hpBarOffset)

		arg0_19._normalHPTF.position = arg0_19._hpBarPos
	end
end

function var2_0.onWeaponPreCast(arg0_20, arg1_20)
	var2_0.super.onWeaponPreCast(arg0_20, arg1_20)

	local var0_20 = arg1_20.Data
	local var1_20 = var0_20.armor

	arg0_20:initArmorBar(var0_20.armor)

	if var1_20 and var1_20 ~= 0 then
		arg0_20:initCastClock(var0_20.time, arg1_20.Dispatcher)
	end
end

function var2_0.onWeaponPrecastFinish(arg0_21, arg1_21)
	var2_0.super.onWeaponPrecastFinish(arg0_21, arg1_21)

	local var0_21 = arg1_21.Data.armor
	local var1_21 = arg1_21.Dispatcher

	if arg0_21._castClock:GetCastingWeapon() == var1_21 and var0_21 and var0_21 ~= 0 then
		if arg0_21._armor <= 0 then
			arg0_21._castClock:Interrupt(true)
		else
			arg0_21._castClock:Interrupt(false)
		end

		arg0_21._armor = nil

		SetActive(arg0_21._armorBar, false)
	end
end

function var2_0.onWeaponInterrupted(arg0_22, arg1_22)
	arg0_22._unitData:StateChange(var0_0.Battle.UnitState.STATE_INTERRUPT)
end

function var2_0.initArmorBar(arg0_23, arg1_23)
	if arg1_23 and arg1_23 ~= 0 then
		arg0_23._armor = arg1_23
		arg0_23._totalArmor = arg1_23

		arg0_23:updateWeaponArmor()
		SetActive(arg0_23._armorBar, true)
	end
end

function var2_0.OnUpdateHP(arg0_24, arg1_24)
	local var0_24 = arg1_24.Data.preShieldHP

	if arg0_24._barrier and var0_24 < 0 then
		arg0_24._barrier = arg0_24._barrier + var0_24

		arg0_24:updateBarrierBar()
	end

	var2_0.super.OnUpdateHP(arg0_24, arg1_24)

	local var1_24 = arg1_24.Data.dHP

	if arg0_24._armor and var1_24 < 0 then
		arg0_24._armor = arg0_24._armor + var1_24

		arg0_24:updateWeaponArmor()
	end
end

function var2_0.updateWeaponArmor(arg0_25)
	arg0_25._armorProgress.fillAmount = arg0_25._armor / arg0_25._totalArmor
end

function var2_0.initCastClock(arg0_26, arg1_26, arg2_26)
	arg0_26._castClock:Casting(arg1_26, arg2_26)

	arg0_26._castFinishTime = pg.TimeMgr.GetInstance():GetCombatTime() + arg1_26
	arg0_26._castDuration = arg1_26
end

function var2_0.UpdateCastClock(arg0_27)
	arg0_27._castClock:UpdateCastClock()
end

function var2_0.updateComponentDiveInvisible(arg0_28)
	var2_0.super.updateComponentDiveInvisible(arg0_28)
	SetActive(arg0_28._HPBarTf, true)
end

function var2_0.updateComponentVisible(arg0_29)
	var2_0.super.updateComponentVisible(arg0_29)
	SetActive(arg0_29._HPBarTf, true)
end

function var2_0.initBarrierBar(arg0_30)
	arg0_30._unitData:RegisterEventListener(arg0_30, var1_0.BARRIER_STATE_CHANGE, arg0_30.onBarrierStateChange)
end

function var2_0.onBarrierStateChange(arg0_31, arg1_31)
	local var0_31 = arg1_31.Data.barrierDurability
	local var1_31 = arg1_31.Data.barrierDuration

	SetActive(arg0_31._barrierBar, var0_31 > 0)

	if var0_31 > 0 then
		arg0_31._totalBarrier = var0_31
		arg0_31._barrier = var0_31

		arg0_31:initBarrierClock(var1_31)
		arg0_31:updateBarrierBar()
		arg0_31:updateBarrierClock()
	else
		arg0_31._barrier = nil
		arg0_31._totalBarrier = nil

		arg0_31._barrierClock:Interrupt()
	end
end

function var2_0.updateBarrierBar(arg0_32)
	arg0_32._barrierProgress.fillAmount = arg0_32._barrier / arg0_32._totalBarrier
end

function var2_0.updateBarrierClock(arg0_33)
	arg0_33._barrierClock:UpdateBarrierClockProgress()
end

function var2_0.initBarrierClock(arg0_34, arg1_34)
	arg0_34._barrierClock:Shielding(arg1_34)
end

function var2_0.AddAimBiasBar(arg0_35, arg1_35)
	arg0_35._normalHPTF = arg1_35
	arg0_35._aimBiarBarTF = arg1_35:Find("biasBar")
	arg0_35._aimBiarBar = var0_0.Battle.BattleAimbiasBar.New(arg0_35._aimBiarBarTF)

	arg0_35._aimBiarBar:ConfigAimBias(arg0_35._unitData:GetAimBias())
	arg0_35._aimBiarBar:UpdateAimBiasProgress()
end

function var2_0.AddModel(arg0_36, arg1_36)
	var2_0.super.AddModel(arg0_36, arg1_36)
	arg0_36:UpdatePosition()
end
