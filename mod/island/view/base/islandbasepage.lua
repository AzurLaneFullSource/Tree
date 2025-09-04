local var0_0 = class("IslandBasePage", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.islandScene = arg1_1

	local var0_1 = arg1_1.event
	local var1_1 = arg1_1.contextData

	var0_0.super.Ctor(arg0_1, arg2_1, var0_1, var1_1)

	arg0_1.__callbacks__ = {}
end

function var0_0.emit(arg0_2, ...)
	arg0_2.islandScene:emit(...)
end

function var0_0.emitCore(arg0_3, arg1_3, ...)
	arg0_3.islandScene:emitCore(arg1_3, ...)
end

function var0_0.NeedCache(arg0_4)
	return true
end

function var0_0.GetIsland(arg0_5)
	return arg0_5.islandScene:GetIsland()
end

function var0_0.GetPoolMgr(arg0_6)
	return arg0_6.islandScene.poolMgr
end

function var0_0.Show(arg0_7, ...)
	arg0_7:AddListeners()
	var0_0.super.Show(arg0_7)
	arg0_7:OnShow(...)
end

function var0_0.Hide(arg0_8)
	arg0_8:ClosePage(arg0_8)
	arg0_8:RemoveListeners()
	arg0_8:OnHide()
end

function var0_0.Enable(arg0_9)
	var0_0.super.Show(arg0_9)

	arg0_9.isVisible = true

	arg0_9:OnEnable()
end

function var0_0.Disable(arg0_10)
	var0_0.super.Hide(arg0_10)

	arg0_10.isVisible = false

	arg0_10:OnDisable()
end

function var0_0.BlurPanel(arg0_11, arg1_11)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf, {
		weight = arg1_11 or LayerWeightConst.TOP_LAYER
	})
end

function var0_0.UnBlurPanel(arg0_12)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf, arg0_12._parentTf)
end

function var0_0.ShowMsgBox(arg0_13, arg1_13)
	return arg0_13.islandScene:ShowMsgbox(arg1_13)
end

function var0_0.PlayStory(arg0_14, arg1_14)
	return arg0_14.islandScene:PlayStory(arg1_14)
end

function var0_0.PlayGetShipTimeline(arg0_15, arg1_15, arg2_15)
	arg0_15.islandScene:PlayGetShipTimeline(arg1_15, arg2_15)
end

function var0_0.OpenPage(arg0_16, arg1_16, ...)
	return arg0_16.islandScene.sceneMgr:OpenPage(arg0_16, arg1_16, ...)
end

function var0_0.OpenScenePage(arg0_17, arg1_17, ...)
	return arg0_17.islandScene:OpenPage(arg1_17, ...)
end

function var0_0.ClosePage(arg0_18, arg1_18)
	arg0_18.islandScene.sceneMgr:ClosePage(arg1_18)
end

function var0_0.AddListener(arg0_19, arg1_19, arg2_19)
	local function var0_19(arg0_20, ...)
		arg2_19(arg0_19, ...)
	end

	local var1_19 = arg0_19:bind(arg1_19, var0_19)

	arg0_19.__callbacks__[arg1_19] = var1_19

	arg0_19:GetIsland():AddListener(arg1_19, var0_19)
end

function var0_0.RemoveListener(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.__callbacks__[arg1_21]

	if var0_21 then
		local var1_21 = arg0_21.eventStore[var0_21]

		arg0_21:GetIsland():RemoveListener(arg1_21, var1_21.callback)
		arg0_21:disconnect(var0_21)

		arg0_21.__callbacks__[arg1_21] = nil
	end
end

function var0_0.Destroy(arg0_22)
	if arg0_22:GetLoaded() then
		arg0_22:Hide()
	end

	arg0_22.__callbacks__ = {}

	var0_0.super.Destroy(arg0_22)
	arg0_22:Reset()
end

function var0_0.SetVisible(arg0_23, arg1_23, arg2_23)
	local var0_23 = GetOrAddComponent(arg1_23, typeof(CanvasGroup))

	var0_23.alpha = arg2_23 and 1 or 0
	var0_23.blocksRaycasts = arg2_23
end

function var0_0.AddListeners(arg0_24)
	return
end

function var0_0.RemoveListeners(arg0_25)
	return
end

function var0_0.Preload(arg0_26, arg1_26)
	arg1_26()
end

function var0_0.OnShow(arg0_27)
	return
end

function var0_0.OnHide(arg0_28)
	return
end

function var0_0.OnEnable(arg0_29)
	return
end

function var0_0.OnDisable(arg0_30)
	return
end

return var0_0
