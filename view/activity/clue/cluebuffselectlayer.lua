local var0_0 = class("ClueBuffSelectLayer", import("view.base.BaseUI"))

var0_0.SP_STRA_MIN_RANGE = 201308
var0_0.SP_STRA_MAX_RANGE = 201320
var0_0.SP_STRATEGY_ID = 201321
var0_0.BOOST_ITEM_ID = 65562
var0_0.PLYAER_PREF_KEY = "ClueBuffSelectedBySingleEnemyID_"

function var0_0.getUIName(arg0_1)
	return "ClueBuffSelectUI"
end

function var0_0.init(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("Top/BackBtn")

	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:emit(var0_0.ON_BACK_PRESSED)
	end)
	onButton(arg0_2, arg0_2:findTF("mask"), function()
		arg0_2:emit(var0_0.ON_BACK_PRESSED)
	end)

	arg0_2.buffContainer = arg0_2:findTF("Buff/buff_list")
	arg0_2.buffTmp = arg0_2.buffContainer:Find("buff")
	arg0_2.buffTFs = {}
	arg0_2.strategyList = {}
	arg0_2.buffDescList = {}

	for iter0_2 = 1, 4 do
		local var0_2 = arg0_2:findTF("Buff/buff_desc_list/buff_desc_" .. iter0_2)

		table.insert(arg0_2.buffDescList, var0_2)
		setText(var0_2:Find("unselect"), i18n("clue_buff_unselect"))
	end

	arg0_2.stageName = arg0_2:findTF("Stage/stage_name_text")
	arg0_2.stageLV = arg0_2:findTF("Stage/stage_level_text")

	setText(arg0_2:findTF("Stage/text_stage_reserach"), i18n("clue_buff_research"))
	setText(arg0_2:findTF("Stage/text_stage_loot"), i18n("clue_buff_stage_loot"))

	arg0_2.awards = arg0_2:findTF("Loot/awards")
	arg0_2.awardTpl = arg0_2:findTF("Loot/awards/award")
	arg0_2.goBtn = arg0_2:findTF("Combat/go_btn")

	onButton(arg0_2, arg0_2.goBtn, function()
		arg0_2:emit(ClueBuffSelectMediator.ON_FLEET_SELECT, arg0_2.singleID)
	end)

	arg0_2.detailView = arg0_2:findTF("Detail")
	arg0_2.detailBtn = arg0_2:findTF("BuffDetail")

	setActive(arg0_2.detailBtn, false)

	arg0_2.detailList = UIItemList.New(arg0_2.detailView:Find("panel/list"), arg0_2.detailView:Find("panel/list/item"))

	onButton(arg0_2, arg0_2.detailBtn, function()
		arg0_2:openDetailView()
	end)

	arg0_2.detailClose = arg0_2.detailView:Find("btnBack")

	onButton(arg0_2, arg0_2.detailClose, function()
		arg0_2:closeDetailView()
	end)
	onButton(arg0_2, arg0_2.detailView:Find("mask"), function()
		arg0_2:closeDetailView()
	end)

	arg0_2.ticket = arg0_2:findTF("Ticket")
	arg0_2.ticketTips = arg0_2:findTF("ticketTips")
	arg0_2.ticketCheckBox = arg0_2.ticket:Find("checkbox")
	arg0_2.useTicket = false

	onButton(arg0_2, arg0_2.ticket:Find("bg"), function()
		arg0_2:UpdateTicket()
	end)
	setText(arg0_2.ticketTips, i18n("clue_buff_ticket_tips"))

	arg0_2.explore = arg0_2:findTF("exploreTarget")

	setActive(arg0_2.explore, true)
	BossSingleBattleFleetSelectViewComponent.AttachFleetSelect(arg0_2, ClueBuffSelectMediator)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_10)
	arg0_10:updateBuffView()
	arg0_10:UpdateCluePanel()

	arg0_10.contextData.selectedBuffList = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.preSelectedBuffList) do
		arg0_10:selectBuff(iter1_10)
	end

	if arg0_10.contextData.editFleet then
		arg0_10:ShowNormalFleet(arg0_10.singleID)
	end
