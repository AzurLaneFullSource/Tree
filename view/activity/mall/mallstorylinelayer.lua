local var0_0 = class("MallStoryLineLayer", import("view.base.BaseUI"))

var0_0.Placeindex = 0
var0_0.roleindex = 0
var0_0.num = {
	Role = 3,
	Story = 1,
	Skin = 2,
	Place = 4
}

function var0_0.getUIName(arg0_1)
	return "MallStoryLineUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2._tf:Find("tip"), i18n("word_click_to_close"))

	arg0_2.adapt = arg0_2._tf:Find("adapt")
	arg0_2.tabs = arg0_2.adapt:Find("tabs")
	arg0_2.tabsListCount = arg0_2.tabs.transform.childCount
	arg0_2.decorate1ListCount = arg0_2.adapt:Find("decorate1").transform.childCount
	arg0_2.page_listCount = arg0_2.adapt:Find("page_list").transform.childCount
	arg0_2.StoryList = {}
	arg0_2.SkinList = {}
	arg0_2.RoleList = {}
	arg0_2.PlaceList = {}

	local var0_2 = _.map(pg.activity_mall_story.all, function(arg0_3)
		return pg.activity_mall_story[arg0_3]
	end)

	arg0_2.TriggeredPointIds = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL):GetTriggeredPointIds()
	arg0_2.OrderDataList = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL):GetOrderData():GetFinishedList()

	for iter0_2, iter1_2 in pairs(var0_2) do
		if iter1_2.type == arg0_2.num.Skin then
			table.insert(arg0_2.StoryList, iter1_2)
		elseif iter1_2.type == arg0_2.num.Place then
			table.insert(arg0_2.SkinList, iter1_2)
		elseif iter1_2.type == arg0_2.num.Role then
			table.insert(arg0_2.RoleList, iter1_2)
		elseif iter1_2.type == arg0_2.num.Story then
			table.insert(arg0_2.PlaceList, iter1_2)
		end
	end

	arg0_2.type2List = {
		[arg0_2.num.Story] = arg0_2.StoryList,
		[arg0_2.num.Skin] = arg0_2.SkinList,
		[arg0_2.num.Role] = arg0_2.RoleList,
		[arg0_2.num.Place] = arg0_2.PlaceList
	}

	local var1_2 = -1

	for iter2_2 = 0, arg0_2.tabsListCount - 1 do
		onToggle(arg0_2, arg0_2.tabs:GetChild(iter2_2), function(arg0_4)
			if arg0_4 then
				if var1_2 ~= iter2_2 then
					arg0_2:OnUpdata(iter2_2 + 1)
				end

				var1_2 = iter2_2
			end
		end, SFX_PANEL)
	end

	arg0_2:OnUpdata(1)
end

