local var0 = class("GuildModiftionPage", import("...base.GuildBasePage"))

function var0.getTargetUI(arg0)
	return "GuildModiftionBluePage", "GuildModiftionRedPage"
end

function var0.OnLoaded(arg0)
	arg0.nameInput = findTF(arg0._tf, "frame/name_bg/input"):GetComponent(typeof(InputField))
	arg0.factionBLHXToggle = findTF(arg0._tf, "frame/policy_container/faction/blhx")
	arg0.factionCSZZToggle = findTF(arg0._tf, "frame/policy_container/faction/cszz")
	arg0.policyRELAXToggle = findTF(arg0._tf, "frame/policy_container/policy/relax")
	arg0.policyPOWERToggle = findTF(arg0._tf, "frame/policy_container/policy/power")
	arg0.manifestoInput = findTF(arg0._tf, "frame/policy_container/input_frame/input"):GetComponent(typeof(InputField))
	arg0.confirmBtn = findTF(arg0._tf, "frame/confirm_btn")
	arg0.cancelBtn = findTF(arg0._tf, "frame/cancel_btn")
	arg0.quitBtn = findTF(arg0._tf, "frame/quit_btn")
	arg0.dissolveBtn = findTF(arg0._tf, "frame/dissolve_btn")
	arg0.factionMask = findTF(arg0._tf, "frame/policy_container/faction/mask")
	arg0.costTF = findTF(arg0._tf, "frame/confirm_btn/print_container/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	arg0.costTF.text = 0
	arg0.modifyBackBG = arg0:findTF("bg_decorations", arg0._tf)

	setActive(arg0._tf, false)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.dissolveBtn, function()
		if arg0.guildVO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("guild_tip_dissolve"),
				onYes = function()
					arg0:emit(GuildMainMediator.DISSOLVE, arg0.guildVO.id)
				end
			})
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.quitBtn, function()
		seriesAsync({
			function(arg0)
				arg0:DealQuit(arg0)
			end
		}, function()
			arg0:emit(GuildMainMediator.QUIT, arg0.guildVO.id)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.modifyBackBG, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		local var0 = Clone(arg0.guildVO)
		local var1 = arg0.nameInput.text
		local var2 = arg0.manifestoInput.text

		if not var1 or var1 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_noname"))

			return
		end

		if not nameValidityCheck(var1, 0, 20, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"err_name_existOtherChar"
		}) then
			return
		end

		if var1 ~= arg0.guildVO:getName() and pg.gameset.modify_guild_cost.key_value > getProxy(PlayerProxy):getData():getTotalGem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		if not var2 or var2 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nomanifesto"))

			return
		end

		var0:setName(var1)
		var0:setPolicy(arg0.policy)
		var0:setFaction(arg0.faction)
		var0:setManifesto(var2)

		local function var3()
			if var0:getPolicy() ~= arg0.guildVO:getPolicy() then
				arg0:emit(GuildMainMediator.MODIFY, 3, var0:getPolicy(), "")
			end

			if var0:getManifesto() ~= arg0.guildVO:getManifesto() then
				arg0:emit(GuildMainMediator.MODIFY, 4, 0, var0:getManifesto())
			end

			if var0:getName() ~= arg0.guildVO:getName() then
				arg0:emit(GuildMainMediator.MODIFY, 1, 0, var0:getName())
			end

			arg0:Hide()
		end

		if var0:getFaction() ~= arg0.guildVO:getFaction() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("guild_faction_change_tip"),
				onYes = function()
					var3()
					arg0:emit(GuildMainMediator.MODIFY, 2, var0:getFaction(), "")
				end
			})
		else
			var3()
		end
	end, SFX_CONFIRM)

	local function var0(arg0)
		onInputChanged(arg0, arg0, function()
			local var0 = getInputText(arg0)
			local var1, var2 = wordVer(var0, {
				isReplace = true
			})

			if var1 > 0 then
				setInputText(arg0, var2)
			end

			if getInputText(arg0.nameInput) ~= arg0.guildVO:getName() then
				local var3 = pg.gameset.modify_guild_cost.key_value

				setText(arg0.costTF, var3)
			else
				setText(arg0.costTF, 0)
			end
		end)
	end

	var0(arg0.nameInput)
	var0(arg0.manifestoInput)
end

