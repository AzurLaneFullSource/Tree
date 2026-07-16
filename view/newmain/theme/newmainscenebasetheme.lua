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
	arg0_1.asmrChatView = arg0_1:GetAsmrChatView()
	arg0_1.redDotUIList = arg0_1:RegisterRedDots()
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
	arg0_4.asmrChatView:Init(arg1_4)
	arg0_4:OverlayPanel(arg0_4._tf, {
		stopTop = true,
		pbList = arg0_4:GetPbList()
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
	arg0_5.asmrChatView:Fold(arg1_5, arg2_5)
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

function var0_0.OnAsmrTurnning(arg0_8, arg1_8)
	arg0_8._asmrTurnning = arg1_8

	for iter0_8, iter1_8 in ipairs(arg0_8.panels) do
		iter1_8:SetAlpha(arg1_8 and 0 or 1)
		iter1_8:SetInteractable(not arg1_8 and true or false)
		iter1_8:SetBlocksRaycasts(not arg1_8 and true or false)
	end

	arg0_8.changeView:IgnoreParentGroups(arg1_8)
	arg0_8.asmrChatView:SetVisible(arg1_8)
	arg0_8.wordView:StopAnimation()
end

function var0_0.SetAsmrChatText(arg0_9, arg1_9, arg2_9)
	arg0_9.asmrChatView:ShowChat(arg1_9, arg2_9)
end

function var0_0.OnSwitchToNextShip(arg0_10, arg1_10)
	arg0_10.iconView:Refresh(arg1_10)
	arg0_10.changeView:Refresh(arg1_10)

	for iter0_10, iter1_10 in ipairs(arg0_10.panels) do
		iter1_10:Refresh()
	end
end

function var0_0.OnPlayerUpdated(arg0_11)
	local var0_11 = arg0_11:GetTopPanel()

	if var0_11 then
		var0_11:Refresh()
	end
end

function var0_0.Refresh(arg0_12, arg1_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.panels) do
		iter1_12:Refresh()
	end

	arg0_12.iconView:Refresh(arg1_12)
	arg0_12.chatRoomView:Refresh()
	arg0_12.buffView:Refresh()
	arg0_12.actBtnView:Refresh()
	arg0_12.bannerView:Refresh()
	arg0_12.tagView:Refresh()
	arg0_12.changeView:Refresh(arg1_12)
	setActiveViaLayer(arg0_12._tf, true)
end

function var0_0.Disable(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.panels) do
		iter1_13:Disable()
	end

	arg0_13.iconView:Disable()
	arg0_13.chatRoomView:Disable()
	arg0_13.buffView:Disable()
	arg0_13.actBtnView:Disable()
	arg0_13.bannerView:Disable()
	arg0_13.wordView:Disable()
	arg0_13.changeView:Disable()
	setActiveViaLayer(arg0_13._tf, false)
end

function var0_0.OnDestroy(arg0_14)
	arg0_14:UnOverlayPanel(arg0_14._tf, arg0_14._parentTf)

	for iter0_14, iter1_14 in ipairs(arg0_14.panels or {}) do
		iter1_14:Dispose()
	end

	arg0_14.panels = nil

	if arg0_14.iconView then
		arg0_14.iconView:Dispose()

		arg0_14.iconView = nil
	end

	if arg0_14.chatRoomView then
		arg0_14.chatRoomView:Dispose()

		arg0_14.chatRoomView = nil
	end

	if arg0_14.bannerView then
		arg0_14.bannerView:Dispose()

		arg0_14.bannerView = nil
	end

	if arg0_14.actBtnView then
		arg0_14.actBtnView:Dispose()

		arg0_14.actBtnView = nil
	end

	if arg0_14.buffView then
		arg0_14.buffView:Dispose()

		arg0_14.buffView = nil
	end

	if arg0_14.tagView then
		arg0_14.tagView:Dispose()

		arg0_14.tagView = nil
	end

	if arg0_14.wordView then
		arg0_14.wordView:Dispose()

		arg0_14.wordView = nil
	end

	if arg0_14.changeView then
		arg0_14.changeView:Dispose()

		arg0_14.changeView = nil
	end

	if arg0_14.asmrChatView then
		arg0_14.asmrChatView:Dispose()

		arg0_14.asmrChatView = nil
	end

	local var0_14 = pg.EasyRedDotMgr.GetInstance()

	for iter2_14, iter3_14 in ipairs(arg0_14.redDotUIList or {}) do
		var0_14:UnRegisterRedDot(iter3_14)
	end

	arg0_14.redDotUIList = nil
end

function var0_0.GetPbList(arg0_15)
	return {}
end

function var0_0.GetCalibrationBG(arg0_16)
	assert(false)
end

function var0_0.GetPaintingOffset(arg0_17, arg1_17)
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

function var0_0.ApplyDefaultResUI(arg0_18)
	return true
end

function var0_0.GetWordView(arg0_19)
	assert(false)
end

function var0_0.GetTagView(arg0_20)
	assert(false)
end

function var0_0.GetTopPanel(arg0_21)
	assert(false)
end

function var0_0.GetRightPanel(arg0_22)
	assert(false)
end

function var0_0.GetLeftPanel(arg0_23)
	assert(false)
end

function var0_0.GetBottomPanel(arg0_24)
	assert(false)
end

function var0_0.GetIconView(arg0_25)
	assert(false)
end

function var0_0.GetChatRoomView(arg0_26)
	assert(false)
end

function var0_0.GetBannerView(arg0_27)
	assert(false)
end

function var0_0.GetActBtnView(arg0_28)
	assert(false)
end

function var0_0.GetBuffView(arg0_29)
	assert(false)
end

function var0_0.GetChangeSkinView(arg0_30)
	assert(false)
end

function var0_0.GetAsmrChatView(arg0_31)
	assert(false)
end

function var0_0.RegisterRedDots(arg0_32)
	return {}
end

return var0_0
