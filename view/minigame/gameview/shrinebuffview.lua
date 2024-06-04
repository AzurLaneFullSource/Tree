local var0 = class("ShrineBuffView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShrineBuff"
end

function var0.OnInit(arg0)
	arg0:Show()
	arg0:initData()
	arg0:initUI()
	arg0:updateView()
end

function var0.OnDestroy(arg0)
	arg0.contextData.onClose()

	arg0.lockBackPress = false
end

function var0.initData(arg0)
	arg0.lockBackPress = true
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.backBtn = arg0:findTF("BackBtn")
	arg0.buffListTF = arg0:findTF("Main/BuffList")

	for iter0 = 1, 3 do
		local var0 = arg0.buffListTF:GetChild(iter0 - 1)

		onButton(arg0, var0, function()
			arg0.contextData.onSelect(iter0)
			arg0:Destroy()
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.backBtn, function()
		arg0:Destroy()
	end, SFX_CANCEL)
end

function var0.updateView(arg0)
	return
end

return var0
