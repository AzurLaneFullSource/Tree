local var0_0 = class("MallStaffLayer", import("view.base.BaseUI"))

var0_0.ATTR_INFOS = {
	{
		"ring_yellow",
		"#ffe59b"
	},
	{
		"ring_green",
		"#9ecf76"
	},
	{
		"ring_blue",
		"#769acf"
	}
}

function var0_0.getUIName(arg0_1)
	return "MallStaffUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiHomeBtn, function()
		arg0_2:quickExitFunc()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiHelpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.mall_help.tip
		})
	end, SFX_PANEL)

	arg0_2.floorsUIList = UIItemList.New(arg0_2.uiFloorsTF, arg0_2.uiFloorsTF:Find("tpl"))

	arg0_2.floorsUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			arg0_2:InitFloorTpl(arg1_6, arg2_6)
		elseif arg0_6 == UIItemList.EventUpdate then
			arg0_2:UpdateFloorTpl(arg1_6, arg2_6)
		end
	end)

	arg0_2.targetUIList = UIItemList.New(arg0_2.uiTargetTF, arg0_2.uiTargetTF:Find("tpl"))

	arg0_2.targetUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_2:UpdateTargetTpl(arg1_7, arg2_7)
		end
	end)

	arg0_2.scrollCom = arg0_2.uiScrollTF:GetComponent("LScrollRect")

	function arg0_2.scrollCom.onInitItem(arg0_8)
		arg0_2:OnInitStaffItem(arg0_8)
	end

	function arg0_2.scrollCom.onUpdateItem(arg0_9, arg1_9)
		arg0_2:OnUpdateStaffItem(arg0_9, arg1_9)
	end

	setText(arg0_2.uiTitleText, i18n("mall_title"))
	setText(arg0_2.uiTitleEnText, i18n("mall_title_en"))
	setText(arg0_2.uiFloorsTF:Find("tpl/lock/Text"), i18n("mall_floor_lock"))
	eachChild(arg0_2.uiRankTF:Find("open"), function(arg0_10)
		setText(arg0_10, MallUtil.RANK2NAME[tonumber(arg0_10.name)])
	end)
end

function var0_0.didEnter(arg0_11)
	arg0_11.curFloorId = arg0_11.contextData.floorId

	arg0_11:UpdateData()
	arg0_11:UpdateView()
end

function var0_0.UpdateData(arg0_12)
	arg0_12.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	arg0_12.level = arg0_12.activity:GetLevelData().level
	arg0_12.floorList = arg0_12.activity:GetFloorList()
	arg0_12.staffList = arg0_12.activity:GetStaffList()
	arg0_12.cards = {}
end

