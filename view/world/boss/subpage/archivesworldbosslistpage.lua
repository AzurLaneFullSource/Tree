local var0_0 = class("ArchivesWorldBossListPage", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2

function var0_0.getUIName(arg0_1)
	return "ArchivesWorldBossListUI"
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.proxy = arg1_2
end

function var0_0.OnSwitchArchives(arg0_3)
	arg0_3.isInit = false

	if arg0_3.key then
		arg0_3:Filter(arg0_3.key)
	end
end

function var0_0.OnGetMetaAwards(arg0_4)
	if arg0_4.prevCard then
		local var0_4 = arg0_4.prevCard.data

		arg0_4:UpdateAwards(var0_4)

		if arg0_4.key and not var0_4.progress.metaPtData:CanGetNextAward() then
			arg0_4:OnSwitchArchives()
		end

		arg0_4.prevCard:Update(arg0_4.prevCard.data)
	end
end

function var0_0.OnLoaded(arg0_5)
	arg0_5.toggles = {
		[var2_0] = arg0_5._tf:Find("filter/finish"),
		[var1_0] = arg0_5._tf:Find("filter/parse")
	}
	arg0_5.filterTr = arg0_5._tf:Find("filter")
	arg0_5.mainTr = arg0_5._tf:Find("main")
	arg0_5.scrollRect = arg0_5._tf:Find("main/list/scrollrect"):GetComponent("LScrollRect")
	arg0_5.paintingTr = arg0_5._tf:Find("main/paint")
	arg0_5.openTr = arg0_5._tf:Find("main/open")
	arg0_5.simulateBtn = arg0_5._tf:Find("main/simulate")
	arg0_5.ptIcon = arg0_5._tf:Find("main/award/pt/icon")
	arg0_5.ptTr = arg0_5._tf:Find("main/award/pt/Text"):GetComponent(typeof(Text))
	arg0_5.getAllBtn = arg0_5._tf:Find("main/award/get_all")
	arg0_5.awardScrollrect = arg0_5._tf:Find("main/award/scrollrect"):GetComponent("LScrollRect")
	arg0_5.awardArrTr = arg0_5._tf:Find("main/award/arr")
	arg0_5.emptyTr = arg0_5._tf:Find("empty")
	arg0_5.emptyFinishTr = arg0_5._tf:Find("empty_finsih")
	arg0_5.backBtn = arg0_5._tf:Find("blur_panel/adapt/top/back")
	arg0_5.msgBox = ArchivesWorldBossMsgboxPage.New(arg0_5._parentTf.parent, arg0_5.event)

	setText(arg0_5._tf:Find("main/award/pt/label"), i18n("meta_syn_value_label"))
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:emit(WorldBossScene.ON_QUIT_ARCHIVES_LIST)
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6._tf:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_archives_boss_list_help.tip
		})
	end, SFX_CANCEL)

	arg0_6.cards = {}

	function arg0_6.scrollRect.onInitItem(arg0_9)
		arg0_6:OnInitItem(arg0_9)
	end

	function arg0_6.scrollRect.onUpdateItem(arg0_10, arg1_10)
		arg0_6:OnUpdateItem(arg0_10, arg1_10)
	end

	function arg0_6.awardScrollrect.onInitItem(arg0_11)
		arg0_6:OnInitAwardItem(arg0_11)
	end

	function arg0_6.awardScrollrect.onUpdateItem(arg0_12, arg1_12)
		arg0_6:OnUpdateAwardItem(arg0_12, arg1_12)
	end

	arg0_6.awardScrollrect.onValueChanged:AddListener(function(arg0_13)
		setActive(arg0_6.awardArrTr, arg0_13.x < 0.97)
	end)

	for iter0_6, iter1_6 in pairs(arg0_6.toggles) do
		onToggle(arg0_6, iter1_6, function(arg0_14)
			arg0_6.isInit = false

			if arg0_14 then
				arg0_6:Filter(iter0_6)
			end
		end, SFX_PANEL)
	end

	if arg0_6._tf:Find("empty_finsih") then
		GetComponent(arg0_6._tf:Find("empty_finsih"), typeof(Image)):SetNativeSize()
	end
end

