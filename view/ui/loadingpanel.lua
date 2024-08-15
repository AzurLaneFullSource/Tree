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

function var0_0.preload(arg0_5, arg1_5)
	arg0_5.isCri, arg0_5.bgPath = getLoginConfig()

	if arg0_5.isCri then
		LoadAndInstantiateAsync("effect", arg0_5.bgPath, function(arg0_6)
			arg0_5.criBgGo = arg0_6

			if arg1_5 then
				arg1_5()
			end
		end)
	else
		LoadSpriteAsync("loadingbg/" .. arg0_5.bgPath, function(arg0_7)
			arg0_5.staticBgSprite = arg0_7

			if arg1_5 then
				arg1_5()
			end
		end)
	end
end

function var0_0.init(arg0_8)
	arg0_8.infos = arg0_8:findTF("infos")
	arg0_8.infoTpl = arg0_8:getTpl("infos/info_tpl")
	arg0_8.indicator = arg0_8:findTF("load")
	arg0_8.bg = arg0_8:findTF("BG")

	arg0_8:displayBG(true)
end

function var0_0.appendInfo(arg0_9, arg1_9)
	local var0_9 = cloneTplTo(arg0_9.infoTpl, arg0_9.infos)

	setText(var0_9, arg1_9)

	local var1_9 = GetOrAddComponent(var0_9, "CanvasGroup")
	local var2_9 = LeanTween.alphaCanvas(var1_9, 0, 0.3)

	var2_9:setDelay(1.5)
	var2_9:setOnComplete(System.Action(function()
		destroy(var0_9)
	end))
end

function var0_0.onLoading(arg0_11)
	return arg0_11._go.activeInHierarchy
end

local var1_0 = 0

function var0_0.on(arg0_12, arg1_12)
	arg1_12 = defaultValue(arg1_12, true)

	setImageAlpha(arg0_12._tf, arg1_12 and 0.01 or 0)

	if not arg1_12 then
		setActive(arg0_12.indicator, arg1_12)
	elseif not arg0_12.delayTimer then
		arg0_12.delayTimer = pg.TimeMgr.GetInstance():AddTimer("loading", 1, 0, function()
			setImageAlpha(arg0_12._tf, 0.2)
			setActive(arg0_12.indicator, true)
		end)
	end

	var1_0 = var1_0 + 1

	if var1_0 > 0 then
		setActive(arg0_12._go, true)
		arg0_12._go.transform:SetAsLastSibling()
	end
end

function var0_0.off(arg0_14)
	if var1_0 > 0 then
		var1_0 = var1_0 - 1

		if var1_0 == 0 then
			setActive(arg0_14._go, false)
			setActive(arg0_14.indicator, false)

			if arg0_14.delayTimer then
				pg.TimeMgr.GetInstance():RemoveTimer(arg0_14.delayTimer)

				arg0_14.delayTimer = nil
			end
		end
	end
end

function var0_0.displayBG(arg0_15, arg1_15)
	setActive(arg0_15.bg, arg1_15)

	local var0_15 = GetComponent(arg0_15.bg, "Image")

	if arg1_15 then
		if not arg0_15.isCri then
			if IsNil(var0_15.sprite) then
				var0_15.sprite = arg0_15.staticBgSprite
			end
		elseif arg0_15.bg.childCount == 0 then
			var0_15.enabled = false

			local var1_15 = arg0_15.criBgGo.transform

			var1_15:SetParent(arg0_15.bg.transform, false)
			var1_15:SetAsFirstSibling()

			local var2_15 = arg0_15.criBgGo:GetComponent("AspectRatioFitter")

			if var2_15 then
				var2_15.enabled = true
			end
		end
	else
		if not arg0_15.isCri then
			var0_15.sprite = nil
		else
			removeAllChildren(arg0_15.bg)
		end

		arg0_15.criBgGo = nil
		arg0_15.staticBgSprite = nil
	end
end

function var0_0.getRetainCount(arg0_16)
	return var1_0
end

return var0_0
