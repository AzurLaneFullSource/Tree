local var0_0 = class("PaintingShowScene", import("..base.BaseUI"))
local var1_0 = {
	{
		-176,
		-466,
		2,
		100,
		100,
		2
	},
	{
		526,
		-107,
		2,
		100,
		100,
		2
	},
	{
		-934,
		-115,
		2,
		100,
		100,
		2
	},
	{
		-32,
		643,
		2,
		100,
		100,
		2
	}
}
local var2_0 = {
	ShipSkin.WITH_LIVE2D,
	ShipSkin.WITH_SPINE
}

function var0_0.getUIName(arg0_1)
	return "PaintingShowUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2._tf.sizeDelta = Vector2(Screen.width, Screen.height)
	arg0_2.ad = findTF(arg0_2._tf, "ad")
	arg0_2.paintTf = findTF(arg0_2.ad, "paint")
	arg0_2.spineContainer = findTF(arg0_2.ad, "paint/spinePainting")
	arg0_2.l2dContainner = findTF(arg0_2.ad, "paint/live2d")
	arg0_2.paintingFitter = findTF(arg0_2.ad, "paint/fitter")
	arg0_2.effectContainer = findTF(arg0_2.ad, "paint/effect")
	arg0_2.flushAnimator = GetComponent(findTF(arg0_2.ad, "flush"), typeof(Animator))
	arg0_2.flushEevent = GetComponent(findTF(arg0_2.ad, "flush"), typeof(DftAniEvent))
	arg0_2.btnClose = findTF(arg0_2.ad, "btnClose")
	arg0_2.btnDebug = findTF(arg0_2.ad, "btnDebug")
	arg0_2.effectTf = findTF(arg0_2.ad, "effect")

	warning("init tf parent pos = " .. arg0_2._tf.parent.position.x .. "," .. arg0_2._tf.parent.position.y)
	warning("init tf pos = " .. arg0_2._tf.anchoredPosition.x .. "," .. arg0_2._tf.anchoredPosition.y)
	warning("init ad pos = " .. arg0_2.ad.anchoredPosition.x .. "," .. arg0_2.ad.anchoredPosition.y)
	warning("init painting pos = " .. arg0_2.paintTf.anchoredPosition.x .. "," .. arg0_2.paintTf.anchoredPosition.y)
	warning("init l2dContainner pos = " .. arg0_2.l2dContainner.anchoredPosition.x .. "," .. arg0_2.l2dContainner.anchoredPosition.y)
	onButton(arg0_2, arg0_2.btnClose, function()
		if not arg0_2.loading then
			arg0_2:closeView()
		end
	end)
	setActive(arg0_2.btnDebug, false)
	onButton(arg0_2, arg0_2.btnDebug, function()
		arg0_2:startShowing()
	end)
	arg0_2.flushEevent:SetTriggerEvent(function(arg0_5)
		if arg0_2.triggerData then
			if not isActive(arg0_2.paintTf) then
				SetActive(arg0_2.paintTf, true)
			end

			warning("set tf pos = " .. arg0_2._tf.anchoredPosition.x .. "," .. arg0_2._tf.anchoredPosition.y)
			warning("set ad pos = " .. arg0_2.ad.anchoredPosition.x .. "," .. arg0_2.ad.anchoredPosition.y)
			warning("set painting pos = " .. arg0_2.paintTf.anchoredPosition.x .. "," .. arg0_2.paintTf.anchoredPosition.y)
			warning("set l2dContainner pos = " .. arg0_2.l2dContainner.anchoredPosition.x .. "," .. arg0_2.l2dContainner.anchoredPosition.y)
			warning("set painting pos = " .. arg0_2.triggerData.pos.x .. "," .. arg0_2.triggerData.pos.y)
			warning("set painting scale = " .. arg0_2.triggerData.scale)

			arg0_2.paintTf.anchoredPosition = arg0_2.triggerData.pos
			arg0_2.paintTf.localScale = Vector3(arg0_2.triggerData.scale, arg0_2.triggerData.scale, arg0_2.triggerData.scale)
		elseif not arg0_2.debugFlag then
			arg0_2:closeView()
		end
	end)
	arg0_2.flushEevent:SetEndEvent(function(arg0_6)
		if arg0_2.triggerData then
			arg0_2:movePaint(function()
				arg0_2:flushPainting()
			end)
		end
	end)

	arg0_2.loading = false

	SetActive(arg0_2.paintTf, false)

	arg0_2.closeCallBack = arg0_2.contextData.callback
	arg0_2.skinId = arg0_2.contextData.skinId
	arg0_2.isShop = arg0_2.contextData.is_shop

	pg.UIMgr.GetInstance():BlurPanel(arg0_2.ad)

	if arg0_2.skinId then
		local var0_2 = pg.ship_skin_template[arg0_2.skinId]
		local var1_2 = var0_2.ship_group * 10 + 1

		if var0_2.get_showing then
			arg0_2.debugFlag = var0_2.get_showing.debug == 1 and true or false
		end

		setActive(arg0_2.btnDebug, arg0_2.debugFlag)
		arg0_2:loadShowPaint(var1_2, arg0_2.skinId, function()
			arg0_2:startShowing()
		end)
	else
		onNextTick(function()
			arg0_2:closeView()
		end)
	end
