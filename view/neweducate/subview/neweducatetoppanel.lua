local var0_0 = class("NewEducateTopPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewEducateTopPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.animCom = arg0_2._tf:GetComponent(typeof(Animation))

	local var0_2 = arg0_2._tf:Find("progress")

	arg0_2.progressEndingTF = var0_2:Find("ending")

	setText(arg0_2.progressEndingTF:Find("Text"), i18n("child2_ending_stage"))

	arg0_2.progressResetTF = var0_2:Find("reset")

	setText(arg0_2.progressResetTF:Find("Text"), i18n("child2_reset_stage"))

	arg0_2.progressInfoTF = var0_2:Find("info")
	arg0_2.progressDetailTF = var0_2:Find("detail")

	setActive(arg0_2.progressDetailTF, true)
	setActive(arg0_2.progressInfoTF, false)

	arg0_2.roundTF = arg0_2.progressDetailTF:Find("round/Text")
	arg0_2.assessRoundTF = arg0_2.progressDetailTF:Find("round/assess")
	arg0_2.targetTF = arg0_2.progressDetailTF:Find("target/content/value")

	if arg0_2.contextData.showBack then
		arg0_2:ShowBack()
	else
		arg0_2:ShowDetail()
	end

	arg0_2.resTF = arg0_2._tf:Find("res")
	arg0_2.resTF:GetComponent(typeof(Image)).enabled = not arg0_2.contextData.hideBlurBg
	arg0_2.toolbarTF = arg0_2._tf:Find("toolbar")

	setActive(arg0_2.toolbarTF:Find("btns/home"), not arg0_2.contextData.hideHome)
	setActive(arg0_2.toolbarTF:Find("btns/help/line"), not arg0_2.contextData.hideHome)
	setAnchoredPosition(arg0_2.resTF, {
		y = -30,
		x = arg0_2.contextData.hideHome and -437 or -565
	})
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("progress/back"), function()
		arg0_3:emit(NewEducateBaseUI.ON_BACK)
	end, SFX_PANEL)

	arg0_3.resUIList = UIItemList.New(arg0_3.resTF, arg0_3.resTF:Find("tpl"))

	arg0_3.resUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			arg0_3:OnInitRes(arg1_5, arg2_5)
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_3:OnUpdateRes(arg1_5, arg2_5)
		end
	end)

	arg0_3.resIds = arg0_3.contextData.char:GetResPanelIds()

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
					id = arg0_3.contextData.char.id
				})
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.toolbarTF:Find("btns/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.child2_main_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.toolbarTF:Find("btns/home"), function()
		NewEducateHelper.TrackExitTime()
		arg0_3:emit(NewEducateBaseUI.ON_HOME)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_3._tf, {
		pbList = {
			arg0_3.resTF
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = LayerWeightConst.BASE_LAYER
	})
	arg0_3:Flush()
end

function var0_0.Flush(arg0_11, arg1_11)
	arg0_11:FlushProgress(arg1_11)
	arg0_11:FlushRes()
end

function var0_0.ShowDetail(arg0_12)
	arg0_12:Show()

	arg0_12.detailShowing = true
end

function var0_0.ShowBack(arg0_13)
	arg0_13:Show()

	arg0_13.detailShowing = false
end

function var0_0.FlushProgress(arg0_14, arg1_14)
	local var0_14 = (arg1_14 or arg0_14.contextData.char:GetFSM():GetStystemNo()) ~= NewEducateFSM.STYSTEM.ENDING

	setActive(arg0_14.progressDetailTF, var0_14)
	setActive(arg0_14.progressEndingTF, not var0_14)
	setActive(arg0_14.progressResetTF, not var0_14)

	if var0_14 then
		local var1_14, var2_14, var3_14 = arg0_14.contextData.char:GetRoundData():GetProgressInfo()

		setText(arg0_14.progressInfoTF:Find("Text"), i18n("child2_cur_round", var1_14))
		setText(arg0_14.roundTF, i18n("child2_cur_round", var1_14))

		local var4_14 = var2_14 > 0 and "39bfff" or "ff6767"

		setText(arg0_14.assessRoundTF, i18n("child2_assess_round", var2_14))
		setTextColor(arg0_14.assessRoundTF, Color.NewHex(var4_14))

		local var5_14 = arg0_14.contextData.char:GetAttrSum()

		setText(arg0_14.targetTF, i18n("child2_assess_target", var5_14, var3_14))

		local var6_14 = var3_14 <= var5_14 and "39bfff" or "848498"

		setTextColor(arg0_14.targetTF, Color.NewHex(var6_14))
	else
		local var7_14 = arg0_14.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.ENDING)
		local var8_14 = var7_14 and var7_14:IsFinish()

		setActive(arg0_14.progressEndingTF, not var8_14)
		setActive(arg0_14.progressResetTF, var8_14)
	end
end

function var0_0.OnInitRes(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.resIds[arg1_15 + 1]

	setActive(arg2_15:Find("line"), arg1_15 + 1 ~= #arg0_15.resIds)

	local var1_15 = pg.child2_resource[var0_15]

	LoadImageSpriteAsync("neweducateicon/" .. var1_15.icon, arg2_15:Find("icon"))
	onButton(arg0_15, arg2_15, function()
		arg0_15:emit(NewEducateBaseUI.ON_ITEM, {
			drop = {
				number = 1,
				type = NewEducateConst.DROP_TYPE.RES,
				id = var0_15
			}
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateRes(arg0_17, arg1_17, arg2_17)
	local var0_17 = pg.child2_resource[arg0_17.resIds[arg1_17 + 1]]
	local var1_17 = var0_17.type ~= NewEducateChar.RES_TYPE.MONEY and "/" .. var0_17.max_value or ""
	local var2_17 = arg0_17.contextData.char:GetRes(var0_17.id)

	if var0_17.type == NewEducateChar.RES_TYPE.MOOD then
		setText(arg2_17:Find("value"), setColorStr(var2_17, arg0_17:GetMoodColor(var2_17)) .. var1_17)
	else
		setText(arg2_17:Find("value"), var2_17 .. var1_17)
	end
end

function var0_0.FlushRes(arg0_18)
	arg0_18.resUIList:align(#arg0_18.resIds)
end

function var0_0.PlayShow(arg0_19)
	arg0_19.animCom:Play("anim_educate_topui_show")
end

function var0_0.PlayHide(arg0_20)
	arg0_20.animCom:Play("anim_educate_topui_hide")
end

function var0_0.OnDestroy(arg0_21)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21._tf)
end

function var0_0.GetMoodColor(arg0_22, arg1_22)
	if arg1_22 < 20 then
		return "#ee4a4a"
	elseif arg1_22 < 40 then
		return "#ab4734"
	elseif arg1_22 < 60 then
		return "#393A3C"
	else
		return "#00c79b"
	end
end

return var0_0
