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
		[var2_0] = arg0_5:findTF("filter/finish"),
		[var1_0] = arg0_5:findTF("filter/parse")
	}
	arg0_5.filterTr = arg0_5:findTF("filter")
	arg0_5.mainTr = arg0_5:findTF("main")
	arg0_5.scrollRect = arg0_5:findTF("main/list/scrollrect"):GetComponent("LScrollRect")
	arg0_5.paintingTr = arg0_5:findTF("main/paint")
	arg0_5.openTr = arg0_5:findTF("main/open")
	arg0_5.ptIcon = arg0_5:findTF("main/award/pt/icon")
	arg0_5.ptTr = arg0_5:findTF("main/award/pt/Text"):GetComponent(typeof(Text))
	arg0_5.getAllBtn = arg0_5:findTF("main/award/get_all")
	arg0_5.awardScrollrect = arg0_5:findTF("main/award/scrollrect"):GetComponent("LScrollRect")
	arg0_5.awardArrTr = arg0_5:findTF("main/award/arr")
	arg0_5.emptyTr = arg0_5:findTF("empty")
	arg0_5.emptyFinishTr = arg0_5:findTF("empty_finsih")
	arg0_5.backBtn = arg0_5:findTF("blur_panel/adapt/top/back")
	arg0_5.msgBox = ArchivesWorldBossMsgboxPage.New(arg0_5._parentTf.parent, arg0_5.event)

	setText(arg0_5:findTF("main/award/pt/label"), i18n("meta_syn_value_label"))
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:emit(WorldBossScene.ON_QUIT_ARCHIVES_LIST)
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6:findTF("help"), function()
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

	if arg0_6:findTF("empty_finsih") then
		GetComponent(arg0_6:findTF("empty_finsih"), typeof(Image)):SetNativeSize()
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
	local var2_22 = arg1_22.id == var1_22 or arg1_22.progress.metaPtData:IsMaxPt()

	setActive(arg0_22.openTr, not var2_22)

	if var2_22 then
		removeOnButton(arg0_22.openTr)
	else
		onButton(arg0_22, arg0_22.openTr, function()
			arg0_22:Switch(arg1_22)
		end, SFX_PANEL)
	end
end

function var0_0.Switch(arg0_24, arg1_24)
	local var0_24 = WorldBossConst.GetAchieveState()

	if var0_24 == WorldBossConst.ACHIEVE_STATE_NOSTART then
		arg0_24:emit(WorldBossMediator.ON_SWITCH_ARCHIVES, arg1_24.id)
	elseif var0_24 == WorldBossConst.ACHIEVE_STATE_STARTING then
		local var1_24 = WorldBossConst.GetArchivesId()
		local var2_24 = WorldBossConst.BossId2MetaId(var1_24)
		local var3_24 = pg.ship_strengthen_meta[var2_24].ship_id
		local var4_24 = pg.ship_data_statistics[var3_24].name

		arg0_24.msgBox:ExecuteAction("Show", {
			content = i18n("world_boss_switch_archives", var4_24),
			onYes = function()
				arg0_24:emit(WorldBossMediator.ON_SWITCH_ARCHIVES, arg1_24.id)
			end
		})
	end
end

function var0_0.UpdateAwards(arg0_26, arg1_26)
	local var0_26 = arg1_26.progress.metaPtData
	local var1_26 = var0_26.dropList
	local var2_26 = var0_26.targets

	setImageSprite(arg0_26.ptIcon, LoadSprite(arg1_26.progress:getPtIconPath()))

	arg0_26.ptTr.text = var0_26.count

	local var3_26 = arg1_26.progress.metaPtData:CanGetAward()

	setActive(arg0_26.getAllBtn, var3_26)

	if not var3_26 then
		removeOnButton(arg0_26.getAllBtn)
	else
		onButton(arg0_26, arg0_26.getAllBtn, function()
			local var0_27, var1_27 = arg0_26:getOneStepPTAwardLevelAndCount(arg1_26.progress)

			pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
				groupID = arg1_26.progress.id,
				targetCount = var1_27
			})
		end, SFX_PANEL)
	end

	arg0_26.awardCards = {}
	arg0_26.awardDisplays = {}

	for iter0_26, iter1_26 in ipairs(var1_26) do
		table.insert(arg0_26.awardDisplays, {
			itemInfo = iter1_26,
			target = var2_26[iter0_26],
			level = var0_26.level,
			count = var0_26.count,
			unlockPTNum = arg1_26.progress.unlockPTNum
		})
	end

	arg0_26.awardScrollrect:SetTotalCount(#arg0_26.awardDisplays)

	local var4_26 = math.min(var0_26.level, #var2_26 - 5)
	local var5_26 = arg0_26.awardScrollrect:HeadIndexToValue(var4_26)

	arg0_26.awardScrollrect:ScrollTo(var5_26)
end

function var0_0.getOneStepPTAwardLevelAndCount(arg0_28, arg1_28)
	local var0_28 = arg1_28.metaPtData:GetResProgress()
	local var1_28 = arg1_28.metaPtData.targets
	local var2_28 = arg1_28:getStoryIndexList()
	local var3_28 = arg1_28.unlockPTLevel
	local var4_28 = 0

	for iter0_28 = 1, #var1_28 do
		local var5_28 = false
		local var6_28 = false

		if var0_28 >= var1_28[iter0_28] then
			var5_28 = true
		end

		local var7_28 = var2_28[iter0_28]

		if var7_28 == 0 then
			var6_28 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(var7_28) then
			var6_28 = true
		end

		if var5_28 and var6_28 then
			var4_28 = iter0_28
		else
			break
		end
	end

	print("calc max level", var4_28, var1_28[var4_28])

	return var4_28, var1_28[var4_28]
end

function var0_0.OnInitAwardItem(arg0_29, arg1_29)
	local var0_29 = ArchivesWorldBossAwardCard.New(arg1_29)

	onButton(arg0_29, var0_29.itemTF, function()
		arg0_29:emit(BaseUI.ON_DROP, var0_29.dropInfo)
	end, SFX_PANEL)

	arg0_29.awardCards[arg1_29] = var0_29
end

function var0_0.OnUpdateAwardItem(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.awardCards[arg2_31]

	if not var0_31 then
		arg0_31:OnInitAwardItem(arg2_31)

		var0_31 = arg0_31.awardCards[arg2_31]
	end

	local var1_31 = arg0_31.awardDisplays[arg1_31 + 1]

	var0_31:Update(var1_31, arg1_31 + 1)
end

function var0_0.OnDestroy(arg0_32)
	arg0_32.scrollRect.onInitItem = nil
	arg0_32.scrollRect.onUpdateItem = nil
	arg0_32.awardScrollrect.onInitItem = nil
	arg0_32.awardScrollrect.onUpdateItem = nil

	arg0_32.awardScrollrect.onValueChanged:RemoveAllListeners()

	if arg0_32.msgBox then
		arg0_32.msgBox:Destroy()

		arg0_32.msgBox = nil
	end

	for iter0_32, iter1_32 in pairs(arg0_32.cards) do
		iter1_32:Dispose()
	end

	arg0_32.cards = nil

	for iter2_32, iter3_32 in pairs(arg0_32.awardCards or {}) do
		iter3_32:Dispose()
	end

	arg0_32.awardCards = nil
end

return var0_0
