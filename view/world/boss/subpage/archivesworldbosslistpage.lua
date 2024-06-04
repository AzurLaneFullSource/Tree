local var0 = class("ArchivesWorldBossListPage", import("view.base.BaseSubView"))
local var1 = 1
local var2 = 2

function var0.getUIName(arg0)
	return "ArchivesWorldBossListUI"
end

function var0.Setup(arg0, arg1)
	arg0.proxy = arg1
end

function var0.OnSwitchArchives(arg0)
	arg0.isInit = false

	if arg0.key then
		arg0:Filter(arg0.key)
	end
end

function var0.OnGetMetaAwards(arg0)
	if arg0.prevCard then
		local var0 = arg0.prevCard.data

		arg0:UpdateAwards(var0)

		if arg0.key and not var0.progress.metaPtData:CanGetNextAward() then
			arg0:OnSwitchArchives()
		end

		arg0.prevCard:Update(arg0.prevCard.data)
	end
end

function var0.OnLoaded(arg0)
	arg0.toggles = {
		[var2] = arg0:findTF("filter/finish"),
		[var1] = arg0:findTF("filter/parse")
	}
	arg0.filterTr = arg0:findTF("filter")
	arg0.mainTr = arg0:findTF("main")
	arg0.scrollRect = arg0:findTF("main/list/scrollrect"):GetComponent("LScrollRect")
	arg0.paintingTr = arg0:findTF("main/paint")
	arg0.openTr = arg0:findTF("main/open")
	arg0.ptIcon = arg0:findTF("main/award/pt/icon")
	arg0.ptTr = arg0:findTF("main/award/pt/Text"):GetComponent(typeof(Text))
	arg0.getAllBtn = arg0:findTF("main/award/get_all")
	arg0.awardScrollrect = arg0:findTF("main/award/scrollrect"):GetComponent("LScrollRect")
	arg0.awardArrTr = arg0:findTF("main/award/arr")
	arg0.emptyTr = arg0:findTF("empty")
	arg0.emptyFinishTr = arg0:findTF("empty_finsih")
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back")
	arg0.msgBox = ArchivesWorldBossMsgboxPage.New(arg0._parentTf.parent, arg0.event)

	setText(arg0:findTF("main/award/pt/label"), i18n("meta_syn_value_label"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(WorldBossScene.ON_QUIT_ARCHIVES_LIST)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_archives_boss_list_help.tip
		})
	end, SFX_CANCEL)

	arg0.cards = {}

	function arg0.scrollRect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	function arg0.awardScrollrect.onInitItem(arg0)
		arg0:OnInitAwardItem(arg0)
	end

	function arg0.awardScrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateAwardItem(arg0, arg1)
	end

	arg0.awardScrollrect.onValueChanged:AddListener(function(arg0)
		setActive(arg0.awardArrTr, arg0.x < 0.97)
	end)

	for iter0, iter1 in pairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			arg0.isInit = false

			if arg0 then
				arg0:Filter(iter0)
			end
		end, SFX_PANEL)
	end

	if arg0:findTF("empty_finsih") then
		GetComponent(arg0:findTF("empty_finsih"), typeof(Image)):SetNativeSize()
	end
end

