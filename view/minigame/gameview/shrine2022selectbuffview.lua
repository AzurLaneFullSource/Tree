local var0 = class("Shrine2022SelectBuffView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "Shrine2022SelectBuffUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:Show()
	arg0:playEnterAni(true)
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0:cleanManagedTween()
end

function var0.initData(arg0)
	arg0.onSelectFunc = arg0.contextData.onSelect
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.cloud1 = arg0:findTF("Cloud1")
	arg0.cloud2 = arg0:findTF("Cloud2")
	arg0.buffListTF = arg0:findTF("BuffContainer")
	arg0.buffListCG = GetComponent(arg0.buffListTF, "CanvasGroup")

	for iter0 = 1, 3 do
		local var0 = arg0.buffListTF:GetChild(iter0 - 1)

		onButton(arg0, var0, function()
			if arg0.onSelectFunc then
				arg0.onSelectFunc(iter0)
			end

			arg0:closeMySelf()
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.bg, function()
		arg0:closeMySelf()
	end, SFX_CANCEL)
end

function var0.playEnterAni(arg0, arg1, arg2)
	local var0 = arg1 and 1000 or 0
	local var1 = arg1 and 0 or 1000
	local var2 = {
		x = var0,
		y = rtf(arg0.cloud1).anchoredPosition.y
	}
	local var3 = arg1 and -1000 or 0
	local var4 = arg1 and 0 or -1000
	local var5 = {
		x = var3,
		y = rtf(arg0.cloud2).anchoredPosition.y
	}
	local var6 = arg1 and 0 or 1
	local var7 = arg1 and 1 or 0
	local var8 = 0.3

	arg0.isPlaying = true

	arg0:managedTween(LeanTween.value, nil, go(arg0.cloud1), 0, 1, var8):setOnUpdate(System.Action_float(function(arg0)
		local var0 = var0 + (var1 - var0) * arg0
		local var1 = var3 + (var4 - var3) * arg0
		local var2 = var6 + (var7 - var6) * arg0

		var2.x = var0

		setAnchoredPosition(arg0.cloud1, var2)

		var5.x = var1

		setAnchoredPosition(arg0.cloud2, var5)

		arg0.buffListCG.alpha = var2
	end)):setOnComplete(System.Action(function()
		arg0.isPlaying = false

		if arg2 then
			arg2()
		end
	end))
end

function var0.closeMySelf(arg0)
	if arg0.isPlaying then
		return
	end

	arg0:playEnterAni(false, function()
		arg0:Destroy()
	end)
end

return var0
