local var0 = class("LoadingPanel", import("..base.BaseUI"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0)
	seriesAsync({
		function(arg0)
			arg0:preload(arg0)
		end
	}, function()
		PoolMgr.GetInstance():GetUI("Loading", true, function(arg0)
			local var0 = GameObject.Find("Overlay/UIOverlay")

			arg0.transform:SetParent(var0.transform, false)
			arg0:SetActive(false)
			arg0:onUILoaded(arg0)
			arg1()
		end)
	end)
end

function var0.preload(arg0, arg1)
	arg0.isCri, arg0.bgPath = getLoginConfig()

	if arg0.isCri then
		LoadAndInstantiateAsync("effect", arg0.bgPath, function(arg0)
			arg0.criBgGo = arg0

			if arg1 then
				arg1()
			end
		end)
	else
		LoadSpriteAsync("loadingbg/" .. arg0.bgPath, function(arg0)
			arg0.staticBgSprite = arg0

			if arg1 then
				arg1()
			end
		end)
	end
end

function var0.init(arg0)
	arg0.infos = arg0:findTF("infos")
	arg0.infoTpl = arg0:getTpl("infos/info_tpl")
	arg0.indicator = arg0:findTF("load")
	arg0.bg = arg0:findTF("BG")

	arg0:displayBG(true)
end

function var0.appendInfo(arg0, arg1)
	local var0 = cloneTplTo(arg0.infoTpl, arg0.infos)

	setText(var0, arg1)

	local var1 = GetOrAddComponent(var0, "CanvasGroup")
	local var2 = LeanTween.alphaCanvas(var1, 0, 0.3)

	var2:setDelay(1.5)
	var2:setOnComplete(System.Action(function()
		destroy(var0)
	end))
end

function var0.onLoading(arg0)
	return arg0._go.activeInHierarchy
end

local var1 = 0

function var0.on(arg0, arg1)
	arg1 = defaultValue(arg1, true)

	setImageAlpha(arg0._tf, arg1 and 0.01 or 0)

	if not arg1 then
		setActive(arg0.indicator, arg1)
	elseif not arg0.delayTimer then
		arg0.delayTimer = pg.TimeMgr.GetInstance():AddTimer("loading", 1, 0, function()
			setImageAlpha(arg0._tf, 0.2)
			setActive(arg0.indicator, true)
		end)
	end

	var1 = var1 + 1

	if var1 > 0 then
		setActive(arg0._go, true)
		arg0._go.transform:SetAsLastSibling()
	end
end

function var0.off(arg0)
	if var1 > 0 then
		var1 = var1 - 1

		if var1 == 0 then
			setActive(arg0._go, false)
			setActive(arg0.indicator, false)

			if arg0.delayTimer then
				pg.TimeMgr.GetInstance():RemoveTimer(arg0.delayTimer)

				arg0.delayTimer = nil
			end
		end
	end
end

function var0.displayBG(arg0, arg1)
	setActive(arg0.bg, arg1)

	local var0 = GetComponent(arg0.bg, "Image")

	if arg1 then
		if not arg0.isCri then
			if IsNil(var0.sprite) then
				var0.sprite = arg0.staticBgSprite
			end
		elseif arg0.bg.childCount == 0 then
			var0.enabled = false

			local var1 = arg0.criBgGo.transform

			var1:SetParent(arg0.bg.transform, false)
			var1:SetAsFirstSibling()
		end
	else
		if not arg0.isCri then
			var0.sprite = nil
		else
			removeAllChildren(arg0.bg)
		end

		arg0.criBgGo = nil
		arg0.staticBgSprite = nil
	end
end

function var0.getRetainCount(arg0)
	return var1
end

return var0
