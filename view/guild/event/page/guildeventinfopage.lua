local var0_0 = class("GuildEventInfoPage", import(".GuildEventBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildEventInfoPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.icon = arg0_2:findTF("frame/icon"):GetComponent(typeof(Image))
	arg0_2.goBtn = arg0_2:findTF("frame/go_btn")
	arg0_2.joinBtn = arg0_2:findTF("frame/join_btn")
	arg0_2.descTxt = arg0_2:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0_2.consumeTF = arg0_2:findTF("frame/consume")
	arg0_2.consumeTxt = arg0_2:findTF("frame/consume/Text"):GetComponent(typeof(Text))
	arg0_2.cntTF = arg0_2:findTF("frame/cnt")
	arg0_2.cntTxt = arg0_2:findTF("frame/cnt/Text"):GetComponent(typeof(Text))
	arg0_2.nameTxt = arg0_2:findTF("frame/title/Text"):GetComponent(typeof(Text))
	arg0_2.scaleTxt = arg0_2:findTF("frame/title/scale"):GetComponent(typeof(Text))
	arg0_2.scaleCntTxt = arg0_2:findTF("frame/title/scale/Text"):GetComponent(typeof(Text))
	arg0_2.progressTF = arg0_2:findTF("frame/cnt/progress")
	arg0_2.progressTxt = arg0_2:findTF("frame/cnt/progress/Text"):GetComponent(typeof(Text))
	arg0_2.missionList = UIItemList.New(arg0_2:findTF("frame/events/icons"), arg0_2:findTF("frame/events/icons/tpl"))
	arg0_2.awardList = UIItemList.New(arg0_2:findTF("frame/award/displays"), arg0_2:findTF("frame/award/displays/item"))

	setText(arg0_2:findTF("frame/events/Text"), i18n("guild_word_may_happen_event"))
	setText(arg0_2:findTF("frame/award/Text"), i18n("guild_battle_award"))
	setText(arg0_2:findTF("frame/consume/label"), i18n("guild_word_consume"))
	setText(arg0_2:findTF("frame/cnt/label"), i18n("guild_join_event_cnt_label"))
	setText(arg0_2:findTF("frame/cnt/progress/label"), i18n("guild_join_event_progress_label"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.goBtn, function()
		if not GuildMember.IsAdministrator(arg0_3.guild:getSelfDuty()) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

			return
		end

		local var0_6 = arg0_3.gevent:GetName()
		local var1_6 = arg0_3.gevent:GetConsume()
		local var2_6 = arg0_3.guild:ShouldTipActiveEvent() and i18n("guild_start_event_consume_tip", var1_6, var0_6) or i18n("guild_start_event_consume_tip_extra", var1_6, var0_6, arg0_3.guild:GetActiveEventCnt())

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = var2_6,
			onYes = function()
				arg0_3:emit(GuildEventMediator.ON_ACTIVE_EVENT, arg0_3.gevent.id)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.joinBtn, function()
		if not arg0_3.activeEvent then
			return
		end

		if arg0_3.activeEvent:IsLimitedJoin() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_join_event_max_cnt_tip"))

			return
		end

		arg0_3:JoinEvent()
	end, SFX_PANEL)
end

function var0_0.JoinEvent(arg0_9)
	local function var0_9()
		local var0_10, var1_10 = arg0_9.activeEvent:GetMainMissionCntAndFinishCnt()

		if var1_10 ~= 0 then
			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = i18n("guild_join_event_exist_finished_mission_tip"),
				onYes = function()
					arg0_9:emit(GuildEventMediator.ON_JOIN_EVENT)
				end
			})
		else
			arg0_9:emit(GuildEventMediator.ON_JOIN_EVENT)
		end
	end

	if arg0_9.activeEvent:GetLeftTime() <= 604800 then
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_tip_operation_time_is_not_ample"),
			onYes = var0_9
		})
	else
		var0_9()
	end
end

function var0_0.Refresh(arg0_12, arg1_12, arg2_12)
	arg0_12:UpdateData(arg1_12, arg2_12, arg0_12.extraData)
	arg0_12:UpdateBtnState()
end

function var0_0.OnShow(arg0_13)
	arg0_13.gevent = arg0_13.extraData.gevent

	local var0_13 = arg0_13.gevent

	arg0_13.icon.sprite = GetSpriteFromAtlas("guildevent/i_" .. var0_13.id, "")

	setActive(arg0_13.icon.gameObject, true)

	arg0_13.descTxt.text = var0_13:GetDesc()

	local var1_13 = arg0_13.guild:getCapital()
	local var2_13 = var0_13:GetConsume()
	local var3_13 = var1_13 < var2_13 and COLOR_RED or COLOR_GREEN

	arg0_13.consumeTxt.text = "<color=" .. var3_13 .. ">" .. var1_13 .. "</color>/" .. var2_13
	arg0_13.nameTxt.text = var0_13:GetName()
	arg0_13.scaleTxt.text = var0_13:GetScaleDesc()
	arg0_13.scaleCntTxt.text = ""

	arg0_13:UpdateMissions(var0_13)
	arg0_13:UpdateAwards(var0_13)
	arg0_13:UpdateBtnState()
end

function var0_0.UpdateBtnState(arg0_14)
	arg0_14.activeEvent = arg0_14.guild:GetActiveEvent()

	setActive(arg0_14.goBtn, not arg0_14.activeEvent)
	setActive(arg0_14.consumeTF, not arg0_14.activeEvent)
	setActive(arg0_14.joinBtn, arg0_14.activeEvent)
	setActive(arg0_14.cntTF, arg0_14.activeEvent)
	setActive(arg0_14.progressTF, arg0_14.activeEvent)

	if arg0_14.activeEvent then
		local var0_14 = arg0_14.activeEvent:GetJoinCnt()
		local var1_14 = arg0_14.activeEvent:GetMaxJoinCnt()
		local var2_14 = var1_14 - var0_14 + arg0_14.activeEvent:GetExtraJoinCnt()
		local var3_14 = var2_14 <= 0 and COLOR_RED or COLOR_WHITE
		local var4_14 = string.format("<color=%s>%d</color>/%d", var3_14, var2_14, var1_14)

		arg0_14.cntTxt.text = var4_14

		local var5_14, var6_14 = arg0_14.activeEvent:GetMainMissionCntAndFinishCnt()

		arg0_14.progressTxt.text = var6_14 .. "/" .. var5_14 + 1
	end
end

function var0_0.UpdateAwards(arg0_15, arg1_15)
	local var0_15 = arg1_15:GetDisplayAward()

	arg0_15.awardList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16 + 1]
			local var1_16 = {
				id = var0_16[2],
				type = var0_16[1],
				count = var0_16[3]
			}

			updateDrop(arg2_16, var1_16)
			onButton(arg0_15, arg2_16, function()
				arg0_15:emit(BaseUI.ON_DROP, var1_16)
			end, SFX_PANEL)
		end
	end)
	arg0_15.awardList:align(#var0_15)
end

function var0_0.UpdateMissions(arg0_18, arg1_18)
	local var0_18 = arg1_18:GetDisplayMission()

	arg0_18.missionList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var0_18[arg1_19 + 1]

			arg2_19:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("GuildEventIcon", var0_19)
		end
	end)
	arg0_18.missionList:align(#var0_18)
end

return var0_0
