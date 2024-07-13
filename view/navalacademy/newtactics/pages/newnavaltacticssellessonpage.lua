local var0_0 = class("NewNavalTacticsSelLessonPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewNavalTacticsLessonPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.skillPanel = arg0_2:findTF("skill")
	arg0_2.cancelBtn = arg0_2:findTF("cancel_btn")
	arg0_2.confirmBtn = arg0_2:findTF("confirm_btn")
	arg0_2.toggleGroup = arg0_2:findTF("items"):GetComponent(typeof(ToggleGroup))
	arg0_2.lessonNameTxt = arg0_2:findTF("introl/name"):GetComponent(typeof(Text))
	arg0_2.lessonDescTxt = arg0_2:findTF("introl/desc"):GetComponent(typeof(Text))
	arg0_2.lessonExpTxt = arg0_2:findTF("introl/exp_Text"):GetComponent(typeof(Text))
	arg0_2.lessonTimeTxt = arg0_2:findTF("introl/timer_Text"):GetComponent(typeof(Text))
	arg0_2.skillCard = NewNavalTacticsAdditionSkillCard.New(arg0_2:findTF("skill/info"))
	arg0_2.itemTpls = {
		arg0_2:findTF("items/scorll/content/item")
	}
	arg0_2.startPos = arg0_2.itemTpls[1].anchoredPosition
	arg0_2.space = Vector2(60, 30)
	arg0_2.cloumnCnt = 6

	setText(arg0_2:findTF("introl/exp_label"), i18n("tactics_class_get_exp"))
	setText(arg0_2:findTF("introl/timer_label"), i18n("tactics_class_spend_time"))
	setText(arg0_2.confirmBtn:Find("Image"), i18n("tactics_class_start"))
	setText(arg0_2.cancelBtn:Find("Image"), i18n("tactics_class_cancel"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Cancel()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if not arg0_3.selLessonId or not arg0_3.spendTime then
			return
		end

		arg0_3.student:setLesson(arg0_3.selLessonId)
		arg0_3.student:setTime(arg0_3.spendTime)
		arg0_3:emit(NewNavalTacticsLayer.ON_LESSON_SELECTED, arg0_3.student)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.skillPanel, function()
		if not arg0_3.canBack then
			return
		end

		arg0_3:emit(NewNavalTacticsLayer.ON_RESEL_SKILL, arg0_3.student)
	end, SFX_PANEL)
end

function var0_0.SetHideCallback(arg0_7, arg1_7)
	arg0_7.hideCallback = arg1_7
end

function var0_0.Show(arg0_8, arg1_8, arg2_8)
	var0_0.super.Show(arg0_8)

	arg0_8.canBack = defaultValue(arg2_8, true)

	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)

	if arg1_8 ~= arg0_8.student then
		arg0_8.selLessonId = nil
		arg0_8.spendTime = nil
		arg0_8.student = arg1_8

		arg0_8:Flush()
	else
		arg0_8:Flush()
	end
end

function var0_0.Cancel(arg0_9)
	arg0_9:emit(NewNavalTacticsMediator.ON_CANCEL_ADD_STUDENT)
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, pg.UIMgr.GetInstance().UIMain)

	if arg0_10.hideCallback then
		arg0_10.hideCallback()

		arg0_10.hideCallback = nil
	end
end

function var0_0.Flush(arg0_11)
	local var0_11 = arg0_11.student
	local var1_11 = getProxy(BayProxy):RawGetShipById(var0_11.shipId)
	local var2_11 = var0_11:getSkillId(var1_11)

	arg0_11:UpdateLessons(var2_11, var1_11)
end

function var0_0.GetLessons(arg0_12)
	local var0_12 = getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE)

	table.sort(var0_12, function(arg0_13, arg1_13)
		local var0_13 = arg0_13:getConfig("rarity")
		local var1_13 = arg1_13:getConfig("rarity")

		if var0_13 == var1_13 then
			return arg0_13.id < arg1_13.id
		else
			return var1_13 < var0_13
		end
	end)

	return var0_12
end

function var0_0.UpdateLessons(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14:GetLessons()

	for iter0_14 = 1, #var0_14 do
		local var1_14 = arg0_14.itemTpls[iter0_14]

		if not var1_14 then
			local var2_14 = arg0_14.itemTpls[1]

			var1_14 = Object.Instantiate(var2_14.gameObject, var2_14.parent).transform
			arg0_14.itemTpls[iter0_14] = var1_14
		end

		setActive(var1_14, true)
		arg0_14:UpdateLesson(var1_14, var0_14[iter0_14], arg1_14, arg2_14)
	end

	for iter1_14 = #arg0_14.itemTpls, #var0_14 + 1, -1 do
		setActive(arg0_14.itemTpls[iter1_14], false)
	end

	if #var0_14 > 0 then
		arg0_14.toggleGroup:SetAllTogglesOff()
		triggerToggle(arg0_14.itemTpls[1], true)
	end
end

function var0_0.UpdateLesson(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	updateItem(arg1_15, Item.New({
		id = arg2_15.id,
		count = arg2_15.count
	}))
	setText(arg1_15:Find("icon_bg/count"), arg2_15.count)

	local var0_15 = Item.getConfigData(arg2_15.id)
	local var1_15 = var0_15.usage_arg[1]
	local var2_15 = 100

	if pg.skill_data_template[arg3_15].type == var0_15.usage_arg[3] then
		var2_15 = var2_15 + var0_15.usage_arg[4]
	end

	local var3_15 = var0_15.usage_arg[2] * (var2_15 / 100)

	onToggle(arg0_15, arg1_15, function(arg0_16)
		if arg0_16 then
			arg0_15.selLessonId = arg2_15.id
			arg0_15.spendTime = var1_15

			arg0_15:UpdateLessonDesc(arg2_15.id, var3_15, var1_15)
			arg0_15:UpdateSkill(arg3_15, var3_15, arg4_15)
		end
	end, SFX_PANEL)

	local var4_15 = var2_15 == 100 and "" or "EXP" .. var2_15 .. "%"

	setText(arg1_15:Find("addition"), var4_15)
end

function var0_0.UpdatePosition(arg0_17, arg1_17, arg2_17)
	local var0_17 = math.ceil(arg2_17 / arg0_17.cloumnCnt)
	local var1_17 = arg2_17 % arg0_17.cloumnCnt

	if var1_17 == 0 then
		var1_17 = arg0_17.cloumnCnt
	end

	local var2_17 = arg0_17.startPos.y - (var0_17 - 1) * (arg1_17.sizeDelta.y + arg0_17.space.y)
	local var3_17 = arg0_17.startPos.x + (var1_17 - 1) * (arg1_17.sizeDelta.x + arg0_17.space.x)

	arg1_17.anchoredPosition = Vector2(var3_17, var2_17)
end

function var0_0.UpdateLessonDesc(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = Item.getConfigData(arg1_18)

	arg0_18.lessonNameTxt.text = var0_18.name .. "   -"
	arg0_18.lessonDescTxt.text = var0_18.display
	arg0_18.lessonExpTxt.text = arg2_18
	arg0_18.lessonTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(arg3_18)
end

function var0_0.UpdateSkill(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = ShipSkill.New(arg3_19.skills[arg1_19], arg3_19.id)

	arg0_19.skillCard:Update(var0_19, arg2_19)
end

function var0_0.OnDestroy(arg0_20)
	if arg0_20:isShowing() then
		arg0_20:Hide()
	end

	arg0_20.skillCard:Dispose()

	arg0_20.skillCard = nil
end

return var0_0
