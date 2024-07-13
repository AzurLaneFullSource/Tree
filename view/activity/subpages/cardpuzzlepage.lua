local var0_0 = class("CardPuzzlePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.titleTF = arg0_1:findTF("title", arg0_1.bg)
	arg0_1.progressTF = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.descTF = arg0_1:findTF("desc", arg0_1.bg)
	arg0_1.startBtn = arg0_1:findTF("start_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
	arg0_1.item = arg0_1:findTF("levels/tpl", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("levels", arg0_1.bg)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.levelList = arg0_2.activity:getConfig("config_data")[1]
	arg0_2.awardList = arg0_2.activity:getConfig("config_data")[2]
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.uilist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			arg0_3:InitItem(arg1_4, arg2_4)
		elseif arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_4, arg2_4)
		end
	end)
	onButton(arg0_3, arg0_3.startBtn, function()
		if not arg0_3.selectedId then
			return
		end

		arg0_3:emit(ActivityMediator.GO_CARDPUZZLE_COMBAT, arg0_3.selectedId)
	end, SFX_PANEL)

	arg0_3.selectedId = arg0_3:GetCurLevel()

	arg0_3:UpdateLevelInfo()
end

function var0_0.InitItem(arg0_6, arg1_6, arg2_6)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/cardpuzzlepage_atlas", arg1_6 + 1, arg0_6:findTF("normal/num", arg2_6), true)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/cardpuzzlepage_atlas", arg1_6 + 1, arg0_6:findTF("selected/num", arg2_6), true)
end

function var0_0.UpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7 + 1
	local var1_7 = arg0_7.levelList[var0_7]

	setActive(arg0_7:findTF("selected", arg2_7), arg0_7.selectedId == var1_7)

	local var2_7 = table.contains(arg0_7.finishList, var1_7)

	setActive(arg0_7:findTF("finish", arg2_7), var2_7)
	setActive(arg0_7:findTF("normal", arg2_7), not var2_7 and arg0_7.selectedId ~= var1_7)
	onButton(arg0_7, arg2_7, function()
		arg0_7.selectedId = var1_7

		arg0_7.uilist:align(#arg0_7.levelList)
		arg0_7:UpdateLevelInfo()
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_9)
	arg0_9.gotList = arg0_9.activity:getData1List()
	arg0_9.finishList = arg0_9.activity.data2_list

	arg0_9.uilist:align(#arg0_9.levelList)

	if arg0_9:CheckAward() then
		setActive(arg0_9.getBtn, true)
		onButton(arg0_9, arg0_9.getBtn, function()
			arg0_9:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 2,
				activity_id = arg0_9.activity.id,
				arg1 = arg0_9:CheckAward()
			})
		end, SFX_PANEL)
	else
		setActive(arg0_9.getBtn, false)
	end

	setActive(arg0_9.gotBtn, #arg0_9.gotList == #arg0_9.awardList)
	setText(arg0_9.progressTF, setColorStr(#arg0_9.finishList, "#C2FFF3") .. "/" .. #arg0_9.levelList)
	arg0_9:UpdateEveryDayTip()
end

function var0_0.CheckAward(arg0_11)
	if #arg0_11.gotList == #arg0_11.awardList then
		return nil
	end

	local var0_11 = #arg0_11.finishList

	for iter0_11, iter1_11 in ipairs(arg0_11.awardList) do
		if not table.contains(arg0_11.gotList, iter1_11[1]) and var0_11 >= iter1_11[1] then
			return iter1_11[1]
		end
	end

	return nil
end

function var0_0.UpdateLevelInfo(arg0_12)
	local var0_12 = pg.puzzle_combat_template[arg0_12.selectedId]

	setText(arg0_12.titleTF, "·" .. var0_12.name)
	setText(arg0_12.descTF, var0_12.description)
end

function var0_0.GetCurLevel(arg0_13)
	arg0_13.finishList = arg0_13.activity.data2_list

	for iter0_13, iter1_13 in ipairs(arg0_13.levelList) do
		if not table.contains(arg0_13.finishList, iter1_13) then
			return iter1_13, iter0_13
		end
	end

	return arg0_13.levelList[#arg0_13.levelList], #arg0_13.levelList
end

function var0_0.UpdateEveryDayTip(arg0_14)
	if #arg0_14.gotList == #arg0_14.awardList then
		return
	end

	if arg0_14:CheckAward() then
		return
	end

	local var0_14, var1_14 = arg0_14:GetCurLevel()
	local var2_14 = arg0_14:findTF("tip", arg0_14.items:GetChild(var1_14 - 1))
	local var3_14 = getProxy(PlayerProxy):getData().id
	local var4_14 = "DAY_TIP_" .. arg0_14.activity.id .. "_" .. var3_14 .. "_" .. arg0_14.activity:getDayIndex()

	if PlayerPrefs.GetInt(var4_14) == 0 then
		setActive(var2_14, true)
		PlayerPrefs.SetInt(var4_14, 1)
	else
		setActive(var2_14, false)
	end
end

return var0_0
