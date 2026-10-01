local var0_0 = class("LoadingPanel", import("..base.BaseUI"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)
	seriesAsync({
		function(arg0_2)
			arg0_1:preload(arg0_2)
		end
	}, function()
		PoolMgr.GetInstance():GetUI("Loading", true, function(arg0_4)
			local var0_4 = GameObject.Find("Overlay/UIOverlay")

			arg0_4.transform:SetParent(var0_4.transform, false)
			arg0_4:SetActive(false)
			arg0_1:onUILoaded(arg0_4)
			arg1_1()
		end)
	end)
end

function var0_0.getResource(arg0_5)
	local var0_5
	local var1_5, var2_5 = getLoginConfig()

	if var1_5 then
		var0_5 = {
			"effect/" .. var2_5
		}
	else
		local var3_5 = LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value and "loadingbg_hx/" or "loadingbg/"

		var0_5 = {
			var3_5 .. var2_5
		}
	end

	return table.insertto(var0_5, var0_0.super.getResource(arg0_5))
end

function var0_0.preload(arg0_6, arg1_6)
	arg0_6.isCri, arg0_6.bgPath = getLoginConfig()

	if arg0_6.isCri then
		LoadAndInstantiateAsync("effect", arg0_6.bgPath, function(arg0_7)
			arg0_6.criBgGo = arg0_7

			if arg1_6 then
				arg1_6()
			end
		end)
	else
		local var0_6 = LOGIN_HX and PlayerProxy.GetDeviceMaxPlayerLevel() <= pg.gameset.LOGIN_HX_LV.key_value and "loadingbg_hx/" or "loadingbg/"

		LoadSpriteAsync(var0_6 .. arg0_6.bgPath, function(arg0_8)
			arg0_6.staticBgSprite = arg0_8

			if arg1_6 then
				arg1_6()
			end
		end)
	end
end

function var0_0.init(arg0_9)
	arg0_9.infos = arg0_9._tf:Find("infos")
	arg0_9.infoTpl = arg0_9:getTpl("infos/info_tpl")
	arg0_9.indicator = arg0_9._tf:Find("load")
	arg0_9.bg = arg0_9._tf:Find("BG")

	arg0_9:displayBG(true)
end

function var0_0.appendInfo(arg0_10, arg1_10)
	local var0_10 = cloneTplTo(arg0_10.infoTpl, arg0_10.infos)

	setText(var0_10, arg1_10)

	local var1_10 = GetOrAddComponent(var0_10, "CanvasGroup")
	local var2_10 = LeanTween.alphaCanvas(var1_10, 0, 0.3)

	var2_10:setDelay(1.5)
	var2_10:setOnComplete(System.Action(function()
		destroy(var0_10)
	end))
end

function var0_0.onLoading(arg0_12)
	return arg0_12._go.activeInHierarchy
end

local var1_0 = 0

function var0_0.on(arg0_13, arg1_13)
	arg0_13.displayIndicator = defaultValue(arg0_13.displayIndicator, true) and arg1_13

	setImageAlpha(arg0_13._tf, arg1_13 and 0.01 or 0)

	if not arg0_13.displayIndicator then
		setActive(arg0_13.indicator, arg1_13)

		if arg0_13.delayTimer then
			pg.TimeMgr.GetInstance():RemoveTimer(arg0_13.delayTimer)

			arg0_13.delayTimer = nil
		end
	elseif not arg0_13.delayTimer then
		arg0_13.delayTimer = pg.TimeMgr.GetInstance():AddTimer("loading", 1, 0, function()
			setImageAlpha(arg0_13._tf, 0.2)
			setActive(arg0_13.indicator, true)
		end)
	end

	if var1_0 * (var1_0 + 1) == 0 then
		setActive(arg0_13._go, true)
		arg0_13._go.transform:SetAsLastSibling()
	end

	var1_0 = var1_0 + 1
end

function var0_0.off(arg0_15)
	if var1_0 * (var1_0 - 1) == 0 then
		setActive(arg0_15._go, false)
		setActive(arg0_15.indicator, false)

		arg0_15.displayIndicator = true

		if arg0_15.delayTimer then
			pg.TimeMgr.GetInstance():RemoveTimer(arg0_15.delayTimer)

			arg0_15.delayTimer = nil
		end
	end

	var1_0 = var1_0 - 1

	assert(var1_0 >= 0)
end

function var0_0.displayBG(arg0_16, arg1_16)
	setActive(arg0_16.bg, arg1_16)

	local var0_16 = GetComponent(arg0_16.bg, "Image")

	if arg1_16 then
		if not arg0_16.isCri then
			if IsNil(var0_16.sprite) then
				var0_16.sprite = arg0_16.staticBgSprite
			end
		elseif arg0_16.bg.childCount == 0 then
			var0_16.enabled = false

			local var1_16 = arg0_16.criBgGo.transform

			var1_16:SetParent(arg0_16.bg.transform, false)
			var1_16:SetAsFirstSibling()

			local var2_16 = arg0_16.criBgGo:GetComponent("AspectRatioFitter")

			if var2_16 then
				var2_16.enabled = true
			end
		end
	else
		if not arg0_16.isCri then
			var0_16.sprite = nil
		else
			removeAllChildren(arg0_16.bg)
		end

		arg0_16.criBgGo = nil
		arg0_16.staticBgSprite = nil
	end
end

function var0_0.getRetainCount(arg0_17)
	return var1_0
end

return var0_0
