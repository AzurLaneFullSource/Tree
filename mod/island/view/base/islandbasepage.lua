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

function var0_0.NeedCache(arg0_5)
	return true
end

function var0_0.GetIsland(arg0_6)
	return arg0_6.islandScene:GetIsland()
end

function var0_0.GetPoolMgr(arg0_7)
	return arg0_7.islandScene.poolMgr
end

function var0_0.Show(arg0_8, ...)
	arg0_8:AddListeners()
	arg0_8.islandUIController:Show(true)
	arg0_8:OnShow(...)
end

function var0_0.Hide(arg0_9, arg1_9, arg2_9)
	local var0_9 = defaultValue(arg1_9, true)
	local var1_9 = {}

	if var0_9 then
		table.insert(var1_9, function(arg0_10)
			arg0_9.islandUIController:Hide(true, arg0_10)
		end)
	end

	seriesAsync(var1_9, function()
		arg0_9:RemoveListeners()
		arg0_9:OnHide()
		arg0_9:ClosePage(arg0_9)

		if not arg2_9 then
			arg0_9:OnExit()
		end
	end)
end

function var0_0.Enable(arg0_12)
	arg0_12.islandUIController:Show(true)

	arg0_12.isVisible = true

	arg0_12:OnEnable()
end

function var0_0.Disable(arg0_13, arg1_13)
	arg0_13.islandUIController:Hide(true, arg1_13)

	arg0_13.isVisible = false

	arg0_13:OnDisable()
end

function var0_0.BlurPanel(arg0_14)
	arg0_14.viewComponent:BlurPanel(arg0_14._tf)
end

function var0_0.UnBlurPanel(arg0_15)
	arg0_15.viewComponent:UnOverlayPanel(arg0_15._tf, arg0_15._parentTf)
end

function var0_0.ShowMsgBox(arg0_16, arg1_16)
	return arg0_16.islandScene:ShowMsgbox(arg1_16)
end

function var0_0.PlayStory(arg0_17, arg1_17)
	return arg0_17.islandScene:PlayStory(arg1_17)
end

function var0_0.PlayGetShipTimeline(arg0_18, arg1_18, arg2_18)
	arg0_18.islandScene:PlayGetShipTimeline(arg1_18, arg2_18)
end

function var0_0.OpenPage(arg0_19, arg1_19, ...)
	return arg0_19.islandScene.sceneMgr:OpenPage(arg0_19, arg1_19, ...)
end

function var0_0.OpenScenePage(arg0_20, arg1_20, ...)
	return arg0_20.islandScene:OpenPage(arg1_20, ...)
end

function var0_0.ClosePage(arg0_21, arg1_21)
	arg0_21.islandScene.sceneMgr:ClosePage(arg1_21)
end

function var0_0.AddListener(arg0_22, arg1_22, arg2_22)
	local function var0_22(arg0_23, ...)
		arg2_22(arg0_22, ...)
	end

	local var1_22 = arg0_22:bind(arg1_22, var0_22)

	arg0_22.__callbacks__[arg1_22] = var1_22

	arg0_22:GetIsland():AddListener(arg1_22, var0_22)
end

function var0_0.RemoveListener(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.__callbacks__[arg1_24]

	if var0_24 then
		local var1_24 = arg0_24.eventStore[var0_24]

		arg0_24:GetIsland():RemoveListener(arg1_24, var1_24.callback)
		arg0_24:disconnect(var0_24)

		arg0_24.__callbacks__[arg1_24] = nil
	end
end

function var0_0.Destroy(arg0_25, arg1_25)
	if arg0_25:isShowing() then
		arg0_25:Hide(false, arg1_25)
	end

	arg0_25.__callbacks__ = {}

	var0_0.super.Destroy(arg0_25)
	arg0_25:Reset()
end

function var0_0.SetVisible(arg0_26, arg1_26, arg2_26)
	local var0_26 = GetOrAddComponent(arg1_26, typeof(CanvasGroup))

	var0_26.alpha = arg2_26 and 1 or 0
	var0_26.blocksRaycasts = arg2_26
end

function var0_0.AddListeners(arg0_27)
	return
end

function var0_0.RemoveListeners(arg0_28)
	return
end

function var0_0.Preload(arg0_29, arg1_29)
	arg1_29()
end

function var0_0.OnShow(arg0_30)
	return
end

function var0_0.OnHide(arg0_31)
	return
end

function var0_0.OnExit(arg0_32)
	return
end

function var0_0.OnEnable(arg0_33)
	return
end

function var0_0.OnDisable(arg0_34)
	return
end

function var0_0.GetEnterAnimationName(arg0_35)
	return ""
end

function var0_0.GetExitAnimationName(arg0_36)
	return ""
end

return var0_0
