local var0 = class("VoteScheduleScene", import("view.base.BaseUI"))
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = 6
local var7 = 1
local var8 = 2
local var9 = 3

function var0.getUIName(arg0)
	return "VoteScheduleUI"
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back_btn")
	arg0.raceTpl = arg0:findTF("res/raceTpl")
	arg0.layoutTpl = arg0:findTF("res/layoutTpl")
	arg0.raceTpl1 = arg0:findTF("res/raceTpl1")
	arg0.layoutTpl1 = arg0:findTF("res/layoutTpl1")
	arg0.container = arg0:findTF("scrollrect/content")
	arg0.verLeftTpl = arg0._tf:Find("res/ver_left")
	arg0.verLeftTplClose = arg0._tf:Find("res/ver_left_close")
	arg0.verRightTpl = arg0._tf:Find("res/ver_right")
	arg0.verRightTplClose = arg0._tf:Find("res/ver_right_close")
	arg0.centTpl = arg0._tf:Find("res/cen")
	arg0.centTplClose = arg0._tf:Find("res/cen_close")
	arg0.hrzRightTpl = arg0._tf:Find("res/hrz_rigth")
	arg0.hrzRightTplClose = arg0._tf:Find("res/hrz_rigth_close")
	arg0.hrzLeftTpl = arg0._tf:Find("res/hrz_left")
	arg0.hrzLeftTplClose = arg0._tf:Find("res/hrz_left_close")
	arg0.lineContainer = arg0:findTF("scrollrect/content/line")
	arg0.lineTpls = {}

	setText(arg0.raceTpl:Find("open/Text"), i18n("vote_lable_voting"))
	setText(arg0.raceTpl:Find("close/Text"), i18n("vote_lable_not_start"))
	setText(arg0.raceTpl1:Find("open/Text"), i18n("vote_lable_voting"))
	setText(arg0.raceTpl1:Find("close/Text"), i18n("vote_lable_not_start"))
	setText(arg0:findTF("title/Text"), i18n("vote_lable_title"))

	arg0.LayoutHeight = arg0.layoutTpl:GetComponent(typeof(LayoutElement)).preferredHeight
	arg0.spacing = arg0.container:GetComponent(typeof(VerticalLayoutGroup)).spacing
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():LoadingOn(false)
	seriesAsync({
		function(arg0)
			arg0:RequestFinishedVoteGroup(arg0)
		end,
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()
			arg0:SetUp(arg0)
		end
	}, function()
		return
	end)
end

function var0.RequestFinishedVoteGroup(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.activity_vote.all) do
		if pg.TimeMgr.GetInstance():parseTimeFromConfig(pg.activity_vote[iter1].time_vote[2]) <= pg.TimeMgr.GetInstance():GetServerTime() then
			table.insert(var0, function(arg0)
				arg0:emit(VoteScheduleMediator.FETCH_RANK, iter1, arg0)
			end)
		end
	end

	seriesAsync(var0, arg1)
end

function var0.SetUp(arg0, arg1)
	arg0.voteIdList = arg0:GetVoteIdList()
	arg0.displayList = arg0:GenDisplayList(arg0.voteIdList)

	arg0:ClearLines()

	local var0 = arg0:InitScheduleList()

	arg0.lineContainer:SetAsLastSibling()
	seriesAsync({
		function(arg0)
			Canvas.ForceUpdateCanvases()
			onNextTick(arg0)
		end,
		function(arg0)
			arg0:UpdateLinesPosition()
			arg0:ScrollTo(var0)
			onNextTick(arg0)
		end,
		function(arg0)
			arg0:PlayAnimation(arg0)
		end
	}, arg1)
end