end

function var0_0.show(arg0_11)
	setActive(arg0_11._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_11._tf)
end

function var0_0.hide(arg0_12)
	setActive(arg0_12._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf, arg0_12._parentTf)
end

function var0_0.openDetailView(arg0_13)
	setActive(arg0_13.detailView, true)
	arg0_13:updateDetailView()
end

function var0_0.closeDetailView(arg0_14)
	setActive(arg0_14.detailView, false)
end

function var0_0.updateBuffView(arg0_15)
	local var0_15 = pg.activity_single_enemy[arg0_15.singleID]
	local var1_15 = var0_15.strategy_id

	for iter0_15, iter1_15 in ipairs(var1_15) do
		if not table.contains(arg0_15.strategyList, iter1_15) then
			setActive(arg0_15.buffTFs[iter1_15]:Find("selected"), false)
		end
	end

	local var2_15 = pg.strategy_data_template

	for iter2_15, iter3_15 in ipairs(arg0_15.buffDescList) do
		local var3_15 = iter3_15:Find("mask/desc")
		local var4_15 = var3_15:GetComponent("RectTransform")

		if iter2_15 > var0_15.strategy_num then
			iter3_15:Find("bg"):GetComponent(typeof(CanvasGroup)).alpha = 0.05

			setActive(iter3_15:Find("lock"), true)
			setActive(var3_15, false)
			setActive(iter3_15:Find("over_deco"), false)
			setActive(iter3_15:Find("unselect"), false)
		else
			setActive(iter3_15:Find("lock"), false)

			if arg0_15.strategyList[iter2_15] then
				setActive(var3_15, true)

				local var5_15 = var2_15[arg0_15.strategyList[iter2_15]]

				iter3_15:Find("bg"):GetComponent(typeof(CanvasGroup)).alpha = 1

				setText(var3_15:Find("index"), iter2_15)
				setText(var3_15:Find("name"), var5_15.name)
				setText(var3_15:Find("desc"), var5_15.desc)
				setActive(iter3_15:Find("lock"), false)
				setActive(iter3_15:Find("unselect"), false)
				Canvas.ForceUpdateCanvases()
				setActive(iter3_15:Find("over_deco"), var4_15.rect.width > 560)
			else
				setActive(var3_15, false)

				iter3_15:Find("bg"):GetComponent(typeof(CanvasGroup)).alpha = 0.2

				setActive(iter3_15:Find("unselect"), true)
				setActive(iter3_15:Find("lock"), false)
				setActive(iter3_15:Find("over_deco"), false)
			end
		end
	end

	for iter4_15, iter5_15 in pairs(arg0_15.buffTFs) do
		if table.contains(arg0_15.strategyList, iter4_15) then
			setActive(iter5_15:Find("selected"), true)

			local var6_15 = table.indexof(arg0_15.strategyList, iter4_15)

			setImageSprite(iter5_15:Find("selected/counter"), LoadSprite("ui/cluebuffselectui_atlas", "buff_n_" .. var6_15), true)
		else
			setActive(iter5_15:Find("selected"), false)
		end
	end

	setActive(arg0_15.detailBtn, #arg0_15.strategyList > 0)

	if arg0_15.ptAwardTF then
		setActive(arg0_15.ptAwardTF:Find("boost"), #arg0_15.strategyList > 0)
		setText(arg0_15.ptAwardTF:Find("boost/boost"), "+" .. 5 * #arg0_15.strategyList .. "%")
	end

	local var7_15 = table.concat({
		unpack(arg0_15.strategyList)
	}, "|")

	PlayerPrefs.SetString(var0_0.PLYAER_PREF_KEY .. arg0_15.singleID, var7_15)
	setText(arg0_15:findTF("Stage/text_stage_buff_count"), "(" .. #arg0_15.strategyList .. "/" .. var0_15.strategy_num .. ")")
end

function var0_0.UpdateCluePanel(arg0_16)
	local var0_16 = ActivityConst.Valleyhospital_ACT_ID
	local var1_16 = getProxy(PlayerProxy):getRawData().id
	local var2_16 = PlayerPrefs.GetInt("investigatingGroupId_" .. var0_16 .. "_" .. var1_16, 0)
	local var3_16 = true
	local var4_16
	local var5_16 = 0
	local var6_16 = pg.activity_clue

	if var2_16 ~= 0 then
		local var7_16 = var6_16.get_id_list_by_group[var2_16]

		var4_16 = {
			var6_16[var7_16[1]],
			var6_16[var7_16[2]],
			var6_16[var7_16[3]]
		}
		var5_16 = getProxy(TaskProxy):getTaskVO(tonumber(var4_16[3].task_id)):getProgress()

		for iter0_16 = 1, 3 do
			if not getProxy(TaskProxy):getFinishTaskById(tonumber(var4_16[iter0_16].task_id)) then
				var3_16 = false

				break
			end
		end
	end

	if var3_16 then
		setText(arg0_16:findTF("target/Text", arg0_16.explore), i18n("clue_unselect_tip"))
	else
		setText(arg0_16:findTF("target/Text", arg0_16.explore), var4_16[1].unlock_desc .. var4_16[1].unlock_num .. "/" .. var4_16[2].unlock_num .. "/" .. var4_16[3].unlock_num .. i18n("clue_task_tip", var5_16))
	end
end

function var0_0.updateDetailView(arg0_17)
	local var0_17 = pg.activity_single_enemy[arg0_17.singleID]
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.strategyList) do
		table.insert(var1_17, iter1_17)
	end

	for iter2_17, iter3_17 in ipairs(arg0_17.strategyList) do
		if iter3_17 >= var0_0.SP_STRA_MIN_RANGE and iter3_17 <= var0_0.SP_STRA_MAX_RANGE then
			table.insert(var1_17, var0_0.SP_STRATEGY_ID)

			break
		end
	end

	local var2_17 = pg.strategy_data_template

	arg0_17.detailList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var1_17[arg1_18 + 1]
			local var1_18 = var2_17[var0_18]

			GetImageSpriteFromAtlasAsync("strategyicon/" .. var1_18.icon, "", arg2_18:Find("icon"))
			setText(arg2_18:Find("textBG/name"), var1_18.name)
			setText(arg2_18:Find("textBG/desc"), var1_18.desc)
		end
	end)
	arg0_17.detailList:align(#var1_17)
end

function var0_0.SetStageID(arg0_19, arg1_19)
	arg0_19.singleID = arg1_19

	local var0_19 = pg.activity_single_enemy[arg0_19.singleID]
	local var1_19 = pg.strategy_data_template

	setText(arg0_19.stageName, var0_19.name)
	setText(arg0_19.stageLV, var0_19.level)
	setText(arg0_19:findTF("Stage/text_stage_PTBoost"), i18n("clue_buff_pt_boost", var0_19.strategy_num))

	local var2_19 = var0_19.strategy_id

	for iter0_19, iter1_19 in ipairs(var2_19) do
		local var3_19 = cloneTplTo(arg0_19.buffTmp, arg0_19.buffContainer)

		setActive(var3_19, true)

		local var4_19 = var1_19[iter1_19]

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var4_19.icon, "", var3_19:Find("icon"))
		setActive(var3_19:Find("selected"), false)
		onButton(arg0_19, var3_19, function()
			arg0_19:onStrategyClick(iter1_19)
		end)

		arg0_19.buffTFs[iter1_19] = var3_19
	end

	setImageSprite(arg0_19:findTF("Stage/stage_icon"), LoadSprite("ui/cluebuffselectui_atlas", var0_19.icon), true)

	if var0_19.type >= BossSingleVariableEnemyData.TYPE.SP then
		setActive(arg0_19:findTF("Stage/stage_type_icon"), false)
		setActive(arg0_19.ticket, true)
		setActive(arg0_19.ticketTips, true)
		GetImageSpriteFromAtlasAsync(pg.item_virtual_data_statistics[var0_19.enter_cost].icon, "", arg0_19.ticket:Find("icon"), true)

		local var5_19 = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID)

		setText(arg0_19.ticket:Find("count"), var5_19.data1)
	else
		setActive(arg0_19:findTF("Stage/stage_type_icon"), true)
		setActive(arg0_19.ticket, false)
		setActive(arg0_19.ticketTips, false)
		setImageSprite(arg0_19:findTF("Stage/stage_type_icon"), LoadSprite("ui/cluebuffselectui_atlas", "tier_" .. var0_19.type), true)

		arg0_19.useTicket = false

		setActive(arg0_19.ticketCheckBox, arg0_19.useTicket)

		arg0_19.contextData.useTicket = arg0_19.useTicket
	end

	local var6_19 = pg.expedition_data_template[var0_19.expedition_id].award_display

	arg0_19:updateAwards(var6_19, arg0_19.awards, arg0_19.awardTpl)
end

function var0_0.UpdateTicket(arg0_21)
	if getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID).data1 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("clue_buff_empty_ticket"))
	else
		arg0_21.useTicket = not arg0_21.useTicket

		setActive(arg0_21.ticketCheckBox, arg0_21.useTicket)

		arg0_21.contextData.useTicket = arg0_21.useTicket
	end
