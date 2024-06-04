local var0 = class("CardPuzzlePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.titleTF = arg0:findTF("title", arg0.bg)
	arg0.progressTF = arg0:findTF("progress", arg0.bg)
	arg0.descTF = arg0:findTF("desc", arg0.bg)
	arg0.startBtn = arg0:findTF("start_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
	arg0.item = arg0:findTF("levels/tpl", arg0.bg)
	arg0.items = arg0:findTF("levels", arg0.bg)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)
end

function var0.OnDataSetting(arg0)
	arg0.levelList = arg0.activity:getConfig("config_data")[1]
	arg0.awardList = arg0.activity:getConfig("config_data")[2]
end

function var0.OnFirstFlush(arg0)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			arg0:InitItem(arg1, arg2)
		elseif arg0 == UIItemList.EventUpdate then
			arg0:UpdateItem(arg1, arg2)
		end
	end)
	onButton(arg0, arg0.startBtn, function()
		if not arg0.selectedId then
			return
		end

		arg0:emit(ActivityMediator.GO_CARDPUZZLE_COMBAT, arg0.selectedId)
	end, SFX_PANEL)

	arg0.selectedId = arg0:GetCurLevel()

	arg0:UpdateLevelInfo()
end

function var0.InitItem(arg0, arg1, arg2)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/cardpuzzlepage_atlas", arg1 + 1, arg0:findTF("normal/num", arg2), true)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/cardpuzzlepage_atlas", arg1 + 1, arg0:findTF("selected/num", arg2), true)
end

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = arg1 + 1
	local var1 = arg0.levelList[var0]

	setActive(arg0:findTF("selected", arg2), arg0.selectedId == var1)

	local var2 = table.contains(arg0.finishList, var1)

	setActive(arg0:findTF("finish", arg2), var2)
	setActive(arg0:findTF("normal", arg2), not var2 and arg0.selectedId ~= var1)
	onButton(arg0, arg2, function()
		arg0.selectedId = var1

		arg0.uilist:align(#arg0.levelList)
		arg0:UpdateLevelInfo()
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	arg0.gotList = arg0.activity:getData1List()
	arg0.finishList = arg0.activity.data2_list

	arg0.uilist:align(#arg0.levelList)

	if arg0:CheckAward() then
		setActive(arg0.getBtn, true)
		onButton(arg0, arg0.getBtn, function()
			arg0:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 2,
				activity_id = arg0.activity.id,
				arg1 = arg0:CheckAward()
			})
		end, SFX_PANEL)
	else
		setActive(arg0.getBtn, false)
	end

	setActive(arg0.gotBtn, #arg0.gotList == #arg0.awardList)
	setText(arg0.progressTF, setColorStr(#arg0.finishList, "#C2FFF3") .. "/" .. #arg0.levelList)
	arg0:UpdateEveryDayTip()
end

function var0.CheckAward(arg0)
	if #arg0.gotList == #arg0.awardList then
		return nil
	end

	local var0 = #arg0.finishList

	for iter0, iter1 in ipairs(arg0.awardList) do
		if not table.contains(arg0.gotList, iter1[1]) and var0 >= iter1[1] then
			return iter1[1]
		end
	end

	return nil
end

function var0.UpdateLevelInfo(arg0)
	local var0 = pg.puzzle_combat_template[arg0.selectedId]

	setText(arg0.titleTF, "·" .. var0.name)
	setText(arg0.descTF, var0.description)
end

function var0.GetCurLevel(arg0)
	arg0.finishList = arg0.activity.data2_list

	for iter0, iter1 in ipairs(arg0.levelList) do
		if not table.contains(arg0.finishList, iter1) then
			return iter1, iter0
		end
	end

	return arg0.levelList[#arg0.levelList], #arg0.levelList
end

function var0.UpdateEveryDayTip(arg0)
	if #arg0.gotList == #arg0.awardList then
		return
	end

	if arg0:CheckAward() then
		return
	end

	local var0, var1 = arg0:GetCurLevel()
	local var2 = arg0:findTF("tip", arg0.items:GetChild(var1 - 1))
	local var3 = getProxy(PlayerProxy):getData().id
	local var4 = "DAY_TIP_" .. arg0.activity.id .. "_" .. var3 .. "_" .. arg0.activity:getDayIndex()

	if PlayerPrefs.GetInt(var4) == 0 then
		setActive(var2, true)
		PlayerPrefs.SetInt(var4, 1)
	else
		setActive(var2, false)
	end
end

return var0
