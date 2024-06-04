ys = ys or {}

local var0 = ys

var0.Battle.BattleCloakBar = class("BattleCloakBar")
var0.Battle.BattleCloakBar.__name = "BattleCloakBar"

local var1 = var0.Battle.BattleCloakBar

var1.FORM_RAD = "radian"
var1.FORM_BAR = "bar"
var1.MIN = 0.31
var1.MAX = 0.69
var1.METER_LENGTH = var1.MAX - var1.MIN
var1.MIN_ANGLE = -31
var1.MAX_ANGLE = 33
var1.RESTORE_LEGHTH = var1.MAX_ANGLE - var1.MIN_ANGLE
var1.BAR_MIN = -62
var1.BAR_MAX = 62
var1.BAR_STEP = var1.BAR_MAX - var1.BAR_MIN

function var1.Ctor(arg0, arg1, arg2)
	arg2 = arg2 or var1.FORM_RAD
	arg0._cloakBar = arg1
	arg0._cloakBarGO = arg0._cloakBar.gameObject
	arg0._progress = arg0._cloakBar:Find("progress"):GetComponent(typeof(Image))
	arg0._restoreMark = arg0._cloakBar:Find("cloak_restore")
	arg0._lockProgress = arg0._cloakBar:Find("lock"):GetComponent(typeof(Image))
	arg0._exposeFX = arg0._cloakBar:Find("top_effect")
	arg0._markContainer = arg0._cloakBar:Find("mark")
	arg0._exposeMark = arg0._cloakBar:Find("mark/2")
	arg0._visionMark = arg0._cloakBar:Find("mark/1")

	setActive(arg0._cloakBar, true)
	setActive(arg0._exposeFX, false)
	setActive(arg0._exposeMark, false)
	setActive(arg0._visionMark, false)

	if arg2 == var1.FORM_RAD then
		arg0._restoreMark.localRotation = Vector3(0, 0, 0)
		arg0.meterConvert = var1.__radMeterConvert
		arg0.restoreConvert = var1.__radRestoreConvert
	else
		arg0.meterConvert = var1.__barMeterConvert
		arg0.restoreConvert = var1.__barRestoreConvert
	end
end

function var1.SetActive(arg0, arg1)
	setActive(arg0._cloakBar, arg1)
end

function var1.ConfigCloak(arg0, arg1)
	arg0._cloakComponent = arg1

	arg0:initCloak()
end

function var1.UpdateCloakProgress(arg0)
	local var0 = arg0._cloakComponent:GetCloakValue() / arg0._meterMaxValue

	arg0._progress.fillAmount = arg0.meterConvert(var0)

	local var1 = arg0._cloakComponent:GetCurrentState()

	if var1 == var0.Battle.BattleUnitCloakComponent.STATE_CLOAK then
		setActive(arg0._exposeFX, false)
	elseif var1 == var0.Battle.BattleUnitCloakComponent.STATE_UNCLOAK then
		setActive(arg0._exposeFX, true)
	end

	if var1 == var0.Battle.BattleUnitCloakComponent.STATE_UNCLOAK then
		setActive(arg0._exposeMark, true)
		setActive(arg0._visionMark, false)
	elseif arg0._cloakComponent:GetExposeSpeed() > 0 then
		setActive(arg0._exposeMark, false)
		setActive(arg0._visionMark, true)
	else
		setActive(arg0._exposeMark, false)
		setActive(arg0._visionMark, false)
	end
end

local var2 = Vector3.New(-1, 1, 1)
local var3 = Vector3.New(-0.5, 0.5, 1)
local var4 = Vector3.New(0.5, 0.5, 1)

function var1.UpdateCloarBarPosition(arg0, arg1)
	if arg1.x < 0 then
		arg0._cloakBar.position = arg1 + Vector3.right
		arg0._cloakBar.localScale = Vector3.one
		arg0._markContainer.localScale = var4
	else
		arg0._cloakBar.position = arg1 + Vector3.left
		arg0._cloakBar.localScale = var2
		arg0._markContainer.localScale = var3
	end
end

function var1.UpdateCloakConfig(arg0)
	arg0:initCloak()
end

function var1.UpdateCloakLock(arg0)
	local var0 = arg0._cloakComponent:GetCloakBottom() / arg0._meterMaxValue

	arg0._lockProgress.fillAmount = arg0.meterConvert(var0)
end

function var1.initCloak(arg0)
	arg0._meterMaxValue = arg0._cloakComponent:GetCloakMax()

	arg0:updateRestoreMark()
end

function var1.updateRestoreMark(arg0)
	local var0 = arg0._cloakComponent:GetCloakRestoreValue() / arg0._meterMaxValue

	arg0.restoreConvert(var0, arg0._restoreMark)
end

function var1.__radMeterConvert(arg0)
	return var1.METER_LENGTH * arg0 + var1.MIN
end

function var1.__radRestoreConvert(arg0, arg1)
	local var0 = var1.RESTORE_LEGHTH * arg0 + var1.MIN_ANGLE

	arg1.localRotation = Quaternion.Euler(0, 0, var0)
end

function var1.__barMeterConvert(arg0)
	return arg0
end

function var1.__barRestoreConvert(arg0, arg1)
	local var0 = var1.BAR_STEP * arg0 + var1.BAR_MIN

	arg1.localPosition = Vector3(var0, 0, 0)
end

function var1.Dispose(arg0)
	arg0._cloakComponent = nil
	arg0._cloakBar = nil
	arg0._progress = nil
	arg0._restoreMark = nil
	arg0._exposeFX = nil

	Object.Destroy(arg0._cloakBarGO)

	arg0._cloakBarGO = nil
end
