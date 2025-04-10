local var0_0 = class("ClueBuffSelectLayer", import("view.base.BaseUI"))

var0_0.SP_STRA_MIN_RANGE = 201308
var0_0.SP_STRA_MAX_RANGE = 201320
var0_0.SP_STRATEGY_ID = 201321
var0_0.BOOST_ITEM_ID = 65562
var0_0.PLYAER_PREF_KEY = "ClueBuffSelectedBySingleEnemyID_"

function var0_0.getUIName(arg0_1)
	return "ClueBuffSelectUI"
end

function var0_0.preloadUIList(arg0_2)
	return {
		arg0_2:getUIName(),
		"BossSingleFleetSelectView"
	}
end

function var0_0.init(arg0_3)
	arg0_3.closeBtn = arg0_3:findTF("Top/BackBtn")

	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:emit(var0_0.ON_BACK_PRESSED)
	end)
	onButton(arg0_3, arg0_3:findTF("mask"), function()
		arg0_3:emit(var0_0.ON_BACK_PRESSED)
	end)

	arg0_3.buffContainer = arg0_3:findTF("Buff/buff_list")
	arg0_3.buffTmp = arg0_3.buffContainer:Find("buff")
	arg0_3.buffTFs = {}
	arg0_3.strategyList = {}
	arg0_3.buffDescList = {}

	for iter0_3 = 1, 4 do
		local var0_3 = arg0_3:findTF("Buff/buff_desc_list/buff_desc_" .. iter0_3)

		table.insert(arg0_3.buffDescList, var0_3)
		setText(var0_3:Find("unselect"), i18n("clue_buff_unselect"))
	end

	arg0_3.stageName = arg0_3:findTF("Stage/stage_name_text")
	arg0_3.stageLV = arg0_3:findTF("Stage/stage_level_text")

	setText(arg0_3:findTF("Stage/text_stage_reserach"), i18n("clue_buff_research"))
	setText(arg0_3:findTF("Stage/text_stage_loot"), i18n("clue_buff_stage_loot"))

	arg0_3.awards = arg0_3:findTF("Loot/awards")
	arg0_3.awardTpl = arg0_3:findTF("Loot/awards/award")
	arg0_3.goBtn = arg0_3:findTF("Combat/go_btn")

	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(ClueBuffSelectMediator.ON_FLEET_SELECT, arg0_3.singleID)
	end)

	arg0_3.detailView = arg0_3:findTF("Detail")
	arg0_3.detailBtn = arg0_3:findTF("BuffDetail")

	setActive(arg0_3.detailBtn, false)

	arg0_3.detailList = UIItemList.New(arg0_3.detailView:Find("panel/list"), arg0_3.detailView:Find("panel/list/item"))

	onButton(arg0_3, arg0_3.detailBtn, function()
		arg0_3:openDetailView()
	end)

	arg0_3.detailClose = arg0_3.detailView:Find("btnBack")

	onButton(arg0_3, arg0_3.detailClose, function()
		arg0_3:closeDetailView()
	end)
	onButton(arg0_3, arg0_3.detailView:Find("mask"), function()
		arg0_3:closeDetailView()
	end)

	arg0_3.ticket = arg0_3:findTF("Ticket")
	arg0_3.ticketTips = arg0_3:findTF("ticketTips")
	arg0_3.ticketCheckBox = arg0_3.ticket:Find("checkbox")
	arg0_3.useTicket = false

	onButton(arg0_3, arg0_3.ticket:Find("bg"), function()
		arg0_3:UpdateTicket()
	end)
	setText(arg0_3.ticketTips, i18n("clue_buff_ticket_tips"))

	arg0_3.explore = arg0_3:findTF("exploreTarget")

	setActive(arg0_3.explore, true)
	BossSingleBattleFleetSelectViewComponent.AttachFleetSelect(arg0_3, ClueBuffSelectMediator)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.didEnter(arg0_11)
	arg0_11:updateBuffView()
	arg0_11:UpdateCluePanel()

	arg0_11.contextData.selectedBuffList = {}

	for iter0_11, iter1_11 in ipairs(arg0_11.preSelectedBuffList) do
		arg0_11:selectBuff(iter1_11)
	end

	if arg0_11.contextData.editFleet then
		arg0_11:ShowNormalFleet(arg0_11.singleID)
	end
