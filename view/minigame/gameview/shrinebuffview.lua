local var0_0 = class("ShrineBuffView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShrineBuff"
end

function var0_0.OnInit(arg0_2)
	arg0_2:Show()
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateView()
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.contextData.onClose()

	arg0_3.lockBackPress = false
end

function var0_0.initData(arg0_4)
	arg0_4.lockBackPress = true
end

function var0_0.initUI(arg0_5)
	arg0_5.bg = arg0_5:findTF("BG")
	arg0_5.backBtn = arg0_5:findTF("BackBtn")
	arg0_5.buffListTF = arg0_5:findTF("Main/BuffList")

	for iter0_5 = 1, 3 do
		local var0_5 = arg0_5.buffListTF:GetChild(iter0_5 - 1)

		onButton(arg0_5, var0_5, function()
			arg0_5.contextData.onSelect(iter0_5)
			arg0_5:Destroy()
		end, SFX_PANEL)
	end

	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:Destroy()
	end, SFX_CANCEL)
end

function var0_0.updateView(arg0_8)
	return
end

return var0_0
