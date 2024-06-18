local var0_0 = class("Shrine2022ShipWordView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "Shrine2022ShipWordUI"
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
	arg0_4.curSelectShip = arg0_4.contextData.curSelectShip
end

function var0_0.initUI(arg0_5)
	arg0_5.bg = arg0_5:findTF("BG")
	arg0_5.wordImg = arg0_5:findTF("Word")
	arg0_5.cloud1 = arg0_5:findTF("Cloud1")
	arg0_5.cloud2 = arg0_5:findTF("Cloud2")

	local var0_5 = "shipword_" .. arg0_5.curSelectShip
	local var1_5 = "Shrine2022/" .. var0_5

	setImageSprite(arg0_5.wordImg, LoadSprite(var1_5, var0_5), true)
	onButton(arg0_5, arg0_5.bg, function()
		arg0_5:closeMySelf()
	end, SFX_PANEL)
end

function var0_0.playEnterAni(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7 and 1000 or 0
	local var1_7 = arg1_7 and 0 or 1000
	local var2_7 = {
		x = var0_7,
		y = rtf(arg0_7.cloud1).anchoredPosition.y
	}
	local var3_7 = arg1_7 and -1000 or 0
	local var4_7 = arg1_7 and 0 or -1000
	local var5_7 = {
		x = var3_7,
		y = rtf(arg0_7.cloud2).anchoredPosition.y
	}
	local var6_7 = arg1_7 and 0 or 1
	local var7_7 = arg1_7 and 1 or 0
	local var8_7 = {
		x = var6_7,
		y = var6_7
	}
	local var9_7 = 0.3

	arg0_7.isPlaying = true

	arg0_7:managedTween(LeanTween.value, nil, go(arg0_7.cloud1), 0, 1, var9_7):setOnUpdate(System.Action_float(function(arg0_8)
		local var0_8 = var0_7 + (var1_7 - var0_7) * arg0_8
		local var1_8 = var3_7 + (var4_7 - var3_7) * arg0_8
		local var2_8 = var6_7 + (var7_7 - var6_7) * arg0_8

		var2_7.x = var0_8

		setAnchoredPosition(arg0_7.cloud1, var2_7)

		var5_7.x = var1_8

		setAnchoredPosition(arg0_7.cloud2, var5_7)

		var8_7.x = var2_8
		var8_7.y = var2_8

		setLocalScale(arg0_7.wordImg, var8_7)
	end)):setOnComplete(System.Action(function()
		arg0_7.isPlaying = false

		if arg2_7 then
			arg2_7()
		end
	end))
end

function var0_0.closeMySelf(arg0_10)
	if arg0_10.isPlaying then
		return
	end

	arg0_10:playEnterAni(false, function()
		arg0_10:Destroy()
	end)
end

return var0_0