end

function var0_0.show(arg0_12)
	setActive(arg0_12._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
end

function var0_0.hide(arg0_13)
	setActive(arg0_13._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf, arg0_13._parentTf)
end

function var0_0.openDetailView(arg0_14)
	setActive(arg0_14.detailView, true)
	arg0_14:updateDetailView()
end

function var0_0.closeDetailView(arg0_15)
	setActive(arg0_15.detailView, false)
end

function var0_0.updateBuffView(arg0_16)
	local var0_16 = pg.activity_single_enemy[arg0_16.singleID]
	local var1_16 = var0_16.strategy_id

	for iter0_16, iter1_16 in ipairs(var1_16) do
		if not table.contains(arg0_16.strategyList, iter1_16) then
			setActive(arg0_16.buffTFs[iter1_16]:Find("selected"), false)
		end
	end

	local var2_16 = pg.strategy_data_template

	for iter2_16, iter3_16 in ipairs(arg0_16.buffDescList) do
		local var3_16 = iter3_16:Find("mask/desc")
		local var4_16 = var3_16:GetComponent("RectTransform")

		if iter2_16 > var0_16.strategy_num then
			iter3_16:Find("bg"):GetComponent(typeof(CanvasGroup)).alpha = 0.05

			setActive(iter3_16:Find("lock"), true)
			setActive(var3_16, false)
			setActive(iter3_16:Find("over_deco"), false)
			setActive(iter3_16:Find("unselect"), false)
		else
			setActive(iter3_16:Find("lock"), false)

			if arg0_16.strategyList[iter2_16] then
				setActive(var3_16, true)

				local var5_16 = var2_16[arg0_16.strategyList[iter2_16]]

				iter3_16:Find("bg"):GetComponent(typeof(CanvasGroup)).alpha = 1

				setText(var3_16:Find("index"), iter2_16)
				setText(var3_16:Find("name"), var5_16.name)
				setText(var3_16:Find("desc"), var5_16.desc)
				setActive(iter3_16:Find("lock"), false)
				setActive(iter3_16:Find("unselect"), false)
				Canvas.ForceUpdateCanvases()
				setActive(iter3_16:Find("over_deco"), var4_16.rect.width > 560)
			else
				setActive(var3_16, false)

				iter3_16:Find("bg"):GetComponent(typeof(CanvasGroup)).alpha = 0.2

				setActive(iter3_16:Find("unselect"), true)
				setActive(iter3_16:Find("lock"), false)
				setActive(iter3_16:Find("over_deco"), false)
			end
		end
	end

	for iter4_16, iter5_16 in pairs(arg0_16.buffTFs) do
		if table.contains(arg0_16.strategyList, iter4_16) then
			setActive(iter5_16:Find("selected"), true)

			local var6_16 = table.indexof(arg0_16.strategyList, iter4_16)

			setImageSprite(iter5_16:Find("selected/counter"), LoadSprite("ui/cluebuffselectui_atlas", "buff_n_" .. var6_16), true)
		else
			setActive(iter5_16:Find("selected"), false)
		end
	end

	setActive(arg0_16.detailBtn, #arg0_16.strategyList > 0)

	if arg0_16.ptAwardTF then
		setActive(arg0_16.ptAwardTF:Find("boost"), #arg0_16.strategyList > 0)
		setText(arg0_16.ptAwardTF:Find("boost/boost"), "+" .. 5 * #arg0_16.strategyList .. "%")
	end

	local var7_16 = table.concat({
		unpack(arg0_16.strategyList)
	}, "|")

	PlayerPrefs.SetString(var0_0.PLYAER_PREF_KEY .. arg0_16.singleID, var7_16)
	setText(arg0_16:findTF("Stage/text_stage_buff_count"), "(" .. #arg0_16.strategyList .. "/" .. var0_16.strategy_num .. ")")
end

function var0_0.UpdateCluePanel(arg0_17)
	local var0_17 = ActivityConst.Valleyhospital_ACT_ID
	local var1_17 = getProxy(PlayerProxy):getRawData().id
	local var2_17 = PlayerPrefs.GetInt("investigatingGroupId_" .. var0_17 .. "_" .. var1_17, 0)
	local var3_17 = true
	local var4_17
	local var5_17 = 0
	local var6_17 = pg.activity_clue

	if var2_17 ~= 0 then
		local var7_17 = var6_17.get_id_list_by_group[var2_17]

		var4_17 = {
			var6_17[var7_17[1]],
			var6_17[var7_17[2]],
			var6_17[var7_17[3]]
		}
		var5_17 = getProxy(TaskProxy):getTaskVO(tonumber(var4_17[3].task_id)):getProgress()

		for iter0_17 = 1, 3 do
			if not getProxy(TaskProxy):getFinishTaskById(tonumber(var4_17[iter0_17].task_id)) then
				var3_17 = false

				break
			end
		end
	end

	if var3_17 then
		setText(arg0_17:findTF("target/Text", arg0_17.explore), i18n("clue_unselect_tip"))
	else
		setText(arg0_17:findTF("target/Text", arg0_17.explore), var4_17[1].unlock_desc .. var4_17[1].unlock_num .. "/" .. var4_17[2].unlock_num .. "/" .. var4_17[3].unlock_num .. i18n("clue_task_tip", var5_17))
	end
end

function var0_0.updateDetailView(arg0_18)
	local var0_18 = pg.activity_single_enemy[arg0_18.singleID]
	local var1_18 = {}

	for iter0_18, iter1_18 in ipairs(arg0_18.strategyList) do
		table.insert(var1_18, iter1_18)
	end

	for iter2_18, iter3_18 in ipairs(arg0_18.strategyList) do
		if iter3_18 >= var0_0.SP_STRA_MIN_RANGE and iter3_18 <= var0_0.SP_STRA_MAX_RANGE then
			table.insert(var1_18, var0_0.SP_STRATEGY_ID)

			break
		end
	end

	local var2_18 = pg.strategy_data_template

	arg0_18.detailList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var1_18[arg1_19 + 1]
			local var1_19 = var2_18[var0_19]

			GetImageSpriteFromAtlasAsync("strategyicon/" .. var1_19.icon, "", arg2_19:Find("icon"))
			setText(arg2_19:Find("textBG/name"), var1_19.name)
			setText(arg2_19:Find("textBG/desc"), var1_19.desc)
		end
	end)
	arg0_18.detailList:align(#var1_18)
end

function var0_0.SetStageID(arg0_20, arg1_20)
	arg0_20.singleID = arg1_20

	local var0_20 = pg.activity_single_enemy[arg0_20.singleID]
	local var1_20 = pg.strategy_data_template

	setText(arg0_20.stageName, var0_20.name)
	setText(arg0_20.stageLV, var0_20.level)
	setText(arg0_20:findTF("Stage/text_stage_PTBoost"), i18n("clue_buff_pt_boost", var0_20.strategy_num))

	local var2_20 = var0_20.strategy_id

	for iter0_20, iter1_20 in ipairs(var2_20) do
		local var3_20 = cloneTplTo(arg0_20.buffTmp, arg0_20.buffContainer)

		setActive(var3_20, true)

		local var4_20 = var1_20[iter1_20]

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var4_20.icon, "", var3_20:Find("icon"))
		setActive(var3_20:Find("selected"), false)
		onButton(arg0_20, var3_20, function()
			arg0_20:onStrategyClick(iter1_20)
		end)

		arg0_20.buffTFs[iter1_20] = var3_20
	end

	setImageSprite(arg0_20:findTF("Stage/stage_icon"), LoadSprite("ui/cluebuffselectui_atlas", var0_20.icon), true)

	if var0_20.type >= BossSingleVariableEnemyData.TYPE.SP then
		setActive(arg0_20:findTF("Stage/stage_type_icon"), false)
		setActive(arg0_20.ticket, true)
		setActive(arg0_20.ticketTips, true)
		GetImageSpriteFromAtlasAsync(pg.item_virtual_data_statistics[var0_20.enter_cost].icon, "", arg0_20.ticket:Find("icon"), true)

		local var5_20 = getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID)

		setText(arg0_20.ticket:Find("count"), var5_20.data1)
	else
		setActive(arg0_20:findTF("Stage/stage_type_icon"), true)
		setActive(arg0_20.ticket, false)
		setActive(arg0_20.ticketTips, false)
		setImageSprite(arg0_20:findTF("Stage/stage_type_icon"), LoadSprite("ui/cluebuffselectui_atlas", "tier_" .. var0_20.type), true)

		arg0_20.useTicket = false

		setActive(arg0_20.ticketCheckBox, arg0_20.useTicket)

		arg0_20.contextData.useTicket = arg0_20.useTicket
	end

	local var6_20 = pg.expedition_data_template[var0_20.expedition_id].award_display

	arg0_20:updateAwards(var6_20, arg0_20.awards, arg0_20.awardTpl)
end

function var0_0.UpdateTicket(arg0_22)
	if getProxy(ActivityProxy):getActivityById(ActivityConst.Valleyhospital_ACT_ID).data1 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("clue_buff_empty_ticket"))
	else
		arg0_22.useTicket = not arg0_22.useTicket

		setActive(arg0_22.ticketCheckBox, arg0_22.useTicket)

		arg0_22.contextData.useTicket = arg0_22.useTicket
	end
end

function var0_0.SetPreSelectedBuff(arg0_23, arg1_23)
	arg0_23.preSelectedBuffList = {}

	for iter0_23, iter1_23 in ipairs(arg1_23) do
		table.insert(arg0_23.preSelectedBuffList, iter1_23)
	end
end

function var0_0.onStrategyClick(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.strategyList) do
		if iter1_24 == arg1_24 then
			table.remove(arg0_24.strategyList, iter0_24)
			table.remove(arg0_24.contextData.selectedBuffList, iter0_24)
			arg0_24:updateBuffView()

			return
		end
	end

	arg0_24:selectBuff(arg1_24)
end

function var0_0.selectBuff(arg0_25, arg1_25)
	local var0_25 = pg.activity_single_enemy[arg0_25.singleID]

	if #arg0_25.strategyList >= var0_25.strategy_num then
		pg.TipsMgr.GetInstance():ShowTips(i18n("clue_buff_reach_max"))

		return
	end

	table.insert(arg0_25.strategyList, arg1_25)
	table.insert(arg0_25.contextData.selectedBuffList, arg1_25)
	arg0_25:updateBuffView()
end

function var0_0.updateAwards(arg0_26, arg1_26, arg2_26, arg3_26)
	for iter0_26 = 1, #arg1_26 do
		local var0_26 = cloneTplTo(arg3_26, arg2_26)
		local var1_26 = arg1_26[iter0_26]
		local var2_26 = {
			type = var1_26[1],
			id = var1_26[2],
			count = var1_26[3]
		}

		if var1_26[2] == var0_0.BOOST_ITEM_ID then
			arg0_26.ptAwardTF = var0_26
		end

		updateDrop(findTF(var0_26, "mask"), var2_26)
		onButton(arg0_26, var0_26, function()
			local var0_27 = Item.getConfigData(var1_26[2])
			local var1_27 = {
				[99] = true
			}

			if var0_27 and var1_27[var0_27.type] then
				local var2_27 = var0_27.display_icon
				local var3_27 = {}

				for iter0_27, iter1_27 in ipairs(var2_27) do
					local var4_27 = iter1_27[1]
					local var5_27 = iter1_27[2]

					var3_27[#var3_27 + 1] = {
						hideName = true,
						type = var4_27,
						id = var5_27
					}
				end

				arg0_26:emit(var0_0.ON_DROP_LIST, {
					item2Row = true,
					itemList = var3_27,
					content = var0_27.display
				})
			else
				arg0_26:emit(BaseUI.ON_DROP, var2_26)
			end
		end, SFX_PANEL)
	end
end

function var0_0.willExit(arg0_28)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_28._tf, arg0_28._parentTf)
end

function var0_0.onBackPressed(arg0_29)
	if isActive(arg0_29.detailView) then
		arg0_29:closeDetailView()
	else
		arg0_29:closeView()
	end
end

return var0_0
