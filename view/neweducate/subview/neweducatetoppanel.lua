local var0_0 = class("NewEducateTopPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewEducateTopPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.animCom = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.progressPart = NewEducateTopProgress.New(arg0_2._tf:Find("progress"), arg0_2)
	arg0_2.resPart = NewEducateTopRes.New(arg0_2._tf:Find("res"), arg0_2)

	arg0_2.resPart:SetBgEnable(not arg0_2.contextData.hideBlurBg)

	arg0_2.toolbarTF = arg0_2._tf:Find("toolbar")

	setActive(arg0_2.toolbarTF:Find("btns/home"), not arg0_2.contextData.hideHome)
	setActive(arg0_2.toolbarTF:Find("btns/help/line"), not arg0_2.contextData.hideHome)

	local var0_2 = pg.gameset.child2_rank_switch.key_value == 1 and arg0_2.contextData.char:GetPermanentData():IsTarotType()

	setActive(arg0_2.toolbarTF:Find("btns/rank"), var0_2)
	setAnchoredPosition(arg0_2.resPart._tf, {
		x = var0_2 and -697 or -565
	})
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.toolbarTF:Find("btns/rank"), function()
		arg0_3:emit(NewEducateBaseUI.GO_SUBLAYER, Context.New({
			mediator = NewEducateRankMediator,
			viewComponent = NewEducateRankLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.toolbarTF:Find("btns/collect"), function()
		arg0_3:emit(NewEducateBaseUI.GO_SUBLAYER, Context.New({
			mediator = NewEducateCollectEntranceMediator,
			viewComponent = NewEducateCollectEntranceLayer,
			data = {
				id = arg0_3.contextData.char.id
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.toolbarTF:Find("btns/refresh"), function()
		arg0_3:emit(NewEducateBaseUI.ON_BOX, {
			content = i18n("child_refresh_sure_tip"),
			onYes = function()
				pg.m02:sendNotification(GAME.NEW_EDUCATE_REFRESH, {
					id = arg0_3.contextData.char.id,
					difficulty = arg0_3.contextData.char.difficulty
				})
			end
		})
	end, SFX_PANEL)

	var0_0.helps = {
		"child2_main_help",
		"child2_explorer_main_help"
	}

	onButton(arg0_3, arg0_3.toolbarTF:Find("btns/help"), function()
		local var0_8 = var0_0.helps[arg0_3.contextData.char.id]

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n(var0_8)
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.toolbarTF:Find("btns/home"), function()
		NewEducateHelper.TrackExitTime()
		arg0_3:emit(NewEducateBaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_3:OverlayPanel(arg0_3._tf, {
		pbList = {
			arg0_3.resPart._tf
		}
	})
	arg0_3:Flush()
end

function var0_0.Flush(arg0_10)
	arg0_10.progressPart:Update(arg0_10.contextData.char)
	arg0_10.resPart:Update(arg0_10.contextData.char)
end

function var0_0.FlushRes(arg0_11)
	arg0_11.resPart:Update(arg0_11.contextData.char)
end

function var0_0.FlushProgress(arg0_12, arg1_12)
	arg0_12.progressPart:Update(arg0_12.contextData.char, arg1_12)
end

function var0_0.PlayShow(arg0_13)
	arg0_13.animCom:Play("anim_educate_topui_show")
end

function var0_0.PlayHide(arg0_14)
	arg0_14.animCom:Play("anim_educate_topui_hide")
end

function var0_0.OnDestroy(arg0_15)
	arg0_15.progressPart:Dispose()
	arg0_15.resPart:Dispose()
	arg0_15:UnOverlayPanel(arg0_15._tf)
end

return var0_0
