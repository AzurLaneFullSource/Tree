local var0_0 = class("CommanderHomeLevelCard")
local var1_0 = "#9A9898"
local var2_0 = "#a59897"
local var3_0 = "#6a5a5a"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.view = arg2_1
	arg0_1.mask = findTF(arg0_1._tf, "mask"):GetComponent(typeof(RectMask2D))
	arg0_1.progress = findTF(arg0_1._tf, "mask/progress/bar")
	arg0_1.unlockTF = findTF(arg0_1._tf, "unlock")
	arg0_1.doingTF = findTF(arg0_1._tf, "doing")
	arg0_1.lockTF = findTF(arg0_1._tf, "lock")
	arg0_1.levelTxt = findTF(arg0_1._tf, "level"):GetComponent(typeof(Text))
	arg0_1.descUnLockIcon = findTF(arg0_1._tf, "desc/icon_pass")
	arg0_1.descDoingIcon = findTF(arg0_1._tf, "desc/icon_doing")
	arg0_1.descTxt = findTF(arg0_1._tf, "desc/Text"):GetComponent(typeof(Text))
	arg0_1.expTxt = findTF(arg0_1._tf, "exp"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2:Clear()

	arg0_2.home = arg1_2
	arg0_2.config = arg2_2

	local var0_2 = arg2_2.level

	arg0_2.mask.enabled = arg2_2.tail == true

	setActive(arg0_2.unlockTF, false)
	setActive(arg0_2.doingTF, false)
	setActive(arg0_2.lockTF, false)
	setActive(arg0_2.descUnLockIcon, false)
	setActive(arg0_2.descDoingIcon, false)

	local var1_2

	if arg1_2.level + 1 == arg2_2.level then
		arg0_2:UpdateDoingState()

		var1_2 = var3_0
	elseif arg1_2.level < arg2_2.level then
		arg0_2:UpdateLockState()

		var1_2 = var1_0
	elseif arg1_2.level >= arg2_2.level then
		arg0_2:UpdateUnlockState()

		var1_2 = var2_0
	end

	arg0_2.levelTxt.text = setColorStr("LV." .. arg2_2.level, var1_2)
	arg0_2.descTxt.text = setColorStr(shortenString(arg2_2.desc, 12), var1_2)
	arg0_2.expTxt.text = setColorStr(arg2_2.totalExp, var1_2)
end

function var0_0.UpdateLockState(arg0_3)
	setFillAmount(arg0_3.progress, 0)
	setActive(arg0_3.lockTF, true)
	onButton(nil, arg0_3.lockTF, function()
		arg0_3:ShowDesc()
	end, SFX_PANEL)
end

function var0_0.UpdateDoingState(arg0_5)
	local var0_5 = pg.commander_home[arg0_5.config.level - 1]
	local var1_5 = 0

	if var0_5 then
		var1_5 = var0_5.home_exp
	end

	setFillAmount(arg0_5.progress, arg0_5.home.exp / var1_5)
	setActive(arg0_5.doingTF, true)
	setActive(arg0_5.descDoingIcon, true)
	onButton(nil, arg0_5.doingTF, function()
		arg0_5:ShowDesc()
	end, SFX_PANEL)
end

function var0_0.UpdateUnlockState(arg0_7)
	setFillAmount(arg0_7.progress, 1)
	setActive(arg0_7.unlockTF, true)
	setActive(arg0_7.descUnLockIcon, true)
	onButton(nil, arg0_7.unlockTF, function()
		arg0_7:ShowDesc()
	end, SFX_PANEL)
end

function var0_0.ShowDesc(arg0_9)
	arg0_9.view:ShowDescWindow(arg0_9.config.desc, arg0_9.config.level)
end

function var0_0.Clear(arg0_10)
	removeOnButton(arg0_10.lockTF)
	removeOnButton(arg0_10.doingTF)
	removeOnButton(arg0_10.unlockTF)
end

function var0_0.Dispose(arg0_11)
	arg0_11:Clear()
end

return var0_0