function var0.PlayAnimation(arg0, arg1)
	local var0 = 1

	local function var1(arg0, arg1, arg2)
		local var0 = arg0:GetComponent(typeof(CanvasGroup))

		LeanTween.value(arg0.gameObject, 0, 1, 0.333):setOnUpdate(System.Action_float(function(arg0)
			var0.alpha = arg0
		end)):setOnComplete(System.Action(arg2)):setDelay(arg1 * var0)

		var0 = var0 + 1
	end

	local var2 = {}

	for iter0, iter1 in pairs(arg0.voteIdList or {}) do
		local var3 = arg0:GetRaceState(iter1)
		local var4 = arg0.animationNodes[iter1]
		local var5 = var3 == var9

		for iter2, iter3 in ipairs(var4) do
			if var5 then
				table.insert(var2, function(arg0)
					var1(iter3, 0.066, arg0)
				end)
			else
				iter3:GetComponent(typeof(CanvasGroup)).alpha = 1
			end
		end
	end

	parallelAsync(var2, function()
		arg0.animationNodes = {}

		arg1()
	end)
end

function var0.ScrollTo(arg0, arg1)
	local var0 = (arg0.LayoutHeight + arg0.spacing) * (arg1 - 1) - 170

	setAnchoredPosition(arg0.container, {
		y = var0
	})
end

function var0.ClearLines(arg0)
	for iter0, iter1 in ipairs(arg0.lineTpls) do
		local var0 = iter1[1]

		Object.Destroy(var0.gameObject)
	end

	arg0.lineTpls = {}
end

local function var10(arg0, arg1, arg2)
	if arg0 == arg1 then
		return arg2
	else
		local var0 = arg0:TransformPoint(arg2)
		local var1 = arg1:InverseTransformPoint(var0)

		return Vector3(var1.x, var1.y, 0)
	end
end

function var0.UpdateLinesPosition(arg0)
	for iter0, iter1 in ipairs(arg0.lineTpls) do
		local var0 = var10(iter1[2], arg0.lineContainer, iter1[3])

		setAnchoredPosition(iter1[1], var0)
	end
end

function var0.GetVoteIdList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.activity_vote.all) do
		table.insert(var0, iter1)
	end

	table.sort(var0, function(arg0, arg1)
		local var0 = pg.activity_vote[arg0]
		local var1 = pg.activity_vote[arg1]

		return pg.TimeMgr.GetInstance():parseTimeFromConfig(var0.time_vote[1]) < pg.TimeMgr.GetInstance():parseTimeFromConfig(var1.time_vote[1])
	end)

	return var0
end