end

function var0_0.SetPreSelectedBuff(arg0_22, arg1_22)
	arg0_22.preSelectedBuffList = {}

	for iter0_22, iter1_22 in ipairs(arg1_22) do
		table.insert(arg0_22.preSelectedBuffList, iter1_22)
	end
end

function var0_0.onStrategyClick(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.strategyList) do
		if iter1_23 == arg1_23 then
			table.remove(arg0_23.strategyList, iter0_23)
			table.remove(arg0_23.contextData.selectedBuffList, iter0_23)
			arg0_23:updateBuffView()

			return
		end
	end

	arg0_23:selectBuff(arg1_23)
end

function var0_0.selectBuff(arg0_24, arg1_24)
	local var0_24 = pg.activity_single_enemy[arg0_24.singleID]

	if #arg0_24.strategyList >= var0_24.strategy_num then
		pg.TipsMgr.GetInstance():ShowTips(i18n("clue_buff_reach_max"))

		return
	end

	table.insert(arg0_24.strategyList, arg1_24)
	table.insert(arg0_24.contextData.selectedBuffList, arg1_24)
	arg0_24:updateBuffView()
end

function var0_0.updateAwards(arg0_25, arg1_25, arg2_25, arg3_25)
	for iter0_25 = 1, #arg1_25 do
		local var0_25 = cloneTplTo(arg3_25, arg2_25)
		local var1_25 = arg1_25[iter0_25]
		local var2_25 = {
			type = var1_25[1],
			id = var1_25[2],
			count = var1_25[3]
		}

		if var1_25[2] == var0_0.BOOST_ITEM_ID then
			arg0_25.ptAwardTF = var0_25
		end

		updateDrop(findTF(var0_25, "mask"), var2_25)
		onButton(arg0_25, var0_25, function()
			local var0_26 = Item.getConfigData(var1_25[2])
			local var1_26 = {
				[99] = true
			}

			if var0_26 and var1_26[var0_26.type] then
				local var2_26 = var0_26.display_icon
				local var3_26 = {}

				for iter0_26, iter1_26 in ipairs(var2_26) do
					local var4_26 = iter1_26[1]
					local var5_26 = iter1_26[2]

					var3_26[#var3_26 + 1] = {
						hideName = true,
						type = var4_26,
						id = var5_26
					}
				end

				arg0_25:emit(var0_0.ON_DROP_LIST, {
					item2Row = true,
					itemList = var3_26,
					content = var0_26.display
				})
			else
				arg0_25:emit(BaseUI.ON_DROP, var2_25)
			end
		end, SFX_PANEL)
	end
end

function var0_0.willExit(arg0_27)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_27._tf, arg0_27._parentTf)
end

function var0_0.onBackPressed(arg0_28)
	if isActive(arg0_28.detailView) then
		arg0_28:closeDetailView()
	else
		arg0_28:closeView()
	end
end

return var0_0
