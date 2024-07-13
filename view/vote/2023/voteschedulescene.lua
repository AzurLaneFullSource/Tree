local var0_0 = class("VoteScheduleScene", import("view.base.BaseUI"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6
local var7_0 = 1
local var8_0 = 2
local var9_0 = 3

function var0_0.getUIName(arg0_1)
	return "VoteScheduleUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("blur_panel/adapt/top/back_btn")
	arg0_2.raceTpl = arg0_2:findTF("res/raceTpl")
	arg0_2.layoutTpl = arg0_2:findTF("res/layoutTpl")
	arg0_2.raceTpl1 = arg0_2:findTF("res/raceTpl1")
	arg0_2.layoutTpl1 = arg0_2:findTF("res/layoutTpl1")
	arg0_2.container = arg0_2:findTF("scrollrect/content")
	arg0_2.verLeftTpl = arg0_2._tf:Find("res/ver_left")
	arg0_2.verLeftTplClose = arg0_2._tf:Find("res/ver_left_close")
	arg0_2.verRightTpl = arg0_2._tf:Find("res/ver_right")
	arg0_2.verRightTplClose = arg0_2._tf:Find("res/ver_right_close")
	arg0_2.centTpl = arg0_2._tf:Find("res/cen")
	arg0_2.centTplClose = arg0_2._tf:Find("res/cen_close")
	arg0_2.hrzRightTpl = arg0_2._tf:Find("res/hrz_rigth")
	arg0_2.hrzRightTplClose = arg0_2._tf:Find("res/hrz_rigth_close")
	arg0_2.hrzLeftTpl = arg0_2._tf:Find("res/hrz_left")
	arg0_2.hrzLeftTplClose = arg0_2._tf:Find("res/hrz_left_close")
	arg0_2.lineContainer = arg0_2:findTF("scrollrect/content/line")
	arg0_2.lineTpls = {}

	setText(arg0_2.raceTpl:Find("open/Text"), i18n("vote_lable_voting"))
	setText(arg0_2.raceTpl:Find("close/Text"), i18n("vote_lable_not_start"))
	setText(arg0_2.raceTpl1:Find("open/Text"), i18n("vote_lable_voting"))
	setText(arg0_2.raceTpl1:Find("close/Text"), i18n("vote_lable_not_start"))
	setText(arg0_2:findTF("title/Text"), i18n("vote_lable_title"))

	arg0_2.LayoutHeight = arg0_2.layoutTpl:GetComponent(typeof(LayoutElement)).preferredHeight
	arg0_2.spacing = arg0_2.container:GetComponent(typeof(VerticalLayoutGroup)).spacing
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():LoadingOn(false)
	seriesAsync({
		function(arg0_5)
			arg0_3:RequestFinishedVoteGroup(arg0_5)
		end,
		function(arg0_6)
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_3:SetUp(arg0_6)
		end
	}, function()
		return
	end)
end

function var0_0.RequestFinishedVoteGroup(arg0_8, arg1_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(pg.activity_vote.all) do
		if pg.TimeMgr.GetInstance():parseTimeFromConfig(pg.activity_vote[iter1_8].time_vote[2]) <= pg.TimeMgr.GetInstance():GetServerTime() then
			table.insert(var0_8, function(arg0_9)
				arg0_8:emit(VoteScheduleMediator.FETCH_RANK, iter1_8, arg0_9)
			end)
		end
	end

	seriesAsync(var0_8, arg1_8)
end

function var0_0.SetUp(arg0_10, arg1_10)
	arg0_10.voteIdList = arg0_10:GetVoteIdList()
	arg0_10.displayList = arg0_10:GenDisplayList(arg0_10.voteIdList)

	arg0_10:ClearLines()

	local var0_10 = arg0_10:InitScheduleList()

	arg0_10.lineContainer:SetAsLastSibling()
	seriesAsync({
		function(arg0_11)
			Canvas.ForceUpdateCanvases()
			onNextTick(arg0_11)
		end,
		function(arg0_12)
			arg0_10:UpdateLinesPosition()
			arg0_10:ScrollTo(var0_10)
			onNextTick(arg0_12)
		end,
		function(arg0_13)
			arg0_10:PlayAnimation(arg0_13)
		end
	}, arg1_10)
end

function var0_0.PlayAnimation(arg0_14, arg1_14)
	local var0_14 = 1

	local function var1_14(arg0_15, arg1_15, arg2_15)
		local var0_15 = arg0_15:GetComponent(typeof(CanvasGroup))

		LeanTween.value(arg0_15.gameObject, 0, 1, 0.333):setOnUpdate(System.Action_float(function(arg0_16)
			var0_15.alpha = arg0_16
		end)):setOnComplete(System.Action(arg2_15)):setDelay(arg1_15 * var0_14)

		var0_14 = var0_14 + 1
	end

	local var2_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14.voteIdList or {}) do
		local var3_14 = arg0_14:GetRaceState(iter1_14)
		local var4_14 = arg0_14.animationNodes[iter1_14]
		local var5_14 = var3_14 == var9_0

		for iter2_14, iter3_14 in ipairs(var4_14) do
			if var5_14 then
				table.insert(var2_14, function(arg0_17)
					var1_14(iter3_14, 0.066, arg0_17)
				end)
			else
				iter3_14:GetComponent(typeof(CanvasGroup)).alpha = 1
			end
		end
	end

	parallelAsync(var2_14, function()
		arg0_14.animationNodes = {}

		arg1_14()
	end)
end

function var0_0.ScrollTo(arg0_19, arg1_19)
	local var0_19 = (arg0_19.LayoutHeight + arg0_19.spacing) * (arg1_19 - 1) - 170

	setAnchoredPosition(arg0_19.container, {
		y = var0_19
	})
end

function var0_0.ClearLines(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.lineTpls) do
		local var0_20 = iter1_20[1]

		Object.Destroy(var0_20.gameObject)
	end

	arg0_20.lineTpls = {}
end

local function var10_0(arg0_21, arg1_21, arg2_21)
	if arg0_21 == arg1_21 then
		return arg2_21
	else
		local var0_21 = arg0_21:TransformPoint(arg2_21)
		local var1_21 = arg1_21:InverseTransformPoint(var0_21)

		return Vector3(var1_21.x, var1_21.y, 0)
	end
end

function var0_0.UpdateLinesPosition(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.lineTpls) do
		local var0_22 = var10_0(iter1_22[2], arg0_22.lineContainer, iter1_22[3])

		setAnchoredPosition(iter1_22[1], var0_22)
	end
end

function var0_0.GetVoteIdList(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(pg.activity_vote.all) do
		table.insert(var0_23, iter1_23)
	end

	table.sort(var0_23, function(arg0_24, arg1_24)
		local var0_24 = pg.activity_vote[arg0_24]
		local var1_24 = pg.activity_vote[arg1_24]

		return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_24.time_vote[1]) < pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_24.time_vote[1])
	end)

	return var0_23
end

function var0_0.GenDisplayList(arg0_25, arg1_25)
	local var0_25 = {}

	if #arg1_25 <= 4 then
		for iter0_25, iter1_25 in ipairs(arg1_25) do
			local var1_25 = var3_0

			if iter0_25 == #arg1_25 then
				var1_25 = var6_0
			end

			table.insert(var0_25, {
				{
					id = iter1_25,
					dir = var1_25
				}
			})
		end

		return var0_25
	end

	table.insert(var0_25, {
		{
			id = arg1_25[1],
			dir = var1_0
		}
	})

	local var2_25 = 0
	local var3_25 = #arg1_25 - 3

	for iter2_25 = 2, var3_25, 2 do
		var2_25 = var2_25 + 1

		local var4_25 = iter2_25 == var3_25 or var3_25 < iter2_25 + 2

		if var2_25 % 2 == 0 then
			table.insert(var0_25, {
				{
					id = arg1_25[iter2_25 + 1],
					dir = var4_25 and var2_0 or var3_0
				},
				{
					id = arg1_25[iter2_25],
					dir = var5_0
				}
			})
		else
			table.insert(var0_25, {
				{
					id = arg1_25[iter2_25],
					dir = var4_0
				},
				{
					id = arg1_25[iter2_25 + 1],
					dir = var4_25 and var1_0 or var3_0
				}
			})
		end
	end

	if #arg1_25 % 2 == 0 then
		table.insert(var0_25, {
			{
				id = arg1_25[#arg1_25 - 2],
				dir = var3_0
			}
		})
	end

	table.insert(var0_25, {
		{
			id = arg1_25[#arg1_25 - 1],
			dir = var3_0
		}
	})
	table.insert(var0_25, {
		{
			id = arg1_25[#arg1_25],
			dir = var6_0
		}
	})

	return var0_25
end

function var0_0.InitScheduleList(arg0_26)
	arg0_26.animationNodes = {}

	local var0_26 = {}

	for iter0_26 = 1, arg0_26.container.childCount do
		local var1_26 = arg0_26.container:GetChild(iter0_26 - 1)

		if var1_26.name ~= "line" then
			table.insert(var0_26, var1_26.gameObject)
		end
	end

	if #var0_26 > 0 then
		for iter1_26, iter2_26 in ipairs(var0_26) do
			Object.Destroy(iter2_26)
		end
	end

	local var2_26 = {}

	for iter3_26, iter4_26 in ipairs(arg0_26.voteIdList) do
		var2_26[iter4_26] = arg0_26:GetRaceState(iter4_26)
	end

	local var3_26 = 1

	for iter5_26, iter6_26 in ipairs(arg0_26.displayList) do
		local var4_26
		local var5_26 = iter5_26 == #arg0_26.displayList

		if var5_26 then
			var4_26 = cloneTplTo(arg0_26.layoutTpl1, arg0_26.container)
		else
			var4_26 = cloneTplTo(arg0_26.layoutTpl, arg0_26.container)
		end

		if arg0_26:GenRaceList(var4_26, iter6_26, var2_26, var5_26) then
			var3_26 = iter5_26
		end
	end

	local var6_26 = false

	for iter7_26, iter8_26 in pairs(var2_26) do
		if pg.activity_vote[iter7_26].type == VoteConst.RACE_TYPE_FINAL and iter8_26 == var8_0 then
			var6_26 = true

			break
		end
	end

	if var6_26 then
		cloneTplTo(arg0_26.layoutTpl, arg0_26.container)
	end

	return var3_26
end

function var0_0.GenRaceList(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27)
	local var0_27 = false
	local var1_27

	if arg4_27 then
		var1_27 = UIItemList.New(arg1_27:Find("content"), arg0_27.raceTpl1)
	else
		var1_27 = UIItemList.New(arg1_27:Find("content"), arg0_27.raceTpl)
	end

	var1_27:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = arg2_27[arg1_28 + 1]
			local var1_28 = table.indexof(arg0_27.voteIdList, var0_28.id)
			local var2_28

			if var1_28 and var1_28 > 0 then
				local var3_28 = arg0_27.voteIdList[var1_28 + 1]

				var2_28 = arg3_27[var3_28]
			end

			local var4_28 = arg3_27[var0_28.id]

			arg0_27:UpdateRace(arg2_28, var0_28, var4_28, var2_28)

			if not var0_27 and var4_28 == var8_0 then
				var0_27 = true
			end
		end
	end)
	var1_27:align(#arg2_27)

	return var0_27
end

function var0_0.GetRaceState(arg0_29, arg1_29)
	local var0_29 = pg.activity_vote[arg1_29]

	if pg.TimeMgr.GetInstance():inTime(var0_29.time_vote) then
		return var8_0
	elseif pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_29.time_vote[2]) <= pg.TimeMgr.GetInstance():GetServerTime() then
		return var7_0
	else
		return var9_0
	end
end

function var0_0.UpdateRace(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	local var0_30 = pg.activity_vote[arg2_30.id]
	local var1_30 = arg0_30:UpdateRaceLink(arg1_30, arg2_30, arg4_30 and arg4_30 ~= var9_0)

	arg0_30:UpdateRaceState(arg1_30, var0_30, arg3_30)

	arg0_30.animationNodes[arg2_30.id] = {
		arg1_30,
		var1_30
	}
end

local function var11_0(arg0_31, arg1_31)
	if arg1_31 == var9_0 then
		return "border_close"
	elseif arg0_31.type == VoteConst.RACE_TYPE_FINAL then
		return "border_finals"
	else
		return "border_open"
	end
end

local function var12_0(arg0_32, arg1_32)
	if arg1_32 == var9_0 then
		return "frame_title_close"
	elseif arg0_32.type == VoteConst.RACE_TYPE_FINAL then
		return "frame_title_finals"
	elseif arg0_32.type == VoteConst.RACE_TYPE_RESURGENCE then
		return "frame_title_rec"
	elseif arg0_32.type == VoteConst.RACE_TYPE_FUN then
		if arg0_32.sub_type == VoteConst.RACE_SUBTYPE_SIRE then
			return "frame_title_sire"
		elseif arg0_32.sub_type == VoteConst.RACE_SUBTYPE_META then
			return "frame_title_META"
		elseif arg0_32.sub_type == VoteConst.RACE_SUBTYPE_KID then
			return "frame_title_kid"
		end
	else
		return "frame_title"
	end
end

local function var13_0(arg0_33, arg1_33)
	if arg0_33.type == VoteConst.RACE_TYPE_FUN then
		if arg0_33.sub_type == VoteConst.RACE_SUBTYPE_SIRE then
			return "icon_sire"
		elseif arg0_33.sub_type == VoteConst.RACE_SUBTYPE_META then
			return "icon_META"
		elseif arg0_33.sub_type == VoteConst.RACE_SUBTYPE_KID then
			return "icon_kid"
		end
	end

	return nil
end

function var0_0.UpdateRaceState(arg0_34, arg1_34, arg2_34, arg3_34)
	arg1_34:Find("border"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/VoteScheduleUI_atlas", var11_0(arg2_34, arg3_34))
	arg1_34:Find("title"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/VoteScheduleUI_atlas", var12_0(arg2_34, arg3_34))

	local var0_34 = var13_0(arg2_34, arg3_34)

	setActive(arg1_34:Find("title/content/icon"), var0_34)

	if var0_34 then
		arg1_34:Find("title/content/icon"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/VoteScheduleUI_atlas", var0_34)
	end

	local var1_34 = arg3_34 ~= var9_0 and arg2_34.type == VoteConst.RACE_TYPE_RESURGENCE and "#074e51" or COLOR_WHITE

	setText(arg1_34:Find("title/content/Text"), setColorStr(arg2_34.name, var1_34))

	local var2_34 = VoteGroup.GetTimeDesc2(arg2_34.time_vote, arg2_34.type)

	setText(arg1_34:Find("title/content/Text/Text"), setColorStr(var2_34, var1_34))
	setActive(arg1_34:Find("open"), arg3_34 == var8_0)
	setActive(arg1_34:Find("close"), arg3_34 == var9_0)
	setActive(arg1_34:Find("list"), arg3_34 == var7_0)

	local var3_34 = getProxy(VoteProxy):RawGetTempVoteGroup(arg2_34.id)
	local var4_34 = UIItemList.New(arg1_34:Find("list"), arg1_34:Find("list/ship_tpl"))

	var4_34:make(function(arg0_35, arg1_35, arg2_35)
		if arg0_35 == UIItemList.EventUpdate then
			arg0_34:UpdateRaceRank(var3_34, arg1_35 + 1, arg2_35)
		end
	end)

	local var5_34 = arg3_34 == var7_0 and var3_34 and #var3_34:getList() >= 3 and 3 or 0

	var4_34:align(var5_34)
	onButton(arg0_34, arg1_34, function()
		if getProxy(VoteProxy):RawGetVoteGroupByConfigId(arg2_34.id) then
			local var0_36 = getProxy(ContextProxy):getCurrentContext()

			if var0_36 and var0_36.mediator == VoteMediator then
				arg0_34:emit(var0_0.ON_CLOSE)
			else
				arg0_34:emit(VoteScheduleMediator.ON_VOTE)
			end
		elseif var3_34 then
			arg0_34:emit(VoteScheduleMediator.GO_RANK, var3_34)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRaceRank(arg0_37, arg1_37, arg2_37, arg3_37)
	if not arg1_37 then
		setActive(arg3_37, false)

		return
	end

	local var0_37 = arg1_37:getList()[arg2_37]
	local var1_37 = VoteShipItem.New(arg3_37.gameObject)
	local var2_37 = arg1_37:GetRank(var0_37)

	var1_37:update(var0_37, {
		rank = var2_37
	})
end

function var0_0.UpdateRaceLink(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = arg2_38.dir
	local var1_38

	if var0_38 == var1_0 and arg3_38 then
		var1_38 = cloneTplTo(arg0_38.verLeftTpl, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(-224.42, -203.2)
		})
	elseif var0_38 == var1_0 then
		var1_38 = cloneTplTo(arg0_38.verLeftTplClose, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(-224.42, -203.2)
		})
	elseif var0_38 == var2_0 and arg3_38 then
		var1_38 = cloneTplTo(arg0_38.verRightTpl, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(224.42, -203.2)
		})
	elseif var0_38 == var2_0 then
		var1_38 = cloneTplTo(arg0_38.verRightTplClose, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(224.42, -203.2)
		})
	elseif var0_38 == var3_0 and arg3_38 then
		var1_38 = cloneTplTo(arg0_38.centTpl, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(0, -203.2)
		})
	elseif var0_38 == var3_0 then
		var1_38 = cloneTplTo(arg0_38.centTplClose, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(0, -203.2)
		})
	elseif var0_38 == var4_0 and arg3_38 then
		var1_38 = cloneTplTo(arg0_38.hrzRightTpl, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(447.2, 0)
		})
	elseif var0_38 == var4_0 then
		var1_38 = cloneTplTo(arg0_38.hrzRightTplClose, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(447.2, 0)
		})
	elseif var0_38 == var5_0 and arg3_38 then
		var1_38 = cloneTplTo(arg0_38.hrzLeftTpl, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(-447.2, 0)
		})
	elseif var0_38 == var5_0 then
		var1_38 = cloneTplTo(arg0_38.hrzLeftTplClose, arg0_38.lineContainer)

		table.insert(arg0_38.lineTpls, {
			var1_38,
			arg1_38,
			Vector2(-447.2, 0)
		})
	end

	return var1_38
end

function var0_0.onBackPressed(arg0_39)
	var0_0.super.onBackPressed(arg0_39)
end

function var0_0.willExit(arg0_40)
	return
end

return var0_0
