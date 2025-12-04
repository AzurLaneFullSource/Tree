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

function var0_0.GetPoolMgr(arg0_8)
	return arg0_8.islandScene.poolMgr
end

function var0_0.Show(arg0_9, ...)
	arg0_9:AddListeners()
	arg0_9.islandUIController:Show(true)
	arg0_9:OnShow(...)
end

function var0_0.Hide(arg0_10, arg1_10, arg2_10)
	local var0_10 = defaultValue(arg1_10, true)
	local var1_10 = {}

	if var0_10 then
		table.insert(var1_10, function(arg0_11)
			arg0_10.islandUIController:Hide(true, arg0_11)
		end)
	end

	seriesAsync(var1_10, function()
		arg0_10:RemoveListeners()
		arg0_10:OnHide()
		arg0_10:ClosePage(arg0_10)

		if not arg2_10 then
			arg0_10:OnExit()
		end
	end)
end

function var0_0.Enable(arg0_13)
	arg0_13.islandUIController:Show(true)

	arg0_13.isVisible = true

	arg0_13:OnEnable()
end

function var0_0.Disable(arg0_14, arg1_14)
	arg0_14.islandUIController:Hide(true, arg1_14)

	arg0_14.isVisible = false

	arg0_14:OnDisable()
end

function var0_0.BlurPanel(arg0_15)
	arg0_15.isBluring = true

	arg0_15.viewComponent:BlurPanel(arg0_15._tf)
end

function var0_0.UnBlurPanel(arg0_16)
	if arg0_16.isBluring then
		arg0_16.viewComponent:UnOverlayPanel(arg0_16._tf, arg0_16._parentTf)

		arg0_16.isBluring = false
	end
end

function var0_0.ShowMsgBox(arg0_17, arg1_17)
	return arg0_17.islandScene:ShowMsgbox(arg1_17)
end

function var0_0.PlayStory(arg0_18, arg1_18)
	return arg0_18.islandScene:PlayStory(arg1_18)
end

function var0_0.PlayGetShipTimeline(arg0_19, arg1_19, arg2_19)
	arg0_19.islandScene:PlayGetShipTimeline(arg1_19, arg2_19)
end

function var0_0.OpenPage(arg0_20, arg1_20, ...)
	IslandGuideChecker.CheckOnOpenPage(arg1_20.__cname)

	return arg0_20.islandScene.sceneMgr:OpenPage(arg0_20, arg1_20, ...)
end

function var0_0.OpenScenePage(arg0_21, arg1_21, ...)
	return arg0_21.islandScene:OpenPage(arg1_21, ...)
end

function var0_0.ClosePage(arg0_22, arg1_22)
	arg0_22.islandScene.sceneMgr:ClosePage(arg1_22)
end

function var0_0.AddListener(arg0_23, arg1_23, arg2_23)
	local function var0_23(arg0_24, ...)
		arg2_23(arg0_23, ...)
	end

	local var1_23 = arg0_23:bind(arg1_23, var0_23)

	arg0_23.__callbacks__[arg1_23] = var1_23

	arg0_23:GetIsland():AddListener(arg1_23, var0_23)
end

function var0_0.RemoveListener(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.__callbacks__[arg1_25]

	if var0_25 then
		local var1_25 = arg0_25.eventStore[var0_25]

		arg0_25:GetIsland():RemoveListener(arg1_25, var1_25.callback)
		arg0_25:disconnect(var0_25)

		arg0_25.__callbacks__[arg1_25] = nil
	end
end

function var0_0.Destroy(arg0_26, arg1_26)
	if arg0_26:isShowing() then
		arg0_26:Hide(false, arg1_26)
	end

	arg0_26.__callbacks__ = {}

	var0_0.super.Destroy(arg0_26)
	arg0_26:Reset()
end

function var0_0.SetVisible(arg0_27, arg1_27, arg2_27)
	local var0_27 = GetOrAddComponent(arg1_27, typeof(CanvasGroup))

	var0_27.alpha = arg2_27 and 1 or 0
	var0_27.blocksRaycasts = arg2_27
end

function var0_0.ActiveOrDisactive(arg0_28, arg1_28)
	if not IsNil(arg0_28._tf) then
		setActive(arg0_28._tf, arg1_28)
	end
end

function var0_0.AddListeners(arg0_29)
	return
end

function var0_0.RemoveListeners(arg0_30)
	return
end

function var0_0.Preload(arg0_31, arg1_31)
	arg1_31()
end

function var0_0.OnShow(arg0_32)
	return
end

function var0_0.OnHide(arg0_33)
	return
end

function var0_0.OnExit(arg0_34)
	return
end

function var0_0.OnEnable(arg0_35)
	return
end

function var0_0.OnDisable(arg0_36)
	return
end

function var0_0.GetEnterAnimationName(arg0_37)
	return ""
end

function var0_0.GetExitAnimationName(arg0_38)
	return ""
end

return var0_0
