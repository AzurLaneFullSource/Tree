local var0 = class("GuildEventInfoPage", import(".GuildEventBasePage"))

function var0.getUIName(arg0)
	return "GuildEventInfoPage"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.icon = arg0:findTF("frame/icon"):GetComponent(typeof(Image))
	arg0.goBtn = arg0:findTF("frame/go_btn")
	arg0.joinBtn = arg0:findTF("frame/join_btn")
	arg0.descTxt = arg0:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0.consumeTF = arg0:findTF("frame/consume")
	arg0.consumeTxt = arg0:findTF("frame/consume/Text"):GetComponent(typeof(Text))
	arg0.cntTF = arg0:findTF("frame/cnt")
	arg0.cntTxt = arg0:findTF("frame/cnt/Text"):GetComponent(typeof(Text))
	arg0.nameTxt = arg0:findTF("frame/title/Text"):GetComponent(typeof(Text))
	arg0.scaleTxt = arg0:findTF("frame/title/scale"):GetComponent(typeof(Text))
	arg0.scaleCntTxt = arg0:findTF("frame/title/scale/Text"):GetComponent(typeof(Text))
	arg0.progressTF = arg0:findTF("frame/cnt/progress")
	arg0.progressTxt = arg0:findTF("frame/cnt/progress/Text"):GetComponent(typeof(Text))
	arg0.missionList = UIItemList.New(arg0:findTF("frame/events/icons"), arg0:findTF("frame/events/icons/tpl"))
	arg0.awardList = UIItemList.New(arg0:findTF("frame/award/displays"), arg0:findTF("frame/award/displays/item"))

	setText(arg0:findTF("frame/events/Text"), i18n("guild_word_may_happen_event"))
	setText(arg0:findTF("frame/award/Text"), i18n("guild_battle_award"))
	setText(arg0:findTF("frame/consume/label"), i18n("guild_word_consume"))
	setText(arg0:findTF("frame/cnt/label"), i18n("guild_join_event_cnt_label"))
	setText(arg0:findTF("frame/cnt/progress/label"), i18n("guild_join_event_progress_label"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		if not GuildMember.IsAdministrator(arg0.guild:getSelfDuty()) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

			return
		end

		local var0 = arg0.gevent:GetName()
		local var1 = arg0.gevent:GetConsume()
		local var2 = arg0.guild:ShouldTipActiveEvent() and i18n("guild_start_event_consume_tip", var1, var0) or i18n("guild_start_event_consume_tip_extra", var1, var0, arg0.guild:GetActiveEventCnt())

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = var2,
			onYes = function()
				arg0:emit(GuildEventMediator.ON_ACTIVE_EVENT, arg0.gevent.id)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.joinBtn, function()
		if not arg0.activeEvent then
			return
		end

		if arg0.activeEvent:IsLimitedJoin() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_join_event_max_cnt_tip"))

			return
		end

		arg0:JoinEvent()
	end, SFX_PANEL)
end

function var0.JoinEvent(arg0)
	local function var0()
		local var0, var1 = arg0.activeEvent:GetMainMissionCntAndFinishCnt()

		if var1 ~= 0 then
			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = i18n("guild_join_event_exist_finished_mission_tip"),
				onYes = function()
					arg0:emit(GuildEventMediator.ON_JOIN_EVENT)
				end
			})
		else
			arg0:emit(GuildEventMediator.ON_JOIN_EVENT)
		end
	end

	if arg0.activeEvent:GetLeftTime() <= 604800 then
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_tip_operation_time_is_not_ample"),
			onYes = var0
		})
	else
		var0()
	end
end

function var0.Refresh(arg0, arg1, arg2)
	arg0:UpdateData(arg1, arg2, arg0.extraData)
	arg0:UpdateBtnState()
end

function var0.OnShow(arg0)
	arg0.gevent = arg0.extraData.gevent

	local var0 = arg0.gevent

	arg0.icon.sprite = GetSpriteFromAtlas("guildevent/i_" .. var0.id, "")

	setActive(arg0.icon.gameObject, true)

	arg0.descTxt.text = var0:GetDesc()

	local var1 = arg0.guild:getCapital()
	local var2 = var0:GetConsume()
	local var3 = var1 < var2 and COLOR_RED or COLOR_GREEN

	arg0.consumeTxt.text = "<color=" .. var3 .. ">" .. var1 .. "</color>/" .. var2
	arg0.nameTxt.text = var0:GetName()
	arg0.scaleTxt.text = var0:GetScaleDesc()
	arg0.scaleCntTxt.text = ""

	arg0:UpdateMissions(var0)
	arg0:UpdateAwards(var0)
	arg0:UpdateBtnState()
end

function var0.UpdateBtnState(arg0)
	arg0.activeEvent = arg0.guild:GetActiveEvent()

	setActive(arg0.goBtn, not arg0.activeEvent)
	setActive(arg0.consumeTF, not arg0.activeEvent)
	setActive(arg0.joinBtn, arg0.activeEvent)
	setActive(arg0.cntTF, arg0.activeEvent)
	setActive(arg0.progressTF, arg0.activeEvent)

	if arg0.activeEvent then
		local var0 = arg0.activeEvent:GetJoinCnt()
		local var1 = arg0.activeEvent:GetMaxJoinCnt()
		local var2 = var1 - var0 + arg0.activeEvent:GetExtraJoinCnt()
		local var3 = var2 <= 0 and COLOR_RED or COLOR_WHITE
		local var4 = string.format("<color=%s>%d</color>/%d", var3, var2, var1)

		arg0.cntTxt.text = var4

		local var5, var6 = arg0.activeEvent:GetMainMissionCntAndFinishCnt()

		arg0.progressTxt.text = var6 .. "/" .. var5 + 1
	end
end

function var0.UpdateAwards(arg0, arg1)
	local var0 = arg1:GetDisplayAward()

	arg0.awardList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = {
				id = var0[2],
				type = var0[1],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.awardList:align(#var0)
end

function var0.UpdateMissions(arg0, arg1)
	local var0 = arg1:GetDisplayMission()

	arg0.missionList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			arg2:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("GuildEventIcon", var0)
		end
	end)
	arg0.missionList:align(#var0)
end

return var0
