local var0 = class("IdolPTPage", import(".TemplatePage.PtTemplatePage"))

var0.RefreshTime = 300

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.lableList = arg0:findTF("list", arg0.bg)
	arg0.lableItems = {}

	for iter0 = 0, arg0.lableList.childCount - 1 do
		table.insert(arg0.lableItems, arg0.lableList:GetChild(iter0))
	end

	arg0.linkBtn = arg0:findTF("btn_link", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = var0.super.OnDataSetting(arg0)
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

	arg0.linkAct = var1

	if var1 and not var1:isEnd() then
		local var2 = getProxy(ActivityProxy).requestTime[var1.id]
		local var3 = pg.TimeMgr.GetInstance():GetServerTime() - (var2 or 0) >= arg0.RefreshTime

		if var3 then
			arg0:emit(ActivityMediator.FETCH_INSTARGRAM, {
				activity_id = var1.id
			})
		end

		return var3 or var0
	end

	return var0
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.displayBtn, function()
		arg0:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0.ptData.type,
			dropList = arg0.ptData.dropList,
			targets = arg0.ptData.targets,
			level = arg0.ptData.level,
			count = arg0.ptData.count,
			resId = arg0.ptData.resId
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		local var0, var1 = arg0.ptData:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0.ptData:GetId(),
			arg1 = var1
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.linkBtn, function()
		if arg0.linkAct and not arg0.linkAct:isEnd() and arg0.linkAct:ExistMsg() then
			arg0:emit(ActivityMediator.OPEN_LAYER, Context.New({
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

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0 = arg0.linkAct

	if var0 and not var0:isEnd() then
		local var1 = {}
		local var2 = math.floor(#var0.data1_list / 2)

		for iter0 = 1, var2 do
			local var3 = var0.data1_list[2 * iter0 - 1]

			var1[var3] = (var1[var3] or 0) + (var0.data1_list[2 * iter0] or 0)
		end

		local var4 = {}

		for iter1, iter2 in pairs(var1) do
			table.insert(var4, {
				name = iter1,
				count = iter2
			})
		end

		table.sort(var4, function(arg0, arg1)
			if arg0.count == arg1.count then
				return arg0.name < arg1.name
			else
				return arg0.count > arg1.count
			end
		end)

		local var5 = math.min(#var4, #arg0.lableItems)

		for iter3 = 1, var5 do
			local var6 = arg0.lableItems[iter3]

			setText(var6:Find("name"), "#" .. tostring(ShipGroup.getDefaultShipNameByGroupID(var4[iter3].name)) .. "#")
			setText(var6:Find("Text"), arg0:TransFormat(var4[iter3].count))
		end

		for iter4 = var5 + 1, #arg0.lableItems do
			local var7 = arg0.lableItems[iter4]

			setText(var7:Find("name"), "")
			setText(var7:Find("Text"), "0")
		end
	end

	arg0:GetWorldRank(arg0.RefreshTime)
end

function var0.TransFormat(arg0, arg1)
	arg1 = tonumber(arg1) or 0

	local var0 = math.floor(arg1 / 1000)
	local var1 = arg1 % 10

	if var0 >= 1 then
		return var0 .. (var1 > 0 and "." .. var1 or "") .. "K"
	else
		return arg1
	end
end

function var0.GetWorldRank(arg0, arg1)
	if not arg0.linkAct or arg0.linkAct:isEnd() then
		return
	end

	local var0 = arg0.linkAct.id

	if arg1 <= pg.TimeMgr.GetInstance():GetServerTime() - (getProxy(ActivityProxy).requestTime[var0] or 0) then
		arg0:emit(ActivityMediator.FETCH_INSTARGRAM, {
			activity_id = var0
		})
	end
end

function var0.NeedTip()
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.IDOL_PT_ID)

	if var0 and not var0:isEnd() then
		return var0:readyToAchieve()
	end
end

return var0
