local var0_0 = class("GuildShowAssultShipPage", import(".GuildEventBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildShowAssultShipPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollrect = arg0_2:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.progress = arg0_2:findTF("frame/progress"):GetComponent(typeof(Text))
end

function var0_0.OnAssultShipBeRecommanded(arg0_3, arg1_3)
	arg0_3:InitList()
end

function var0_0.OnRefreshAll(arg0_4)
	arg0_4:InitData()

	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.displays) do
		var0_4[iter1_4.ship.id] = iter1_4
	end

	for iter2_4, iter3_4 in pairs(arg0_4.cards) do
		local var1_4 = var0_4[iter3_4.ship.id]

		if var1_4 then
			iter3_4:Flush(var1_4.member, var1_4.ship)
		end
	end
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)

	arg0_5.cards = {}

	function arg0_5.scrollrect.onInitItem(arg0_7)
		arg0_5:OnInitItem(arg0_7)
	end

	function arg0_5.scrollrect.onUpdateItem(arg0_8, arg1_8)
		arg0_5:OnUpdateItem(arg0_8, arg1_8)
	end
end

function var0_0.GetRecommandShipCnt(arg0_9)
	local var0_9 = 0

	for iter0_9, iter1_9 in ipairs(arg0_9.displays) do
		if iter1_9.ship.guildRecommand then
			var0_9 = var0_9 + 1
		end
	end

	return var0_9
end

function var0_0.OnInitItem(arg0_10, arg1_10)
	local var0_10 = GuildBossAssultCard.New(arg1_10)

	onButton(arg0_10, var0_10.recommendBtn, function()
		local var0_11 = var0_10.ship
		local var1_11 = var0_11.guildRecommand and GuildConst.CANCEL_RECOMMAND_SHIP or GuildConst.RECOMMAND_SHIP

		arg0_10:emit(GuildEventMediator.REFRESH_RECOMMAND_SHIPS, function()
			if var1_11 == GuildConst.RECOMMAND_SHIP and arg0_10:GetRecommandShipCnt() >= 9 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_recommend_limit"))

				return
			end

			local var0_12 = var0_11.guildRecommand and GuildConst.RECOMMAND_SHIP or GuildConst.CANCEL_RECOMMAND_SHIP

			if var1_11 ~= var0_12 then
				arg0_10:emit(GuildEventMediator.ON_RECOMM_ASSULT_SHIP, var0_11.id, var1_11)
			elseif var1_11 == GuildConst.RECOMMAND_SHIP then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_assult_ship_recommend_conflict"))
			elseif var1_11 == GuildConst.CANCEL_RECOMMAND_SHIP then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_cancel_assult_ship_recommend_conflict"))
			end
		end)
	end, SFX_PANEL)

	local function var1_10()
		if IsNil(arg0_10._tf) then
			return
		end

		pg.UIMgr:GetInstance():BlurPanel(arg0_10._tf)
	end

	local function var2_10()
		if IsNil(arg0_10._tf) then
			return
		end

		pg.UIMgr:GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
	end

	onButton(arg0_10, var0_10.viewEquipmentBtn, function()
		local var0_15 = var0_10.ship
		local var1_15 = var0_10.member

		arg0_10:emit(GuildEventLayer.SHOW_SHIP_EQUIPMENTS, var0_15, var1_15, var1_10, var2_10)
	end, SFX_PANEL)

	arg0_10.cards[arg1_10] = var0_10
end

function var0_0.OnUpdateItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.cards[arg2_16]

	if not var0_16 then
		arg0_16:OnInitItem(arg2_16)

		var0_16 = arg0_16.cards[arg2_16]
	end

	local var1_16 = arg0_16.displays[arg1_16 + 1]

	var0_16:Flush(var1_16.member, var1_16.ship)

	local var2_16 = arg0_16.totalPageCnt
	local var3_16 = math.ceil((arg0_16.scrollrect.value + 0.001) * var2_16)

	arg0_16.progress.text = var3_16 .. "/" .. var2_16
end

function var0_0.OnShow(arg0_17)
	arg0_17:emit(GuildEventMediator.ON_GET_ALL_ASSULT_FLEET, function()
		arg0_17:InitList()
	end)
end

function var0_0.InitData(arg0_19)
	local var0_19 = arg0_19.guild
	local var1_19 = arg0_19.player

	arg0_19.displays = {}

	local var2_19 = var0_19:GetMembers()

	for iter0_19, iter1_19 in pairs(var2_19) do
		local var3_19 = iter1_19:GetAssaultFleet():GetShipList()

		for iter2_19, iter3_19 in pairs(var3_19) do
			table.insert(arg0_19.displays, {
				ship = iter3_19,
				member = iter1_19
			})
		end
	end

	table.sort(arg0_19.displays, function(arg0_20, arg1_20)
		return (arg0_20.ship.guildRecommand and 1 or 0) > (arg1_20.ship.guildRecommand and 1 or 0)
	end)
end

function var0_0.InitList(arg0_21)
	arg0_21:InitData()

	arg0_21.totalPageCnt = math.ceil(#arg0_21.displays / 9)

	arg0_21.scrollrect:SetTotalCount(#arg0_21.displays)
end

function var0_0.OnDestroy(arg0_22)
	var0_0.super.OnDestroy(arg0_22)

	for iter0_22, iter1_22 in pairs(arg0_22.cards) do
		iter1_22:Dispose()
	end
end

return var0_0
