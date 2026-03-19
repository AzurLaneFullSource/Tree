local var0_0 = class("NewEducateScheduleResultLayer", import("view.newEducate.base.NewEducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateScheduleResultUI"
end

function var0_0.SetData(arg0_2)
	arg0_2.attrIds = arg0_2.contextData.char:GetAttrIds()
	arg0_2.moneyResId = arg0_2.contextData.char:GetResIdByType(NewEducateChar.RES_TYPE.MONEY)
	arg0_2.moodResId = arg0_2.contextData.char:GetResIdByType(NewEducateChar.RES_TYPE.MOOD)
	arg0_2.resIds = {
		arg0_2.moneyResId,
		arg0_2.moodResId
	}
	arg0_2.unlockPlanNum = arg0_2.contextData.char:GetRoundData():getConfig("plan_num")
	arg0_2.planIds = arg0_2.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.PLAN):GetPlans()
end

function var0_0.init(arg0_3)
	arg0_3.rootTF = arg0_3._tf:Find("root")
	arg0_3.anim = arg0_3.rootTF:GetComponent(typeof(Animation))
	arg0_3.animEvent = arg0_3.rootTF:GetComponent(typeof(DftAniEvent))

	arg0_3.animEvent:SetEndEvent(function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end)

	arg0_3.plansTF = arg0_3.rootTF:Find("window/plans/content")
	arg0_3.planUIList = UIItemList.New(arg0_3.plansTF, arg0_3.plansTF:Find("tpl"))
	arg0_3.attrsTF = arg0_3.rootTF:Find("window/attr")
	arg0_3.attrUIList = UIItemList.New(arg0_3.attrsTF, arg0_3.attrsTF:Find("tpl"))
	arg0_3.resTF = arg0_3.rootTF:Find("window/res/content")
	arg0_3.resUIList = UIItemList.New(arg0_3.resTF, arg0_3.resTF:Find("tpl"))

	setText(arg0_3.rootTF:Find("window/tip"), i18n("child_close_tip"))

	arg0_3.moodTF = arg0_3.rootTF:Find("window/benefit/mood")
	arg0_3.moodStageTF = arg0_3.moodTF:Find("left/Text")
	arg0_3.moodEffectTF = arg0_3.moodTF:Find("right/value")

	setText(arg0_3.moodTF:Find("right/Text"), i18n("child2_mood_benefit"))
	arg0_3:BlurPanel(arg0_3._tf, {
		groupDelta = 1
	})
end

function var0_0.didEnter(arg0_5)
	arg0_5:SetData()
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:_close()
	end, SFX_CANCEL)

	arg0_5.result = {}
	arg0_5.benefit = {}

	underscore.each(arg0_5.contextData.drops, function(arg0_7)
		if not arg0_5.result[arg0_7.id] then
			arg0_5.result[arg0_7.id] = 0
		end

		arg0_5.result[arg0_7.id] = arg0_5.result[arg0_7.id] + arg0_7.number

		if arg0_7.isBenefit then
			if not arg0_5.benefit[arg0_7.type] then
				arg0_5.benefit[arg0_7.type] = {}
			end

			if not arg0_5.benefit[arg0_7.type][arg0_7.id] then
				arg0_5.benefit[arg0_7.type][arg0_7.id] = 0
			end

			arg0_5.benefit[arg0_7.type][arg0_7.id] = arg0_5.benefit[arg0_7.type][arg0_7.id] + arg0_7.number
		end
	end)

	local var0_5 = arg0_5.contextData.char:GetFSM():GetState(NewEducateFSM.SYSTEM.PLAN)

	arg0_5.oldRes = var0_5:GetResources() or {}
	arg0_5.oldAttrs = var0_5:GetAttrs() or {}

	arg0_5:UpdataMood()
	arg0_5.attrUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_5:UpdateAttr(arg1_8, arg2_8)
		end
	end)
	arg0_5.attrUIList:align(#arg0_5.attrIds)
	arg0_5.resUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_5:UpdateRes(arg1_9, arg2_9)
		end
	end)
	arg0_5.resUIList:align(#arg0_5.resIds)
	arg0_5.planUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg0_5:UpdatePlan(arg1_10, arg2_10)
		end
	end)
	arg0_5.planUIList:align(arg0_5.unlockPlanNum)
end

function var0_0.UpdataMood(arg0_11)
	local var0_11, var1_11 = arg0_11.contextData.char:GetMoodStage()

	setText(arg0_11.moodStageTF, i18n("child2_mood_stage" .. var0_11))
	setText(arg0_11.moodEffectTF, var1_11 / 100 .. "%")
	setActive(arg0_11.moodTF:Find("buff"), var1_11 >= 0)
	setActive(arg0_11.moodTF:Find("debuff"), var1_11 < 0)
end