function var0_0.UpdataToggle(arg0_5, arg1_5)
	local var0_5 = arg0_5.type2List[arg1_5]
	local var1_5 = arg1_5 ~= var0_0.num.Skin and arg0_5:OnTask(var0_5) or arg0_5:GetSkinFinishNum(var0_5)

	setText(arg0_5.adapt:Find("tabs/" .. arg1_5 .. "/name"), var1_5 .. "/" .. #var0_5)
	setText(arg0_5.adapt:Find("tabs/" .. arg1_5 .. "/on/name"), var1_5 .. "/" .. #var0_5)
end

function var0_0.OnUpdata(arg0_6, arg1_6)
	for iter0_6 = 0, arg0_6.decorate1ListCount - 1 do
		SetActive(arg0_6.adapt:Find("decorate1/" .. iter0_6 + 1), iter0_6 + 1 == arg1_6)
	end

	for iter1_6 = 0, arg0_6.page_listCount - 1 do
		SetActive(arg0_6.adapt:Find("page_list/" .. iter1_6 + 1), iter1_6 + 1 == arg1_6)
	end

	arg0_6:UpdataToggle(arg1_6)

	if arg1_6 == arg0_6.num.Story then
		arg0_6:OnStoryPage(arg1_6)
	elseif arg1_6 == arg0_6.num.Skin then
		arg0_6:OnSkinPage(arg1_6)
	elseif arg1_6 == arg0_6.num.Role then
		arg0_6:OnRolePage(arg1_6)
	elseif arg1_6 == arg0_6.num.Place then
		arg0_6:OnPlacePage(arg1_6)
	end
end

function var0_0.OnTask(arg0_7, arg1_7)
	local var0_7 = 0

	for iter0_7, iter1_7 in pairs(arg1_7) do
		if table.contains(arg0_7.TriggeredPointIds, iter1_7.id) then
			var0_7 = var0_7 + 1
		end
	end

	return var0_7
end

function var0_0.GetSkinFinishNum(arg0_8, arg1_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in pairs(arg1_8) do
		if table.contains(arg0_8.OrderDataList, tonumber(iter1_8.desc)) then
			var0_8 = var0_8 + 1
		end
	end

	return var0_8
end

function var0_0.OnStoryPage(arg0_9, arg1_9)
	local var0_9 = arg0_9.adapt:Find("page_list/" .. arg1_9)

	for iter0_9 = 1, #arg0_9.StoryList do
		arg0_9:OnStoryUPdata(var0_9:Find("bg/" .. iter0_9), arg0_9.StoryList[iter0_9])
	end
end

function var0_0.OnStoryUPdata(arg0_10, arg1_10, arg2_10)
	local var0_10 = table.contains(arg0_10.TriggeredPointIds, arg2_10.id)
	local var1_10 = arg2_10.name
	local var2_10 = arg2_10.desc
	local var3_10 = arg2_10.lua

	setActive(arg1_10:Find("on"), var0_10)
	setActive(arg1_10:Find("off"), not var0_10)
	setText(arg1_10:Find("on/bg/name"), var1_10)
	setText(arg1_10:Find("off/bg/lockname"), var2_10)
	onButton(arg0_10, arg1_10, function()
		if not var0_10 then
			return
		end

		pg.NewStoryMgr.GetInstance():Play(var3_10, function()
			return
		end, true)
	end, SFX_PANEL)
end

function var0_0.OnSkinPage(arg0_13, arg1_13)
	local var0_13 = arg0_13.adapt:Find("page_list/" .. arg1_13)
	local var1_13 = var0_13:Find("skin/" .. arg0_13.roleindex).transform.childCount

	arg0_13:OnSkin(var1_13, var0_13)
	onButton(arg0_13, var0_13:Find("left"), function()
		arg0_13.roleindex = arg0_13.roleindex - 1

		local var0_14 = var0_13:Find("skin/" .. arg0_13.roleindex).transform.childCount

		arg0_13:OnSkin(var0_14, var0_13)
	end, SFX_PANEL)
	onButton(arg0_13, var0_13:Find("right"), function()
		arg0_13.roleindex = arg0_13.roleindex + 1

		local var0_15 = var0_13:Find("skin/" .. arg0_13.roleindex).transform.childCount

		arg0_13:OnSkin(var0_15, var0_13)
	end, SFX_PANEL)
end

function var0_0.OnSkin(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg2_16:Find("skin").transform.childCount

	setActive(arg2_16:Find("left"), arg0_16.roleindex == 1)
	setActive(arg2_16:Find("right"), arg0_16.roleindex == 0)
	setText(arg2_16:Find("Text"), arg0_16.roleindex + 1 .. "/" .. #arg0_16.SkinList / 5)

	for iter0_16 = 0, var0_16 - 1 do
		SetActive(arg2_16:Find("skin/" .. iter0_16), iter0_16 == arg0_16.roleindex)
	end

	for iter1_16 = 0, arg1_16 - 1 do
		arg0_16:OnSkinUpdata(arg2_16:Find("skin/" .. arg0_16.roleindex .. "/" .. iter1_16 + 1), arg0_16.SkinList[arg0_16.roleindex * 5 + (iter1_16 + 1)])
	end
end

function var0_0.OnSkinUpdata(arg0_17, arg1_17, arg2_17)
	local var0_17 = table.contains(arg0_17.OrderDataList, tonumber(arg2_17.desc))
	local var1_17 = arg2_17.name
	local var2_17 = i18n("mall_char_lock")
	local var3_17 = arg2_17.lua
	local var4_17 = arg2_17.icon

	SetActive(arg1_17:Find("on"), var0_17)
	SetActive(arg1_17:Find("off"), not var0_17)
	setText(arg1_17:Find("on/name"), var1_17)
	setText(arg1_17:Find("off/lockname"), var2_17)
	setImageSprite(arg1_17:Find("on/bg"), LoadSprite("ui/mallstorylineui_atlas", var4_17))
	onButton(arg0_17, arg1_17, function()
		if not var0_17 then
			return
		end

		pg.NewStoryMgr.GetInstance():Play(var3_17, function()
			return
		end, true)
	end, SFX_PANEL)
	onButton(arg0_17, arg1_17:Find("on/bg"), function()
		if not var0_17 then
			return
		end

		pg.NewStoryMgr.GetInstance():Play(var3_17, function()
			return
		end, true)
	end, SFX_PANEL)
end

function var0_0.OnRolePage(arg0_22, arg1_22)
	local var0_22 = arg0_22.adapt:Find("page_list/" .. arg1_22)

	for iter0_22 = 1, #arg0_22.RoleList do
		arg0_22:OnRoleUPdata(var0_22:Find("" .. iter0_22), arg0_22.RoleList[iter0_22])
	end
end

function var0_0.OnRoleUPdata(arg0_23, arg1_23, arg2_23)
	local var0_23 = table.contains(arg0_23.TriggeredPointIds, arg2_23.id)
	local var1_23 = arg2_23.name
	local var2_23 = i18n("mall_title_lock")
	local var3_23 = arg2_23.lua
	local var4_23 = arg2_23.icon

	setActive(arg1_23:Find("on"), var0_23)
	setActive(arg1_23:Find("off"), not var0_23)
	setText(arg1_23:Find("on/name_s/name"), var1_23)
	setScrollText(arg1_23:Find("on/name_l/mask/name"), var1_23)

	local var5_23 = GetPerceptualSize(var1_23) > 7

	setActive(arg1_23:Find("on/name_s"), not var5_23)
	setActive(arg1_23:Find("on/name_l"), var5_23)
	setText(arg1_23:Find("off/lock/lockname"), var2_23)
	setImageSprite(arg1_23:Find("on/icon"), LoadSprite("ui/mallstorylineui_atlas", var4_23))
	onButton(arg0_23, arg1_23:Find("on"), function()
		if not var0_23 then
			return
		end

		pg.NewStoryMgr.GetInstance():Play(var3_23, function()
			return
		end, true)
	end, SFX_PANEL)
	onButton(arg0_23, arg1_23:Find("off"), function()
		return
	end, SFX_PANEL)
end

function var0_0.OnPlacePage(arg0_27, arg1_27)
	arg0_27.Place = arg0_27.adapt:Find("page_list/" .. arg1_27)

	local var0_27 = arg0_27.Place:Find("table").transform.childCount

	for iter0_27 = 0, var0_27 - 1 do
		SetActive(arg0_27.Place:Find("table/" .. iter0_27 + 1), arg0_27.Placeindex == iter0_27 + 1)
	end

	local var1_27 = #arg0_27.PlaceList - (arg0_27.Placeindex + 1) * 6 > 0 and 6 or (arg0_27.Placeindex + 1) * 6 - #arg0_27.PlaceList

	arg0_27:OnPlaceList(var1_27, arg0_27.Place)
	addSlip(SLIP_TYPE_HRZ, arg0_27.adapt:Find("page_list/" .. arg1_27 .. "/table"), function()
		if arg0_27.Placeindex > 0 then
			arg0_27.Placeindex = arg0_27.Placeindex - 1

			local var0_28 = arg0_27.adapt:Find("page_list/" .. arg1_27)
			local var1_28 = #arg0_27.PlaceList - (arg0_27.Placeindex + 1) * 6 > 0 and 6 or (arg0_27.Placeindex + 1) * 6 - #arg0_27.PlaceList

			arg0_27:OnPlaceList(var1_28, var0_28)
		end
	end, function()
		if arg0_27.Placeindex < 2 then
			arg0_27.Placeindex = arg0_27.Placeindex + 1

			local var0_29 = arg0_27.adapt:Find("page_list/" .. arg1_27)
			local var1_29 = #arg0_27.PlaceList - (arg0_27.Placeindex + 1) * 6 > 0 and 6 or (arg0_27.Placeindex + 1) * 6 - #arg0_27.PlaceList

			arg0_27:OnPlaceList(var1_29, var0_29)
		end
	end)
	onButton(arg0_27, arg0_27.Place:Find("left"), function()
		arg0_27.Placeindex = arg0_27.Placeindex - 1

		local var0_30 = arg0_27.adapt:Find("page_list/" .. arg1_27)
		local var1_30 = #arg0_27.PlaceList - (arg0_27.Placeindex + 1) * 6 > 0 and 6 or (arg0_27.Placeindex + 1) * 6 - #arg0_27.PlaceList

		arg0_27:OnPlaceList(var1_30, var0_30)
	end, SFX_PANEL)
	onButton(arg0_27, arg0_27.Place:Find("right"), function()
		arg0_27.Placeindex = arg0_27.Placeindex + 1

		local var0_31 = arg0_27.adapt:Find("page_list/" .. arg1_27)
		local var1_31 = #arg0_27.PlaceList - (arg0_27.Placeindex + 1) * 6 > 0 and 6 or (arg0_27.Placeindex + 1) * 6 - #arg0_27.PlaceList

		arg0_27:OnPlaceList(var1_31, var0_31)
	end, SFX_PANEL)
end

function var0_0.OnPlaceList(arg0_32, arg1_32, arg2_32)
	setActive(arg0_32.Place:Find("left"), arg0_32.Placeindex ~= 0)
	setActive(arg0_32.Place:Find("right"), arg0_32.Placeindex < 2)
	setActive(arg0_32.Place:Find("table/0"), arg0_32.Placeindex == 0)
	setActive(arg0_32.Place:Find("table/1"), arg0_32.Placeindex == 1)
	setActive(arg0_32.Place:Find("table/2"), arg0_32.Placeindex == 2)
	setText(arg2_32:Find("Text"), arg0_32.Placeindex + 1 .. "/" .. #arg0_32.PlaceList / 5)

	for iter0_32 = 1, arg1_32 do
		arg0_32:OnPlaceUPdata(arg2_32:Find("table/" .. arg0_32.Placeindex .. "/" .. iter0_32), arg0_32.PlaceList[arg0_32.Placeindex * 6 + iter0_32], arg0_32.Placeindex * 6 + iter0_32)
	end
end

function var0_0.OnPlaceUPdata(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = table.contains(arg0_33.TriggeredPointIds, arg2_33.id)
	local var1_33 = i18n("mall_continue_to_unlock")
	local var2_33 = arg2_33.icon
	local var3_33 = arg2_33.name
	local var4_33 = arg2_33.desc
	local var5_33 = arg2_33.lua

	SetActive(arg1_33:Find("lock"), not var0_33)

	if var0_33 then
		setText(arg1_33:Find("name_bg/name"), var3_33)
		setText(arg1_33:Find("desc/Text"), var4_33)
		setImageSprite(arg1_33:Find("icon"), LoadSprite("ui/mallstorylineui_atlas", var2_33))
	end

	setText(arg1_33:Find("lock/lockname"), var1_33)
end

function var0_0.didEnter(arg0_34)
	onButton(arg0_34, arg0_34._tf:Find("bg"), function()
		arg0_34:closeView()
	end, SFX_PANEL)

	for iter0_34, iter1_34 in pairs(arg0_34.type2List) do
		arg0_34:UpdataToggle(iter0_34)
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_34._tf)
end

function var0_0.willExit(arg0_36)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_36._tf)
end

return var0_0
