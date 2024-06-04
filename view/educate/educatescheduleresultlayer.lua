local var0 = class("EducateScheduleResultLayer", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateScheduleResultUI"
end

function var0.init(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))
	arg0.inAnimPlaying = true

	arg0.animEvent:SetEndEvent(function()
		arg0.inAnimPlaying = false

		arg0.animEvent:SetEndEvent(function()
			arg0:emit(var0.ON_CLOSE)
		end)
	end)

	arg0.windowTF = arg0:findTF("anim_root/window")
	arg0.personalTF = arg0:findTF("personal", arg0.windowTF)
	arg0.majorArrTF = arg0:findTF("major", arg0.windowTF)
	arg0.minorArrTF = arg0:findTF("minor", arg0.windowTF)
	arg0.resTF = arg0:findTF("res/content", arg0.windowTF)

	setText(arg0:findTF("tip", arg0.windowTF), i18n("child_close_tip"))
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:_close()
	end, SFX_CANCEL)

	local var0 = arg0.contextData.plan_results or {}

	arg0.result = {}
	arg0.resResult = {}
	arg0.drops = {}

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg0) do
			table.insert(arg0.drops, iter1)

			if iter1.type == EducateConst.DROP_TYPE_ATTR then
				if not arg0.result[iter1.id] then
					arg0.result[iter1.id] = 0
				end

				arg0.result[iter1.id] = arg0.result[iter1.id] + iter1.number
			end

			if iter1.type == EducateConst.DROP_TYPE_RES then
				if not arg0.resResult[iter1.id] then
					arg0.resResult[iter1.id] = 0
				end

				arg0.resResult[iter1.id] = arg0.resResult[iter1.id] + iter1.number
			end
		end
	end

	for iter0, iter1 in ipairs(var0) do
		var1(iter1.plan_drops)
		var1(iter1.event_drops)
		var1(iter1.spec_event_drops)
	end

	arg0.char = getProxy(EducateProxy):GetCharData()
	arg0.natureIds = arg0.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_PERSONALITY)
	arg0.majorIds = arg0.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_MAJOR)
	arg0.minorIds = arg0.char:GetAttrIdsByType(EducateChar.ATTR_TYPE_MINOR)
	arg0.resIds = {
		EducateChar.RES_MOOD_ID,
		EducateChar.RES_MONEY_ID
	}

	arg0:updatePersonalPanel()
	arg0:updateMajorPanel()
	arg0:updateMinorPanel()
	arg0:updateResPanel()
end

function var0.updatePersonalPanel(arg0)
	local var0 = EducateHelper.IsShowNature()

	setActive(arg0.personalTF, var0)

	if var0 then
		local var1 = arg0:findTF("content", arg0.natureTF)

		for iter0, iter1 in ipairs(arg0.natureIds) do
			local var2 = arg0:findTF(tostring(iter1), arg0.personalTF)
			local var3 = arg0.char:GetAttrById(iter1)

			setText(arg0:findTF("old", var2), pg.child_attr[iter1].name .. " " .. var3)

			local var4 = arg0.result[iter1] or 0

			setActive(arg0:findTF("new", var2), var4 ~= 0)

			if var4 ~= 0 then
				local var5 = var4 > 0 and "39BFFF" or "FF6767"
				local var6 = var4 > 0 and "+" or ""

				setText(arg0:findTF("new", var2), var6 .. " " .. var4)
				setTextColor(arg0:findTF("new", var2), Color.NewHex(var5))
			end
		end
	end
end

function var0.updateMajorPanel(arg0)
	for iter0 = 1, arg0.majorArrTF.childCount do
		local var0 = arg0.majorArrTF:GetChild(iter0 - 1)
		local var1 = arg0.majorIds[iter0]

		GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var1, arg0:findTF("icon_bg/icon", var0), true)
		setScrollText(arg0:findTF("name_mask/name", var0), pg.child_attr[var1].name)

		local var2 = arg0.char:GetAttrInfo(var1)

		setText(arg0:findTF("grade/Text", var0), var2)

		local var3 = arg0.char:GetAttrById(var1)

		setText(arg0:findTF("value_old", var0), var3)

		local var4 = EducateConst.GRADE_2_COLOR[var2][1]
		local var5 = EducateConst.GRADE_2_COLOR[var2][2]

		setImageColor(arg0:findTF("gradient", var0), Color.NewHex(var4))
		setImageColor(arg0:findTF("grade", var0), Color.NewHex(var5))

		local var6 = arg0.result[var1] or 0
		local var7 = var6 == 0 and "39393C" or "39BFFF"

		setActive(arg0:findTF("VX", var0), var6 ~= 0)
		setImageColor(arg0:findTF("arrow", var0), Color.NewHex(var7))
		setText(arg0:findTF("value_new", var0), var3 + var6)
		setTextColor(arg0:findTF("value_new", var0), Color.NewHex(var7))
	end
end

function var0.updateMinorPanel(arg0)
	for iter0 = 1, arg0.minorArrTF.childCount do
		local var0 = arg0.minorArrTF:GetChild(iter0 - 1)
		local var1 = arg0.minorIds[iter0]

		GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "attr_" .. var1, arg0:findTF("icon", var0), true)
		setText(arg0:findTF("name", var0), pg.child_attr[var1].name)

		local var2 = arg0.char:GetAttrById(var1)

		setText(arg0:findTF("value_add/value_old", var0), var2)

		local var3 = arg0.result[var1] or 0

		setActive(arg0:findTF("VX", var0), var3 ~= 0)
		setText(arg0:findTF("value_add", var0), "")

		if var3 ~= 0 then
			onDelayTick(function()
				setText(arg0:findTF("value_add", var0), "+" .. var3)
			end, 0.891)
		end
	end
end

function var0.updateResPanel(arg0)
	for iter0 = 1, #arg0.resIds do
		local var0 = arg0.resTF:GetChild(iter0 - 1)
		local var1 = arg0.resIds[iter0]

		GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", "res_" .. var1, arg0:findTF("icon", var0), true)
		setText(arg0:findTF("name", var0), pg.child_resource[var1].name)

		local var2 = arg0.char:GetResById(var1)

		if var2 < 0 then
			var2 = 0
		end

		setText(arg0:findTF("value_add/value_old", var0), var2)

		local var3 = arg0.resResult[var1] or 0
		local var4 = var3 == 0 and "" or "+" .. var3

		setText(arg0:findTF("value_add", var0), var4)
	end
end

function var0._close(arg0)
	if arg0.inAnimPlaying then
		return
	end

	arg0.anim:Play("anim_educate_result_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	getProxy(EducateProxy):OnNextWeek()
	arg0.animEvent:SetEndEvent(nil)

	if arg0.drops then
		EducateHelper.UpdateDropsData(arg0.drops)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
