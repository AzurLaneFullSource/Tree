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
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_3._tf)
	arg0_3:cleanManagedTween()
end

function var0_0.setUIData(arg0_4)
	arg0_4.shipWordSpriteList = {}

	local var0_4 = "shipword_" .. arg0_4.curSelectShip
	local var1_4 = "Shrine2022/" .. var0_4
	local var2_4 = LoadSprite(var1_4, var0_4)

	arg0_4.shipWordSpriteList[arg0_4.curSelectShip] = var2_4
end

function var0_0.initData(arg0_5)
	arg0_5.curSelectShip = arg0_5.contextData.curSelectShip
end

function var0_0.initUI(arg0_6)
	arg0_6:setUIData()

	arg0_6.bg = arg0_6._tf:Find("BG")
	arg0_6.wordImg = arg0_6._tf:Find("Word")
	arg0_6.cloud1 = arg0_6._tf:Find("Cloud1")
	arg0_6.cloud2 = arg0_6._tf:Find("Cloud2")

	setImageSprite(arg0_6.wordImg, arg0_6.shipWordSpriteList[arg0_6.curSelectShip], true)
	onButton(arg0_6, arg0_6.bg, function()
		arg0_6:closeMySelf()
	end, SFX_PANEL)
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
	local var8_8 = {
		x = var6_8,
		y = var6_8
	}
	local var9_8 = 0.3

	arg0_8.isPlaying = true

	setLocalScale(arg0_8.wordImg, {
		x = 0,
		y = 0
	})
	setActive(arg0_8.wordImg, true)
	arg0_8:managedTween(LeanTween.value, nil, go(arg0_8.cloud1), 0, 1, var9_8):setOnUpdate(System.Action_float(function(arg0_9)
		local var0_9 = var0_8 + (var1_8 - var0_8) * arg0_9
		local var1_9 = var3_8 + (var4_8 - var3_8) * arg0_9
		local var2_9 = var6_8 + (var7_8 - var6_8) * arg0_9

		var2_8.x = var0_9

		setAnchoredPosition(arg0_8.cloud1, var2_8)

		var5_8.x = var1_9

		setAnchoredPosition(arg0_8.cloud2, var5_8)

		var8_8.x = var2_9
		var8_8.y = var2_9

		setLocalScale(arg0_8.wordImg, var8_8)
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
