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

function var0_0.getUIName(arg0_1)
	return "PaintingShowUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2.ad = findTF(arg0_2._tf, "ad")
	arg0_2.paintTf = findTF(arg0_2.ad, "paint")
	arg0_2.spineContainer = findTF(arg0_2.ad, "paint/spinePainting")
	arg0_2.l2dContainner = findTF(arg0_2.ad, "paint/live2d")
	arg0_2.paintingContainer = findTF(arg0_2.ad, "paint")
	arg0_2.effectContainer = findTF(arg0_2.ad, "paint/effect")
	arg0_2.flushAnimator = GetComponent(findTF(arg0_2.ad, "flush"), typeof(Animator))
	arg0_2.flushEevent = GetComponent(findTF(arg0_2.ad, "flush"), typeof(DftAniEvent))
	arg0_2.btnClose = findTF(arg0_2.ad, "btnClose")
	arg0_2.btnDebug = findTF(arg0_2.ad, "btnDebug")
	arg0_2.effectTf = findTF(arg0_2.ad, "effect")

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

	pg.UIMgr.GetInstance():BlurPanel(arg0_2.ad, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

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

		arg0_10.showDatas = {}

		for iter0_10 = 1, #var1_10 do
			local var2_10 = var1_10[iter0_10]
			local var3_10 = Vector2(var2_10[1], var2_10[2])
			local var4_10 = var2_10[3]
			local var5_10
			local var6_10

			if #var2_10 >= 4 then
				var5_10 = Vector3(var2_10[1] + var2_10[4], var2_10[2] + var2_10[5], 0)
				var6_10 = var2_10[6]
			end

			table.insert(arg0_10.showDatas, {
				pos = var3_10,
				scale = var4_10,
				move = var5_10,
				move_time = var6_10
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
		LeanTween.moveLocal(go(arg0_12.paintingContainer), var0_12, var1_12):setOnComplete(System.Action(function()
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

	local var0_14 = Ship.New({
		configId = arg1_14,
		skin_id = arg2_14
	})
	local var1_14 = MainPaintingView.GetAssistantStatus(var0_14)

	if var1_14 == MainPaintingView.STATE_SPINE_PAINTING then
		local var2_14 = SpinePainting.GenerateData({
			ship = var0_14,
			position = Vector3(0, 0, 0),
			parent = arg0_14.spineContainer,
			effectParent = arg0_14.effectContainer
		})

		arg0_14.spinePainting = SpinePainting.New(var2_14, function(arg0_15)
			local var0_15 = arg0_15:GetSpineTrasform():GetComponent(typeof(ItemList)).prefabItem:ToTable()

			for iter0_15, iter1_15 in ipairs(var0_15) do
				local var1_15 = GetComponent(iter1_15, typeof(Canvas))

				if var1_15 then
					RemoveComponent(var1_15, typeof(Canvas))
				end
			end

			arg0_14.loading = false

			arg3_14()
		end)
	elseif var1_14 == MainPaintingView.STATE_PAINTING then
		local var3_14 = var0_14:getPainting()
		local var4_14 = var0_0.StaticGetPaintingName(var3_14)

		LoadPaintingPrefabAsync(arg0_14.paintingContainer, var3_14, var4_14, "mainNormal", function()
			arg0_14.loading = false

			arg3_14()
		end)
	elseif var1_14 == MainPaintingView.STATE_L2D then
		local var5_14 = Live2D.GenerateData({
			ship = var0_14,
			scale = Vector3(52, 52, 52),
			position = Vector3(0, 0, -1),
			parent = arg0_14.l2dContainner
		})

		arg0_14.live2dChar = Live2D.New(var5_14, function(arg0_17)
			arg0_14:updateL2dSortMode(arg0_17)
			arg0_17:IgonreReactPos(true)

			arg0_14.loading = false

			arg3_14()
		end)
	else
		local var6_14 = var0_14:getPainting()
		local var7_14 = var0_0.StaticGetPaintingName(var6_14)

		LoadPaintingPrefabAsync(arg0_14.paintingContainer, var6_14, var7_14, "mainNormal", function()
			arg0_14.loading = false
		end)
	end
end

function var0_0.updateL2dSortMode(arg0_19, arg1_19)
	local var0_19 = arg1_19._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
	local var1_19 = typeof("Live2D.Cubism.Rendering.CubismRenderController")
	local var2_19 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontOrder", nil)

	ReflectionHelp.RefSetProperty(var1_19, "SortingMode", var0_19, var2_19)
end

function var0_0.StaticGetPaintingName(arg0_20)
	local var0_20 = arg0_20

	if checkABExist("painting/" .. var0_20 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. var0_20, 0) ~= 0 then
		var0_20 = var0_20 .. "_n"
	end

	if HXSet.isHx() then
		return var0_20
	end

	local var1_20 = getProxy(SettingsProxy):GetMainPaintingVariantFlag(arg0_20) == var0_0.PAINTING_VARIANT_EX

	if var1_20 and not checkABExist("painting/" .. var0_20 .. "_ex") then
		return var0_20
	end

	return var1_20 and var0_20 .. "_ex" or var0_20
end

function var0_0.closeView(arg0_21)
	if arg0_21.loading then
		return
	end

	var0_0.super.closeView(arg0_21)
end

function var0_0.onBackPressed(arg0_22)
	if arg0_22.loading then
		return
	end

	var0_0.super.onBackPressed(arg0_22)
end

function var0_0.GetSkinShowAble(arg0_23)
	local var0_23 = pg.ship_skin_template[arg0_23]
	local var1_23 = false

	if var0_23.get_showing.show and var0_23.get_showing.show == 1 then
		var1_23 = true
	end

	return var1_23
end

function var0_0.willExit(arg0_24)
	arg0_24.flushEevent:SetTriggerEvent(nil)
	arg0_24.flushEevent:SetEndEvent(nil)

	if LeanTween.isTweening(go(arg0_24.paintingContainer)) then
		LeanTween.cancel(go(arg0_24.paintingContainer))
	end

	if arg0_24.live2dChar then
		arg0_24.live2dChar:Dispose()

		arg0_24.live2dChar = nil
	end

	if arg0_24.spinePainting then
		arg0_24.spinePainting:Dispose()

		arg0_24.spinePainting = nil
	end

	if arg0_24.closeCallBack then
		arg0_24.closeCallBack()

		arg0_24.closeCallBack = nil
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_24.ad, arg0_24._tf)
end

return var0_0
