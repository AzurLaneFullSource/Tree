local var0_0 = class("ALYPtPage", import("..CorePageNewPtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.anim = arg0_1:findTF("bg/Image_back"):GetComponent(typeof(Animation))

	arg0_1.anim:Play("anim_AlyptPage_BackImage")

	arg0_1.animEvent = arg0_1.anim:GetComponent(typeof(DftAniEvent))

	arg0_1.animEvent:SetStartEvent(function()
		arg0_1._tf:GetComponent(typeof(Animation)):Play("anim_AlyptPage_In")
	end)

	arg0_1._tfanim = arg0_1._tf:GetComponent(typeof(Animation))
	arg0_1._tfanimEvent = arg0_1._tfanim:GetComponent(typeof(DftAniEvent))

	arg0_1._tfanimEvent:SetEndEvent(function()
		setActive(arg0_1:findTF("bg/Image_back_Loop"), true)
		setActive(arg0_1:findTF("bg/VX"), true)
	end)

	arg0_1.itemAlpha = 0

	setCanvasGroupAlpha(arg0_1.awardTpl, arg0_1.itemAlpha)

	arg0_1.awardanimEvent = arg0_1._tf:GetComponent(typeof(DftAniEvent))

	arg0_1.awardanimEvent:SetTriggerEvent(function(arg0_4)
		arg0_1.itemAlpha = 1

		setCanvasGroupAlpha(arg0_1.awardTpl, arg0_1.itemAlpha)

		local var0_4 = arg0_1.content.transform.childCount

		for iter0_4 = 0, var0_4 - 1 do
			local var1_4 = arg0_1.content:GetChild(iter0_4)

			onDelayTick(function()
				if arg0_1._state == var0_0.STATES.DESTROY then
					return
				end

				setCanvasGroupAlpha(var1_4, arg0_1.itemAlpha)
				quickPlayAnimation(var1_4, "anim_AlyptPage_awardtpl_In")
			end, 0.08)
		end

		onDelayTick(function()
			if arg0_1._state == var0_0.STATES.DESTROY then
				return
			end

			quickPlayAnimation(arg0_1.sptf, "anim_AlyptPage_sp_award_In")
		end, 0.08)
	end)
end

function var0_0.UpdateAward(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7 + 1
	local var1_7 = arg0_7.awardList[var0_7].drop

	updateDrop(arg2_7:Find("icon"), var1_7)
	setText(arg2_7:Find("pt"), arg0_7.awardList[var0_7].target)

	local var2_7 = var0_7 <= arg0_7.ptData:GetLevel()
	local var3_7 = not var2_7 and var0_7 <= arg0_7.ptData:GetMaxAvailableTargetIndex()
	local var4_7 = not var2_7 and not var3_7

	setText(arg2_7:Find("got/got_text"), i18n("yumia_pt_4"))
	setActive(arg2_7:Find("got"), var2_7)
	setActive(arg2_7:Find("get"), var3_7)
	setActive(arg2_7:Find("lock"), var4_7)
	onButton(arg0_7, arg2_7, function()
		arg0_7:emit(BaseUI.ON_DROP, var1_7)
	end, SFX_PANEL)
end

function var0_0.OnFirstFlush(arg0_9)
	var0_0.super.OnFirstFlush(arg0_9)
	setText(arg0_9:findTF("Text (Legacy)", arg0_9.shopBtn), i18n("yumia_pt_3"))
	setText(arg0_9:findTF("Text (Legacy)", arg0_9.getBtn), i18n("yumia_pt_2"))
	setText(arg0_9:findTF("rule_bg/rule_text", arg0_9.bg), i18n("yumia_pt_1"))
	setText(arg0_9:findTF("pt_bg/Text (Legacy)", arg0_9.bg), i18n("yumia_pt_tip"))
end

function var0_0.UpdateNextAward(arg0_10, arg1_10)
	arg1_10 = math.min(arg1_10, 1)

	for iter0_10, iter1_10 in pairs(arg0_10.importantPos) do
		if arg1_10 + var0_0.AWARD_OFFSET < iter1_10.pos then
			arg0_10:UpdateAward(iter1_10.index - 1, arg0_10.spAward)

			break
		elseif iter0_10 == #arg0_10.importantPos then
			-- block empty
		end
	end
end

function var0_0.OnUpdateFlush(arg0_11)
	local var0_11 = var0_0.OFFSET * arg0_11.ptData:GetLevel()

	if isActive(arg0_11._tf) then
		arg0_11.scrollCom:ScrollTo(math.clamp(arg0_11.scrollCom:HeadIndexToValue(arg0_11.ptData:GetLevel()) / arg0_11.impTotalPos + var0_11, 0, 1), true)
	end

	setText(arg0_11.get, i18n("word_got_pt"))
	setText(arg0_11.ptCount, arg0_11.ptData.count)
end

function var0_0.OnHideFlush(arg0_12)
	onDelayTick(function()
		for iter0_13 = 0, arg0_12.content.transform.childCount - 1 do
			arg0_12.content:GetChild(iter0_13):GetComponent(typeof(Animation)):Stop()
			setCanvasGroupAlpha(arg0_12.content:GetChild(iter0_13), 0)
		end
	end, 0.08)
	onDelayTick(function()
		setCanvasGroupAlpha(arg0_12.sptf, 0)
	end, 0.08)
end

return var0_0
