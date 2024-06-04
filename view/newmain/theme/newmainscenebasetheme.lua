local var0 = class("NewMainSceneBaseTheme", import("view.base.BaseSubView"))

function var0.OnLoaded(arg0)
	arg0.mainCG = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))
	arg0.mainCG.alpha = 0
	arg0.panels = {
		arg0:GetTopPanel(),
		arg0:GetRightPanel(),
		arg0:GetLeftPanel(),
		arg0:GetBottomPanel()
	}
	arg0.tagView = arg0:GetTagView()
	arg0.iconView = arg0:GetIconView()
	arg0.chatRoomView = arg0:GetChatRoomView()
	arg0.bannerView = arg0:GetBannerView()
	arg0.actBtnView = arg0:GetActBtnView()
	arg0.buffView = arg0:GetBuffView()
	arg0.wordView = arg0:GetWordView()

	pg.redDotHelper:Init(arg0:GetRedDots())
end

function var0.Show(arg0, arg1)
	arg1()
	var0.super.Show(arg0)
end

function var0.PlayEnterAnimation(arg0, arg1, arg2)
	arg0.bannerView:Init()
	arg0.actBtnView:Init()
	arg0:_FoldPanels(true, 0)

	arg0.mainCG.alpha = 1

	arg0:_FoldPanels(false, 0.5)
	onDelayTick(arg2, 0.51)
end

function var0.init(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:Init()
	end

	arg0.iconView:Init(arg1)
	arg0.chatRoomView:Init()
	arg0.buffView:Init()
	arg0.tagView:Init()
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_OVERLAY_FOREVER, arg0._tf, {
		pbList = arg0:GetPbList(),
		weight = LayerWeightConst.BASE_LAYER + 1
	})
end

function var0._FoldPanels(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:Fold(arg1, arg2)
	end

	arg0.iconView:Fold(arg1, arg2)
	arg0.chatRoomView:Fold(arg1, arg2)
	arg0.bannerView:Fold(arg1, arg2)
	arg0.actBtnView:Fold(arg1, arg2)
	arg0.buffView:Fold(arg1, arg2)
	arg0.wordView:Fold(arg1, arg2)
	arg0.tagView:Fold(arg1, arg2)
end

function var0.OnFoldPanels(arg0, arg1)
	if arg1 then
		arg0.mainCG.blocksRaycasts = false
	else
		Timer.New(function()
			if arg0.mainCG then
				arg0.mainCG.blocksRaycasts = true
			end
		end, 0.5, 1):Start()
	end

	arg0:_FoldPanels(arg1, 0.5)
end

function var0.OnSwitchToNextShip(arg0, arg1)
	arg0.iconView:Refresh(arg1)
end

function var0.Refresh(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:Refresh()
	end

	arg0.iconView:Refresh(arg1)
	arg0.chatRoomView:Refresh()
	arg0.buffView:Refresh()
	arg0.actBtnView:Refresh()
	arg0.bannerView:Refresh()
	arg0.tagView:Refresh()
	pg.LayerWeightMgr.GetInstance():SetVisibleViaLayer(arg0._tf, true)
end

function var0.Disable(arg0)
	for iter0, iter1 in ipairs(arg0.panels) do
		iter1:Disable()
	end

	arg0.iconView:Disable()
	arg0.chatRoomView:Disable()
	arg0.buffView:Disable()
	arg0.actBtnView:Disable()
	arg0.bannerView:Disable()
	arg0.wordView:Disable()
	pg.LayerWeightMgr.GetInstance():SetVisibleViaLayer(arg0._tf, false)
end

function var0.OnDestroy(arg0)
	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0._tf, arg0._parentTf)

	for iter0, iter1 in ipairs(arg0.panels or {}) do
		iter1:Dispose()
	end

	arg0.panels = nil

	if arg0.iconView then
		arg0.iconView:Dispose()

		arg0.iconView = nil
	end

	if arg0.chatRoomView then
		arg0.chatRoomView:Dispose()

		arg0.chatRoomView = nil
	end

	if arg0.bannerView then
		arg0.bannerView:Dispose()

		arg0.bannerView = nil
	end

	if arg0.actBtnView then
		arg0.actBtnView:Dispose()

		arg0.actBtnView = nil
	end

	if arg0.buffView then
		arg0.buffView:Dispose()

		arg0.buffView = nil
	end

	if arg0.tagView then
		arg0.tagView:Dispose()

		arg0.tagView = nil
	end

	if arg0.wordView then
		arg0.wordView:Dispose()

		arg0.wordView = nil
	end

	pg.redDotHelper:Clear()
end

function var0.GetPbList(arg0)
	return {}
end

function var0.GetCalibrationBG(arg0)
	assert(false)
end

function var0.GetPaintingOffset(arg0, arg1)
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

function var0.ApplyDefaultResUI(arg0)
	return true
end

function var0.GetWordView(arg0)
	assert(false)
end

function var0.GetTagView(arg0)
	assert(false)
end

function var0.GetTopPanel(arg0)
	assert(false)
end

function var0.GetRightPanel(arg0)
	assert(false)
end

function var0.GetLeftPanel(arg0)
	assert(false)
end

function var0.GetBottomPanel(arg0)
	assert(false)
end

function var0.GetIconView(arg0)
	assert(false)
end

function var0.GetChatRoomView(arg0)
	assert(false)
end

function var0.GetBannerView(arg0)
	assert(false)
end

function var0.GetActBtnView(arg0)
	assert(false)
end

function var0.GetBuffView(arg0)
	assert(false)
end

function var0.GetRedDots(arg0)
	return {}
end

return var0
