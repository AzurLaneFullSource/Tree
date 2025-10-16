local var0_0 = class("ClueGroupSingleView", import("view.base.BaseUI"))
local var1_0 = pg.activity_clue
local var2_0 = pg.activity_clue_group
local var3_0 = 0.6
local var4_0 = 1

function var0_0.getUIName(arg0_1)
	return "ClueGroupSingleUI"
end

function var0_0.init(arg0_2)
	arg0_2.clueGroupTf = arg0_2._tf:Find("clueGroup")

	setText(arg0_2.clueGroupTf:Find("goBtn/Text"), i18n("clue_task_goto"))
	setText(arg0_2._tf:Find("closeTip"), i18n("clue_close_tip"))

	arg0_2.timerList = {}
end

function var0_0.didEnter(arg0_3)
	arg0_3.activityId = ActivityConst.Valleyhospital_ACT_ID
	arg0_3.playerId = getProxy(PlayerProxy):getRawData().id
	arg0_3.investigatingGroupId = PlayerPrefs.GetInt("investigatingGroupId_" .. arg0_3.activityId .. "_" .. arg0_3.playerId)
	arg0_3.taskProxy = getProxy(TaskProxy)

	onButton(arg0_3, arg0_3._tf:Find("mask"), function()
		arg0_3:closeView()
	end, SFX_PANEL)
	arg0_3:SetClueGroup()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.SetClueGroup(arg0_5)
	local var0_5 = arg0_5.contextData.clueGroupId
	local var1_5 = arg0_5.contextData.submitClueIds
	local var2_5 = arg0_5.clueGroupTf
	local var3_5 = var2_0[var0_5]
	local var4_5 = var1_0.get_id_list_by_group[var0_5]
	local var5_5 = {
		var1_0[var4_5[1]],
		var1_0[var4_5[2]],
		var1_0[var4_5[3]]
	}
	local var6_5 = arg0_5.taskProxy:getTaskVO(tonumber(var5_5[3].task_id)):getProgress()
	local var7_5 = {}

	for iter0_5 = 1, 3 do
		var7_5[iter0_5] = arg0_5.taskProxy:getFinishTaskById(tonumber(var5_5[iter0_5].task_id))
	end

	setText(var2_5:Find("title/Text"), var3_5.title)
	setActive(var2_5:Find("title/Text"), var7_5[1] or var7_5[2] or var7_5[3])
	setActive(var2_5:Find("title/lock"), not var7_5[1] and not var7_5[2] and not var7_5[3])
	LoadImageSpriteAsync("cluepictures/" .. var3_5.pic, var2_5:Find("picture"), true)

	if var3_5.type == 1 then
		var2_5:Find("picture").localScale = Vector3(1, 1, 1)
	else
		var2_5:Find("picture").localScale = Vector3(0.6, 0.6, 1)
	end

	setActive(var2_5:Find("picture/lockSite"), var3_5.type == 1 and not var7_5[1] and not var7_5[2] and not var7_5[3])
	setActive(var2_5:Find("picture/lockChara"), var3_5.type == 2 and not var7_5[1] and not var7_5[2] and not var7_5[3])

	local var8_5 = false

	for iter1_5 = 1, 3 do
		if var7_5[iter1_5] then
			setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter1_5), var5_5[iter1_5].desc)
		elseif arg0_5.investigatingGroupId == var0_5 then
			setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter1_5), "<color=#858593>" .. var5_5[iter1_5].unlock_desc .. var5_5[iter1_5].unlock_num .. i18n("clue_task_tip", var6_5) .. "</color>")
		elseif not var8_5 then
			var8_5 = true

			setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter1_5), "<color=#858593>" .. var5_5[iter1_5].unlock_desc .. var5_5[iter1_5].unlock_num .. i18n("clue_task_tip", var6_5) .. "</color>")
		else
			setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter1_5), "<color=#858593>？？？</color>")
		end
	end

	setActive(var2_5:Find("goBtn/selected"), arg0_5.investigatingGroupId == var0_5)
	onButton(arg0_5, var2_5:Find("goBtn"), function()
		arg0_5.investigatingGroupId = var0_5

		PlayerPrefs.SetInt("investigatingGroupId_" .. arg0_5.activityId .. "_" .. arg0_5.playerId, var0_5)
		setActive(var2_5:Find("goBtn/selected"), true)

		if arg0_5.pageIndex == 1 then
			arg0_5:ShowSitePage()
		elseif arg0_5.pageIndex == 2 then
			arg0_5:ShowCharaPage()
		end

		arg0_5:OpenChapter(var0_5)
		arg0_5:closeView()
	end, SFX_PANEL)

	if not var7_5[1] and not var7_5[2] and not var7_5[3] then
		setActive(arg0_5.clueGroupTf:Find("triangle"), false)
	else
		setActive(arg0_5.clueGroupTf:Find("triangle"), true)
		setActive(arg0_5.clueGroupTf:Find("triangle"), arg0_5.clueGroupTf:Find("clueScroll"):GetComponent(typeof(ScrollRect)).normalizedPosition.y > 0.01)
		onScroll(arg0_5, arg0_5.clueGroupTf:Find("clueScroll"), function(arg0_7)
			setActive(arg0_5.clueGroupTf:Find("triangle"), arg0_7.y > 0.01)
		end)
	end

	setActive(arg0_5._tf:Find("top"), var1_5 and #var1_5 > 0)

	if var1_5 and #var1_5 > 0 then
		if table.contains(var1_5, var4_5[1]) then
			setActive(var2_5:Find("title/Text"), false)
			setActive(var2_5:Find("title/lock"), true)
			setActive(var2_5:Find("picture/lockSite"), var3_5.type == 1)
			setActive(var2_5:Find("picture/lockChara"), var3_5.type == 2)

			for iter2_5 = 1, #var1_5 do
				if arg0_5.investigatingGroupId == var0_5 then
					setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter2_5), "<color=#858593>" .. var5_5[iter2_5].unlock_desc .. var5_5[iter2_5].unlock_num .. "</color>")
				else
					setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter2_5), "<color=#858593>？？？</color>")
				end
			end

			arg0_5:StartTimer(function()
				setActive(var2_5:Find("title/Text"), true)

				local var0_8 = var2_5:Find("title"):GetComponent(typeof(Animation)):Play("anim_clue_single_unlock1")

				arg0_5:SetEndAniEvent(var2_5:Find("title"), function()
					setActive(var2_5:Find("title/lock"), false)
				end)
			end, var3_0)
			arg0_5:StartTimer(function()
				local var0_10 = var2_5:Find("picture"):GetComponent(typeof(Animation)):Play("anim_clue_single_unlock")

				arg0_5:SetEndAniEvent(var2_5:Find("picture"), function()
					setActive(var2_5:Find("picture/lockSite"), false)
					setActive(var2_5:Find("picture/lockChara"), false)
				end)
			end, var3_0)

			for iter3_5 = 1, #var1_5 do
				arg0_5:StartTimer(function()
					setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter3_5), var5_5[iter3_5].desc)
				end, var4_0 * iter3_5 + var3_0)
			end
		else
			local var9_5 = table.indexof(var4_5, var1_5[1])

			for iter4_5 = var9_5, 3 do
				if arg0_5.investigatingGroupId == var0_5 then
					setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter4_5), "<color=#858593>" .. var5_5[iter4_5].unlock_desc .. var5_5[iter4_5].unlock_num .. "</color>")
				else
					setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter4_5), "<color=#858593>？？？</color>")
				end
			end

			local var10_5 = 1

			for iter5_5 = var9_5, var9_5 + #var1_5 - 1 do
				arg0_5:StartTimer(function()
					setText(var2_5:Find("clueScroll/Viewport/Content/clue" .. iter5_5), var5_5[iter5_5].desc)
				end, var4_0 * var10_5)

				var10_5 = var10_5 + 1
			end
		end

		setActive(var2_5:Find("goBtn"), false)
	else
		setActive(var2_5:Find("goBtn"), not var7_5[1] or not var7_5[2] or not var7_5[3])
	end
end

function var0_0.OpenChapter(arg0_14, arg1_14)
	arg0_14:emit(ClueGroupSingleMediator.OPEN_CLUE_JUMP, arg1_14)
end

function var0_0.StartTimer(arg0_15, arg1_15, arg2_15)
	local var0_15 = Timer.New(arg1_15, arg2_15, 1)

	var0_15:Start()
	table.insert(arg0_15.timerList, var0_15)
end

function var0_0.RemoveAllTimer(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.timerList) do
		iter1_16:Stop()
	end

	arg0_16.timerList = {}
end

function var0_0.SetEndAniEvent(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17:GetComponent(typeof(DftAniEvent))

	if var0_17 then
		var0_17:SetEndEvent(function()
			arg2_17()
			var0_17:SetEndEvent(nil)
		end)
	end
end

function var0_0.willExit(arg0_19)
	arg0_19:RemoveAllTimer()
end

function var0_0.onBackPressed(arg0_20)
	arg0_20:closeView()
end

return var0_0
