EventConst = require("view/event/EventConst")

local var0 = class("EventListItem")

function var0.Ctor(arg0, arg1, arg2)
	arg0.go = arg1
	arg0.tr = arg1.transform
	arg0.dispatch = arg2
	arg0.bgNormal = arg0:findTF("bgNormal$").gameObject
	arg0.bgEmergence = arg0:findTF("bgEmergence$").gameObject
	arg0.timeLimit = arg0:findTF("timeLimit$").gameObject
	arg0.labelLimitTime = arg0:findTF("timeLimit$/labelLimitTime$"):GetComponent("Text")
	arg0.iconType = arg0:findTF("iconType$"):GetComponent("Image")
	arg0.iconState = arg0:findTF("iconState$")
	arg0.activityLimitBg = arg0:findTF("bgAct")
	arg0.shadow = arg0:findTF("Image"):GetComponent(typeof(Image))
	arg0.timerBg = arg0:findTF("labelTime$"):GetComponent(typeof(Image))
	arg0.label = arg0:findTF("labelName$/Image"):GetComponent(typeof(Text))
	arg0.labelLv = arg0:findTF("level/labelLv$"):GetComponent("Text")
	arg0.iconTip = arg0:findTF("iconTip$").gameObject
	arg0.labelName = arg0:findTF("labelName$"):GetComponent("Text")
	arg0.labelTime = arg0:findTF("labelTime$/Text"):GetComponent("Text")
	arg0.awardsTr = arg0:findTF("awards$")
	arg0.specialAward = arg0:findTF("specialAward/item")
	arg0.awardItem = arg0:findTF("awards$/item").gameObject
	arg0.mark = arg0:findTF("mark")

	SetActive(arg0.mark, false)

	arg0.ptBonus = EventPtBonus.New(arg0:findTF("bonusPt"))
end

function var0.Update(arg0, arg1, arg2)
	arg0.index = arg1
	arg0.event = arg2

	arg0:Flush()
end

function var0.UpdateTime(arg0)
	if not arg0.event then
		return
	end

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0.event.state == EventInfo.StateNone then
		arg0.labelTime.gameObject:SetActive(true)

		arg0.labelTime.text = pg.TimeMgr.GetInstance():DescCDTime(arg0.event.template.collect_time)
	elseif arg0.event.state == EventInfo.StateActive then
		arg0.labelTime.gameObject:SetActive(true)

		if var0 <= arg0.event.finishTime then
			arg0.labelTime.text = pg.TimeMgr.GetInstance():DescCDTime(arg0.event.finishTime - var0)
		else
			arg0.labelTime.text = "00:00:00"
		end
	elseif arg0.event.state == EventInfo.StateFinish then
		arg0.labelTime.gameObject:SetActive(false)
	end

	local var1 = arg0.event:GetCountDownTime()

	if var1 and var1 >= 0 then
		arg0.timeLimit:SetActive(true)

		arg0.labelLimitTime.text = pg.TimeMgr.GetInstance():DescCDTime(var1)
	else
		arg0.timeLimit:SetActive(false)
	end

	SetActive(arg0.mark, arg0.event.state == EventInfo.StateFinish)
end

function var0.Flush(arg0)
	arg0.bgNormal:SetActive(arg0.event.template.type ~= 2)
	arg0.bgEmergence:SetActive(arg0.event.template.type == 2)

	if arg0.event.state == EventInfo.StateFinish then
		arg0.iconTip:SetActive(true)
	else
		arg0.iconTip:SetActive(false)
	end

	LoadImageSpriteAsync("eventtype/" .. arg0.event.template.icon, arg0.iconType, true)

	local var0 = arg0.event:IsActivityType()

	arg0.iconType.transform.localScale = var0 and Vector3.one or Vector3(1.5, 1.5, 1.5)

	setActive(arg0.activityLimitBg, var0)
	setActive(arg0.shadow.gameObject, not var0)

	arg0.timerBg.color = var0 and Color.New(0, 0, 0, 0) or Color.New(1, 1, 1, 1)
	arg0.label.color = var0 and Color.New(0.941176470588235, 0.803921568627451, 1, 1) or Color.New(0.643137254901961, 0.811764705882353, 0.972549019607843, 1)

	eachChild(arg0.iconState, function(arg0)
		setActive(arg0, arg0.gameObject.name == tostring(arg0.event.state))
	end)

	arg0.labelLv.text = "" .. arg0.event.template.lv
	arg0.labelName.text = arg0.event.template.title

	local var1 = arg0.event.template.drop_display

	for iter0 = arg0.awardsTr.childCount, #var1 - 1 do
		Object.Instantiate(arg0.awardItem).transform:SetParent(arg0.awardsTr, false)
	end

	local var2 = arg0.awardsTr.childCount

	for iter1 = 0, var2 - 1 do
		local var3 = arg0.awardsTr:GetChild(iter1)

		if iter1 < #var1 then
			var3.gameObject:SetActive(true)

			local var4 = var1[iter1 + 1]

			updateDrop(var3, {
				type = var4.type,
				id = var4.id,
				count = var4.nums
			})
		else
			var3.gameObject:SetActive(false)
		end
	end

	local var5 = table.getCount(arg0.event.template.special_drop) ~= 0

	SetActive(arg0.specialAward, var5)

	if var5 then
		updateDrop(arg0.specialAward, {
			type = arg0.event.template.special_drop.type,
			id = arg0.event.template.special_drop.id
		})
	end
end

function var0.Clear(arg0)
	return
end

function var0.findTF(arg0, arg1)
	return findTF(arg0.tr, arg1)
end

return var0