function var0.GenDisplayList(arg0, arg1)
	local var0 = {}

	if #arg1 <= 4 then
		for iter0, iter1 in ipairs(arg1) do
			local var1 = var3

			if iter0 == #arg1 then
				var1 = var6
			end

			table.insert(var0, {
				{
					id = iter1,
					dir = var1
				}
			})
		end

		return var0
	end

	table.insert(var0, {
		{
			id = arg1[1],
			dir = var1
		}
	})

	local var2 = 0
	local var3 = #arg1 - 3

	for iter2 = 2, var3, 2 do
		var2 = var2 + 1

		local var4 = iter2 == var3 or var3 < iter2 + 2

		if var2 % 2 == 0 then
			table.insert(var0, {
				{
					id = arg1[iter2 + 1],
					dir = var4 and var2 or var3
				},
				{
					id = arg1[iter2],
					dir = var5
				}
			})
		else
			table.insert(var0, {
				{
					id = arg1[iter2],
					dir = var4
				},
				{
					id = arg1[iter2 + 1],
					dir = var4 and var1 or var3
				}
			})
		end
	end

	if #arg1 % 2 == 0 then
		table.insert(var0, {
			{
				id = arg1[#arg1 - 2],
				dir = var3
			}
		})
	end

	table.insert(var0, {
		{
			id = arg1[#arg1 - 1],
			dir = var3
		}
	})
	table.insert(var0, {
		{
			id = arg1[#arg1],
			dir = var6
		}
	})

	return var0
end

function var0.InitScheduleList(arg0)
	arg0.animationNodes = {}

	local var0 = {}

	for iter0 = 1, arg0.container.childCount do
		local var1 = arg0.container:GetChild(iter0 - 1)

		if var1.name ~= "line" then
			table.insert(var0, var1.gameObject)
		end
	end

	if #var0 > 0 then
		for iter1, iter2 in ipairs(var0) do
			Object.Destroy(iter2)
		end
	end

	local var2 = {}

	for iter3, iter4 in ipairs(arg0.voteIdList) do
		var2[iter4] = arg0:GetRaceState(iter4)
	end

	local var3 = 1

	for iter5, iter6 in ipairs(arg0.displayList) do
		local var4
		local var5 = iter5 == #arg0.displayList

		if var5 then
			var4 = cloneTplTo(arg0.layoutTpl1, arg0.container)
		else
			var4 = cloneTplTo(arg0.layoutTpl, arg0.container)
		end

		if arg0:GenRaceList(var4, iter6, var2, var5) then
			var3 = iter5
		end
	end

	local var6 = false

	for iter7, iter8 in pairs(var2) do
		if pg.activity_vote[iter7].type == VoteConst.RACE_TYPE_FINAL and iter8 == var8 then
			var6 = true

			break
		end
	end

	if var6 then
		cloneTplTo(arg0.layoutTpl, arg0.container)
	end

	return var3
end

function var0.GenRaceList(arg0, arg1, arg2, arg3, arg4)
	local var0 = false
	local var1

	if arg4 then
		var1 = UIItemList.New(arg1:Find("content"), arg0.raceTpl1)
	else
		var1 = UIItemList.New(arg1:Find("content"), arg0.raceTpl)
	end

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2[arg1 + 1]
			local var1 = table.indexof(arg0.voteIdList, var0.id)
			local var2

			if var1 and var1 > 0 then
				local var3 = arg0.voteIdList[var1 + 1]

				var2 = arg3[var3]
			end

			local var4 = arg3[var0.id]

			arg0:UpdateRace(arg2, var0, var4, var2)

			if not var0 and var4 == var8 then
				var0 = true
			end
		end
	end)
	var1:align(#arg2)

	return var0
end

function var0.GetRaceState(arg0, arg1)
	local var0 = pg.activity_vote[arg1]

	if pg.TimeMgr.GetInstance():inTime(var0.time_vote) then
		return var8
	elseif pg.TimeMgr.GetInstance():parseTimeFromConfig(var0.time_vote[2]) <= pg.TimeMgr.GetInstance():GetServerTime() then
		return var7
	else
		return var9
	end
end

function var0.UpdateRace(arg0, arg1, arg2, arg3, arg4)
	local var0 = pg.activity_vote[arg2.id]
	local var1 = arg0:UpdateRaceLink(arg1, arg2, arg4 and arg4 ~= var9)

	arg0:UpdateRaceState(arg1, var0, arg3)

	arg0.animationNodes[arg2.id] = {
		arg1,
		var1
	}
end

local function var11(arg0, arg1)
	if arg1 == var9 then
		return "border_close"
	elseif arg0.type == VoteConst.RACE_TYPE_FINAL then
		return "border_finals"
	else
		return "border_open"
	end
end

local function var12(arg0, arg1)
	if arg1 == var9 then
		return "frame_title_close"
	elseif arg0.type == VoteConst.RACE_TYPE_FINAL then
		return "frame_title_finals"
	elseif arg0.type == VoteConst.RACE_TYPE_RESURGENCE then
		return "frame_title_rec"
	elseif arg0.type == VoteConst.RACE_TYPE_FUN then
		if arg0.sub_type == VoteConst.RACE_SUBTYPE_SIRE then
			return "frame_title_sire"
		elseif arg0.sub_type == VoteConst.RACE_SUBTYPE_META then
			return "frame_title_META"
		elseif arg0.sub_type == VoteConst.RACE_SUBTYPE_KID then
			return "frame_title_kid"
		end
	else
		return "frame_title"
	end
end

local function var13(arg0, arg1)
	if arg0.type == VoteConst.RACE_TYPE_FUN then
		if arg0.sub_type == VoteConst.RACE_SUBTYPE_SIRE then
			return "icon_sire"
		elseif arg0.sub_type == VoteConst.RACE_SUBTYPE_META then
			return "icon_META"
		elseif arg0.sub_type == VoteConst.RACE_SUBTYPE_KID then
			return "icon_kid"
		end
	end

	return nil
end

function var0.UpdateRaceState(arg0, arg1, arg2, arg3)
	arg1:Find("border"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/VoteScheduleUI_atlas", var11(arg2, arg3))
	arg1:Find("title"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/VoteScheduleUI_atlas", var12(arg2, arg3))

	local var0 = var13(arg2, arg3)

	setActive(arg1:Find("title/content/icon"), var0)

	if var0 then
		arg1:Find("title/content/icon"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/VoteScheduleUI_atlas", var0)
	end

	local var1 = arg3 ~= var9 and arg2.type == VoteConst.RACE_TYPE_RESURGENCE and "#074e51" or COLOR_WHITE

	setText(arg1:Find("title/content/Text"), setColorStr(arg2.name, var1))

	local var2 = VoteGroup.GetTimeDesc2(arg2.time_vote, arg2.type)

	setText(arg1:Find("title/content/Text/Text"), setColorStr(var2, var1))
	setActive(arg1:Find("open"), arg3 == var8)
	setActive(arg1:Find("close"), arg3 == var9)
	setActive(arg1:Find("list"), arg3 == var7)

	local var3 = getProxy(VoteProxy):RawGetTempVoteGroup(arg2.id)
	local var4 = UIItemList.New(arg1:Find("list"), arg1:Find("list/ship_tpl"))

	var4:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateRaceRank(var3, arg1 + 1, arg2)
		end
	end)

	local var5 = arg3 == var7 and var3 and #var3:getList() >= 3 and 3 or 0

	var4:align(var5)
	onButton(arg0, arg1, function()
		if getProxy(VoteProxy):RawGetVoteGroupByConfigId(arg2.id) then
			local var0 = getProxy(ContextProxy):getCurrentContext()

			if var0 and var0.mediator == VoteMediator then
				arg0:emit(var0.ON_CLOSE)
			else
				arg0:emit(VoteScheduleMediator.ON_VOTE)
			end
		elseif var3 then
			arg0:emit(VoteScheduleMediator.GO_RANK, var3)
		end
	end, SFX_PANEL)
end

function var0.UpdateRaceRank(arg0, arg1, arg2, arg3)
	if not arg1 then
		setActive(arg3, false)

		return
	end

	local var0 = arg1:getList()[arg2]
	local var1 = VoteShipItem.New(arg3.gameObject)
	local var2 = arg1:GetRank(var0)

	var1:update(var0, {
		rank = var2
	})
end

function var0.UpdateRaceLink(arg0, arg1, arg2, arg3)
	local var0 = arg2.dir
	local var1

	if var0 == var1 and arg3 then
		var1 = cloneTplTo(arg0.verLeftTpl, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(-224.42, -203.2)
		})
	elseif var0 == var1 then
		var1 = cloneTplTo(arg0.verLeftTplClose, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(-224.42, -203.2)
		})
	elseif var0 == var2 and arg3 then
		var1 = cloneTplTo(arg0.verRightTpl, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(224.42, -203.2)
		})
	elseif var0 == var2 then
		var1 = cloneTplTo(arg0.verRightTplClose, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(224.42, -203.2)
		})
	elseif var0 == var3 and arg3 then
		var1 = cloneTplTo(arg0.centTpl, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(0, -203.2)
		})
	elseif var0 == var3 then
		var1 = cloneTplTo(arg0.centTplClose, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(0, -203.2)
		})
	elseif var0 == var4 and arg3 then
		var1 = cloneTplTo(arg0.hrzRightTpl, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(447.2, 0)
		})
	elseif var0 == var4 then
		var1 = cloneTplTo(arg0.hrzRightTplClose, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(447.2, 0)
		})
	elseif var0 == var5 and arg3 then
		var1 = cloneTplTo(arg0.hrzLeftTpl, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(-447.2, 0)
		})
	elseif var0 == var5 then
		var1 = cloneTplTo(arg0.hrzLeftTplClose, arg0.lineContainer)

		table.insert(arg0.lineTpls, {
			var1,
			arg1,
			Vector2(-447.2, 0)
		})
	end

	return var1
end

function var0.onBackPressed(arg0)
	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	return
end

return var0