end

function var0_0.startShowing(arg0_10)
	if not arg0_10.l2dFlag then
		local var0_10 = pg.ship_skin_template[arg0_10.skinId]
		local var1_10 = var0_10.get_showing.data and var0_10.get_showing.data or var1_0
		local var2_10
		local var3_10

		if arg0_10.paintOffset then
			var2_10 = Vector2(arg0_10.paintOffset[1], arg0_10.paintOffset[2])
			var3_10 = arg0_10.paintOffset[3]
		else
			var2_10 = Vector2(0, 0)
			var3_10 = 1
		end

		arg0_10.showDatas = {}

		for iter0_10 = 1, #var1_10 do
			local var4_10 = var1_10[iter0_10]
			local var5_10 = Vector2(var4_10[1] + var2_10.x, var4_10[2] + var2_10.y)
			local var6_10 = var4_10[3] * var3_10
			local var7_10
			local var8_10

			if #var4_10 >= 4 then
				var7_10 = Vector3(var4_10[1] + var2_10.x + var4_10[4], var4_10[2] + var2_10.y + var4_10[5], 0)
				var8_10 = var4_10[6]
			end

			table.insert(arg0_10.showDatas, {
				pos = var5_10,
				scale = var6_10,
				move = var7_10,
				move_time = var8_10
			})
		end

		arg0_10:flushPainting()
	end
end

function var0_0.flushPainting(arg0_11)
	if #arg0_11.showDatas > 0 then
		arg0_11.triggerData = table.remove(arg0_11.showDatas, 1)

		arg0_11.flushAnimator:SetTrigger("active")
	else
		arg0_11.triggerData = nil

		arg0_11.flushAnimator:SetTrigger("active")
	end
end

function var0_0.movePaint(arg0_12, arg1_12)
	local var0_12 = arg0_12.triggerData.move
	local var1_12 = arg0_12.triggerData.move_time

	if var0_12 and var1_12 then
		LeanTween.moveLocal(go(arg0_12.paintTf), var0_12, var1_12):setOnComplete(System.Action(function()
			if arg1_12 then
				arg1_12()
			end
		end))
	elseif arg1_12 then
		arg1_12()
	end
end

