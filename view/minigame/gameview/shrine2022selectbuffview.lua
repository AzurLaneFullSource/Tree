local var0_0 = class("Shrine2022SelectBuffView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "Shrine2022SelectBuffUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
	arg0_2:Show()
	arg0_2:playEnterAni(true)
end

function var0_0.OnDestroy(arg0_3)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_3._tf)
	arg0_3:cleanManagedTween()
end

function var0_0.initData(arg0_4)
	arg0_4.onSelectFunc = arg0_4.contextData.onSelect
end

function var0_0.initUI(arg0_5)
	arg0_5.bg = arg0_5:findTF("BG")
	arg0_5.cloud1 = arg0_5:findTF("Cloud1")
	arg0_5.cloud2 = arg0_5:findTF("Cloud2")
	arg0_5.buffListTF = arg0_5:findTF("BuffContainer")
	arg0_5.buffListCG = GetComponent(arg0_5.buffListTF, "CanvasGroup")

	for iter0_5 = 1, 3 do
		local var0_5 = arg0_5.buffListTF:GetChild(iter0_5 - 1)

		onButton(arg0_5, var0_5, function()
			if arg0_5.onSelectFunc then
				arg0_5.onSelectFunc(iter0_5)
			end

			arg0_5:closeMySelf()
		end, SFX_PANEL)
	end

	onButton(arg0_5, arg0_5.bg, function()
		arg0_5:closeMySelf()
	end, SFX_CANCEL)
end

function var0_0.playEnterAni(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8 and 1000 or 0
	local var1_8 = arg1_8 and 0 or 1000
	local var2_8 = {
		x = var0_8,
		y = rtf(arg0_8.cloud1).anchoredPosition.y
	}
	local var3_8 = arg1_8 and -1000 or 0
	local var4_8 = arg1_8 and 0 or -1000
	local var5_8 = {
		x = var3_8,
		y = rtf(arg0_8.cloud2).anchoredPosition.y
	}
	local var6_8 = arg1_8 and 0 or 1
	local var7_8 = arg1_8 and 1 or 0
	local var8_8 = 0.3

	arg0_8.isPlaying = true

	arg0_8:managedTween(LeanTween.value, nil, go(arg0_8.cloud1), 0, 1, var8_8):setOnUpdate(System.Action_float(function(arg0_9)
		local var0_9 = var0_8 + (var1_8 - var0_8) * arg0_9
		local var1_9 = var3_8 + (var4_8 - var3_8) * arg0_9
		local var2_9 = var6_8 + (var7_8 - var6_8) * arg0_9

		var2_8.x = var0_9

		setAnchoredPosition(arg0_8.cloud1, var2_8)

		var5_8.x = var1_9

		setAnchoredPosition(arg0_8.cloud2, var5_8)

		arg0_8.buffListCG.alpha = var2_9
	end)):setOnComplete(System.Action(function()
		arg0_8.isPlaying = false

		if arg2_8 then
			arg2_8()
		end
	end))
end

function var0_0.closeMySelf(arg0_11)
	if arg0_11.isPlaying then
		return
	end

	arg0_11:playEnterAni(false, function()
		arg0_11:Destroy()
	end)
end

return var0_0