function var0_0.UpdateView(arg0_13)
	arg0_13.floorsUIList:align(#arg0_13.floorList)
	triggerButton(arg0_13.floorsUIList.container:Find(tostring(arg0_13.curFloorId)))
end

function var0_0.InitFloorTpl(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.floorList[arg1_14 + 1]

	arg2_14.name = var0_14.id

	GetImageSpriteFromAtlasAsync("ui/mallstaffui_atlas", var0_14.id .. "f", arg2_14:Find("unsel/f"), true)
	GetImageSpriteFromAtlasAsync("ui/mallstaffui_atlas", var0_14.id .. "f_sel", arg2_14:Find("sel/f"), true)
end

function var0_0.UpdateFloorTpl(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.floorList[arg1_15 + 1]

	setActive(arg2_15:Find("lock"), not var0_15:IsUnlock())

	local var1_15 = var0_15.id == arg0_15.curFloorId

	setActive(arg2_15:Find("sel"), var1_15)
	setActive(arg2_15:Find("unsel"), not var1_15)

	if not var0_15:IsUnlock() then
		setActive(arg2_15:Find("staffs"), false)

		return
	end

	setActive(arg2_15:Find("staffs"), true)

	local var2_15 = var0_15:GetStaffList()

	UIItemList.StaticAlign(arg2_15:Find("staffs"), arg2_15:Find("staffs/tpl"), #var2_15, function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var2_15[arg1_16 + 1]
			local var1_16 = arg0_15.activity:GetStaff(var0_16)

			setActive(arg2_16:Find("icon"), var1_16)

			if var1_16 then
				MallStaffCard.StaticUpdateIcon(arg2_16:Find("icon"), var1_16.tid)
			end

			onButton(arg0_15, arg2_16, function()
				if arg0_15.curFloorId ~= var0_15.id then
					triggerButton(arg2_15)

					return
				end

				if not var1_16 then
					return
				end

				arg0_15.activity:SetFloorStaff(var0_15.id, arg1_16 + 1, 0)
				arg0_15:UpdateView()
			end)
		end
	end)
	onButton(arg0_15, arg2_15, function()
		if not var0_15:IsUnlock() then
			return
		end

		arg0_15.curFloorId = var0_15.id

		arg0_15.floorsUIList:eachActive(function(arg0_19, arg1_19)
			local var0_19 = arg0_15.floorList[arg0_19 + 1].id == arg0_15.curFloorId

			setActive(arg1_19:Find("sel"), var0_19)
			setActive(arg1_19:Find("unsel"), not var0_19)
			eachChild(arg1_19:Find("staffs"), function(arg0_20)
				setActive(arg0_20:Find("c_sel"), var0_19)
				setActive(arg0_20:Find("c"), not var0_19)
			end)
		end)
		var0_0.CheckUpdateFloorStaffs(arg0_15.activity)
		arg0_15:UpdataRight()
	end)
end

function var0_0.UpdataRight(arg0_21)
	arg0_21.selIds = underscore.select(arg0_21.activity:GetFloor(arg0_21.curFloorId):GetStaffList(), function(arg0_22)
		return arg0_22 ~= 0
	end)

	GetImageSpriteFromAtlasAsync("ui/mallstaffui_atlas", "title_" .. arg0_21.curFloorId .. "f", arg0_21.uiRightTitleTF, true)

	arg0_21.allAttrDatas = {}

	local var0_21 = arg0_21.activity:GetFloor(arg0_21.curFloorId)

	for iter0_21, iter1_21 in ipairs(var0_21:GetTargetInfos(arg0_21.level)) do
		table.insert(arg0_21.allAttrDatas, {
			cur = 0,
			id = iter0_21,
			base = iter1_21[1],
			max = iter1_21[2]
		})
	end

	for iter2_21, iter3_21 in ipairs(var0_21:GetStaffList()) do
		if iter3_21 ~= 0 then
			local var1_21 = arg0_21.activity:GetStaff(iter3_21)

			for iter4_21, iter5_21 in ipairs(var1_21:GetAttrList()) do
				arg0_21.allAttrDatas[iter4_21].cur = arg0_21.allAttrDatas[iter4_21].cur + iter5_21
			end
		end
	end

	arg0_21.showAttrDatas = underscore.select(arg0_21.allAttrDatas, function(arg0_23)
		return arg0_23.base ~= 0 and arg0_23.max ~= 0
	end)

	table.sort(arg0_21.showAttrDatas, CompareFuncs({
		function(arg0_24)
			return arg0_24.id
		end
	}))

	local var2_21 = underscore.reduce(arg0_21.showAttrDatas, 0, function(arg0_25, arg1_25)
		return arg0_25 + arg1_25.cur
	end)
	local var3_21 = underscore.reduce(arg0_21.showAttrDatas, 0, function(arg0_26, arg1_26)
		return arg0_26 + arg1_26.base
	end)
	local var4_21 = MallUtil.GetFloorRank(var2_21, var3_21)
	local var5_21 = var4_21 ~= MallUtil.FLOOR_RANK.CLOSE

	setActive(arg0_21.uiRankTF:Find("open"), var5_21)
	setActive(arg0_21.uiRankTF:Find("close"), not var5_21)

	if var5_21 then
		eachChild(arg0_21.uiRankTF:Find("open"), function(arg0_27)
			setActive(arg0_27, tonumber(arg0_27.name) == var4_21)
		end)
	end

	arg0_21.targetUIList:align(#arg0_21.showAttrDatas)
	arg0_21:SortList()
	arg0_21.scrollCom:SetTotalCount(#arg0_21.staffList)
end

function var0_0.SortList(arg0_28)
	table.sort(arg0_28.staffList, CompareFuncs({
		function(arg0_29)
			local var0_29, var1_29 = arg0_29:GetStatusInfos()

			return var0_29 == MallStaff.STATUS.ORDER and 1 or 0
		end,
		function(arg0_30)
			local var0_30, var1_30 = arg0_30:GetStatusInfos()

			return var0_30 == MallStaff.STATUS.FLOOR and var1_30.floorId ~= arg0_28.curFloorId and 1 or 0
		end,
		function(arg0_31)
			return -arg0_31.id
		end
	}))
end

function var0_0.UpdateTargetTpl(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.showAttrDatas[arg1_32 + 1]
	local var1_32 = var0_32.id

	GetImageSpriteFromAtlasAsync("ui/mallstaffui_atlas", "attr" .. var1_32, arg2_32:Find("icon"), true)

	local var2_32 = arg0_32:GetAttrInfos(var0_32)

	GetImageSpriteFromAtlasAsync("ui/mallstaffui_atlas", var2_32[1], arg2_32:Find("ring/v"), true)
	setFillAmount(arg2_32:Find("ring/r"), var0_32.base / var0_32.max)
	setFillAmount(arg2_32:Find("ring/v"), var0_32.cur / var0_32.max)
	setText(arg2_32:Find("bg/Text"), (setColorStr(var0_32.cur, var2_32[2]) or var0_32.cur) .. "/" .. var0_32.max)
end

function var0_0.GetAttrInfos(arg0_33, arg1_33)
	if arg1_33.cur >= arg1_33.max then
		return var0_0.ATTR_INFOS[3]
	end

	if arg1_33.cur >= arg1_33.base then
		return var0_0.ATTR_INFOS[2]
	end

	return var0_0.ATTR_INFOS[1]
end

function var0_0.OnInitStaffItem(arg0_34, arg1_34)
	local var0_34 = MallStaffCard.New(arg1_34)

	onButton(arg0_34, var0_34._go, function()
		local var0_35 = arg0_34.activity:GetFloor(arg0_34.curFloorId):GetEmptyIdx()

		if not var0_35 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mall_staff_position_full_tip"))

			return
		end

		local var1_35, var2_35 = var0_34.staff:GetStatusInfos()

		if var1_35 == MallStaff.STATUS.ORDER then
			return
		end

		if var1_35 == MallStaff.STATUS.FLOOR and var2_35.floorId == arg0_34.curFloorId then
			return
		end

		seriesAsync({
			function(arg0_36)
				if var1_35 == MallStaff.STATUS.FLOOR then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("mall_change_floor_sure"),
						onYes = function()
							arg0_34.activity:SetFloorStaff(var2_35.floorId, var2_35.floorIdx, 0)
							arg0_36()
						end
					})
				else
					arg0_36()
				end
			end
		}, function()
			arg0_34.activity:SetFloorStaff(arg0_34.curFloorId, var0_35, var0_34.id)
			arg0_34:UpdateView()
		end)
	end, SFX_PANEL)

	arg0_34.cards[arg1_34] = var0_34
end

function var0_0.OnUpdateStaffItem(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39.cards[arg2_39]

	if not var0_39 then
		arg0_39:OnInitStaffItem(arg2_39)

		var0_39 = arg0_39.cards[arg2_39]
	end

	local var1_39 = arg0_39.staffList[arg1_39 + 1]

	var0_39:Update(var1_39, arg0_39.selIds, true)
end

function var0_0.willExit(arg0_40)
	var0_0.CheckUpdateFloorStaffs(arg0_40.activity)
	ClearLScrollrect(arg0_40.scrollCom)

	for iter0_40, iter1_40 in pairs(arg0_40.cards) do
		iter1_40:Dispose()
	end

	arg0_40.cards = {}
end

function var0_0.CheckUpdateFloorStaffs(arg0_41, arg1_41)
	if arg0_41:NeedUpdateFloorStaff() then
		pg.m02:sendNotification(GAME.ACTIVITY_MALL_OP, {
			activity_id = arg0_41.id,
			cmd = ActivityMallOPCommand.CMD.SET_FLOOR_STAFF,
			arg_list = arg0_41:GetFloorStaffList(),
			callback = arg1_41
		})
	end
end

return var0_0
