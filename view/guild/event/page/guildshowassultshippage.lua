local var0 = class("GuildShowAssultShipPage", import(".GuildEventBasePage"))

function var0.getUIName(arg0)
	return "GuildShowAssultShipPage"
end

function var0.OnLoaded(arg0)
	arg0.scrollrect = arg0:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.progress = arg0:findTF("frame/progress"):GetComponent(typeof(Text))
end

function var0.OnAssultShipBeRecommanded(arg0, arg1)
	arg0:InitList()
end

function var0.OnRefreshAll(arg0)
	arg0:InitData()

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.displays) do
		var0[iter1.ship.id] = iter1
	end

	for iter2, iter3 in pairs(arg0.cards) do
		local var1 = var0[iter3.ship.id]

		if var1 then
			iter3:Flush(var1.member, var1.ship)
		end
	end
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.cards = {}

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end
end

function var0.GetRecommandShipCnt(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.displays) do
		if iter1.ship.guildRecommand then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.OnInitItem(arg0, arg1)
	local var0 = GuildBossAssultCard.New(arg1)

	onButton(arg0, var0.recommendBtn, function()
		local var0 = var0.ship
		local var1 = var0.guildRecommand and GuildConst.CANCEL_RECOMMAND_SHIP or GuildConst.RECOMMAND_SHIP

		arg0:emit(GuildEventMediator.REFRESH_RECOMMAND_SHIPS, function()
			if var1 == GuildConst.RECOMMAND_SHIP and arg0:GetRecommandShipCnt() >= 9 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_recommend_limit"))

				return
			end

			local var0 = var0.guildRecommand and GuildConst.RECOMMAND_SHIP or GuildConst.CANCEL_RECOMMAND_SHIP

			if var1 ~= var0 then
				arg0:emit(GuildEventMediator.ON_RECOMM_ASSULT_SHIP, var0.id, var1)
			elseif var1 == GuildConst.RECOMMAND_SHIP then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_assult_ship_recommend_conflict"))
			elseif var1 == GuildConst.CANCEL_RECOMMAND_SHIP then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_cancel_assult_ship_recommend_conflict"))
			end
		end)
	end, SFX_PANEL)

	local function var1()
		if IsNil(arg0._tf) then
			return
		end

		pg.UIMgr:GetInstance():BlurPanel(arg0._tf)
	end

	local function var2()
		if IsNil(arg0._tf) then
			return
		end

		pg.UIMgr:GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	end

	onButton(arg0, var0.viewEquipmentBtn, function()
		local var0 = var0.ship
		local var1 = var0.member

		arg0:emit(GuildEventLayer.SHOW_SHIP_EQUIPMENTS, var0, var1, var1, var2)
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

	var0:Flush(var1.member, var1.ship)

	local var2 = arg0.totalPageCnt
	local var3 = math.ceil((arg0.scrollrect.value + 0.001) * var2)

	arg0.progress.text = var3 .. "/" .. var2
end

function var0.OnShow(arg0)
	arg0:emit(GuildEventMediator.ON_GET_ALL_ASSULT_FLEET, function()
		arg0:InitList()
	end)
end

function var0.InitData(arg0)
	local var0 = arg0.guild
	local var1 = arg0.player

	arg0.displays = {}

	local var2 = var0:GetMembers()

	for iter0, iter1 in pairs(var2) do
		local var3 = iter1:GetAssaultFleet():GetShipList()

		for iter2, iter3 in pairs(var3) do
			table.insert(arg0.displays, {
				ship = iter3,
				member = iter1
			})
		end
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return (arg0.ship.guildRecommand and 1 or 0) > (arg1.ship.guildRecommand and 1 or 0)
	end)
end

function var0.InitList(arg0)
	arg0:InitData()

	arg0.totalPageCnt = math.ceil(#arg0.displays / 9)

	arg0.scrollrect:SetTotalCount(#arg0.displays)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end
end

return var0
