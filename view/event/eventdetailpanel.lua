EventConst = require("view/event/EventConst")

local var0_0 = class("EventDetailPanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.go = arg1_1
	arg0_1.tr = arg1_1.transform
	arg0_1.dispatch = arg2_1
	arg0_1.btn = arg0_1.tr:Find("btn").gameObject

	setText(findTF(arg0_1.tr, "btn_recommend/text"), pg.gametip.event_ui_recommend.tip)
	setText(findTF(arg0_1.tr, "btn_recommend_disable/text"), pg.gametip.event_ui_recommend.tip)
	setText(findTF(arg0_1.tr, "consume/label"), pg.gametip.event_ui_consume.tip)
	setText(findTF(arg0_1.tr, "btn/start/text"), pg.gametip.event_ui_start.tip)
	setText(findTF(arg0_1.tr, "btn_disable/text"), pg.gametip.event_ui_start.tip)
	setText(findTF(arg0_1.tr, "btn/giveup/text"), pg.gametip.event_ui_giveup.tip)
	setText(findTF(arg0_1.tr, "btn/finish/text"), pg.gametip.event_ui_finish.tip)

	arg0_1.conditions = findTF(arg0_1.tr, "conditions")
	arg0_1.condition1 = findTF(arg0_1.conditions, "condition_1/mask/Text")
	arg0_1.condition2 = findTF(arg0_1.conditions, "condition_2/mask/Text")
	arg0_1.condition3 = findTF(arg0_1.conditions, "condition_3/mask/Text")
	arg0_1.consume = arg0_1.tr:Find("consume/Text")
	arg0_1.leftShips = arg0_1.tr:Find("frame/ship_contain_left")
	arg0_1.rightShips = arg0_1.tr:Find("frame/ship_contain_right")
	arg0_1.disabeleBtn = arg0_1.tr:Find("btn_disable").gameObject
	arg0_1.recommentBtn = arg0_1.tr:Find("btn_recommend")
	arg0_1.recommentDisable = arg0_1.tr:Find("btn_recommend_disable")
	arg0_1.usePrevFormationBtn = arg0_1.tr:Find("use_prev_formation")
	arg0_1.shipItems = {}

	eachChild(arg0_1.leftShips, function(arg0_2)
		table.insert(arg0_1.shipItems, 1, arg0_2)
	end)
	eachChild(arg0_1.rightShips, function(arg0_3)
		table.insert(arg0_1.shipItems, 4, arg0_3)
	end)
	onButton(arg0_1, arg0_1.btn, function()
		arg0_1:onFuncClick()
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.recommentBtn, function()
		local var0_5 = getProxy(BayProxy)
		local var1_5 = var0_5:getDelegationRecommendShips(arg0_1.event)

		if #var1_5 > 0 then
			table.insertto(arg0_1.event.shipIds, var1_5)
			arg0_1:Flush()
		else
			local var2_5 = var0_5:getDelegationRecommendShipsLV1(arg0_1.event)

			if #var2_5 > 0 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("event_recommend_level1"),
					onYes = function()
						table.insertto(arg0_1.event.shipIds, var2_5)
						arg0_1:Flush()
					end
				})
			elseif not arg0_1.event:reachNum() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("event_recommend_fail"))
			end
		end
	end)
	onButton(arg0_1, arg0_1.usePrevFormationBtn, function()
		arg0_1:UsePrevFormation()
	end, SFX_PANEL)
end

function var0_0.Update(arg0_8, arg1_8, arg2_8)
	arg0_8.index = arg1_8
	arg0_8.event = arg2_8

	arg0_8:Flush()
end

function var0_0.UsePrevFormation(arg0_9)
	if arg0_9.event and arg0_9.event:ExistPrevFormation() then
		local var0_9 = arg0_9.event:GetPrevFormation()
		local var1_9 = {}
		local var2_9 = false
		local var3_9 = false

		for iter0_9, iter1_9 in ipairs(getProxy(BayProxy):getShipList(var0_9)) do
			if iter1_9 then
				local var4_9, var5_9 = ShipStatus.ShipStatusConflict("inEvent", iter1_9)

				if var4_9 == ShipStatus.STATE_CHANGE_FAIL then
					var2_9 = true
				elseif var4_9 == ShipStatus.STATE_CHANGE_CHECK then
					var3_9 = true
				else
					table.insert(var1_9, iter1_9.id)
				end
			end
		end

		if var2_9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collect_tip"))
		end

		if var3_9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collect_tip2"))
		end

		arg0_9.event:setShipIds(var1_9)
		arg0_9:Flush()
	end
end