function var0.Filter(arg0, arg1)
	local var0 = WorldBossConst.GetAchieveBossList()

	arg0.displays = {}

	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		local var2 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(iter1.meta_id)
		local var3 = var2:getMetaProgressPTState()
		local var4 = not var2.metaPtData:CanGetNextAward()

		if arg1 == var2 and var4 then
			table.insert(arg0.displays, {
				id = iter1.id,
				progress = var2
			})
		elseif arg1 == var1 and not var4 then
			table.insert(arg0.displays, {
				id = iter1.id,
				progress = var2
			})
		end

		var1[iter1.id] = var3
	end

	local var5 = WorldBossConst.GetArchivesId()

	table.sort(arg0.displays, function(arg0, arg1)
		local var0 = arg0.id == var5 and 1 or 0
		local var1 = arg1.id == var5 and 1 or 0

		if var0 == var1 then
			local var2 = var1[arg0.id]
			local var3 = var1[arg1.id]

			if var2 == var3 then
				return arg0.progress.configId < arg1.progress.configId
			else
				return var3 < var2
			end
		else
			return var1 < var0
		end
	end)

	arg0.key = arg1

	local var6 = #arg0.displays <= 0

	setActive(arg0.emptyTr, var6 and arg1 == var1)
	setActive(arg0.emptyFinishTr, var6 and arg1 == var2)
	setActive(arg0.mainTr, not var6)
	arg0.scrollRect:SetTotalCount(#arg0.displays)
end

function var0.Update(arg0)
	arg0:Show()
	triggerToggle(arg0.toggles[var1], true)
end

function var0.OnInitItem(arg0, arg1)
	local var0 = ArchivesWorldBossCard.New(arg1)

	onButton(arg0, var0._tf, function()
		if arg0.prevCard == var0 and arg0.isInit then
			return
		end

		if arg0.prevCard then
			arg0.prevCard:UnSelect()
		end

		var0:Select()
		arg0:ClickCard(var0.data)

		arg0.prevCard = var0
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	var0:Update(var1)

	if arg1 == 0 and not arg0.isInit then
		triggerButton(var0._tf)

		arg0.isInit = true
	end
end

function var0.ClickCard(arg0, arg1)
	arg0:UpdateMain(arg1)
	arg0:UpdateAwards(arg1)
end

function var0.UpdateMain(arg0, arg1)
	local var0 = arg1.progress.id

	setMetaPaintingPrefabAsync(arg0.paintingTr, var0, "archives")

	local var1 = WorldBossConst.GetArchivesId()
	local var2 = arg1.id == var1 or arg1.progress.metaPtData:IsMaxPt()

	setActive(arg0.openTr, not var2)

	if var2 then
		removeOnButton(arg0.openTr)
	else
		onButton(arg0, arg0.openTr, function()
			arg0:Switch(arg1)
		end, SFX_PANEL)
	end
end

function var0.Switch(arg0, arg1)
	local var0 = WorldBossConst.GetAchieveState()

	if var0 == WorldBossConst.ACHIEVE_STATE_NOSTART then
		arg0:emit(WorldBossMediator.ON_SWITCH_ARCHIVES, arg1.id)
	elseif var0 == WorldBossConst.ACHIEVE_STATE_STARTING then
		local var1 = WorldBossConst.GetArchivesId()
		local var2 = WorldBossConst.BossId2MetaId(var1)
		local var3 = pg.ship_strengthen_meta[var2].ship_id
		local var4 = pg.ship_data_statistics[var3].name

		arg0.msgBox:ExecuteAction("Show", {
			content = i18n("world_boss_switch_archives", var4),
			onYes = function()
				arg0:emit(WorldBossMediator.ON_SWITCH_ARCHIVES, arg1.id)
			end
		})
	end
end

function var0.UpdateAwards(arg0, arg1)
	local var0 = arg1.progress.metaPtData
	local var1 = var0.dropList
	local var2 = var0.targets

	setImageSprite(arg0.ptIcon, LoadSprite(arg1.progress:getPtIconPath()))

	arg0.ptTr.text = var0.count

	local var3 = arg1.progress.metaPtData:CanGetAward()

	setActive(arg0.getAllBtn, var3)

	if not var3 then
		removeOnButton(arg0.getAllBtn)
	else
		onButton(arg0, arg0.getAllBtn, function()
			local var0, var1 = arg0:getOneStepPTAwardLevelAndCount(arg1.progress)

			pg.m02:sendNotification(GAME.GET_META_PT_AWARD, {
				groupID = arg1.progress.id,
				targetCount = var1
			})
		end, SFX_PANEL)
	end

	arg0.awardCards = {}
	arg0.awardDisplays = {}

	for iter0, iter1 in ipairs(var1) do
		table.insert(arg0.awardDisplays, {
			itemInfo = iter1,
			target = var2[iter0],
			level = var0.level,
			count = var0.count,
			unlockPTNum = arg1.progress.unlockPTNum
		})
	end

	arg0.awardScrollrect:SetTotalCount(#arg0.awardDisplays)

	local var4 = math.min(var0.level, #var2 - 5)
	local var5 = arg0.awardScrollrect:HeadIndexToValue(var4)

	arg0.awardScrollrect:ScrollTo(var5)
end

function var0.getOneStepPTAwardLevelAndCount(arg0, arg1)
	local var0 = arg1.metaPtData:GetResProgress()
	local var1 = arg1.metaPtData.targets
	local var2 = arg1:getStoryIndexList()
	local var3 = arg1.unlockPTLevel
	local var4 = 0

	for iter0 = 1, #var1 do
		local var5 = false
		local var6 = false

		if var0 >= var1[iter0] then
			var5 = true
		end

		local var7 = var2[iter0]

		if var7 == 0 then
			var6 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(var7) then
			var6 = true
		end

		if var5 and var6 then
			var4 = iter0
		else
			break
		end
	end

	print("calc max level", var4, var1[var4])

	return var4, var1[var4]
end

function var0.OnInitAwardItem(arg0, arg1)
	local var0 = ArchivesWorldBossAwardCard.New(arg1)

	onButton(arg0, var0.itemTF, function()
		arg0:emit(BaseUI.ON_DROP, var0.dropInfo)
	end, SFX_PANEL)

	arg0.awardCards[arg1] = var0
end

function var0.OnUpdateAwardItem(arg0, arg1, arg2)
	local var0 = arg0.awardCards[arg2]

	if not var0 then
		arg0:OnInitAwardItem(arg2)

		var0 = arg0.awardCards[arg2]
	end

	local var1 = arg0.awardDisplays[arg1 + 1]

	var0:Update(var1, arg1 + 1)
end

function var0.OnDestroy(arg0)
	arg0.scrollRect.onInitItem = nil
	arg0.scrollRect.onUpdateItem = nil
	arg0.awardScrollrect.onInitItem = nil
	arg0.awardScrollrect.onUpdateItem = nil

	arg0.awardScrollrect.onValueChanged:RemoveAllListeners()

	if arg0.msgBox then
		arg0.msgBox:Destroy()

		arg0.msgBox = nil
	end

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil

	for iter2, iter3 in pairs(arg0.awardCards or {}) do
		iter3:Dispose()
	end

	arg0.awardCards = nil
end

return var0
