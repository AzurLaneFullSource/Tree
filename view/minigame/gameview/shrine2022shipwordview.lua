local var0 = class("Shrine2022ShipWordView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "Shrine2022ShipWordUI"
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
	arg0.curSelectShip = arg0.contextData.curSelectShip
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.wordImg = arg0:findTF("Word")
	arg0.cloud1 = arg0:findTF("Cloud1")
	arg0.cloud2 = arg0:findTF("Cloud2")

	local var0 = "shipword_" .. arg0.curSelectShip
	local var1 = "Shrine2022/" .. var0

	setImageSprite(arg0.wordImg, LoadSprite(var1, var0), true)
	onButton(arg0, arg0.bg, function()
		arg0:closeMySelf()
	end, SFX_PANEL)
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
	local var8 = {
		x = var6,
		y = var6
	}
	local var9 = 0.3

	arg0.isPlaying = true

	arg0:managedTween(LeanTween.value, nil, go(arg0.cloud1), 0, 1, var9):setOnUpdate(System.Action_float(function(arg0)
		local var0 = var0 + (var1 - var0) * arg0
		local var1 = var3 + (var4 - var3) * arg0
		local var2 = var6 + (var7 - var6) * arg0

		var2.x = var0

		setAnchoredPosition(arg0.cloud1, var2)

		var5.x = var1

		setAnchoredPosition(arg0.cloud2, var5)

		var8.x = var2
		var8.y = var2

		setLocalScale(arg0.wordImg, var8)
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
