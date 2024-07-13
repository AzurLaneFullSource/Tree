local var0_0 = class("IdolPTPage", import(".TemplatePage.PtTemplatePage"))

var0_0.RefreshTime = 300

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.lableList = arg0_1:findTF("list", arg0_1.bg)
	arg0_1.lableItems = {}

	for iter0_1 = 0, arg0_1.lableList.childCount - 1 do
		table.insert(arg0_1.lableItems, arg0_1.lableList:GetChild(iter0_1))
	end

	arg0_1.linkBtn = arg0_1:findTF("btn_link", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = var0_0.super.OnDataSetting(arg0_2)
	local var1_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

	arg0_2.linkAct = var1_2

	if var1_2 and not var1_2:isEnd() then
		local var2_2 = getProxy(ActivityProxy).requestTime[var1_2.id]
		local var3_2 = pg.TimeMgr.GetInstance():GetServerTime() - (var2_2 or 0) >= arg0_2.RefreshTime

		if var3_2 then
			arg0_2:emit(ActivityMediator.FETCH_INSTARGRAM, {
				activity_id = var1_2.id
			})
		end

		return var3_2 or var0_2
	end

	return var0_2
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.displayBtn, function()
		arg0_3:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0_3.ptData.type,
			dropList = arg0_3.ptData.dropList,
			targets = arg0_3.ptData.targets,
			level = arg0_3.ptData.level,
			count = arg0_3.ptData.count,
			resId = arg0_3.ptData.resId
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		local var0_6, var1_6 = arg0_3.ptData:GetResProgress()

		arg0_3:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_3.ptData:GetId(),
			arg1 = var1_6
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.linkBtn, function()
		if arg0_3.linkAct and not arg0_3.linkAct:isEnd() and arg0_3.linkAct:ExistMsg() then
			arg0_3:emit(ActivityMediator.OPEN_LAYER, Context.New({
				viewComponent = InstagramLayer,
				mediator = InstagramMediator,
				data = {
					id = ActivityConst.IDOL_INS_ID
				}
			}))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_8)
	var0_0.super.OnUpdateFlush(arg0_8)

	local var0_8 = arg0_8.linkAct

	if var0_8 and not var0_8:isEnd() then
		local var1_8 = {}
		local var2_8 = math.floor(#var0_8.data1_list / 2)

		for iter0_8 = 1, var2_8 do
			local var3_8 = var0_8.data1_list[2 * iter0_8 - 1]

			var1_8[var3_8] = (var1_8[var3_8] or 0) + (var0_8.data1_list[2 * iter0_8] or 0)
		end

		local var4_8 = {}

		for iter1_8, iter2_8 in pairs(var1_8) do
			table.insert(var4_8, {
				name = iter1_8,
				count = iter2_8
			})
		end

		table.sort(var4_8, function(arg0_9, arg1_9)
			if arg0_9.count == arg1_9.count then
				return arg0_9.name < arg1_9.name
			else
				return arg0_9.count > arg1_9.count
			end
		end)

		local var5_8 = math.min(#var4_8, #arg0_8.lableItems)

		for iter3_8 = 1, var5_8 do
			local var6_8 = arg0_8.lableItems[iter3_8]

			setText(var6_8:Find("name"), "#" .. tostring(ShipGroup.getDefaultShipNameByGroupID(var4_8[iter3_8].name)) .. "#")
			setText(var6_8:Find("Text"), arg0_8:TransFormat(var4_8[iter3_8].count))
		end

		for iter4_8 = var5_8 + 1, #arg0_8.lableItems do
			local var7_8 = arg0_8.lableItems[iter4_8]

			setText(var7_8:Find("name"), "")
			setText(var7_8:Find("Text"), "0")
		end
	end

	arg0_8:GetWorldRank(arg0_8.RefreshTime)
end

function var0_0.TransFormat(arg0_10, arg1_10)
	arg1_10 = tonumber(arg1_10) or 0

	local var0_10 = math.floor(arg1_10 / 1000)
	local var1_10 = arg1_10 % 10

	if var0_10 >= 1 then
		return var0_10 .. (var1_10 > 0 and "." .. var1_10 or "") .. "K"
	else
		return arg1_10
	end
end

function var0_0.GetWorldRank(arg0_11, arg1_11)
	if not arg0_11.linkAct or arg0_11.linkAct:isEnd() then
		return
	end

	local var0_11 = arg0_11.linkAct.id

	if arg1_11 <= pg.TimeMgr.GetInstance():GetServerTime() - (getProxy(ActivityProxy).requestTime[var0_11] or 0) then
		arg0_11:emit(ActivityMediator.FETCH_INSTARGRAM, {
			activity_id = var0_11
		})
	end
end

function var0_0.NeedTip()
	local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.IDOL_PT_ID)

	if var0_12 and not var0_12:isEnd() then
		return var0_12:readyToAchieve()
	end
end

return var0_0