function var0_0.Flush(arg0_10)
	setActive(arg0_10.usePrevFormationBtn, arg0_10.event:ExistPrevFormation() and arg0_10.event:GetState() == EventInfo.StateNone and arg0_10.event:CanRecordPrevFormation())
	eachChild(arg0_10.btn, function(arg0_11)
		local var0_11 = arg0_10.event:GetState()

		if var0_11 == EventInfo.StateNone and arg0_11.name == "start" then
			SetActive(arg0_11, true)
		elseif var0_11 == EventInfo.StateActive and arg0_11.name == "giveup" then
			SetActive(arg0_11, true)
		elseif var0_11 == EventInfo.StateFinish and arg0_11.name == "finish" then
			SetActive(arg0_11, true)
		else
			SetActive(arg0_11, false)
		end
	end)

	local var0_10 = arg0_10.event:reachLevel()
	local var1_10 = arg0_10.event:reachNum()
	local var2_10 = arg0_10.event:reachTypes()

	SetActive(arg0_10.disabeleBtn, not var0_10 or not var1_10 or not var2_10)

	local var3_10 = arg0_10.event:getShipList()
	local var4_10 = arg0_10.event.template
	local var5_10 = arg0_10:setConditionStr(i18n("event_condition_ship_level", var4_10.ship_lv), var0_10)

	setScrollText(arg0_10.condition1, var5_10)
	setActive(findTF(arg0_10.conditions, "condition_1/mark"), var0_10)
	setActive(findTF(arg0_10.conditions, "condition_1/mark1"), not var0_10)

	local var6_10 = arg0_10:setConditionStr(i18n("event_condition_ship_count", var4_10.ship_num), var1_10)

	setScrollText(arg0_10.condition2, var6_10)
	setActive(findTF(arg0_10.conditions, "condition_2/mark"), var1_10)
	setActive(findTF(arg0_10.conditions, "condition_2/mark1"), not var1_10)

	local var7_10 = arg0_10.event:getTypesStr()
	local var8_10 = arg0_10:setConditionStr(var7_10, var2_10)

	setScrollText(arg0_10.condition3, var8_10)
	setActive(findTF(arg0_10.conditions, "condition_3/mark"), var2_10)
	setActive(findTF(arg0_10.conditions, "condition_3/mark1"), not var2_10)
	setText(arg0_10.consume, arg0_10.event:getOilConsume())

	for iter0_10, iter1_10 in ipairs(arg0_10.shipItems) do
		local var9_10 = iter1_10:Find("shiptpl")
		local var10_10 = iter1_10:Find("emptytpl")
		local var11_10 = iter0_10 <= #var3_10

		SetActive(var9_10, var11_10)
		SetActive(var10_10, not var11_10)

		if var11_10 then
			updateShip(var9_10, var3_10[iter0_10], {
				initStar = true
			})
			setText(findTF(var9_10, "icon_bg/lv/Text"), var3_10[iter0_10].level)
			onButton(arg0_10, var9_10:Find("icon_bg"), function()
				arg0_10:onRemoveClick(iter0_10)
			end, SFX_PANEL)
		else
			onButton(arg0_10, var10_10, function()
				arg0_10:onChangeClick()
			end)
		end
	end

	if arg0_10.event:GetState() == EventInfo.StateNone then
		SetActive(arg0_10.recommentBtn, true)
		SetActive(arg0_10.recommentDisable, false)
	else
		SetActive(arg0_10.recommentBtn, false)
		SetActive(arg0_10.recommentDisable, true)
	end
end

function var0_0.setConditionStr(arg0_14, arg1_14, arg2_14)
	return arg2_14 and setColorStr(arg1_14, COLOR_YELLOW) or setColorStr(arg1_14, "#F35842FF")
end

function var0_0.Clear(arg0_15)
	pg.DelegateInfo.Dispose(arg0_15)
end

function var0_0.onChangeClick(arg0_16)
	if arg0_16.event:GetState() == EventInfo.StateNone then
		arg0_16.dispatch(EventConst.EVENT_OPEN_DOCK, arg0_16.event)
	end
end

function var0_0.onRemoveClick(arg0_17, arg1_17)
	if arg0_17.event:GetState() == EventInfo.StateNone then
		table.remove(arg0_17.event.shipIds, arg1_17)
		arg0_17:Flush()
	end
end

function var0_0.onFuncClick(arg0_18)
	local var0_18 = arg0_18.event:GetState()

	if var0_18 == EventInfo.StateNone then
		arg0_18.dispatch(EventConst.EVENT_START, arg0_18.event)
	elseif var0_18 == EventInfo.StateActive then
		arg0_18.dispatch(EventConst.EVENT_GIVEUP, arg0_18.event)
	elseif var0_18 == EventInfo.StateFinish then
		arg0_18.dispatch(EventConst.EVENT_FINISH, arg0_18.event)
	end
end

return var0_0
