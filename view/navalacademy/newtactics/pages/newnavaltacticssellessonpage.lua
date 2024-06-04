local var0 = class("NewNavalTacticsSelLessonPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewNavalTacticsLessonPage"
end

function var0.OnLoaded(arg0)
	arg0.skillPanel = arg0:findTF("skill")
	arg0.cancelBtn = arg0:findTF("cancel_btn")
	arg0.confirmBtn = arg0:findTF("confirm_btn")
	arg0.toggleGroup = arg0:findTF("items"):GetComponent(typeof(ToggleGroup))
	arg0.lessonNameTxt = arg0:findTF("introl/name"):GetComponent(typeof(Text))
	arg0.lessonDescTxt = arg0:findTF("introl/desc"):GetComponent(typeof(Text))
	arg0.lessonExpTxt = arg0:findTF("introl/exp_Text"):GetComponent(typeof(Text))
	arg0.lessonTimeTxt = arg0:findTF("introl/timer_Text"):GetComponent(typeof(Text))
	arg0.skillCard = NewNavalTacticsAdditionSkillCard.New(arg0:findTF("skill/info"))
	arg0.itemTpls = {
		arg0:findTF("items/scorll/content/item")
	}
	arg0.startPos = arg0.itemTpls[1].anchoredPosition
	arg0.space = Vector2(60, 30)
	arg0.cloumnCnt = 6

	setText(arg0:findTF("introl/exp_label"), i18n("tactics_class_get_exp"))
	setText(arg0:findTF("introl/timer_label"), i18n("tactics_class_spend_time"))
	setText(arg0.confirmBtn:Find("Image"), i18n("tactics_class_start"))
	setText(arg0.cancelBtn:Find("Image"), i18n("tactics_class_cancel"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Cancel()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if not arg0.selLessonId or not arg0.spendTime then
			return
		end

		arg0.student:setLesson(arg0.selLessonId)
		arg0.student:setTime(arg0.spendTime)
		arg0:emit(NewNavalTacticsLayer.ON_LESSON_SELECTED, arg0.student)
	end, SFX_PANEL)
	onButton(arg0, arg0.skillPanel, function()
		if not arg0.canBack then
			return
		end

		arg0:emit(NewNavalTacticsLayer.ON_RESEL_SKILL, arg0.student)
	end, SFX_PANEL)
end

function var0.SetHideCallback(arg0, arg1)
	arg0.hideCallback = arg1
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)

	arg0.canBack = defaultValue(arg2, true)

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	if arg1 ~= arg0.student then
		arg0.selLessonId = nil
		arg0.spendTime = nil
		arg0.student = arg1

		arg0:Flush()
	else
		arg0:Flush()
	end
end

function var0.Cancel(arg0)
	arg0:emit(NewNavalTacticsMediator.ON_CANCEL_ADD_STUDENT)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)

	if arg0.hideCallback then
		arg0.hideCallback()

		arg0.hideCallback = nil
	end
end

function var0.Flush(arg0)
	local var0 = arg0.student
	local var1 = getProxy(BayProxy):RawGetShipById(var0.shipId)
	local var2 = var0:getSkillId(var1)

	arg0:UpdateLessons(var2, var1)
end

function var0.GetLessons(arg0)
	local var0 = getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE)

	table.sort(var0, function(arg0, arg1)
		local var0 = arg0:getConfig("rarity")
		local var1 = arg1:getConfig("rarity")

		if var0 == var1 then
			return arg0.id < arg1.id
		else
			return var1 < var0
		end
	end)

	return var0
end

function var0.UpdateLessons(arg0, arg1, arg2)
	local var0 = arg0:GetLessons()

	for iter0 = 1, #var0 do
		local var1 = arg0.itemTpls[iter0]

		if not var1 then
			local var2 = arg0.itemTpls[1]

			var1 = Object.Instantiate(var2.gameObject, var2.parent).transform
			arg0.itemTpls[iter0] = var1
		end

		setActive(var1, true)
		arg0:UpdateLesson(var1, var0[iter0], arg1, arg2)
	end

	for iter1 = #arg0.itemTpls, #var0 + 1, -1 do
		setActive(arg0.itemTpls[iter1], false)
	end

	if #var0 > 0 then
		arg0.toggleGroup:SetAllTogglesOff()
		triggerToggle(arg0.itemTpls[1], true)
	end
end

function var0.UpdateLesson(arg0, arg1, arg2, arg3, arg4)
	updateItem(arg1, Item.New({
		id = arg2.id,
		count = arg2.count
	}))
	setText(arg1:Find("icon_bg/count"), arg2.count)

	local var0 = Item.getConfigData(arg2.id)
	local var1 = var0.usage_arg[1]
	local var2 = 100

	if pg.skill_data_template[arg3].type == var0.usage_arg[3] then
		var2 = var2 + var0.usage_arg[4]
	end

	local var3 = var0.usage_arg[2] * (var2 / 100)

	onToggle(arg0, arg1, function(arg0)
		if arg0 then
			arg0.selLessonId = arg2.id
			arg0.spendTime = var1

			arg0:UpdateLessonDesc(arg2.id, var3, var1)
			arg0:UpdateSkill(arg3, var3, arg4)
		end
	end, SFX_PANEL)

	local var4 = var2 == 100 and "" or "EXP" .. var2 .. "%"

	setText(arg1:Find("addition"), var4)
end

function var0.UpdatePosition(arg0, arg1, arg2)
	local var0 = math.ceil(arg2 / arg0.cloumnCnt)
	local var1 = arg2 % arg0.cloumnCnt

	if var1 == 0 then
		var1 = arg0.cloumnCnt
	end

	local var2 = arg0.startPos.y - (var0 - 1) * (arg1.sizeDelta.y + arg0.space.y)
	local var3 = arg0.startPos.x + (var1 - 1) * (arg1.sizeDelta.x + arg0.space.x)

	arg1.anchoredPosition = Vector2(var3, var2)
end

function var0.UpdateLessonDesc(arg0, arg1, arg2, arg3)
	local var0 = Item.getConfigData(arg1)

	arg0.lessonNameTxt.text = var0.name .. "   -"
	arg0.lessonDescTxt.text = var0.display
	arg0.lessonExpTxt.text = arg2
	arg0.lessonTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(arg3)
end

function var0.UpdateSkill(arg0, arg1, arg2, arg3)
	local var0 = ShipSkill.New(arg3.skills[arg1], arg3.id)

	arg0.skillCard:Update(var0, arg2)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end

	arg0.skillCard:Dispose()

	arg0.skillCard = nil
end

return var0