function var0_0.Filter(arg0_15, arg1_15)
	local var0_15 = WorldBossConst.GetAchieveBossList()

	arg0_15.displays = {}

	local var1_15 = {}

	for iter0_15, iter1_15 in pairs(var0_15) do
		local var2_15 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(iter1_15.meta_id)
		local var3_15 = var2_15:getMetaProgressPTState()
		local var4_15 = not var2_15.metaPtData:CanGetNextAward()

		if arg1_15 == var2_0 and var4_15 then
			table.insert(arg0_15.displays, {
				id = iter1_15.id,
				progress = var2_15
			})
		elseif arg1_15 == var1_0 and not var4_15 then
			table.insert(arg0_15.displays, {
				id = iter1_15.id,
				progress = var2_15
			})
		end

		var1_15[iter1_15.id] = var3_15
	end

	local var5_15 = WorldBossConst.GetArchivesId()

	table.sort(arg0_15.displays, function(arg0_16, arg1_16)
		local var0_16 = arg0_16.id == var5_15 and 1 or 0
		local var1_16 = arg1_16.id == var5_15 and 1 or 0

		if var0_16 == var1_16 then
			local var2_16 = var1_15[arg0_16.id]
			local var3_16 = var1_15[arg1_16.id]

			if var2_16 == var3_16 then
				return arg0_16.progress.configId < arg1_16.progress.configId
			else
				return var3_16 < var2_16
			end
		else
			return var1_16 < var0_16
		end
	end)

	arg0_15.key = arg1_15

	local var6_15 = #arg0_15.displays <= 0

	setActive(arg0_15.emptyTr, var6_15 and arg1_15 == var1_0)
	setActive(arg0_15.emptyFinishTr, var6_15 and arg1_15 == var2_0)
	setActive(arg0_15.mainTr, not var6_15)
	arg0_15.scrollRect:SetTotalCount(#arg0_15.displays)
end

function var0_0.Update(arg0_17)
	arg0_17:Show()
	triggerToggle(arg0_17.toggles[var1_0], true)
end

function var0_0.OnInitItem(arg0_18, arg1_18)
	local var0_18 = ArchivesWorldBossCard.New(arg1_18)

	onButton(arg0_18, var0_18._tf, function()
		if arg0_18.prevCard == var0_18 and arg0_18.isInit then
			return
		end

		if arg0_18.prevCard then
			arg0_18.prevCard:UnSelect()
		end

		var0_18:Select()
		arg0_18:ClickCard(var0_18.data)

		arg0_18.prevCard = var0_18
		arg0_18.prevBossId = var0_18.bossId
	end, SFX_PANEL)

	arg0_18.cards[arg1_18] = var0_18
end

function var0_0.OnUpdateItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.cards[arg2_20]

	if not var0_20 then
		arg0_20:OnInitItem(arg2_20)

		var0_20 = arg0_20.cards[arg2_20]
	end

	local var1_20 = arg0_20.displays[arg1_20 + 1]

	var0_20:Update(var1_20)

	if arg0_20.prevBossId and arg0_20.prevBossId == var0_20.bossId then
		var0_20:Select()
	else
		var0_20:UnSelect()
	end

	if arg1_20 == 0 and not arg0_20.isInit then
		triggerButton(var0_20._tf)

		arg0_20.isInit = true
	end
end

function var0_0.ClickCard(arg0_21, arg1_21)
	arg0_21:UpdateMain(arg1_21)
	arg0_21:UpdateAwards(arg1_21)
end

function var0_0.UpdateMain(arg0_22, arg1_22)
	local var0_22 = arg1_22.progress.id

	setMetaPaintingPrefabAsync(arg0_22.paintingTr, var0_22, "archives")

	local var1_22 = WorldBossConst.GetArchivesId()
	local var2_22 = arg1_22.progress.metaPtData:IsMaxPt()
	local var3_22 = arg1_22.id == var1_22 or var2_22

	setActive(arg0_22.openTr, not var3_22)
	setActive(arg0_22.simulateBtn, not arg1_22.progress.metaPtData:CanGetNextAward())

	if var3_22 then
		removeOnButton(arg0_22.openTr)
	else
		onButton(arg0_22, arg0_22.openTr, function()
			arg0_22:Switch(arg1_22)
		end, SFX_PANEL)
	end

	if var2_22 then
		onButton(arg0_22, arg0_22.simulateBtn, function()
			arg0_22:Simulate(arg1_22)
		end)
	else
		removeOnButton(arg0_22.simulateBtn)
	end
end

function var0_0.Switch(arg0_25, arg1_25)
	local var0_25 = WorldBossConst.GetAchieveState()

	if var0_25 == WorldBossConst.ACHIEVE_STATE_NOSTART then
		arg0_25:emit(WorldBossMediator.ON_SWITCH_ARCHIVES, arg1_25.id)
	elseif var0_25 == WorldBossConst.ACHIEVE_STATE_STARTING then
		local var1_25 = WorldBossConst.GetArchivesId()
		local var2_25 = WorldBossConst.BossId2MetaId(var1_25)
		local var3_25 = pg.ship_strengthen_meta[var2_25].ship_id
		local var4_25 = pg.ship_data_statistics[var3_25].name

		arg0_25.msgBox:ExecuteAction("Show", {
			content = i18n("world_boss_switch_archives", var4_25),
			onYes = function()
				arg0_25:emit(WorldBossMediator.ON_SWITCH_ARCHIVES, arg1_25.id)
			end
		})
	end
end

function var0_0.Simulate(arg0_27, arg1_27)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("meta_reproduce_btn"),
		onYes = function()
			arg0_27:emit(WorldBossMediator.ON_BATTLE, arg1_27.id, false, 1, true)
		end
	})
