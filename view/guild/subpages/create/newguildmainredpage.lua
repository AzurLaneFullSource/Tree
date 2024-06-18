local var0_0 = class("NewGuildMainRedPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewGuildRedUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.nameInput = findTF(arg0_2._tf, "bg/frame/name_bg/input"):GetComponent(typeof(InputField))
	arg0_2.manifestoInput = findTF(arg0_2._tf, "bg/frame/policy_container/input_frame/input"):GetComponent(typeof(InputField))
	arg0_2.relaxToggle = findTF(arg0_2._tf, "bg/frame/policy_container/policy/relax")
	arg0_2.powerToggle = findTF(arg0_2._tf, "bg/frame/policy_container/policy/power")
	arg0_2.cancelBtn = findTF(arg0_2._tf, "bg/frame/cancel_btn")
	arg0_2.confirmBtn = findTF(arg0_2._tf, "bg/frame/confirm_btn")
	arg0_2.costTF = findTF(arg0_2._tf, "bg/frame/confirm_btn/print_container/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	local var0_3 = pg.gameset.create_guild_cost.key_value

	arg0_3.costTF.text = var0_3

	onInputChanged(arg0_3, arg0_3.nameInput, function()
		local var0_4 = getInputText(arg0_3.nameInput)
		local var1_4, var2_4 = wordVer(var0_4, {
			isReplace = true
		})

		if var1_4 > 0 then
			setInputText(arg0_3.nameInput, var2_4)
		end
	end)
	onInputChanged(arg0_3, arg0_3.manifestoInput, function()
		local var0_5 = getInputText(arg0_3.manifestoInput)
		local var1_5, var2_5 = wordVer(var0_5, {
			isReplace = true
		})

		if var1_5 > 0 then
			setInputText(arg0_3.manifestoInput, var2_5)
		end
	end)
	onToggle(arg0_3, arg0_3.relaxToggle, function(arg0_6)
		if arg0_6 then
			local var0_6 = GuildConst.POLICY_TYPE_RELAXATION

			arg0_3.newGuildVO:setPolicy(var0_6)
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.powerToggle, function(arg0_7)
		if arg0_7 then
			local var0_7 = GuildConst.POLICY_TYPE_POWER

			arg0_3.newGuildVO:setPolicy(var0_7)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		if arg0_3.onCancel then
			arg0_3.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_9 = arg0_3.nameInput.text

		arg0_3.newGuildVO:setName(var0_9)

		local var1_9 = arg0_3.manifestoInput.text
		local var2_9 = wordVer(var1_9)

		arg0_3.newGuildVO:setManifesto(var1_9)

		local var3_9 = arg0_3.newGuildVO:getName()

		if not var3_9 or var3_9 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_noname"))

			return
		end

		if not nameValidityCheck(var3_9, 0, 20, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"err_name_existOtherChar"
		}) then
			return
		end

		if not arg0_3.newGuildVO:getFaction() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nofaction"))

			return
		end

		if not arg0_3.newGuildVO:getPolicy() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nopolicy"))

			return
		end

		local var4_9 = arg0_3.newGuildVO:getManifesto()

		if not var4_9 or var4_9 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nomanifesto"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_create_confirm", var0_3),
			onYes = function()
				if arg0_3.playerVO:getTotalGem() < var0_3 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
				else
					arg0_3:emit(NewGuildMediator.CREATE, arg0_3.newGuildVO)
				end
			end
		})
	end, SFX_CONFIRM)
end

function var0_0.Show(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	arg0_11.playerVO = arg2_11

	var0_0.super.Show(arg0_11)

	arg0_11.onCancel = arg4_11
	arg0_11.newGuildVO = arg1_11

	triggerToggle(arg0_11.relaxToggle, true)

	local var0_11 = GetOrAddComponent(arg0_11._tf, "CanvasGroup")

	var0_11.alpha = 0
	arg0_11.isPlaying = true

	LeanTween.value(arg0_11._go, 0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0_12)
		var0_11.alpha = arg0_12
	end)):setOnComplete(System.Action(function()
		arg0_11.isPlaying = false

		arg3_11()
	end)):setDelay(0.5)
	arg0_11._tf:SetSiblingIndex(1)
end

function var0_0.IsPlaying(arg0_14)
	return arg0_14.isPlaying
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
