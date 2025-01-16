local var0_0 = class("NewMainSceneBaseTheme", import("view.base.BaseSubView"))

function var0_0.OnLoaded(arg0_1)
	arg0_1.mainCG = GetOrAddComponent(arg0_1._tf, typeof(CanvasGroup))
	arg0_1.mainCG.alpha = 0
	arg0_1.panels = {
		arg0_1:GetTopPanel(),
		arg0_1:GetRightPanel(),
		arg0_1:GetLeftPanel(),
		arg0_1:GetBottomPanel()
	}
	arg0_1.tagView = arg0_1:GetTagView()
	arg0_1.iconView = arg0_1:GetIconView()
	arg0_1.chatRoomView = arg0_1:GetChatRoomView()
	arg0_1.bannerView = arg0_1:GetBannerView()
	arg0_1.actBtnView = arg0_1:GetActBtnView()
	arg0_1.buffView = arg0_1:GetBuffView()
	arg0_1.wordView = arg0_1:GetWordView()
	arg0_1.changeView = arg0_1:GetChangeSkinView()

	pg.redDotHelper:Init(arg0_1:GetRedDots())
end

function var0_0.Show(arg0_2, arg1_2)
	arg1_2()
	var0_0.super.Show(arg0_2)
end

function var0_0.PlayEnterAnimation(arg0_3, arg1_3, arg2_3)
	arg0_3.bannerView:Init()
	arg0_3.actBtnView:Init()
	arg0_3:_FoldPanels(true, 0)

	arg0_3.mainCG.alpha = 1

	arg0_3:_FoldPanels(false, 0.5)
	onDelayTick(arg2_3, 0.51)
end

function var0_0.init(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.panels) do
		iter1_4:Init()
	end

	arg0_4.iconView:Init(arg1_4)
	arg0_4.chatRoomView:Init()
	arg0_4.buffView:Init()
	arg0_4.tagView:Init()
	arg0_4.changeView:Init(arg1_4)
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_OVERLAY_FOREVER, arg0_4._tf, {
		pbList = arg0_4:GetPbList(),
		weight = LayerWeightConst.BASE_LAYER + 1
	})
end

function var0_0._FoldPanels(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.panels) do
		iter1_5:Fold(arg1_5, arg2_5)
	end

	arg0_5.iconView:Fold(arg1_5, arg2_5)
	arg0_5.chatRoomView:Fold(arg1_5, arg2_5)
	arg0_5.bannerView:Fold(arg1_5, arg2_5)
	arg0_5.actBtnView:Fold(arg1_5, arg2_5)
	arg0_5.buffView:Fold(arg1_5, arg2_5)
	arg0_5.wordView:Fold(arg1_5, arg2_5)
	arg0_5.tagView:Fold(arg1_5, arg2_5)
	arg0_5.changeView:Fold(arg1_5, arg2_5)
end

function var0_0.OnFoldPanels(arg0_6, arg1_6)
	if arg1_6 then
		arg0_6.mainCG.blocksRaycasts = false
	else
		Timer.New(function()
			if arg0_6.mainCG then
				arg0_6.mainCG.blocksRaycasts = true
			end
		end, 0.5, 1):Start()
	end

	arg0_6:_FoldPanels(arg1_6, 0.5)
end

function var0_0.OnSwitchToNextShip(arg0_8, arg1_8)
	arg0_8.iconView:Refresh(arg1_8)
	arg0_8.changeView:Refresh(arg1_8)

	for iter0_8, iter1_8 in ipairs(arg0_8.panels) do
		iter1_8:Refresh()
	end
end

function var0_0.Refresh(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.panels) do
		iter1_9:Refresh()
	end

	arg0_9.iconView:Refresh(arg1_9)
	arg0_9.chatRoomView:Refresh()
	arg0_9.buffView:Refresh()
	arg0_9.actBtnView:Refresh()
	arg0_9.bannerView:Refresh()
	arg0_9.tagView:Refresh()
	arg0_9.changeView:Refresh(arg1_9)
	pg.LayerWeightMgr.GetInstance():SetVisibleViaLayer(arg0_9._tf, true)
end

function var0_0.Disable(arg0_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.panels) do
		iter1_10:Disable()
	end

	arg0_10.iconView:Disable()
	arg0_10.chatRoomView:Disable()
	arg0_10.buffView:Disable()
	arg0_10.actBtnView:Disable()
	arg0_10.bannerView:Disable()
	arg0_10.wordView:Disable()
	arg0_10.changeView:Disable()
	pg.LayerWeightMgr.GetInstance():SetVisibleViaLayer(arg0_10._tf, false)
end

function var0_0.SetEffectPanelVisible(arg0_11, arg1_11)
	return
end

function var0_0.OnDestroy(arg0_12)
	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0_12._tf, arg0_12._parentTf)

	for iter0_12, iter1_12 in ipairs(arg0_12.panels or {}) do
		iter1_12:Dispose()
	end

	arg0_12.panels = nil

	if arg0_12.iconView then
		arg0_12.iconView:Dispose()

		arg0_12.iconView = nil
	end

	if arg0_12.chatRoomView then
		arg0_12.chatRoomView:Dispose()

		arg0_12.chatRoomView = nil
	end

	if arg0_12.bannerView then
		arg0_12.bannerView:Dispose()

		arg0_12.bannerView = nil
	end

	if arg0_12.actBtnView then
		arg0_12.actBtnView:Dispose()

		arg0_12.actBtnView = nil
	end

	if arg0_12.buffView then
		arg0_12.buffView:Dispose()

		arg0_12.buffView = nil
	end

	if arg0_12.tagView then
		arg0_12.tagView:Dispose()

		arg0_12.tagView = nil
	end

	if arg0_12.wordView then
		arg0_12.wordView:Dispose()

		arg0_12.wordView = nil
	end

	if arg0_12.changeView then
		arg0_12.changeView:Dispose()

		arg0_12.changeView = nil
	end

	pg.redDotHelper:Clear()
end

function var0_0.GetPbList(arg0_13)
	return {}
end

function var0_0.GetCalibrationBG(arg0_14)
	assert(false)
end

function var0_0.GetPaintingOffset(arg0_15, arg1_15)
	return MainPaintingShift.New({
		0,
		-10,
		0,
		0,
		0,
		0,
		1,
		1,
		1
	})
end

function var0_0.ApplyDefaultResUI(arg0_16)
	return true
end

function var0_0.GetWordView(arg0_17)
	assert(false)
end

function var0_0.GetTagView(arg0_18)
	assert(false)
end

function var0_0.GetTopPanel(arg0_19)
	assert(false)
end

function var0_0.GetRightPanel(arg0_20)
	assert(false)
end

function var0_0.GetLeftPanel(arg0_21)
	assert(false)
end

function var0_0.GetBottomPanel(arg0_22)
	assert(false)
end

function var0_0.GetIconView(arg0_23)
	assert(false)
end

function var0_0.GetChatRoomView(arg0_24)
	assert(false)
end

function var0_0.GetBannerView(arg0_25)
	assert(false)
end

function var0_0.GetActBtnView(arg0_26)
	assert(false)
end

function var0_0.GetBuffView(arg0_27)
	assert(false)
end

function var0_0.GetChangeSkinView(arg0_28)
	assert(false)
end

function var0_0.GetRedDots(arg0_29)
	return {}
end

return var0_0
