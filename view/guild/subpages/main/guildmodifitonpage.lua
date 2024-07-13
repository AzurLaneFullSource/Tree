local var0_0 = class("GuildModiftionPage", import("...base.GuildBasePage"))

function var0_0.getTargetUI(arg0_1)
	return "GuildModiftionBluePage", "GuildModiftionRedPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameInput = findTF(arg0_2._tf, "frame/name_bg/input"):GetComponent(typeof(InputField))
	arg0_2.factionBLHXToggle = findTF(arg0_2._tf, "frame/policy_container/faction/blhx")
	arg0_2.factionCSZZToggle = findTF(arg0_2._tf, "frame/policy_container/faction/cszz")
	arg0_2.policyRELAXToggle = findTF(arg0_2._tf, "frame/policy_container/policy/relax")
	arg0_2.policyPOWERToggle = findTF(arg0_2._tf, "frame/policy_container/policy/power")
	arg0_2.manifestoInput = findTF(arg0_2._tf, "frame/policy_container/input_frame/input"):GetComponent(typeof(InputField))
	arg0_2.confirmBtn = findTF(arg0_2._tf, "frame/confirm_btn")
	arg0_2.cancelBtn = findTF(arg0_2._tf, "frame/cancel_btn")
	arg0_2.quitBtn = findTF(arg0_2._tf, "frame/quit_btn")
	arg0_2.dissolveBtn = findTF(arg0_2._tf, "frame/dissolve_btn")
	arg0_2.factionMask = findTF(arg0_2._tf, "frame/policy_container/faction/mask")
	arg0_2.costTF = findTF(arg0_2._tf, "frame/confirm_btn/print_container/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	arg0_3.costTF.text = 0
	arg0_3.modifyBackBG = arg0_3:findTF("bg_decorations", arg0_3._tf)

	setActive(arg0_3._tf, false)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.dissolveBtn, function()
		if arg0_3.guildVO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("guild_tip_dissolve"),
				onYes = function()
					arg0_3:emit(GuildMainMediator.DISSOLVE, arg0_3.guildVO.id)
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.quitBtn, function()
		seriesAsync({
			function(arg0_8)
				arg0_3:DealQuit(arg0_8)
			end
		}, function()
			arg0_3:emit(GuildMainMediator.QUIT, arg0_3.guildVO.id)
		end)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.modifyBackBG, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_11 = Clone(arg0_3.guildVO)
		local var1_11 = arg0_3.nameInput.text
		local var2_11 = arg0_3.manifestoInput.text

		if not var1_11 or var1_11 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_noname"))

			return
		end

		if not nameValidityCheck(var1_11, 0, 20, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"err_name_existOtherChar"
		}) then
			return
		end

		if var1_11 ~= arg0_3.guildVO:getName() and pg.gameset.modify_guild_cost.key_value > getProxy(PlayerProxy):getData():getTotalGem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		if not var2_11 or var2_11 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nomanifesto"))

			return
		end

		var0_11:setName(var1_11)
		var0_11:setPolicy(arg0_3.policy)
		var0_11:setFaction(arg0_3.faction)
		var0_11:setManifesto(var2_11)

		local function var3_11()
			if var0_11:getPolicy() ~= arg0_3.guildVO:getPolicy() then
				arg0_3:emit(GuildMainMediator.MODIFY, 3, var0_11:getPolicy(), "")
			end

			if var0_11:getManifesto() ~= arg0_3.guildVO:getManifesto() then
				arg0_3:emit(GuildMainMediator.MODIFY, 4, 0, var0_11:getManifesto())
			end

			if var0_11:getName() ~= arg0_3.guildVO:getName() then
				arg0_3:emit(GuildMainMediator.MODIFY, 1, 0, var0_11:getName())
			end

			arg0_3:Hide()
		end

		if var0_11:getFaction() ~= arg0_3.guildVO:getFaction() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("guild_faction_change_tip"),
				onYes = function()
					var3_11()
					arg0_3:emit(GuildMainMediator.MODIFY, 2, var0_11:getFaction(), "")
				end
			})
		else
			var3_11()
		end
	end, SFX_CONFIRM)

	local function var0_3(arg0_14)
		onInputChanged(arg0_3, arg0_14, function()
			local var0_15 = getInputText(arg0_14)
			local var1_15, var2_15 = wordVer(var0_15, {
				isReplace = true
			})

			if var1_15 > 0 then
				setInputText(arg0_14, var2_15)
			end

			if getInputText(arg0_3.nameInput) ~= arg0_3.guildVO:getName() then
				local var3_15 = pg.gameset.modify_guild_cost.key_value

				setText(arg0_3.costTF, var3_15)
			else
				setText(arg0_3.costTF, 0)
			end
		end)
	end

	var0_3(arg0_3.nameInput)
	var0_3(arg0_3.manifestoInput)
end

