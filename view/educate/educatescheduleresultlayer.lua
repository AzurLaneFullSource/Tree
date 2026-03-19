local var0_0 = class("EducateScheduleResultLayer", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateScheduleResultUI"
end

function var0_0.init(arg0_2)
	arg0_2.anim = arg0_2._tf:Find("anim_root"):GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2._tf:Find("anim_root"):GetComponent(typeof(DftAniEvent))
	arg0_2.inAnimPlaying = true

	arg0_2.animEvent:SetEndEvent(function()
		arg0_2.inAnimPlaying = false

		arg0_2.animEvent:SetEndEvent(function()
			arg0_2:emit(var0_0.ON_CLOSE)
		end)
	end)

	arg0_2.windowTF = arg0_2._tf:Find("anim_root/window")
	arg0_2.personalTF = arg0_2.windowTF:Find("personal")
	arg0_2.majorArrTF = arg0_2.windowTF:Find("major")
	arg0_2.minorArrTF = arg0_2.windowTF:Find("minor")
	arg0_2.resTF = arg0_2.windowTF:Find("res/content")

	setText(arg0_2.windowTF:Find("tip"), i18n("child_close_tip"))
	arg0_2:BlurPanel(arg0_2._tf, {
		groupDelta = 1
	})
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:_close()
	end, SFX_CANCEL)

	local var0_5 = arg0_5.contextData.plan_results or {}

	arg0_5.result = {}
	arg0_5.resResult = {}
	arg0_5.resultEvent = {}
	arg0_5.resResultEvent = {}
	arg0_5.drops = {}

	local function var1_5(arg0_7, arg1_7)
		for iter0_7, iter1_7 in ipairs(arg0_7) do
			table.insert(arg0_5.drops, iter1_7)

			if iter1_7.type == EducateConst.DROP_TYPE_ATTR then
				if arg1_7 then
					if not arg0_5.resultEvent[iter1_7.id] then
						arg0_5.resultEvent[iter1_7.id] = 0
					end

					arg0_5.resultEvent[iter1_7.id] = arg0_5.resultEvent[iter1_7.id] + iter1_7.number
				else
					if not arg0_5.result[iter1_7.id] then
						arg0_5.result[iter1_7.id] = 0
					end

					arg0_5.result[iter1_7.id] = arg0_5.result[iter1_7.id] + iter1_7.number
				end
			end

			if iter1_7.type == EducateConst.DROP_TYPE_RES then
				if arg1_7 then
					if not arg0_5.resResultEvent[iter1_7.id] then
						arg0_5.resResultEvent[iter1_7.id] = 0
					end

					arg0_5.resResultEvent[iter1_7.id] = arg0_5.resResultEvent[iter1_7.id] + iter1_7.number
				else
					if not arg0_5.resResult[iter1_7.id] then
						arg0_5.resResult[iter1_7.id] = 0
					end

					arg0_5.resResult[iter1_7.id] = arg0_5.resResult[iter1_7.id] + iter1_7.number
				end
			end
		end
	end

	for iter0_5, iter1_5 in ipairs(var0_5) do
		var1_5(iter1_5.plan_drops)
		var1_5(iter1_5.event_drops, true)
		var1_5(iter1_5.spec_event_drops)
	end

	arg0_5.char = getProxy(EducateProxy):GetCharData()
	arg0_5.natureIds = arg0_5.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_PERSONALITY)
	arg0_5.majorIds = arg0_5.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_MAJOR)
	arg0_5.minorIds = arg0_5.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_MINOR)
	arg0_5.resIds = {
		EducateChar.RES_MOOD_ID,
		EducateChar.RES_MONEY_ID
	}

	arg0_5:updatePersonalPanel()
	arg0_5:updateMajorPanel()
	arg0_5:updateMinorPanel()
	arg0_5:updateResPanel()
end

function var0_0.updatePersonalPanel(arg0_8)
	local var0_8 = EducateHelper.IsShowNature()

	setActive(arg0_8.personalTF, var0_8)

	if var0_8 then
		for iter0_8, iter1_8 in ipairs(arg0_8.natureIds) do
			local var1_8 = arg0_8.personalTF:Find(tostring(iter1_8))
			local var2_8 = arg0_8.char:GetAttrById(iter1_8)

			setText(var1_8:Find("old"), pg.child_attr[iter1_8].name .. " " .. var2_8)

			local var3_8 = arg0_8.result[iter1_8] or 0

			setActive(var1_8:Find("new"), var3_8 ~= 0)

			if var3_8 ~= 0 then
				local var4_8 = var3_8 > 0 and "39BFFF" or "FF6767"
				local var5_8 = var3_8 > 0 and "+" or ""

				setText(var1_8:Find("new"), var5_8 .. " " .. var3_8)
				setTextColor(var1_8:Find("new"), Color.NewHex(var4_8))
			end
		end
	end
