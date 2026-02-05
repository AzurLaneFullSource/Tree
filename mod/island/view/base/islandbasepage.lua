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

function var0_0.CanEsc(arg0_5)
	return true
end

function var0_0.NeedCache(arg0_6)
	return true
end

function var0_0.GetIsland(arg0_7)
	return arg0_7.islandScene:GetIsland()
end

function var0_0.GetSelfIsland(arg0_8)
	return getProxy(IslandProxy):GetIsland()
end

function var0_0.IsSelfIsland(arg0_9)
	return arg0_9:GetIsland().id == arg0_9:GetSelfIsland().id
end

function var0_0.GetPoolMgr(arg0_10)
	return arg0_10.islandScene.poolMgr
end

function var0_0.Show(arg0_11, ...)
	arg0_11:AddListeners()
	arg0_11.islandUIController:Show(true)
	arg0_11:OnShow(...)
end

function var0_0.Hide(arg0_12, arg1_12, arg2_12)
	local var0_12 = defaultValue(arg1_12, true)
	local var1_12 = {}

	if var0_12 then
		table.insert(var1_12, function(arg0_13)
			arg0_12.islandUIController:Hide(true, arg0_13)
		end)
	end

	seriesAsync(var1_12, function()
		arg0_12:RemoveListeners()
		arg0_12:OnHide()
		arg0_12:ClosePage(arg0_12)

		if not arg2_12 then
			arg0_12:OnExit()
		end
	end)
end

function var0_0.Enable(arg0_15)
	arg0_15.islandUIController:Show(true)

	arg0_15.isVisible = true

	arg0_15:OnEnable()
end

function var0_0.Disable(arg0_16, arg1_16)
	arg0_16.islandUIController:Hide(true, arg1_16)

	arg0_16.isVisible = false

	arg0_16:OnDisable()
end

function var0_0.BlurPanel(arg0_17)
	arg0_17.isBluring = true

	arg0_17.viewComponent:BlurPanel(arg0_17._tf)
end

function var0_0.UnBlurPanel(arg0_18)
	if arg0_18.isBluring then
		arg0_18.viewComponent:UnOverlayPanel(arg0_18._tf, arg0_18._parentTf)

		arg0_18.isBluring = false
	end
end

function var0_0.ShowMsgBox(arg0_19, arg1_19)
	return arg0_19.islandScene:ShowMsgbox(arg1_19)
end

function var0_0.PlayStory(arg0_20, arg1_20)
	return arg0_20.islandScene:PlayStory(arg1_20)
end

function var0_0.PlayGetShipTimeline(arg0_21, arg1_21, arg2_21)
	arg0_21.islandScene:PlayGetShipTimeline(arg1_21, arg2_21)
end

function var0_0.OpenPage(arg0_22, arg1_22, ...)
	IslandGuideChecker.CheckOnOpenPage(arg1_22.__cname)

	return arg0_22.islandScene.sceneMgr:OpenPage(arg0_22, arg1_22, ...)
end

function var0_0.OpenScenePage(arg0_23, arg1_23, ...)
	return arg0_23.islandScene:OpenPage(arg1_23, ...)
end

function var0_0.ClosePage(arg0_24, arg1_24)
	arg0_24.islandScene.sceneMgr:ClosePage(arg1_24)
end

function var0_0.AddListener(arg0_25, arg1_25, arg2_25)
	local function var0_25(arg0_26, ...)
		arg2_25(arg0_25, ...)
	end

	local var1_25 = arg0_25:bind(arg1_25, var0_25)

	arg0_25.__callbacks__[arg1_25] = var1_25

	arg0_25:GetIsland():AddListener(arg1_25, var0_25)
end

function var0_0.RemoveListener(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.__callbacks__[arg1_27]

	if var0_27 then
		local var1_27 = arg0_27.eventStore[var0_27]

		arg0_27:GetIsland():RemoveListener(arg1_27, var1_27.callback)
		arg0_27:disconnect(var0_27)

		arg0_27.__callbacks__[arg1_27] = nil
	end
end

function var0_0.Destroy(arg0_28, arg1_28)
	if arg0_28:isShowing() then
		arg0_28:Hide(false, arg1_28)
	end

	arg0_28.__callbacks__ = {}

	var0_0.super.Destroy(arg0_28)
	arg0_28:Reset()
end

function var0_0.SetVisible(arg0_29, arg1_29, arg2_29)
	local var0_29 = GetOrAddComponent(arg1_29, typeof(CanvasGroup))

	var0_29.alpha = arg2_29 and 1 or 0
	var0_29.blocksRaycasts = arg2_29
end

function var0_0.ActiveOrDisactive(arg0_30, arg1_30)
	if not IsNil(arg0_30._tf) then
		setActive(arg0_30._tf, arg1_30)
	end
end

function var0_0.AddListeners(arg0_31)
	return
end

function var0_0.RemoveListeners(arg0_32)
	return
end

function var0_0.Preload(arg0_33, arg1_33)
	arg1_33()
end

function var0_0.OnShow(arg0_34)
	return
end

function var0_0.OnHide(arg0_35)
	return
end

function var0_0.OnExit(arg0_36)
	return
end

function var0_0.OnEnable(arg0_37)
	return
end

function var0_0.OnDisable(arg0_38)
	return
end

function var0_0.GetEnterAnimationName(arg0_39)
	return ""
end

function var0_0.GetExitAnimationName(arg0_40)
	return ""
end

return var0_0