function var0_0.DealQuit(arg0_16, arg1_16)
	local var0_16 = arg0_16.guildVO:GetActiveEvent()

	if not var0_16 or var0_16 and not var0_16:IsParticipant() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_tip_quit"),
			onYes = arg1_16
		})
	else
		local var1_16 = var0_16:GetJoinCnt()
		local var2_16 = var0_16:GetMaxJoinCnt()
		local var3_16 = var2_16 - var1_16 + var0_16:GetExtraJoinCnt()
		local var4_16 = var3_16 <= 0 and COLOR_RED or COLOR_WHITE
		local var5_16 = string.format("<color=%s>%d</color>/%d", var4_16, var3_16, var2_16)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_tip_quit_operation", var5_16),
			onYes = arg1_16
		})
	end
end

function var0_0.DealBattleReportAward(arg0_17, arg1_17)
	local var0_17 = getProxy(GuildProxy):GetCanGetReports()

	if #var0_17 == 0 then
		arg1_17()

		return
	end

	local function var1_17()
		pg.m02:sendNotification(GAME.SUBMIT_GUILD_REPORT, {
			ids = var0_17,
			callback = arg1_17
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("guild_exist_report_award_when_exit"),
		onYes = var1_17,
		onNo = function()
			arg0_17:emit(GuildMainMediator.QUIT, arg0_17.guildVO.id)
		end
	})
end

function var0_0.Show(arg0_20, arg1_20, arg2_20)
	arg0_20.guildVO = arg1_20
	arg0_20.playerVO = arg2_20

	setActive(arg0_20._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_20._tf)
	arg0_20._tf:SetAsLastSibling()

	arg0_20.isShowModify = true
	arg0_20.nameInput.text = arg0_20.guildVO:getName()
	arg0_20.manifestoInput.text = arg0_20.guildVO.manifesto

	local var0_20 = arg0_20.guildVO:getDutyByMemberId(arg0_20.playerVO.id) == GuildConst.DUTY_COMMANDER

	arg0_20.nameInput.interactable = var0_20
	arg0_20.manifestoInput.interactable = var0_20

	setActive(arg0_20.confirmBtn, var0_20)
	setActive(arg0_20.cancelBtn, var0_20)

	local var1_20 = arg0_20.guildVO:inChangefactionTime()

	setActive(arg0_20.factionMask, arg0_20.guildVO:inChangefactionTime())

	if var1_20 then
		local var2_20 = arg0_20.guildVO:changeFactionLeftTime()

		setText(arg0_20:findTF("timer_container/Text", arg0_20.factionMask), var2_20)
	end

	arg0_20.faction = arg0_20.guildVO:getFaction()

	onToggle(arg0_20, arg0_20.factionBLHXToggle, function(arg0_21)
		if arg0_21 then
			arg0_20.faction = GuildConst.FACTION_TYPE_BLHX
		end
	end, SFX_PANEL)
	onToggle(arg0_20, arg0_20.factionCSZZToggle, function(arg0_22)
		if arg0_22 then
			arg0_20.faction = GuildConst.FACTION_TYPE_CSZZ
		end
	end, SFX_PANEL)

	arg0_20.policy = arg0_20.guildVO:getPolicy()

	onToggle(arg0_20, arg0_20.policyRELAXToggle, function(arg0_23)
		if arg0_23 then
			arg0_20.policy = GuildConst.POLICY_TYPE_RELAXATION
		end
	end, SFX_PANEL)
	onToggle(arg0_20, arg0_20.policyPOWERToggle, function(arg0_24)
		if arg0_24 then
			arg0_20.policy = GuildConst.POLICY_TYPE_POWER
		end
	end, SFX_PANEL)

	if arg0_20.faction == GuildConst.FACTION_TYPE_BLHX then
		triggerToggle(arg0_20.factionBLHXToggle, true)
	elseif arg0_20.faction == GuildConst.FACTION_TYPE_CSZZ then
		triggerToggle(arg0_20.factionCSZZToggle, true)
	end

	if arg0_20.policy == GuildConst.POLICY_TYPE_RELAXATION then
		triggerToggle(arg0_20.policyRELAXToggle, true)
	elseif arg0_20.policy == GuildConst.POLICY_TYPE_POWER then
		triggerToggle(arg0_20.policyPOWERToggle, true)
	end

	arg0_20.policyPOWERToggle:GetComponent(typeof(Toggle)).interactable = var0_20
	arg0_20.policyRELAXToggle:GetComponent(typeof(Toggle)).interactable = var0_20
	arg0_20.factionCSZZToggle:GetComponent(typeof(Toggle)).interactable = var0_20
	arg0_20.factionBLHXToggle:GetComponent(typeof(Toggle)).interactable = var0_20

	local var3_20 = arg0_20.guildVO:getDutyByMemberId(arg0_20.playerVO.id)

	setActive(arg0_20.quitBtn, var3_20 ~= GuildConst.DUTY_COMMANDER)
	setActive(arg0_20.dissolveBtn, var3_20 == GuildConst.DUTY_COMMANDER)
end

function var0_0.Hide(arg0_25)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_25._tf, arg0_25._parentTf)
	setActive(arg0_25._tf, false)
end

function var0_0.OnDestroy(arg0_26)
	arg0_26:Hide()
end

return var0_0