end

function var0_0.updateMajorPanel(arg0_9)
	for iter0_9 = 1, arg0_9.majorArrTF.childCount do
		local var0_9 = arg0_9.majorArrTF:GetChild(iter0_9 - 1)
		local var1_9 = arg0_9.majorIds[iter0_9]

		GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var1_9, var0_9:Find("icon_bg/icon"), true)
		setScrollText(var0_9:Find("name_mask/name"), pg.child_attr[var1_9].name)

		local var2_9 = arg0_9.char:GetAttrInfo(var1_9)

		setText(var0_9:Find("grade/Text"), var2_9)

		local var3_9 = arg0_9.char:GetAttrById(var1_9)

		setText(var0_9:Find("value_old"), var3_9)

		local var4_9 = EducateConst.GRADE_2_COLOR[var2_9][1]
		local var5_9 = EducateConst.GRADE_2_COLOR[var2_9][2]

		setImageColor(var0_9:Find("gradient"), Color.NewHex(var4_9))
		setImageColor(var0_9:Find("grade"), Color.NewHex(var5_9))

		local var6_9 = arg0_9.result[var1_9] or 0
		local var7_9 = var6_9 == 0 and "39393C" or "39BFFF"

		setActive(var0_9:Find("VX"), var6_9 ~= 0)
		setImageColor(var0_9:Find("arrow"), Color.NewHex(var7_9))
		setText(var0_9:Find("value_new"), var3_9 + var6_9)
		setTextColor(var0_9:Find("value_new"), Color.NewHex(var7_9))
	end
end

function var0_0.updateMinorPanel(arg0_10)
	for iter0_10 = 1, arg0_10.minorArrTF.childCount do
		local var0_10 = arg0_10.minorArrTF:GetChild(iter0_10 - 1)
		local var1_10 = arg0_10.minorIds[iter0_10]

		GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var1_10, var0_10:Find("icon"), true)
		setText(var0_10:Find("name"), pg.child_attr[var1_10].name)

		local var2_10 = arg0_10.char:GetAttrById(var1_10)

		setText(var0_10:Find("value/value/old"), var2_10)

		local var3_10 = arg0_10.result[var1_10] or 0

		setText(var0_10:Find("value/value/add"), "")

		local var4_10 = arg0_10.resultEvent[var1_10] or 0

		setText(var0_10:Find("value/event_add"), "")

		local var5_10 = var3_10 ~= 0 or var4_10 ~= 0

		setActive(var0_10:Find("VX"), var5_10)

		if var5_10 then
			onDelayTick(function()
				if var3_10 > 0 then
					setText(var0_10:Find("value/value/add"), "+" .. var3_10)
				end

				if var4_10 > 0 then
					setText(var0_10:Find("value/event_add"), "+" .. var4_10)
				end
			end, 0.891)
		end
	end
end

function var0_0.updateResPanel(arg0_12)
	for iter0_12 = 1, #arg0_12.resIds do
		local var0_12 = arg0_12.resTF:GetChild(iter0_12 - 1)
		local var1_12 = arg0_12.resIds[iter0_12]

		GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "res_" .. var1_12, var0_12:Find("icon"), true)
		setText(var0_12:Find("name"), pg.child_resource[var1_12].name)

		local var2_12 = arg0_12.char:GetResById(var1_12)

		if var2_12 < 0 then
			var2_12 = 0
		end

		setText(var0_12:Find("value/value/old"), var2_12)

		local var3_12 = arg0_12.resResult[var1_12] or 0
		local var4_12 = var3_12 == 0 and "" or "+" .. var3_12

		setText(var0_12:Find("value/value/add"), var4_12)

		local var5_12 = arg0_12.resResultEvent[var1_12] or 0
		local var6_12 = var5_12 == 0 and "" or "+" .. var5_12

		setText(var0_12:Find("value/event_add"), var6_12)
	end
end

function var0_0._close(arg0_13)
	if arg0_13.inAnimPlaying then
		return
	end

	arg0_13.anim:Play("anim_educate_result_out")
end

function var0_0.onBackPressed(arg0_14)
	arg0_14:_close()
end

function var0_0.willExit(arg0_15)
	getProxy(EducateProxy):OnNextWeek()
	arg0_15.animEvent:SetEndEvent(nil)

	if arg0_15.drops then
		EducateHelper.UpdateDropsData(arg0_15.drops)
	end

	arg0_15:UnOverlayPanel(arg0_15._tf)

	if arg0_15.contextData.onExit then
		arg0_15.contextData.onExit()
	end
end

return var0_0
