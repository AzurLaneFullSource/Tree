﻿local var0_0 = class("NewMainMellowTheme", import(".NewMainSceneBaseTheme"))

function var0_0.getUIName(arg0_1)
	return "NewMainMellowTheme"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.switcherAnimationPlayer = arg0_2._tf:Find("frame/right"):GetComponent(typeof(Animation))
	arg0_2.fxEffect = arg0_2:findTF("frame/right/1/battle/root/FX")
	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.switcher = arg0_2:findTF("frame/right/switch")

	onToggle(arg0_2, arg0_2.switcher, function(arg0_3)
		local var0_3 = arg0_3 and "anim_newmain_switch_1to2" or "anim_newmain_switch_2to1"

		arg0_2.switcherAnimationPlayer:Play(var0_3)

		local var1_3 = arg0_2:GetRedDots()
		local var2_3 = _.select(var1_3, function(arg0_4)
			return isa(arg0_4, SwitcherRedDotNode)
		end)

		_.each(var2_3, function(arg0_5)
			arg0_5:RefreshSelf()
		end)
	end, SFX_PANEL)
	arg0_2:Register()
end

function var0_0.Register(arg0_6)
	return
end

function var0_0.PlayEnterAnimation(arg0_7, arg1_7, arg2_7)
	arg0_7.bannerView:Init()
	arg0_7.actBtnView:Init()
	arg0_7.dftAniEvent:SetStartEvent(nil)
	arg0_7.dftAniEvent:SetStartEvent(function()
		arg0_7.dftAniEvent:SetStartEvent(nil)

		arg0_7.mainCG.alpha = 1
	end)
	arg0_7.animationPlayer:Play("anim_newmain_open")
	onDelayTick(arg2_7, 0.51)
end

function var0_0.Refresh(arg0_9, arg1_9)
	var0_0.super.Refresh(arg0_9, arg1_9)
	UIUtil.SetLayerRecursively(arg0_9.fxEffect.gameObject, LayerMask.NameToLayer("UI"))
	arg0_9.animationPlayer:Play("anim_newmain_open")
end

function var0_0.OnFoldPanels(arg0_10, arg1_10)
	if arg1_10 then
		arg0_10.animationPlayer:Play("anim_newmain_hide")
	else
		arg0_10.animationPlayer:Play("anim_newmain_show")
	end
end

function var0_0.Disable(arg0_11)
	var0_0.super.Disable(arg0_11)
	arg0_11.dftAniEvent:SetStartEvent(nil)
	triggerToggle(arg0_11.switcher, false)
	UIUtil.SetLayerRecursively(arg0_11.fxEffect.gameObject, LayerMask.NameToLayer("UIHidden"))
end

function var0_0.OnDestroy(arg0_12)
	var0_0.super.OnDestroy(arg0_12)
	arg0_12.dftAniEvent:SetStartEvent(nil)
end

function var0_0.ApplyDefaultResUI(arg0_13)
	return false
end

function var0_0.GetCalibrationBG(arg0_14)
	return "mainui_calibration_mellow"
end

function var0_0.GetPbList(arg0_15)
	return {
		arg0_15:findTF("frame/bottom/frame")
	}
end

function var0_0.GetPaintingOffset(arg0_16, arg1_16)
	local var0_16 = pg.ship_skin_newmainui_shift[arg1_16.skinId]

	if var0_16 then
		local var1_16 = arg0_16:GetConfigShift(var0_16)

		return MainPaintingShift.New(var1_16, Vector3(-MainPaintingView.MESH_POSITION_X_OFFSET, -10, 0))
	else
		return MainPaintingShift.New({
			-MainPaintingView.MESH_POSITION_X_OFFSET,
			-10,
			MainPaintingView.MESH_POSITION_X_OFFSET,
			0,
			MainPaintingView.MESH_POSITION_X_OFFSET,
			0,
			1,
			1,
			1
		})
	end
end

function var0_0.GetConfigShift(arg0_17, arg1_17)
	local var0_17 = arg1_17.skin_shift
	local var1_17 = arg1_17.l2d_shift
	local var2_17 = var1_17[1] - var0_17[1]
	local var3_17 = var1_17[2] - var0_17[2]
	local var4_17 = arg1_17.spine_shift
	local var5_17 = var4_17[1] - var0_17[1]
	local var6_17 = var4_17[2] - var0_17[2]

	return {
		var0_17[1],
		var0_17[2],
		var2_17,
		var3_17,
		var5_17,
		var6_17,
		var0_17[4],
		var1_17[4],
		var4_17[4]
	}