end

function var0_0.UpdateAwards(arg0_29, arg1_29)
	local var0_29 = arg1_29.progress.metaPtData
	local var1_29 = var0_29.dropList
	local var2_29 = var0_29.targets

	setImageSprite(arg0_29.ptIcon, LoadSprite(arg1_29.progress:getPtIconPath()))

	arg0_29.ptTr.text = var0_29.count

	local var3_29 = arg1_29.progress.metaPtData:CanGetAward()

	setActive(arg0_29.getAllBtn, var3_29)

	if not var3_29 then
		removeOnButton(arg0_29.getAllBtn)
	else
		onButton(arg0_29, arg0_29.getAllBtn, function()
			local var0_30, var1_30 = arg0_29:getOneStepPTAwardLevelAndCount(arg1_29.progress)

			pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
				groupID = arg1_29.progress.id,
				targetCount = var1_30
			})
		end, SFX_PANEL)
	end

	arg0_29.awardCards = {}
	arg0_29.awardDisplays = {}

	for iter0_29, iter1_29 in ipairs(var1_29) do
		table.insert(arg0_29.awardDisplays, {
			itemInfo = iter1_29,
			target = var2_29[iter0_29],
			level = var0_29.level,
			count = var0_29.count,
			unlockPTNum = arg1_29.progress.unlockPTNum
		})
	end

	arg0_29.awardScrollrect:SetTotalCount(#arg0_29.awardDisplays)

	local var4_29 = math.min(var0_29.level, #var2_29 - 5)
	local var5_29 = arg0_29.awardScrollrect:HeadIndexToValue(var4_29)

	arg0_29.awardScrollrect:ScrollTo(var5_29)
end

function var0_0.getOneStepPTAwardLevelAndCount(arg0_31, arg1_31)
	local var0_31 = arg1_31.metaPtData:GetResProgress()
	local var1_31 = arg1_31.metaPtData.targets
	local var2_31 = arg1_31:getStoryIndexList()
	local var3_31 = arg1_31.unlockPTLevel
	local var4_31 = 0

	for iter0_31 = 1, #var1_31 do
		local var5_31 = false
		local var6_31 = false

		if var0_31 >= var1_31[iter0_31] then
			var5_31 = true
		end

		local var7_31 = var2_31[iter0_31]

		if var7_31 == 0 then
			var6_31 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(var7_31) then
			var6_31 = true
		end

		if var5_31 and var6_31 then
			var4_31 = iter0_31
		else
			break
		end
	end

	print("calc max level", var4_31, var1_31[var4_31])

	return var4_31, var1_31[var4_31]
end

function var0_0.OnInitAwardItem(arg0_32, arg1_32)
	local var0_32 = ArchivesWorldBossAwardCard.New(arg1_32)

	onButton(arg0_32, var0_32.itemTF, function()
		arg0_32:emit(BaseUI.ON_DROP, var0_32.dropInfo)
	end, SFX_PANEL)

	arg0_32.awardCards[arg1_32] = var0_32
end

function var0_0.OnUpdateAwardItem(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.awardCards[arg2_34]

	if not var0_34 then
		arg0_34:OnInitAwardItem(arg2_34)

		var0_34 = arg0_34.awardCards[arg2_34]
	end

	local var1_34 = arg0_34.awardDisplays[arg1_34 + 1]

	var0_34:Update(var1_34, arg1_34 + 1)
end

function var0_0.OnDestroy(arg0_35)
	arg0_35.scrollRect.onInitItem = nil
	arg0_35.scrollRect.onUpdateItem = nil
	arg0_35.awardScrollrect.onInitItem = nil
	arg0_35.awardScrollrect.onUpdateItem = nil

	arg0_35.awardScrollrect.onValueChanged:RemoveAllListeners()

	if arg0_35.msgBox then
		arg0_35.msgBox:Destroy()

		arg0_35.msgBox = nil
	end

	for iter0_35, iter1_35 in pairs(arg0_35.cards) do
		iter1_35:Dispose()
	end

	arg0_35.cards = nil

	for iter2_35, iter3_35 in pairs(arg0_35.awardCards or {}) do
		iter3_35:Dispose()
	end

	arg0_35.awardCards = nil
end

return var0_0
