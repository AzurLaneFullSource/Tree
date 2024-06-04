local var0 = class("NewMainMellowTheme", import(".NewMainSceneBaseTheme"))

function var0.getUIName(arg0)
	return "NewMainMellowTheme"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.switcherAnimationPlayer = arg0._tf:Find("frame/right"):GetComponent(typeof(Animation))
	arg0.fxEffect = arg0:findTF("frame/right/1/battle/root/FX")
	arg0.animationPlayer = arg0._tf:GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg0._tf:GetComponent(typeof(DftAniEvent))
	arg0.switcher = arg0:findTF("frame/right/switch")

	onToggle(arg0, arg0.switcher, function(arg0)
		local var0 = arg0 and "anim_newmain_switch_1to2" or "anim_newmain_switch_2to1"

		arg0.switcherAnimationPlayer:Play(var0)

		local var1 = arg0:GetRedDots()
		local var2 = _.select(var1, function(arg0)
			return isa(arg0, SwitcherRedDotNode)
		end)

		_.each(var2, function(arg0)
			arg0:RefreshSelf()
		end)
	end, SFX_PANEL)
	arg0:Register()
end

function var0.Register(arg0)
	return
end

function var0.PlayEnterAnimation(arg0, arg1, arg2)
	arg0.bannerView:Init()
	arg0.actBtnView:Init()
	arg0.dftAniEvent:SetStartEvent(nil)
	arg0.dftAniEvent:SetStartEvent(function()
		arg0.dftAniEvent:SetStartEvent(nil)

		arg0.mainCG.alpha = 1
	end)
	arg0.animationPlayer:Play("anim_newmain_open")
	onDelayTick(arg2, 0.51)
end

function var0.Refresh(arg0, arg1)
	var0.super.Refresh(arg0, arg1)
	UIUtil.SetLayerRecursively(arg0.fxEffect.gameObject, LayerMask.NameToLayer("UI"))
	arg0.animationPlayer:Play("anim_newmain_open")
end

function var0.OnFoldPanels(arg0, arg1)
	if arg1 then
		arg0.animationPlayer:Play("anim_newmain_hide")
	else
		arg0.animationPlayer:Play("anim_newmain_show")
	end
end

function var0.Disable(arg0)
	var0.super.Disable(arg0)
	arg0.dftAniEvent:SetStartEvent(nil)
	triggerToggle(arg0.switcher, false)
	UIUtil.SetLayerRecursively(arg0.fxEffect.gameObject, LayerMask.NameToLayer("UIHidden"))
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)
	arg0.dftAniEvent:SetStartEvent(nil)
end

function var0.ApplyDefaultResUI(arg0)
	return false
end

function var0.GetCalibrationBG(arg0)
	return "mainui_calibration_mellow"
end

function var0.GetPbList(arg0)
	return {
		arg0:findTF("frame/bottom/frame")
	}
end

function var0.GetPaintingOffset(arg0, arg1)
	local var0 = pg.ship_skin_newmainui_shift[arg1.skinId]

	if var0 then
		local var1 = arg0:GetConfigShift(var0)

		return MainPaintingShift.New(var1, Vector3(-MainPaintingView.MESH_POSITION_X_OFFSET, -10, 0))
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

function var0.GetConfigShift(arg0, arg1)
	local var0 = arg1.skin_shift
	local var1 = arg1.l2d_shift
	local var2 = var1[1] - var0[1]
	local var3 = var1[2] - var0[2]
	local var4 = arg1.spine_shift
	local var5 = var4[1] - var0[1]
	local var6 = var4[2] - var0[2]

	return {
		var0[1],
		var0[2],
		var2,
		var3,
		var5,
		var6,
		var0[4],
		var1[4],
		var4[4]
	}
end

function var0.GetWordView(arg0)
	return MainWordView4Mellow.New(arg0:findTF("chat"), arg0.event)
end

function var0.GetTagView(arg0)
	return MainTagsView.New(arg0:findTF("frame/bottom/tags"), arg0.event)
end

