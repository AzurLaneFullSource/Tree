local var0_0 = class("NewMainClassicTheme", import(".NewMainSceneBaseTheme"))

function var0_0.getUIName(arg0_1)
	return "NewMainClassicTheme"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.adapterView = MainAdpterView.New(arg0_2:findTF("top_bg"), arg0_2:findTF("bottom_bg"), arg0_2:findTF("bg/right"))
end

function var0_0.PlayEnterAnimation(arg0_3, arg1_3, arg2_3)
	arg0_3.adapterView:Init()
	var0_0.super.PlayEnterAnimation(arg0_3, arg1_3, arg2_3)
end

function var0_0._FoldPanels(arg0_4, arg1_4, arg2_4)
	var0_0.super._FoldPanels(arg0_4, arg1_4, arg2_4)
	arg0_4.adapterView:Fold(arg1_4, arg2_4)
end

function var0_0.OnDestroy(arg0_5)
	var0_0.super.OnDestroy(arg0_5)

	if arg0_5.adapterView then
		arg0_5.adapterView:Dispose()

		arg0_5.adapterView = nil
	end
end

function var0_0.GetCalibrationBG(arg0_6)
	return "mainui_calibration"
end

function var0_0.GetPbList(arg0_7)
	return {
		arg0_7:findTF("frame/chatPreview"),
		arg0_7:findTF("frame/eventPanel")
	}
end

function var0_0.GetPaintingOffset(arg0_8, arg1_8)
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

function var0_0.GetWordView(arg0_9)
	return MainWordView.New(arg0_9:findTF("chat"), arg0_9.event)
end

function var0_0.GetTagView(arg0_10)
	return MainTagsView.New(arg0_10:findTF("frame/bottom/tags"), arg0_10.event)
end

function var0_0.GetTopPanel(arg0_11)
	return MainTopPanel.New(arg0_11:findTF("frame/top"), arg0_11.event, arg0_11.contextData)
end

function var0_0.GetRightPanel(arg0_12)
	return MainRightPanel.New(arg0_12:findTF("frame/right"), arg0_12.event, arg0_12.contextData)
end

function var0_0.GetLeftPanel(arg0_13)
	return MainLeftPanel.New(arg0_13:findTF("frame/left"), arg0_13.event, arg0_13.contextData)
end

function var0_0.GetBottomPanel(arg0_14)
	return MainBottomPanel.New(arg0_14:findTF("frame/bottom"), arg0_14.event, arg0_14.contextData)
end

function var0_0.GetIconView(arg0_15)
	return MainIconView.New(arg0_15:findTF("frame/char"))
end

function var0_0.GetChatRoomView(arg0_16)
	return MainChatRoomView.New(arg0_16:findTF("frame/chatPreview"), arg0_16.event)
end

function var0_0.GetBannerView(arg0_17)
	return MainBannerView.New(arg0_17:findTF("frame/eventPanel"), arg0_17.event)
end

function var0_0.GetActBtnView(arg0_18)
	return MainActivityBtnView.New(arg0_18:findTF("frame/linkBtns"), arg0_18.event)
end

function var0_0.GetBuffView(arg0_19)
	return MainBuffView.New(arg0_19:findTF("frame/buffs"), arg0_19.event)
end

function var0_0.GetCalibrationView(arg0_20)
	return MainCalibrationPage.New(arg0_20._tf, arg0_20.event)
end

function var0_0.GetRedDots(arg0_21)
	return {
		RedDotNode.New(arg0_21._tf:Find("frame/bottom/taskButton/tip"), {
			pg.RedDotMgr.TYPES.TASK
		}),
		MailRedDotNode.New(arg0_21._tf:Find("frame/right/mailButton")),
		RedDotNode.New(arg0_21._tf:Find("frame/bottom/buildButton/tip"), {
			pg.RedDotMgr.TYPES.BUILD
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/bottom/guildButton/tip"), {
			pg.RedDotMgr.TYPES.GUILD
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/top/tip"), {
			pg.RedDotMgr.TYPES.ATTIRE
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/right/memoryButton/tip"), {
			pg.RedDotMgr.TYPES.MEMORY_REVIEW
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/right/collectionButton/tip"), {
			pg.RedDotMgr.TYPES.COLLECTION
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/right/friendButton/tip"), {
			pg.RedDotMgr.TYPES.FRIEND
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/left/commissionButton/tip"), {
			pg.RedDotMgr.TYPES.COMMISSION
		}),
		SettingsRedDotNode.New(arg0_21._tf:Find("frame/right/settingButton/tip"), {
			pg.RedDotMgr.TYPES.SETTTING
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/right/noticeButton/tip"), {
			pg.RedDotMgr.TYPES.SERVER
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/bottom/technologyButton/tip"), {
			pg.RedDotMgr.TYPES.BLUEPRINT
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/right/combatBtn/tip"), {
			pg.RedDotMgr.TYPES.EVENT
		}),
		RedDotNode.New(arg0_21._tf:Find("frame/bottom/liveButton/tip"), {
			pg.RedDotMgr.TYPES.COURTYARD,
			pg.RedDotMgr.TYPES.SCHOOL,
			pg.RedDotMgr.TYPES.COMMANDER
		})
	}
end

return var0_0
