ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleCloakBar = class("BattleCloakBar")
var0_0.Battle.BattleCloakBar.__name = "BattleCloakBar"

local var1_0 = var0_0.Battle.BattleCloakBar

var1_0.FORM_RAD = "radian"
var1_0.FORM_BAR = "bar"
var1_0.MIN = 0.31
var1_0.MAX = 0.69
var1_0.METER_LENGTH = var1_0.MAX - var1_0.MIN
var1_0.MIN_ANGLE = -31
var1_0.MAX_ANGLE = 33
var1_0.RESTORE_LEGHTH = var1_0.MAX_ANGLE - var1_0.MIN_ANGLE
var1_0.BAR_MIN = -62
var1_0.BAR_MAX = 62
var1_0.BAR_STEP = var1_0.BAR_MAX - var1_0.BAR_MIN

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg2_1 = arg2_1 or var1_0.FORM_RAD
	arg0_1._cloakBar = arg1_1
	arg0_1._cloakBarGO = arg0_1._cloakBar.gameObject
	arg0_1._progress = arg0_1._cloakBar:Find("progress"):GetComponent(typeof(Image))
	arg0_1._restoreMark = arg0_1._cloakBar:Find("cloak_restore")
	arg0_1._lockProgress = arg0_1._cloakBar:Find("lock"):GetComponent(typeof(Image))
	arg0_1._exposeFX = arg0_1._cloakBar:Find("top_effect")
	arg0_1._markContainer = arg0_1._cloakBar:Find("mark")
	arg0_1._exposeMark = arg0_1._cloakBar:Find("mark/2")
	arg0_1._visionMark = arg0_1._cloakBar:Find("mark/1")

	setActive(arg0_1._cloakBar, true)
	setActive(arg0_1._exposeFX, false)
	setActive(arg0_1._exposeMark, false)
	setActive(arg0_1._visionMark, false)

	if arg2_1 == var1_0.FORM_RAD then
		arg0_1._restoreMark.localRotation = Vector3(0, 0, 0)
		arg0_1.meterConvert = var1_0.__radMeterConvert
		arg0_1.restoreConvert = var1_0.__radRestoreConvert
	else
		arg0_1.meterConvert = var1_0.__barMeterConvert
		arg0_1.restoreConvert = var1_0.__barRestoreConvert
	end
end

function var1_0.SetActive(arg0_2, arg1_2)
	setActive(arg0_2._cloakBar, arg1_2)
end

function var1_0.ConfigCloak(arg0_3, arg1_3)
	arg0_3._cloakComponent = arg1_3

	arg0_3:initCloak()
end

function var1_0.UpdateCloakProgress(arg0_4)
	local var0_4 = arg0_4._cloakComponent:GetCloakValue() / arg0_4._meterMaxValue

	arg0_4._progress.fillAmount = arg0_4.meterConvert(var0_4)

	local var1_4 = arg0_4._cloakComponent:GetCurrentState()

	if var1_4 == var0_0.Battle.BattleUnitCloakComponent.STATE_CLOAK then
		setActive(arg0_4._exposeFX, false)
	elseif var1_4 == var0_0.Battle.BattleUnitCloakComponent.STATE_UNCLOAK then
		setActive(arg0_4._exposeFX, true)
	end

	if var1_4 == var0_0.Battle.BattleUnitCloakComponent.STATE_UNCLOAK then
		setActive(arg0_4._exposeMark, true)
		setActive(arg0_4._visionMark, false)
	elseif arg0_4._cloakComponent:GetExposeSpeed() > 0 then
		setActive(arg0_4._exposeMark, false)
		setActive(arg0_4._visionMark, true)
	else
		setActive(arg0_4._exposeMark, false)
		setActive(arg0_4._visionMark, false)
	end
end

local var2_0 = Vector3.New(-1, 1, 1)
local var3_0 = Vector3.New(-0.5, 0.5, 1)
local var4_0 = Vector3.New(0.5, 0.5, 1)

function var1_0.UpdateCloarBarPosition(arg0_5, arg1_5)
	if arg1_5.x < 0 then
		arg0_5._cloakBar.position = arg1_5 + Vector3.right
		arg0_5._cloakBar.localScale = Vector3.one
		arg0_5._markContainer.localScale = var4_0
	else
		arg0_5._cloakBar.position = arg1_5 + Vector3.left
		arg0_5._cloakBar.localScale = var2_0
		arg0_5._markContainer.localScale = var3_0
	end
end

function var1_0.UpdateCloakConfig(arg0_6)
	arg0_6:initCloak()
end

function var1_0.UpdateCloakLock(arg0_7)
	local var0_7 = arg0_7._cloakComponent:GetCloakBottom() / arg0_7._meterMaxValue

	arg0_7._lockProgress.fillAmount = arg0_7.meterConvert(var0_7)
end

function var1_0.initCloak(arg0_8)
	arg0_8._meterMaxValue = arg0_8._cloakComponent:GetCloakMax()

	arg0_8:updateRestoreMark()
end

function var1_0.updateRestoreMark(arg0_9)
	local var0_9 = arg0_9._cloakComponent:GetCloakRestoreValue() / arg0_9._meterMaxValue

	arg0_9.restoreConvert(var0_9, arg0_9._restoreMark)
end

function var1_0.__radMeterConvert(arg0_10)
	return var1_0.METER_LENGTH * arg0_10 + var1_0.MIN
end

function var1_0.__radRestoreConvert(arg0_11, arg1_11)
	local var0_11 = var1_0.RESTORE_LEGHTH * arg0_11 + var1_0.MIN_ANGLE

	arg1_11.localRotation = Quaternion.Euler(0, 0, var0_11)
end

function var1_0.__barMeterConvert(arg0_12)
	return arg0_12
end

function var1_0.__barRestoreConvert(arg0_13, arg1_13)
	local var0_13 = var1_0.BAR_STEP * arg0_13 + var1_0.BAR_MIN

	arg1_13.localPosition = Vector3(var0_13, 0, 0)
end

function var1_0.Dispose(arg0_14)
	arg0_14._cloakComponent = nil
	arg0_14._cloakBar = nil
	arg0_14._progress = nil
	arg0_14._restoreMark = nil
	arg0_14._exposeFX = nil

	Object.Destroy(arg0_14._cloakBarGO)

	arg0_14._cloakBarGO = nil
end