function var0.GetTopPanel(arg0)
	return MainTopPanel4Mellow.New(arg0:findTF("frame/top"), arg0.event, arg0.contextData)
end

function var0.GetRightPanel(arg0)
	return MainRightPanel4Mellow.New(arg0:findTF("frame/right"), arg0.event, arg0.contextData)
end

function var0.GetLeftPanel(arg0)
	return MainLeftPanel4Mellow.New(arg0:findTF("frame/left"), arg0.event, arg0.contextData)
end

function var0.GetBottomPanel(arg0)
	return MainBottomPanel4Mellow.New(arg0:findTF("frame/bottom"), arg0.event, arg0.contextData)
end

function var0.GetIconView(arg0)
	return MainIconView4Mellow.New(arg0:findTF("frame/top/icon"), arg0.event)
end

function var0.GetChatRoomView(arg0)
	return MainChatRoomView4Mellow.New(arg0:findTF("frame/right/chat_room"), arg0.event)
end

function var0.GetBannerView(arg0)
	return MainBannerView4Mellow.New(arg0:findTF("frame/left/banner"), arg0.event)
end

function var0.GetActBtnView(arg0)
	return MainActivityBtnView4Mellow.New(arg0:findTF("frame"), arg0.event)
end

function var0.GetBuffView(arg0)
	return MainBuffView4Mellow.New(arg0:findTF("frame/top/buff_list"), arg0.event)
end

function var0.GetRedDots(arg0)
	return {
		RedDotNode.New(arg0._tf:Find("frame/bottom/frame/task/tip"), {
			pg.RedDotMgr.TYPES.TASK
		}),
		MailRedDotNode4Mellow.New(arg0._tf:Find("frame/top/btns/mail")),
		RedDotNode.New(arg0._tf:Find("frame/bottom/frame/build/tip"), {
			pg.RedDotMgr.TYPES.BUILD
		}),
		RedDotNode.New(arg0._tf:Find("frame/bottom/frame/guild/tip"), {
			pg.RedDotMgr.TYPES.GUILD
		}),
		RedDotNode.New(arg0._tf:Find("frame/top/icon_front/tip"), {
			pg.RedDotMgr.TYPES.ATTIRE
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/2/menor/root/tip"), {
			pg.RedDotMgr.TYPES.MEMORY_REVIEW
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/2/collection/root/tip"), {
			pg.RedDotMgr.TYPES.COLLECTION
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/2/friend/root/tip"), {
			pg.RedDotMgr.TYPES.FRIEND
		}),
		RedDotNode.New(arg0._tf:Find("frame/left/extend/tip"), {
			pg.RedDotMgr.TYPES.COMMISSION
		}),
		SettingsRedDotNode.New(arg0._tf:Find("frame/top/btns/settings/tip"), {
			pg.RedDotMgr.TYPES.SETTTING
		}),
		RedDotNode.New(arg0._tf:Find("frame/top/btns/noti/tip"), {
			pg.RedDotMgr.TYPES.SERVER
		}),
		RedDotNode.New(arg0._tf:Find("frame/bottom/frame/tech/tip"), {
			pg.RedDotMgr.TYPES.BLUEPRINT
		}),
		RedDotNode.New(arg0._tf:Find("frame/right/1/battle/root/tip"), {
			pg.RedDotMgr.TYPES.EVENT
		}),
		RedDotNode.New(arg0._tf:Find("frame/bottom/frame/live/tip"), {
			pg.RedDotMgr.TYPES.COURTYARD,
			pg.RedDotMgr.TYPES.SCHOOL,
			pg.RedDotMgr.TYPES.COMMANDER
		}),
		SwitcherRedDotNode.New(arg0._tf:Find("frame/right/switch"), {
			pg.RedDotMgr.TYPES.COLLECTION,
			pg.RedDotMgr.TYPES.FRIEND,
			pg.RedDotMgr.TYPES.MEMORY_REVIEW
		}, true),
		SwitcherRedDotNode.New(arg0._tf:Find("frame/right/switch"), {
			pg.RedDotMgr.TYPES.EVENT
		}, false)
	}
end

return var0
