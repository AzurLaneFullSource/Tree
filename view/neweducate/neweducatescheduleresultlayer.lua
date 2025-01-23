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
	arg0_2.planIds = arg0_2.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.PLAN):GetPlans()
end

function var0_0.init(arg0_3)
	arg0_3.rootTF = arg0_3._tf:Find("root")
	arg0_3.anim = arg0_3.rootTF:GetComponent(typeof(Animation))
	arg0_3.animEvent = arg0_3.rootTF:GetComponent(typeof(DftAniEvent))
	arg0_3.inAnimPlaying = false

	arg0_3.animEvent:SetEndEvent(function()
		arg0_3.inAnimPlaying = false

		arg0_3.animEvent:SetEndEvent(function()
			arg0_3:emit(var0_0.ON_CLOSE)
		end)
	end)

	arg0_3.plansTF = arg0_3.rootTF:Find("window/plans/content")
	arg0_3.planUIList = UIItemList.New(arg0_3.plansTF, arg0_3.plansTF:Find("tpl"))
	arg0_3.attrsTF = arg0_3.rootTF:Find("window/attr")
	arg0_3.attrUIList = UIItemList.New(arg0_3.attrsTF, arg0_3.attrsTF:Find("tpl"))
	arg0_3.resTF = arg0_3.rootTF:Find("window/res/content")
	arg0_3.resUIList = UIItemList.New(arg0_3.resTF, arg0_3.resTF:Find("tpl"))

	setText(arg0_3.rootTF:Find("window/tip"), i18n("child_close_tip"))

	arg0_3.effectTF = arg0_3.rootTF:Find("window/effect")

	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, nil, {
		groupName = arg0_3:getGroupNameFromData(),
		weight = arg0_3:getWeightFromData() + 1
	})
end

function var0_0.didEnter(arg0_6)
	arg0_6:SetData()
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:closeView()
	end, SFX_CANCEL)

	arg0_6.result = {}
	arg0_6.benefit = {}

	underscore.each(arg0_6.contextData.drops, function(arg0_8)
		if not arg0_6.result[arg0_8.id] then
			arg0_6.result[arg0_8.id] = 0
		end

		arg0_6.result[arg0_8.id] = arg0_6.result[arg0_8.id] + arg0_8.number

		if arg0_8.isBenefit then
			if not arg0_6.benefit[arg0_8.id] then
				arg0_6.benefit[arg0_8.id] = 0
			end

			arg0_6.benefit[arg0_8.id] = arg0_6.benefit[arg0_8.id] + arg0_8.number
		end
	end)

	local var0_6 = arg0_6.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.PLAN)

	arg0_6.oldRes = var0_6:GetResources() or {}
	arg0_6.oldAttrs = var0_6:GetAttrs() or {}

	local var1_6 = arg0_6.contextData.char:GetMoodStage()

	setText(arg0_6.effectTF, string.gsub("$1", "$1", i18n("child2_mood_desc" .. var1_6)))
	arg0_6.attrUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_6:UpdateAttr(arg1_9, arg2_9)
		end
	end)
	arg0_6.attrUIList:align(#arg0_6.attrIds)
	arg0_6.resUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg0_6:UpdateRes(arg1_10, arg2_10)
		end
	end)
	arg0_6.resUIList:align(#arg0_6.resIds)
	arg0_6.planUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_6:UpdatePlan(arg1_11, arg2_11)
		end
	end)
	arg0_6.planUIList:align(arg0_6.unlockPlanNum)
end

function var0_0.UpdateAttr(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.attrIds[arg1_12 + 1]
	local var1_12 = pg.child2_attr[var0_12]

	LoadImageSpriteAsync("neweducateicon/" .. var1_12.icon, arg2_12:Find("icon_bg/icon"))
	setScrollText(arg2_12:Find("name_mask/name"), var1_12.name)

	local var2_12 = arg0_12.attrIds[arg1_12 + 1]
	local var3_12 = arg0_12.contextData.char:GetAttr(var2_12)
	local var4_12, var5_12 = NewEducateInfoPanel.GetArrtInfo(pg.child2_attr[var2_12].rank, var3_12)

	setText(arg2_12:Find("rank/Text"), var4_12)
	setText(arg2_12:Find("value_new"), var3_12)

	local var6_12 = EducateConst.GRADE_2_COLOR[var4_12][1]
	local var7_12 = EducateConst.GRADE_2_COLOR[var4_12][2]

	setImageColor(arg2_12:Find("gradient"), Color.NewHex(var6_12))
	setImageColor(arg2_12:Find("rank"), Color.NewHex(var7_12))

	local var8_12 = arg0_12.oldAttrs[var2_12] or var3_12
	local var9_12 = var3_12 - var8_12
	local var10_12 = var9_12 > 0 and "16CF99" or "FF6767"

	if var9_12 == 0 then
		var10_12 = "393A3C"
	end

	setText(arg2_12:Find("value_old"), math.max(var8_12, 0))
	setImageColor(arg2_12:Find("arrow"), Color.NewHex(var10_12))
	setTextColor(arg2_12:Find("value_new"), Color.NewHex(var10_12))
	setActive(arg2_12:Find("VX"), var8_12 ~= var3_12)
end

function var0_0.UpdateRes(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.resIds[arg1_13 + 1]

	LoadImageSpriteAsync("neweducateicon/" .. pg.child2_resource[var0_13].icon, arg2_13:Find("icon"))
	setText(arg2_13:Find("name"), pg.child2_resource[var0_13].name)

	local var1_13 = arg0_13.contextData.char:GetRes(var0_13)
	local var2_13 = arg0_13.oldRes[var0_13] or var1_13
	local var3_13 = var1_13 - var2_13
	local var4_13 = var3_13 > 0 and "16CF99" or "FF6767"

	if var3_13 == 0 then
		var4_13 = "393A3C"
	end

	setText(arg2_13:Find("value_old"), math.max(var2_13, 0))
	setText(arg2_13:Find("value_new"), var1_13)
	setImageColor(arg2_13:Find("arrow"), Color.NewHex(var4_13))
	setTextColor(arg2_13:Find("value_new"), Color.NewHex(var4_13))
end

function var0_0.UpdatePlan(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.planIds[arg1_14 + 1]

	setActive(arg2_14:Find("bg/icon"), var0_14)
	setActive(arg2_14:Find("bg/empty"), not var0_14)

	if var0_14 then
		local var1_14 = "plan_type" .. pg.child2_plan[var0_14].replace_type_show

		LoadImageSpriteAtlasAsync("ui/neweducatecommonui_atlas", var1_14, arg2_14:Find("bg/icon"))
	end

	setActive(arg2_14:Find("dot"), arg1_14 + 1 ~= arg0_14.unlockPlanNum)
end

function var0_0._close(arg0_15)
	if arg0_15.inAnimPlaying then
		return
	end

	arg0_15.anim:Play("anim_educate_result_out")

	arg0_15.inAnimPlaying = true
end

function var0_0.onBackPressed(arg0_16)
	arg0_16:_close()
end

function var0_0.willExit(arg0_17)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_17._tf)
	existCall(arg0_17.contextData.onExit)
end

return var0_0
