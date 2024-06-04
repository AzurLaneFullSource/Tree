local var0 = class("NewGuildMainRedPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewGuildRedUI"
end

function var0.OnLoaded(arg0)
	arg0.nameInput = findTF(arg0._tf, "bg/frame/name_bg/input"):GetComponent(typeof(InputField))
	arg0.manifestoInput = findTF(arg0._tf, "bg/frame/policy_container/input_frame/input"):GetComponent(typeof(InputField))
	arg0.relaxToggle = findTF(arg0._tf, "bg/frame/policy_container/policy/relax")
	arg0.powerToggle = findTF(arg0._tf, "bg/frame/policy_container/policy/power")
	arg0.cancelBtn = findTF(arg0._tf, "bg/frame/cancel_btn")
	arg0.confirmBtn = findTF(arg0._tf, "bg/frame/confirm_btn")
	arg0.costTF = findTF(arg0._tf, "bg/frame/confirm_btn/print_container/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	local var0 = pg.gameset.create_guild_cost.key_value

	arg0.costTF.text = var0

	onInputChanged(arg0, arg0.nameInput, function()
		local var0 = getInputText(arg0.nameInput)
		local var1, var2 = wordVer(var0, {
			isReplace = true
		})

		if var1 > 0 then
			setInputText(arg0.nameInput, var2)
		end
	end)
	onInputChanged(arg0, arg0.manifestoInput, function()
		local var0 = getInputText(arg0.manifestoInput)
		local var1, var2 = wordVer(var0, {
			isReplace = true
		})

		if var1 > 0 then
			setInputText(arg0.manifestoInput, var2)
		end
	end)
	onToggle(arg0, arg0.relaxToggle, function(arg0)
		if arg0 then
			local var0 = GuildConst.POLICY_TYPE_RELAXATION

			arg0.newGuildVO:setPolicy(var0)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.powerToggle, function(arg0)
		if arg0 then
			local var0 = GuildConst.POLICY_TYPE_POWER

			arg0.newGuildVO:setPolicy(var0)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.confirmBtn, function()
		local var0 = arg0.nameInput.text

		arg0.newGuildVO:setName(var0)

		local var1 = arg0.manifestoInput.text
		local var2 = wordVer(var1)

		arg0.newGuildVO:setManifesto(var1)

		local var3 = arg0.newGuildVO:getName()

		if not var3 or var3 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_noname"))

			return
		end

		if not nameValidityCheck(var3, 0, 20, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"err_name_existOtherChar"
		}) then
			return
		end

		if not arg0.newGuildVO:getFaction() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nofaction"))

			return
		end

		if not arg0.newGuildVO:getPolicy() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nopolicy"))

			return
		end

		local var4 = arg0.newGuildVO:getManifesto()

		if not var4 or var4 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_create_error_nomanifesto"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_create_confirm", var0),
			onYes = function()
				if arg0.playerVO:getTotalGem() < var0 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
				else
					arg0:emit(NewGuildMediator.CREATE, arg0.newGuildVO)
				end
			end
		})
	end, SFX_CONFIRM)
end

function var0.Show(arg0, arg1, arg2, arg3, arg4)
	arg0.playerVO = arg2

	var0.super.Show(arg0)

	arg0.onCancel = arg4
	arg0.newGuildVO = arg1

	triggerToggle(arg0.relaxToggle, true)

	local var0 = GetOrAddComponent(arg0._tf, "CanvasGroup")

	var0.alpha = 0
	arg0.isPlaying = true

	LeanTween.value(arg0._go, 0, 1, 0.6):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.isPlaying = false

		arg3()
	end)):setDelay(0.5)
	arg0._tf:SetSiblingIndex(1)
end

function var0.IsPlaying(arg0)
	return arg0.isPlaying
end

function var0.OnDestroy(arg0)
	return
end

return var0
