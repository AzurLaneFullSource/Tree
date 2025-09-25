local var0_0 = class("IslandDeviceBaseBtn", import(".IslandMainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1.event = arg2_1
	arg0_1.configId = arg3_1
	arg0_1.config = pg.island_main_btns[arg0_1.configId]
	arg0_1.lockTF = arg0_1._tf:Find("lock")

	local var0_1 = arg0_1.lockTF:Find("Text")

	if var0_1 then
		setText(var0_1, i18n("island_freight_btn_locked"))
	end

	arg0_1.unlockTF = arg0_1._tf:Find("unlock")
	arg0_1.tipTF = arg0_1.unlockTF:Find("tip")
	arg0_1.nameTF = arg0_1._tf:Find("name")

	local var1_1 = arg0_1.nameTF and arg0_1.nameTF:GetComponent(typeof(Text))

	if var1_1 then
		var1_1.text = arg0_1.config.name
	end

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2._tf, function()
		if not arg0_2:IsUnlock() then
			return
		end

		arg0_2:OnClick()
	end, SFX_PANEL)
end

function var0_0.UnlockCheck(arg0_4)
	local var0_4 = arg0_4:IsUnlock()

	setActive(arg0_4.lockTF, not var0_4)
	setActive(arg0_4.unlockTF, var0_4)

	if var0_4 then
		arg0_4:FlushDataUI()
	end
end

function var0_0.FlushDataUI(arg0_5)
	return
end

return var0_0
