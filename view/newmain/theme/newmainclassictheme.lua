local var0 = class("NewMainClassicTheme", import(".NewMainSceneBaseTheme"))

function var0.getUIName(arg0)
	return "NewMainClassicTheme"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.adapterView = MainAdpterView.New(arg0:findTF("top_bg"), arg0:findTF("bottom_bg"), arg0:findTF("bg/right"))
end

function var0.PlayEnterAnimation(arg0, arg1, arg2)
	arg0.adapterView:Init()
	var0.super.PlayEnterAnimation(arg0, arg1, arg2)
end

function var0._FoldPanels(arg0, arg1, arg2)
	var0.super._FoldPanels(arg0, arg1, arg2)
	arg0.adapterView:Fold(arg1, arg2)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.adapterView then
		arg0.adapterView:Dispose()

		arg0.adapterView = nil
	end
end

function var0.GetCalibrationBG(arg0)
	return "mainui_calibration"
end

function var0.GetPbList(arg0)
	return {
		arg0:findTF("frame/chatPreview"),
		arg0:findTF("frame/eventPanel")
	}
end

function var0.GetPaintingOffset(arg0, arg1)
	return MainPaintingShift.New({
		-600,
		-10,
		170,
		0,
		170,
		0,
		1,
		1,
		1
	})
end

function var0.GetWordView(arg0)
	return MainWordView.New(arg0:findTF("chat"), arg0.event)
end

function var0.GetTagView(arg0)
	return MainTagsView.New(arg0:findTF("frame/bottom/tags"), arg0.event)
end

function var0.GetTopPanel(arg0)
	return MainTopPanel.New(arg0:findTF("frame/top"), arg0.event, arg0.contextData)
end

function var0.GetRightPanel(arg0)
	return MainRightPanel.New(arg0:findTF("frame/right"), arg0.event, arg0.contextData)
end

function var0.GetLeftPanel(arg0)
	return MainLeftPanel.New(arg0:findTF("frame/left"), arg0.event, arg0.contextData)
end

function var0.GetBottomPanel(arg0)
	return MainBottomPanel.New(arg0:findTF("frame/bottom"), arg0.event, arg0.contextData)
end

function var0.GetIconView(arg0)
	return MainIconView.New(arg0:findTF("frame/char"))
end

function var0.GetChatRoomView(arg0)
	return MainChatRoomView.New(arg0:findTF("frame/chatPreview"), arg0.event)
end

function var0.GetBannerView(arg0)
	return MainBannerView.New(arg0:findTF("frame/eventPanel"), arg0.event)
end

function var0.GetActBtnView(arg0)
	return MainActivityBtnView.New(arg0:findTF("frame/linkBtns"), arg0.event)
end

function var0.GetBuffView(arg0)
	return MainBuffView.New(arg0:findTF("frame/buffs"), arg0.event)
end

function var0.GetCalibrationView(arg0)
	return MainCalibrationPage.New(arg0._tf, arg0.event)
end

function var0.GetRedDots(arg0)
	return {
		RedDotNode.New(arg0._tf:Find("frame/bottom/taskButton/tip"), {
			pg.RedDotMgr.TYPES.TASK
		}),
		MailRedDotNode.New(arg0._tf:Find("frame/right/mailButton")),
		RedDotNode.New(arg0._tf:Find("frame/bottom/buildButton/tip"), {
			pg.RedDotMgr.TYPES.BUILD
		}),
		RedDotNode.New(arg0._tf:Find("frame/bottom/guildButton/tip"), {
			pg.RedDotMgr.TYPES.GUILD
		}),
		RedDotNode.New(arg0._tf:Find("frame/top/tip"), {
			pg.RedDotMgr.TYPES.ATTIRE
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/memoryButton/tip"), {
			pg.RedDotMgr.TYPES.MEMORY_REVIEW
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/collectionButton/tip"), {
			pg.RedDotMgr.TYPES.COLLECTION
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/friendButton/tip"), {
			pg.RedDotMgr.TYPES.FRIEND
		}),
		RedDotNode.New(arg0._tf:Find("frame/left/commissionButton/tip"), {
			pg.RedDotMgr.TYPES.COMMISSION
		}),
		SettingsRedDotNode.New(arg0._tf:Find("frame/right/settingButton/tip"), {
			pg.RedDotMgr.TYPES.SETTTING
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/noticeButton/tip"), {
			pg.RedDotMgr.TYPES.SERVER
		}),
		RedDotNode.New(arg0._tf:Find("frame/bottom/technologyButton/tip"), {
			pg.RedDotMgr.TYPES.BLUEPRINT
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/combatBtn/tip"), {
			pg.RedDotMgr.TYPES.EVENT
		}),
		RedDotNode.New(arg0._tf:Find("frame/bottom/liveButton/tip"), {
			pg.RedDotMgr.TYPES.COURTYARD,
			pg.RedDotMgr.TYPES.SCHOOL,
			pg.RedDotMgr.TYPES.COMMANDER
		})
	}
end

return var0
