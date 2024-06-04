EventConst = require("view/event/EventConst")

local var0 = class("EventDetailPanel")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.go = arg1
	arg0.tr = arg1.transform
	arg0.dispatch = arg2
	arg0.btn = arg0:findTF("btn").gameObject

	setText(findTF(arg0.tr, "btn_recommend/text"), pg.gametip.event_ui_recommend.tip)
	setText(findTF(arg0.tr, "btn_recommend_disable/text"), pg.gametip.event_ui_recommend.tip)
	setText(findTF(arg0.tr, "consume/label"), pg.gametip.event_ui_consume.tip)
	setText(findTF(arg0.tr, "btn/start/text"), pg.gametip.event_ui_start.tip)
	setText(findTF(arg0.tr, "btn_disable/text"), pg.gametip.event_ui_start.tip)
	setText(findTF(arg0.tr, "btn/giveup/text"), pg.gametip.event_ui_giveup.tip)
	setText(findTF(arg0.tr, "btn/finish/text"), pg.gametip.event_ui_finish.tip)

	arg0.conditions = findTF(arg0.tr, "conditions")
	arg0.condition1 = findTF(arg0.conditions, "condition_1/mask/Text")
	arg0.condition2 = findTF(arg0.conditions, "condition_2/mask/Text")
	arg0.condition3 = findTF(arg0.conditions, "condition_3/mask/Text")
	arg0.consume = arg0:findTF("consume/Text")
	arg0.leftShips = arg0:findTF("frame/ship_contain_left")
	arg0.rightShips = arg0:findTF("frame/ship_contain_right")
	arg0.disabeleBtn = arg0:findTF("btn_disable").gameObject
	arg0.recommentBtn = arg0:findTF("btn_recommend")
	arg0.recommentDisable = arg0:findTF("btn_recommend_disable")
	arg0.usePrevFormationBtn = arg0:findTF("use_prev_formation")
	arg0.shipItems = {}

	eachChild(arg0.leftShips, function(arg0)
		table.insert(arg0.shipItems, 1, arg0)
	end)
	eachChild(arg0.rightShips, function(arg0)
		table.insert(arg0.shipItems, 4, arg0)
	end)
	onButton(arg0, arg0.btn, function()
		arg0:onFuncClick()
	end, SFX_PANEL)
	onButton(arg0, arg0.recommentBtn, function()
		local var0 = getProxy(BayProxy)
		local var1 = var0:getDelegationRecommendShips(arg0.event)
		local var2 = var0:getDelegationRecommendShipsLV1(arg0.event)

		if #var1 == 0 and #var2 > 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("event_recommend_level1"),
				onYes = function()
					arg0.dispatch(EventConst.EVENT_RECOMMEND_LEVEL1, arg0.event)
				end
			})
		else
			arg0.dispatch(EventConst.EVENT_RECOMMEND, arg0.event)
		end
	end)
	onButton(arg0, arg0.usePrevFormationBtn, function()
		arg0:UsePrevFormation()
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1, arg2)
	arg0.index = arg1
	arg0.event = arg2

	arg0:Flush()
end

function var0.UsePrevFormation(arg0)
	if arg0.event and arg0.event:ExistPrevFormation() then
		local var0 = arg0.event:GetPrevFormation()

		arg0.dispatch(EventConst.EVEN_USE_PREV_FORMATION, arg0.event, var0)
	end
end

function var0.Flush(arg0)
	setActive(arg0.usePrevFormationBtn, arg0.event:ExistPrevFormation() and arg0.event.state == EventInfo.StateNone and arg0.event:CanRecordPrevFormation())
	eachChild(arg0.btn, function(arg0)
		if arg0.event.state == EventInfo.StateNone and arg0.name == "start" then
			SetActive(arg0, true)
		elseif arg0.event.state == EventInfo.StateActive and arg0.name == "giveup" then
			SetActive(arg0, true)
		elseif arg0.event.state == EventInfo.StateFinish and arg0.name == "finish" then
			SetActive(arg0, true)
		else
			SetActive(arg0, false)
		end
	end)

	local var0 = arg0.event:reachLevel()
	local var1 = arg0.event:reachNum()
	local var2 = arg0.event:reachTypes()

	SetActive(arg0.disabeleBtn, not var0 or not var1 or not var2)

	local var3 = arg0.event.ships
	local var4 = arg0.event.template
	local var5 = arg0:setConditionStr(i18n("event_condition_ship_level", var4.ship_lv), var0)

	setScrollText(arg0.condition1, var5)
	setActive(findTF(arg0.conditions, "condition_1/mark"), var0)
	setActive(findTF(arg0.conditions, "condition_1/mark1"), not var0)

	local var6 = arg0:setConditionStr(i18n("event_condition_ship_count", var4.ship_num), var1)

	setScrollText(arg0.condition2, var6)
	setActive(findTF(arg0.conditions, "condition_2/mark"), var1)
	setActive(findTF(arg0.conditions, "condition_2/mark1"), not var1)

	local var7 = arg0.event:getTypesStr()
	local var8 = arg0:setConditionStr(var7, var2)

	setScrollText(arg0.condition3, var8)
	setActive(findTF(arg0.conditions, "condition_3/mark"), var2)
	setActive(findTF(arg0.conditions, "condition_3/mark1"), not var2)
	setText(arg0.consume, arg0.event:getOilConsume())

	for iter0, iter1 in ipairs(arg0.shipItems) do
		local var9 = iter1:Find("shiptpl")
		local var10 = iter1:Find("emptytpl")
		local var11 = iter0 <= #var3

		SetActive(var9, var11)
		SetActive(var10, not var11)

		if var11 then
			updateShip(var9, var3[iter0], {
				initStar = true
			})
			setText(findTF(var9, "icon_bg/lv/Text"), var3[iter0].level)
			onButton(arg0, var9:Find("icon_bg"), function()
				arg0:onRemoveClick(iter0)
			end, SFX_PANEL)
		else
			onButton(arg0, var10, function()
				arg0:onChangeClick()
			end)
		end
	end

	if arg0.event.state == EventInfo.StateNone then
		SetActive(arg0.recommentBtn, true)
		SetActive(arg0.recommentDisable, false)
	else
		SetActive(arg0.recommentBtn, false)
		SetActive(arg0.recommentDisable, true)
	end
end

function var0.setConditionStr(arg0, arg1, arg2)
	return arg2 and setColorStr(arg1, COLOR_YELLOW) or setColorStr(arg1, "#F35842FF")
end

function var0.Clear(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

function var0.onChangeClick(arg0)
	if arg0.event.state == EventInfo.StateNone then
		arg0.dispatch(EventConst.EVENT_OPEN_DOCK, arg0.event)
	end
end

function var0.onRemoveClick(arg0, arg1)
	if arg0.event.state == EventInfo.StateNone then
		table.remove(arg0.event.shipIds, arg1)
		table.remove(arg0.event.ships, arg1)
		arg0:Flush()
	end
end

function var0.onFuncClick(arg0)
	if arg0.event.state == EventInfo.StateNone then
		arg0.dispatch(EventConst.EVENT_START, arg0.event)
	elseif arg0.event.state == EventInfo.StateActive then
		arg0.dispatch(EventConst.EVENT_GIVEUP, arg0.event)
	elseif arg0.event.state == EventInfo.StateFinish then
		arg0.dispatch(EventConst.EVENT_FINISH, arg0.event)
	end
end

function var0.findTF(arg0, arg1)
	return findTF(arg0.tr, arg1)
end

return var0