function var0.DealQuit(arg0, arg1)
	local var0 = arg0.guildVO:GetActiveEvent()

	if not var0 or var0 and not var0:IsParticipant() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_tip_quit"),
			onYes = arg1
		})
	else
		local var1 = var0:GetJoinCnt()
		local var2 = var0:GetMaxJoinCnt()
		local var3 = var2 - var1 + var0:GetExtraJoinCnt()
		local var4 = var3 <= 0 and COLOR_RED or COLOR_WHITE
		local var5 = string.format("<color=%s>%d</color>/%d", var4, var3, var2)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_tip_quit_operation", var5),
			onYes = arg1
		})
	end
end

function var0.DealBattleReportAward(arg0, arg1)
	local var0 = getProxy(GuildProxy):GetCanGetReports()

	if #var0 == 0 then
		arg1()

		return
	end

	local function var1()
		pg.m02:sendNotification(GAME.SUBMIT_GUILD_REPORT, {
			ids = var0,
			callback = arg1
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("guild_exist_report_award_when_exit"),
		onYes = var1,
		onNo = function()
			arg0:emit(GuildMainMediator.QUIT, arg0.guildVO.id)
		end
	})
end

function var0.Show(arg0, arg1, arg2)
	arg0.guildVO = arg1
	arg0.playerVO = arg2

	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0._tf:SetAsLastSibling()

	arg0.isShowModify = true
	arg0.nameInput.text = arg0.guildVO:getName()
	arg0.manifestoInput.text = arg0.guildVO.manifesto

	local var0 = arg0.guildVO:getDutyByMemberId(arg0.playerVO.id) == GuildConst.DUTY_COMMANDER

	arg0.nameInput.interactable = var0
	arg0.manifestoInput.interactable = var0

	setActive(arg0.confirmBtn, var0)
	setActive(arg0.cancelBtn, var0)

	local var1 = arg0.guildVO:inChangefactionTime()

	setActive(arg0.factionMask, arg0.guildVO:inChangefactionTime())

	if var1 then
		local var2 = arg0.guildVO:changeFactionLeftTime()

		setText(arg0:findTF("timer_container/Text", arg0.factionMask), var2)
	end

	arg0.faction = arg0.guildVO:getFaction()

	onToggle(arg0, arg0.factionBLHXToggle, function(arg0)
		if arg0 then
			arg0.faction = GuildConst.FACTION_TYPE_BLHX
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.factionCSZZToggle, function(arg0)
		if arg0 then
			arg0.faction = GuildConst.FACTION_TYPE_CSZZ
		end
	end, SFX_PANEL)

	arg0.policy = arg0.guildVO:getPolicy()

	onToggle(arg0, arg0.policyRELAXToggle, function(arg0)
		if arg0 then
			arg0.policy = GuildConst.POLICY_TYPE_RELAXATION
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.policyPOWERToggle, function(arg0)
		if arg0 then
			arg0.policy = GuildConst.POLICY_TYPE_POWER
		end
	end, SFX_PANEL)

	if arg0.faction == GuildConst.FACTION_TYPE_BLHX then
		triggerToggle(arg0.factionBLHXToggle, true)
	elseif arg0.faction == GuildConst.FACTION_TYPE_CSZZ then
		triggerToggle(arg0.factionCSZZToggle, true)
	end

	if arg0.policy == GuildConst.POLICY_TYPE_RELAXATION then
		triggerToggle(arg0.policyRELAXToggle, true)
	elseif arg0.policy == GuildConst.POLICY_TYPE_POWER then
		triggerToggle(arg0.policyPOWERToggle, true)
	end

	arg0.policyPOWERToggle:GetComponent(typeof(Toggle)).interactable = var0
	arg0.policyRELAXToggle:GetComponent(typeof(Toggle)).interactable = var0
	arg0.factionCSZZToggle:GetComponent(typeof(Toggle)).interactable = var0
	arg0.factionBLHXToggle:GetComponent(typeof(Toggle)).interactable = var0

	local var3 = arg0.guildVO:getDutyByMemberId(arg0.playerVO.id)

	setActive(arg0.quitBtn, var3 ~= GuildConst.DUTY_COMMANDER)
	setActive(arg0.dissolveBtn, var3 == GuildConst.DUTY_COMMANDER)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