end

function var0_0.GetWordView(arg0_18)
	return MainWordView4Mellow.New(arg0_18:findTF("chat"), arg0_18.event)
end

function var0_0.GetTagView(arg0_19)
	return MainTagsView.New(arg0_19:findTF("frame/bottom/tags"), arg0_19.event)
end

function var0_0.GetTopPanel(arg0_20)
	return MainTopPanel4Mellow.New(arg0_20:findTF("frame/top"), arg0_20.event, arg0_20.contextData)
end

function var0_0.GetRightPanel(arg0_21)
	return MainRightPanel4Mellow.New(arg0_21:findTF("frame/right"), arg0_21.event, arg0_21.contextData)
end

function var0_0.GetLeftPanel(arg0_22)
	return MainLeftPanel4Mellow.New(arg0_22:findTF("frame/left"), arg0_22.event, arg0_22.contextData)
end

function var0_0.GetBottomPanel(arg0_23)
	return MainBottomPanel4Mellow.New(arg0_23:findTF("frame/bottom"), arg0_23.event, arg0_23.contextData)
end

function var0_0.GetIconView(arg0_24)
	return MainIconView4Mellow.New(arg0_24:findTF("frame/top/icon"), arg0_24.event)
end

function var0_0.GetChatRoomView(arg0_25)
	return MainChatRoomView4Mellow.New(arg0_25:findTF("frame/right/chat_room"), arg0_25.event)
end

function var0_0.GetBannerView(arg0_26)
	return MainBannerView4Mellow.New(arg0_26:findTF("frame/left/banner"), arg0_26.event)
end

function var0_0.GetActBtnView(arg0_27)
	return MainActivityBtnView4Mellow.New(arg0_27:findTF("frame"), arg0_27.event)
end

function var0_0.GetBuffView(arg0_28)
	return MainBuffView4Mellow.New(arg0_28:findTF("frame/top/buff_list"), arg0_28.event)
end

function var0_0.GetRedDots(arg0_29)
	return {
		RedDotNode.New(arg0_29._tf:Find("frame/bottom/frame/task/tip"), {
			pg.RedDotMgr.TYPES.TASK
		}),
		MailRedDotNode4Mellow.New(arg0_29._tf:Find("frame/top/btns/mail")),
		RedDotNode.New(arg0_29._tf:Find("frame/bottom/frame/build/tip"), {
			pg.RedDotMgr.TYPES.BUILD
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/bottom/frame/guild/tip"), {
			pg.RedDotMgr.TYPES.GUILD
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/top/icon_front/tip"), {
			pg.RedDotMgr.TYPES.ATTIRE
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/right/2/menor/root/tip"), {
			pg.RedDotMgr.TYPES.MEMORY_REVIEW
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/right/2/collection/root/tip"), {
			pg.RedDotMgr.TYPES.COLLECTION
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/right/2/friend/root/tip"), {
			pg.RedDotMgr.TYPES.FRIEND
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/left/extend/tip"), {
			pg.RedDotMgr.TYPES.COMMISSION
		}),
		SettingsRedDotNode.New(arg0_29._tf:Find("frame/top/btns/settings/tip"), {
			pg.RedDotMgr.TYPES.SETTTING
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/top/btns/noti/tip"), {
			pg.RedDotMgr.TYPES.SERVER
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/bottom/frame/tech/tip"), {
			pg.RedDotMgr.TYPES.BLUEPRINT
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/right/1/battle/root/tip"), {
			pg.RedDotMgr.TYPES.EVENT
		}),
		RedDotNode.New(arg0_29._tf:Find("frame/bottom/frame/live/tip"), {
			pg.RedDotMgr.TYPES.COURTYARD,
			pg.RedDotMgr.TYPES.SCHOOL,
			pg.RedDotMgr.TYPES.COMMANDER
		}),
		SwitcherRedDotNode.New(arg0_29._tf:Find("frame/right/switch"), {
			pg.RedDotMgr.TYPES.COLLECTION,
			pg.RedDotMgr.TYPES.FRIEND,
			pg.RedDotMgr.TYPES.MEMORY_REVIEW
		}, true),
		SwitcherRedDotNode.New(arg0_29._tf:Find("frame/right/switch"), {
			pg.RedDotMgr.TYPES.EVENT
		}, false)
	}
end

return var0_0