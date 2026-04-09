local var0_0 = class("IslandBasePage", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1.event
	local var1_1 = arg1_1.contextData

	var0_0.super.Ctor(arg0_1, arg2_1, var0_1, var1_1)
	arg0_1:RegisterView(arg1_1)

	arg0_1.islandScene = arg1_1
	arg0_1.__callbacks__ = {}
	arg0_1.isBlur = false
end

function var0_0.Loaded(arg0_2, arg1_2)
	var0_0.super.Loaded(arg0_2, arg1_2)

	arg0_2.islandUIController = GetOrAddComponent(arg1_2, typeof(IslandUIController))
	arg0_2.cg = arg1_2:GetComponent(typeof(CanvasGroup))
end

function var0_0.emit(arg0_3, ...)
	arg0_3.islandScene:emit(...)
end

function var0_0.emitCore(arg0_4, arg1_4, ...)
	arg0_4.islandScene:emitCore(arg1_4, ...)
end

function var0_0.emitCoreController(arg0_5, arg1_5, ...)
	arg0_5.islandScene:emitCoreController(arg1_5, ...)
end

function var0_0.CanEsc(arg0_6)
	return true
end

function var0_0.NeedCache(arg0_7)
	return true
end

function var0_0.GetIsland(arg0_8)
	return arg0_8.islandScene:GetIsland()
end

function var0_0.GetSelfIsland(arg0_9)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.IsSelfIsland(arg0_10)
	return arg0_10:GetIsland().id == arg0_10:GetSelfIsland().id
end

function var0_0.GetPoolMgr(arg0_11)
	return arg0_11.islandScene.poolMgr
end

function var0_0.GetPage(arg0_12, arg1_12)
	return arg0_12.islandScene:GetPage(arg1_12)
end

function var0_0.Show(arg0_13, ...)
	arg0_13:AddListeners()
	arg0_13.islandUIController:Show(true)
	arg0_13:OnShow(...)
end

function var0_0.Hide(arg0_14, arg1_14, arg2_14)
	local var0_14 = defaultValue(arg1_14, true)
	local var1_14 = {}

	if var0_14 then
		table.insert(var1_14, function(arg0_15)
			arg0_14.islandUIController:Hide(true, arg0_15)
		end)
	end

	seriesAsync(var1_14, function()
		arg0_14:RemoveListeners()
		arg0_14:OnHide()
		arg0_14:ClosePage(arg0_14)

		if not arg2_14 then
			arg0_14:OnExit()
		end
	end)
end

function var0_0.Enable(arg0_17)
	arg0_17.islandUIController:Show(true)

	arg0_17.isVisible = true

	arg0_17:OnEnable()
end

function var0_0.Disable(arg0_18, arg1_18)
	arg0_18.islandUIController:Hide(true, arg1_18)

	arg0_18.isVisible = false

	arg0_18:OnDisable()
end

function var0_0.BlurPanel(arg0_19)
	arg0_19.isBluring = true

	arg0_19.viewComponent:BlurPanel(arg0_19._tf)
end

function var0_0.UnBlurPanel(arg0_20)
	if arg0_20.isBluring then
		arg0_20.viewComponent:UnOverlayPanel(arg0_20._tf, arg0_20._parentTf)

		arg0_20.isBluring = false
	end
end

function var0_0.ShowMsgBox(arg0_21, arg1_21)
	return arg0_21.islandScene:ShowMsgbox(arg1_21)
end

function var0_0.PlayStory(arg0_22, arg1_22)
	return arg0_22.islandScene:PlayStory(arg1_22)
end

function var0_0.PlayGetShipTimeline(arg0_23, arg1_23, arg2_23)
	arg0_23.islandScene:PlayGetShipTimeline(arg1_23, arg2_23)
end

function var0_0.OpenPage(arg0_24, arg1_24, ...)
	IslandGuideChecker.CheckOnOpenPage(arg1_24.__cname)

	return arg0_24.islandScene.sceneMgr:OpenPage(arg0_24, arg1_24, ...)
end

function var0_0.OpenScenePage(arg0_25, arg1_25, ...)
	return arg0_25.islandScene:OpenPage(arg1_25, ...)
end

function var0_0.ClosePage(arg0_26, arg1_26)
	arg0_26.islandScene.sceneMgr:ClosePage(arg1_26)
end

function var0_0.DestorySubPage(arg0_27, arg1_27)
	arg0_27.islandScene.sceneMgr:DestorySubPage(arg1_27)
end

function var0_0.AddListener(arg0_28, arg1_28, arg2_28)
	local function var0_28(arg0_29, ...)
		arg2_28(arg0_28, ...)
	end

	local var1_28 = arg0_28:bind(arg1_28, var0_28)

	arg0_28.__callbacks__[arg1_28] = var1_28

	arg0_28:GetIsland():AddListener(arg1_28, var0_28)
end

function var0_0.RemoveListener(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.__callbacks__[arg1_30]

	if var0_30 then
		local var1_30 = arg0_30.eventStore[var0_30]

		arg0_30:GetIsland():RemoveListener(arg1_30, var1_30.callback)
		arg0_30:disconnect(var0_30)

		arg0_30.__callbacks__[arg1_30] = nil
	end
end

function var0_0.Destroy(arg0_31, arg1_31)
	if arg0_31:isShowing() then
		arg0_31:Hide(false, arg1_31)
	end

	arg0_31.__callbacks__ = {}

	var0_0.super.Destroy(arg0_31)
	arg0_31:Reset()
end

function var0_0.SetVisible(arg0_32, arg1_32, arg2_32)
	local var0_32 = GetOrAddComponent(arg1_32, typeof(CanvasGroup))

	var0_32.alpha = arg2_32 and 1 or 0
	var0_32.blocksRaycasts = arg2_32
end

function var0_0.ActiveOrDisactive(arg0_33, arg1_33)
	if not IsNil(arg0_33._tf) then
		setActive(arg0_33._tf, arg1_33)
	end
end

function var0_0.AddListeners(arg0_34)
	return
end

function var0_0.RemoveListeners(arg0_35)
	return
end

function var0_0.Preload(arg0_36, arg1_36)
	arg1_36()
end

function var0_0.OnShow(arg0_37)
	return
end

function var0_0.OnHide(arg0_38)
	return
end

function var0_0.OnExit(arg0_39)
	return
end

function var0_0.OnEnable(arg0_40)
	return
end

function var0_0.OnDisable(arg0_41)
	return
end

function var0_0.GetEnterAnimationName(arg0_42)
	return ""
end

function var0_0.GetExitAnimationName(arg0_43)
	return ""
end

return var0_0
