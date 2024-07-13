EventConst = require("view/event/EventConst")

local var0_0 = class("EventListItem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.dispatch = arg2_1
	arg0_1.bgNormal = arg0_1:findTF("bgNormal$").gameObject
	arg0_1.bgEmergence = arg0_1:findTF("bgEmergence$").gameObject
	arg0_1.timeLimit = arg0_1:findTF("timeLimit$").gameObject
	arg0_1.labelLimitTime = arg0_1:findTF("timeLimit$/labelLimitTime$"):GetComponent("Text")
	arg0_1.iconType = arg0_1:findTF("iconType$"):GetComponent("Image")
	arg0_1.iconState = arg0_1:findTF("iconState$")
	arg0_1.activityLimitBg = arg0_1:findTF("bgAct")
	arg0_1.shadow = arg0_1:findTF("Image"):GetComponent(typeof(Image))
	arg0_1.timerBg = arg0_1:findTF("labelTime$"):GetComponent(typeof(Image))
	arg0_1.label = arg0_1:findTF("labelName$/Image"):GetComponent(typeof(Text))
	arg0_1.labelLv = arg0_1:findTF("level/labelLv$"):GetComponent("Text")
	arg0_1.iconTip = arg0_1:findTF("iconTip$").gameObject
	arg0_1.labelName = arg0_1:findTF("labelName$"):GetComponent("Text")
	arg0_1.labelTime = arg0_1:findTF("labelTime$/Text"):GetComponent("Text")
	arg0_1.awardsTr = arg0_1:findTF("awards$")
	arg0_1.specialAward = arg0_1:findTF("specialAward/item")
	arg0_1.awardItem = arg0_1:findTF("awards$/item").gameObject
	arg0_1.mark = arg0_1:findTF("mark")

	SetActive(arg0_1.mark, false)

	arg0_1.ptBonus = EventPtBonus.New(arg0_1:findTF("bonusPt"))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.index = arg1_2
	arg0_2.event = arg2_2

	arg0_2:Flush()
end

function var0_0.UpdateTime(arg0_3)
	if not arg0_3.event then
		return
	end

	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_3.event.state == EventInfo.StateNone then
		arg0_3.labelTime.gameObject:SetActive(true)

		arg0_3.labelTime.text = pg.TimeMgr.GetInstance():DescCDTime(arg0_3.event.template.collect_time)
	elseif arg0_3.event.state == EventInfo.StateActive then
		arg0_3.labelTime.gameObject:SetActive(true)

		if var0_3 <= arg0_3.event.finishTime then
			arg0_3.labelTime.text = pg.TimeMgr.GetInstance():DescCDTime(arg0_3.event.finishTime - var0_3)
		else
			arg0_3.labelTime.text = "00:00:00"
		end
	elseif arg0_3.event.state == EventInfo.StateFinish then
		arg0_3.labelTime.gameObject:SetActive(false)
	end

	local var1_3 = arg0_3.event:GetCountDownTime()

	if var1_3 and var1_3 >= 0 then
		arg0_3.timeLimit:SetActive(true)

		arg0_3.labelLimitTime.text = pg.TimeMgr.GetInstance():DescCDTime(var1_3)
	else
		arg0_3.timeLimit:SetActive(false)
	end

	SetActive(arg0_3.mark, arg0_3.event.state == EventInfo.StateFinish)
end

function var0_0.Flush(arg0_4)
	arg0_4.bgNormal:SetActive(arg0_4.event.template.type ~= 2)
	arg0_4.bgEmergence:SetActive(arg0_4.event.template.type == 2)

	if arg0_4.event.state == EventInfo.StateFinish then
		arg0_4.iconTip:SetActive(true)
	else
		arg0_4.iconTip:SetActive(false)
	end

	LoadImageSpriteAsync("eventtype/" .. arg0_4.event.template.icon, arg0_4.iconType, true)

	local var0_4 = arg0_4.event:IsActivityType()

	arg0_4.iconType.transform.localScale = var0_4 and Vector3.one or Vector3(1.5, 1.5, 1.5)

	setActive(arg0_4.activityLimitBg, var0_4)
	setActive(arg0_4.shadow.gameObject, not var0_4)

	arg0_4.timerBg.color = var0_4 and Color.New(0, 0, 0, 0) or Color.New(1, 1, 1, 1)
	arg0_4.label.color = var0_4 and Color.New(0.941176470588235, 0.803921568627451, 1, 1) or Color.New(0.643137254901961, 0.811764705882353, 0.972549019607843, 1)

	eachChild(arg0_4.iconState, function(arg0_5)
		setActive(arg0_5, arg0_5.gameObject.name == tostring(arg0_4.event.state))
	end)

	arg0_4.labelLv.text = "" .. arg0_4.event.template.lv
	arg0_4.labelName.text = arg0_4.event.template.title

	local var1_4 = arg0_4.event.template.drop_display

	for iter0_4 = arg0_4.awardsTr.childCount, #var1_4 - 1 do
		Object.Instantiate(arg0_4.awardItem).transform:SetParent(arg0_4.awardsTr, false)
	end

	local var2_4 = arg0_4.awardsTr.childCount

	for iter1_4 = 0, var2_4 - 1 do
		local var3_4 = arg0_4.awardsTr:GetChild(iter1_4)

		if iter1_4 < #var1_4 then
			var3_4.gameObject:SetActive(true)

			local var4_4 = var1_4[iter1_4 + 1]

			updateDrop(var3_4, {
				type = var4_4.type,
				id = var4_4.id,
				count = var4_4.nums
			})
		else
			var3_4.gameObject:SetActive(false)
		end
	end

	local var5_4 = table.getCount(arg0_4.event.template.special_drop) ~= 0

	SetActive(arg0_4.specialAward, var5_4)

	if var5_4 then
		updateDrop(arg0_4.specialAward, {
			type = arg0_4.event.template.special_drop.type,
			id = arg0_4.event.template.special_drop.id
		})
	end
end

function var0_0.Clear(arg0_6)
	return
end

function var0_0.findTF(arg0_7, arg1_7)
	return findTF(arg0_7.tr, arg1_7)
end

return var0_0