function var0_0.loadShowPaint(arg0_14, arg1_14, arg2_14, arg3_14)
	arg0_14.loading = true
	arg0_14.flagShip = Ship.New({
		configId = arg1_14,
		skin_id = arg2_14
	})

	local var0_14 = arg0_14.flagShip
	local var1_14 = MainPaintingView.GetAssistantStatus(var0_14)
	local var2_14 = var0_14:GetSkinConfig().tag
	local var3_14 = pg.ship_skin_template[arg0_14.skinId]

	if var1_14 == MainPaintingView.STATE_SPINE_PAINTING then
		local var4_14 = SpinePainting.GenerateData({
			ship = var0_14,
			position = Vector3(0, 0, 0),
			parent = arg0_14.spineContainer,
			effectParent = arg0_14.effectContainer
		})

		arg0_14.spinePainting = SpinePainting.New(var4_14, function(arg0_15)
			local var0_15 = arg0_15:GetSpineTransform():GetComponent(typeof(ItemList)).prefabItem:ToTable()

			for iter0_15, iter1_15 in ipairs(var0_15) do
				local var1_15 = GetComponent(iter1_15, typeof(Canvas))

				if var1_15 then
					RemoveComponent(var1_15, typeof(Canvas))
				end
			end

			if arg0_15:getAnimationExist("get") then
				arg0_15:SetOnceAction("get", nil, function()
					arg0_15:SetAction(arg0_15:getIdleName(), 0)
				end, true)
			end

			arg0_15:SetShopHx(arg0_14.isShop)

			arg0_14.loading = false

			arg3_14()
		end)
	elseif var1_14 == MainPaintingView.STATE_PAINTING then
		arg0_14.paintOffset = var3_14.get_showing.paint_offset and var3_14.get_showing.paint_offset or nil

		if (table.contains(var2_14, ShipSkin.WITH_LIVE2D) or table.contains(var2_14, ShipSkin.WITH_SPINE)) and not arg0_14.paintOffset then
			arg0_14.paintingFitter.localScale = Vector3(1.1, 1.1, 1.1)
		end

		local var5_14 = var0_14:getPainting()

		LoadPaintingPrefabAsync(arg0_14.paintTf, var5_14, var5_14, "mainNormal", function(arg0_17)
			arg0_14.loading = false

			local var0_17 = findTF(arg0_17, "shop_hx")

			if not IsNil(var0_17) and arg0_14.isShop then
				setActive(var0_17, HXSet.isHx())
			end

			arg3_14()
		end)
	elseif var1_14 == MainPaintingView.STATE_L2D then
		if not isActive(arg0_14.paintTf) then
			SetActive(arg0_14.paintTf, true)
		end

		warning("set l2d painting pos = " .. arg0_14.paintTf.anchoredPosition.x .. "," .. arg0_14.paintTf.anchoredPosition.y)
		warning("set l2d l2dContainner pos = " .. arg0_14.l2dContainner.anchoredPosition.x .. "," .. arg0_14.l2dContainner.anchoredPosition.y)

		local var6_14 = Live2DPainting.GenerateData({
			ship = var0_14,
			position = Vector3(0, 0, -1),
			parent = arg0_14.l2dContainner,
			shopPreView = arg0_14.isShop
		})

		arg0_14.live2dChar = Live2DPainting.New(var6_14, function(arg0_18)
			arg0_14:updateL2dSortMode(arg0_18)
			arg0_18:IgonreReactPos(true)

			arg0_14.loading = false

			arg3_14()
		end)
	else
		arg0_14.paintOffset = var3_14.get_showing.paint_offset and var3_14.get_showing.paint_offset or nil

		if (table.contains(var2_14, ShipSkin.WITH_LIVE2D) or table.contains(var2_14, ShipSkin.WITH_SPINE)) and not arg0_14.paintOffset then
			arg0_14.paintingFitter.localScale = Vector3(1.1, 1.1, 1.1)
		end

		local var7_14 = var0_14:getPainting()

		LoadPaintingPrefabAsync(arg0_14.paintTf, var7_14, var7_14, "mainNormal", function()
			arg0_14.loading = false
		end)
	end
end

function var0_0.updateL2dSortMode(arg0_20, arg1_20)
	arg1_20._go:GetComponent(typeof(CubismRenderController)).SortingMode = CubismSortingMode.BackToFrontOrder
end

function var0_0.StaticGetPaintingName(arg0_21)
	local var0_21 = arg0_21

	if HXSet.isHx() then
		return var0_21
	end

	local var1_21 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0_21) == var0_0.PAINTING_VARIANT_EX

	if var1_21 and not checkABExist("painting/" .. var0_21 .. "_ex") then
		return var0_21
	end

	return var1_21 and var0_21 .. "_ex" or var0_21
end

function var0_0.closeView(arg0_22)
	if arg0_22.loading then
		return
	end

	var0_0.super.closeView(arg0_22)
end

function var0_0.onBackPressed(arg0_23)
	if arg0_23.loading then
		return
	end

	var0_0.super.onBackPressed(arg0_23)
end

function var0_0.GetSkinShowAble(arg0_24)
	local var0_24 = pg.ship_skin_template[arg0_24]
	local var1_24 = false

	if var0_24.get_showing.show and var0_24.get_showing.show == 1 then
		var1_24 = true
	end

	return var1_24
end

function var0_0.willExit(arg0_25)
	arg0_25.flushEevent:SetTriggerEvent(nil)
	arg0_25.flushEevent:SetEndEvent(nil)

	if LeanTween.isTweening(go(arg0_25.paintTf)) then
		LeanTween.cancel(go(arg0_25.paintTf))
	end

	if arg0_25.live2dChar then
		arg0_25.live2dChar:Dispose()

		arg0_25.live2dChar = nil
	end

	if arg0_25.spinePainting then
		arg0_25.spinePainting:Dispose()

		arg0_25.spinePainting = nil
	end

	if arg0_25.closeCallBack then
		arg0_25.closeCallBack()

		arg0_25.closeCallBack = nil
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_25.ad, arg0_25._tf)
end

return var0_0
