local var0_0 = class("ToLovePtPage", import("view.base.BaseActivityPage"))

var0_0.OFFSET = 0.00042
var0_0.SHOW_COUNT = 8

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.getBtnGray = arg0_1.getBtn:Find("gray")
	arg0_1.shopBtn = arg0_1.bg:Find("exchange_btn")
	arg0_1.content = arg0_1.bg:Find("award_list/content")
	arg0_1.awardTpl = arg0_1.bg:Find("award")
	arg0_1.sptf = arg0_1.bg:Find("sp_award")
	arg0_1.spAward = arg0_1.bg:Find("sp_award/award")
	arg0_1.ptCount = arg0_1.bg:Find("ptCount")
	arg0_1.scrollCom = GetComponent(arg0_1.content, "LScrollRect")

	function arg0_1.scrollCom.onUpdateItem(arg0_2, arg1_2)
		arg0_1:UpdateAward(arg0_2, tf(arg1_2))
	end

	setActive(arg0_1.awardTpl, false)
end

function var0_0.OnDataSetting(arg0_3)
	if arg0_3.ptData then
		arg0_3.ptData:Update(arg0_3.activity)
	else
		arg0_3.highValueItemSort = arg0_3.activity:getConfig("config_client").highValueItemSort
		arg0_3.ptData = ActivityPtData.New(arg0_3.activity)
		arg0_3.awardList = {}

		for iter0_3, iter1_3 in pairs(arg0_3.ptData.dropList) do
			table.insert(arg0_3.awardList, {
				drop = Drop.New({
					type = iter1_3[1],
					id = iter1_3[2],
					count = iter1_3[3]
				}),
				isImportant = table.contains(arg0_3.highValueItemSort, iter0_3),
				target = arg0_3.ptData.targets[iter0_3]
			})
		end
	end
end

function var0_0.OnFirstFlush(arg0_4)
	onButton(arg0_4, arg0_4.getBtn, function()
		if arg0_4.ptData:GetMaxAvailableTargetIndex() == arg0_4.ptData:GetLevel() then
			return
		end

		local var0_5 = {}
		local var1_5 = getProxy(PlayerProxy):getRawData()
		local var2_5 = pg.gameset.urpt_chapter_max.description[1]
		local var3_5 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var2_5)
		local var4_5 = arg0_4.ptData:GetAllAvailableAwards()
		local var5_5, var6_5 = Task.StaticJudgeOverflow(var1_5.gold, var1_5.oil, var3_5, true, true, var4_5)

		if var5_5 then
			table.insert(var0_5, function(arg0_6)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_5,
					onYes = arg0_6
				})
			end)
		end

		seriesAsync(var0_5, function()
			local var0_7 = arg0_4.ptData:GetCurrTarget()

			arg0_4:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 4,
				activity_id = arg0_4.ptData:GetId(),
				arg1 = var0_7
			})
		end)
	end, SFX_PANEL)

	local var0_4 = arg0_4.activity:getConfig("config_client").shopLinkActID
	local var1_4 = getProxy(ActivityProxy):getActivityById(var0_4)

	onButton(arg0_4, arg0_4.shopBtn, function()
		if not var1_4 or var1_4:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_4:emit(ActivityMediator.GO_SHOPS_LAYER, {
			warp = NewShopsScene.TYPE_ACTIVITY,
			actId = var1_4 and var1_4.id
		})
	end)
	arg0_4.scrollCom:SetTotalCount(#arg0_4.awardList)
	arg0_4:BuildPhaseAwardScrollPos()
	arg0_4.scrollCom.onValueChanged:AddListener(function(arg0_9)
		arg0_4:UpdateNextAward(arg0_9.x)
	end)
	arg0_4:UpdateNextAward(arg0_4.scrollCom.value)
end

function var0_0.BuildPhaseAwardScrollPos(arg0_10)
	arg0_10.impTotalPos = arg0_10.scrollCom:HeadIndexToValue(#arg0_10.awardList - var0_0.SHOW_COUNT) - arg0_10.scrollCom:HeadIndexToValue(0)
	arg0_10.importantPos = {}

	for iter0_10, iter1_10 in pairs(arg0_10.awardList) do
		if iter1_10.isImportant then
			table.insert(arg0_10.importantPos, {
				index = iter0_10,
				pos = arg0_10.scrollCom:HeadIndexToValue(iter0_10 - var0_0.SHOW_COUNT) / arg0_10.impTotalPos
			})
		end
	end
end

function var0_0.UpdateNextAward(arg0_11, arg1_11)
	arg1_11 = math.min(arg1_11, 1)

	for iter0_11, iter1_11 in pairs(arg0_11.importantPos) do
		if arg1_11 < iter1_11.pos then
			setActive(arg0_11.sptf, true)
			arg0_11:UpdateAward(iter1_11.index - 1, arg0_11.spAward)

			break
		elseif iter0_11 == #arg0_11.importantPos then
			setActive(arg0_11.sptf, false)
		end
	end
end

function var0_0.UpdateAward(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12 + 1
	local var1_12 = arg0_12.awardList[var0_12].drop

	updateDrop(arg2_12:Find("icon"), var1_12)
	setText(arg2_12:Find("pt"), arg0_12.awardList[var0_12].target)

	local var2_12 = var0_12 <= arg0_12.ptData:GetLevel()
	local var3_12 = not var2_12 and var0_12 <= arg0_12.ptData:GetMaxAvailableTargetIndex()
	local var4_12 = not var2_12 and not var3_12

	setActive(arg2_12:Find("got"), var2_12)
	setActive(arg2_12:Find("get"), var3_12)
	setActive(arg2_12:Find("lock"), var4_12)
	onButton(arg0_12, arg2_12, function()
		arg0_12:emit(BaseUI.ON_DROP, var1_12)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_14)
	local var0_14 = var0_0.OFFSET * arg0_14.ptData:GetLevel()

	if isActive(arg0_14._tf) then
		arg0_14.scrollCom:ScrollTo(math.clamp(arg0_14.scrollCom:HeadIndexToValue(arg0_14.ptData:GetLevel()) / arg0_14.impTotalPos + var0_14, 0, 1), true)
	end

	setText(arg0_14.ptCount, arg0_14.ptData.count)
	setActive(arg0_14.getBtnGray, arg0_14.ptData:GetMaxAvailableTargetIndex() == arg0_14.ptData:GetLevel())
end

function var0_0.GetWorldPtData(arg0_15, arg1_15)
	if arg1_15 <= pg.TimeMgr.GetInstance():GetServerTime() - (ActivityMainScene.Data2Time or 0) then
		ActivityMainScene.Data2Time = pg.TimeMgr.GetInstance():GetServerTime()

		arg0_15:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 2,
			activity_id = arg0_15.ptData:GetId()
		})
	end
end

return var0_0