function var0_0.GetExtraStr(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = ""

	if arg3_12 ~= 0 then
		local var1_12 = arg3_12 > 0 and "#22AFFF" or "#FF6767"

		var0_12 = setColorStr((arg3_12 > 0 and "+" or "") .. arg3_12, var1_12)
	end

	local var2_12 = ""
	local var3_12 = arg2_12 - arg3_12 - arg1_12

	if var3_12 ~= 0 then
		local var4_12 = var3_12 > 0 and "#393A3C" or "#FF6767"

		var2_12 = setColorStr((var3_12 > 0 and "+" or "") .. var3_12, var4_12)
	end

	return var2_12 .. var0_12
end

function var0_0.UpdateAttr(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.attrIds[arg1_13 + 1]
	local var1_13 = pg.child2_attr[var0_13]

	LoadImageSpriteAsync("neweducateicon/" .. var1_13.icon, arg2_13:Find("icon_bg/icon"))
	setScrollText(arg2_13:Find("name_mask/name"), var1_13.name)

	local var2_13 = arg0_13.attrIds[arg1_13 + 1]
	local var3_13 = arg0_13.contextData.char:GetAttr(var2_13)
	local var4_13, var5_13 = NewEducateInfoPanel.GetArrtInfo(pg.child2_attr[var2_13].rank, var3_13)

	setText(arg2_13:Find("rank/Text"), var4_13)
	setText(arg2_13:Find("value_new"), var3_13)

	local var6_13 = EducateConst.GRADE_2_COLOR[var4_13][1]
	local var7_13 = EducateConst.GRADE_2_COLOR[var4_13][2]

	setImageColor(arg2_13:Find("gradient"), Color.NewHex(var6_13))
	setImageColor(arg2_13:Find("rank"), Color.NewHex(var7_13))

	local var8_13 = arg0_13.oldAttrs[var2_13] or var3_13
	local var9_13 = var3_13 - var8_13
	local var10_13 = var9_13 > 0 and "16CF99" or "FF6767"

	if var9_13 == 0 then
		var10_13 = "393A3C"
	end

	setImageColor(arg2_13:Find("arrow"), Color.NewHex(var10_13))
	setTextColor(arg2_13:Find("value_new"), Color.NewHex(var10_13))

	local var11_13 = arg0_13.benefit[NewEducateConst.DROP_TYPE.ATTR]
	local var12_13 = var11_13 and var11_13[var2_13] or 0
	local var13_13 = arg0_13:GetExtraStr(var8_13, var3_13, var12_13)

	setText(arg2_13:Find("value_old"), math.max(var8_13, 0) .. var13_13)
	setActive(arg2_13:Find("VX"), var8_13 ~= var3_13)
end

function var0_0.UpdateRes(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.resIds[arg1_14 + 1]

	LoadImageSpriteAsync("neweducateicon/" .. pg.child2_resource[var0_14].icon, arg2_14:Find("icon"))
	setText(arg2_14:Find("name"), pg.child2_resource[var0_14].name)

	local var1_14 = arg0_14.contextData.char:GetRes(var0_14)
	local var2_14 = arg0_14.oldRes[var0_14] or var1_14
	local var3_14 = var1_14 - var2_14
	local var4_14 = var3_14 > 0 and "16CF99" or "FF6767"

	if var3_14 == 0 then
		var4_14 = "393A3C"
	end

	setText(arg2_14:Find("value_new"), var1_14)
	setImageColor(arg2_14:Find("arrow"), Color.NewHex(var4_14))
	setTextColor(arg2_14:Find("value_new"), Color.NewHex(var4_14))

	local var5_14 = arg0_14.benefit[NewEducateConst.DROP_TYPE.RES]
	local var6_14 = var5_14 and var5_14[var0_14] or 0
	local var7_14 = arg0_14:GetExtraStr(var2_14, var1_14, var6_14)

	setText(arg2_14:Find("value_old"), math.max(var2_14, 0) .. var7_14)
end

function var0_0.UpdatePlan(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.planIds[arg1_15 + 1]

	setActive(arg2_15:Find("bg/icon"), var0_15)
	setActive(arg2_15:Find("bg/empty"), not var0_15)

	if var0_15 then
		local var1_15 = "plan_type" .. pg.child2_plan[var0_15].replace_type_show

		LoadImageSpriteAtlasAsync("ui/neweducatecommonui_atlas", var1_15, arg2_15:Find("bg/icon"))
	end

	setActive(arg2_15:Find("dot"), arg1_15 + 1 ~= arg0_15.unlockPlanNum)
end

function var0_0._close(arg0_16)
	arg0_16.anim:Play("anim_educate_result_out")
end

function var0_0.onBackPressed(arg0_17)
	arg0_17:_close()
end

function var0_0.willExit(arg0_18)
	arg0_18:UnOverlayPanel(arg0_18._tf)
	existCall(arg0_18.contextData.onExit)
	arg0_18.animEvent:SetEndEvent(nil)
end

return var0_0
