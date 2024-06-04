local var0 = class("CommanderHomeLevelCard")
local var1 = "#9A9898"
local var2 = "#a59897"
local var3 = "#6a5a5a"

function var0.Ctor(arg0, arg1, arg2)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.view = arg2
	arg0.mask = findTF(arg0._tf, "mask"):GetComponent(typeof(RectMask2D))
	arg0.progress = findTF(arg0._tf, "mask/progress/bar")
	arg0.unlockTF = findTF(arg0._tf, "unlock")
	arg0.doingTF = findTF(arg0._tf, "doing")
	arg0.lockTF = findTF(arg0._tf, "lock")
	arg0.levelTxt = findTF(arg0._tf, "level"):GetComponent(typeof(Text))
	arg0.descUnLockIcon = findTF(arg0._tf, "desc/icon_pass")
	arg0.descDoingIcon = findTF(arg0._tf, "desc/icon_doing")
	arg0.descTxt = findTF(arg0._tf, "desc/Text"):GetComponent(typeof(Text))
	arg0.expTxt = findTF(arg0._tf, "exp"):GetComponent(typeof(Text))
end

function var0.Update(arg0, arg1, arg2)
	arg0:Clear()

	arg0.home = arg1
	arg0.config = arg2

	local var0 = arg2.level

	arg0.mask.enabled = arg2.tail == true

	setActive(arg0.unlockTF, false)
	setActive(arg0.doingTF, false)
	setActive(arg0.lockTF, false)
	setActive(arg0.descUnLockIcon, false)
	setActive(arg0.descDoingIcon, false)

	local var1

	if arg1.level + 1 == arg2.level then
		arg0:UpdateDoingState()

		var1 = var3
	elseif arg1.level < arg2.level then
		arg0:UpdateLockState()

		var1 = var1
	elseif arg1.level >= arg2.level then
		arg0:UpdateUnlockState()

		var1 = var2
	end

	arg0.levelTxt.text = setColorStr("LV." .. arg2.level, var1)
	arg0.descTxt.text = setColorStr(shortenString(arg2.desc, 12), var1)
	arg0.expTxt.text = setColorStr(arg2.totalExp, var1)
end

function var0.UpdateLockState(arg0)
	setFillAmount(arg0.progress, 0)
	setActive(arg0.lockTF, true)
	onButton(nil, arg0.lockTF, function()
		arg0:ShowDesc()
	end, SFX_PANEL)
end

function var0.UpdateDoingState(arg0)
	local var0 = pg.commander_home[arg0.config.level - 1]
	local var1 = 0

	if var0 then
		var1 = var0.home_exp
	end

	setFillAmount(arg0.progress, arg0.home.exp / var1)
	setActive(arg0.doingTF, true)
	setActive(arg0.descDoingIcon, true)
	onButton(nil, arg0.doingTF, function()
		arg0:ShowDesc()
	end, SFX_PANEL)
end

function var0.UpdateUnlockState(arg0)
	setFillAmount(arg0.progress, 1)
	setActive(arg0.unlockTF, true)
	setActive(arg0.descUnLockIcon, true)
	onButton(nil, arg0.unlockTF, function()
		arg0:ShowDesc()
	end, SFX_PANEL)
end

function var0.ShowDesc(arg0)
	arg0.view:ShowDescWindow(arg0.config.desc, arg0.config.level)
end

function var0.Clear(arg0)
	removeOnButton(arg0.lockTF)
	removeOnButton(arg0.doingTF)
	removeOnButton(arg0.unlockTF)
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
