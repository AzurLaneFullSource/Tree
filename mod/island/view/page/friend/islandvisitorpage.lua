local var0_0 = class("IslandSignInInvitationPage", import("...base.IslandBasePage"))
local var1_0 = 1
local var2_0 = 2

function var0_0.getUIName(arg0_1)
	return "IslandVisitorUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.kickAllBtn = arg0_2:findTF("frame/public")
	arg0_2.closeAccessBtn = arg0_2:findTF("frame/onkey")
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.peopleCntTxt = arg0_2:findTF("frame/cnt/Text"):GetComponent(typeof(Text))
	arg0_2.toggles = {
		arg0_2:findTF("frame/toggles/1"),
		arg0_2:findTF("frame/toggles/2")
	}
	arg0_2.texts = {
		arg0_2:findTF("frame/toggles/1/Text"):GetComponent(typeof(Text)),
		arg0_2:findTF("frame/toggles/2/Text"):GetComponent(typeof(Text))
	}
	arg0_2.names = {
		i18n("island_curr_visitor"),
		i18n("island_visitor_log")
	}
	arg0_2._scrollrect = arg0_2:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	arg0_2._scrollrectLog = arg0_2:findTF("frame/scrollrect4Log"):GetComponent("LScrollRect")
	arg0_2.scrollrects = {
		arg0_2._scrollrect,
		arg0_2._scrollrectLog
	}
	arg0_2.cards = {}
	arg0_2.logCards = {}
	arg0_2.cardList = {
		arg0_2.cards,
		arg0_2.logCards
	}

	function arg0_2._scrollrect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2._scrollrect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	function arg0_2._scrollrectLog.onInitItem(arg0_5)
		arg0_2:OnInitItem4Log(arg0_5)
	end

	function arg0_2._scrollrectLog.onUpdateItem(arg0_6, arg1_6)
		arg0_2:OnUpdateItem4Log(arg0_6, arg1_6)
	end

	setText(arg0_2:findTF("frame/public/Text"), i18n("island_kick_all"))
	setText(arg0_2:findTF("frame/onkey/Text"), i18n("island_close_visit"))
	setText(arg0_2:findTF("frame/cnt/label"), i18n("island_curr_people_cnt"))
end

function var0_0.OnInit(arg0_7)
	onButton(arg0_7, arg0_7._tf, function()
		arg0_7:Hide()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.closeBtn, function()
		arg0_7:Hide()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.kickAllBtn, function()
		local var0_10 = _.map(arg0_7.displays, function(arg0_11)
			return arg0_11.id
		end)

		if #var0_10 <= 0 then
			return
		end

		arg0_7:emit(IslandMediator.KICK_ALL_VISITOR, var0_10)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.closeAccessBtn, function()
		if not arg0_7:GetIsland():GetAccessAgency():HasOpenFlag(IslandConst.OPEN_ALL) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_close_access_state"))

			return
		end

		local var0_12 = {}
		local var1_12 = {
			IslandConst.OPEN_ALL
		}

		arg0_7:emit(IslandMediator.SET_ACCESS_FLAG, var0_12, var1_12)
	end, SFX_PANEL)

	for iter0_7, iter1_7 in pairs(arg0_7.toggles) do
		local var0_7 = arg0_7.texts[iter0_7]
		local var1_7 = arg0_7.names[iter0_7]

		onToggle(arg0_7, iter1_7, function(arg0_13)
			if arg0_13 then
				arg0_7:SwitchPage(iter0_7)
			end

			var0_7.text = arg0_13 and setColorStr(var1_7, "#FEFEFE") or setColorStr(var1_7, "#6B6E75")
		end, SFX_PANEL)

		var0_7.text = setColorStr(var1_7, "#6B6E75")
	end
end

function var0_0.AddListeners(arg0_14)
	arg0_14:AddListener(IslandVisitorAgency.PLAYER_ADD, arg0_14.OnFlush)
	arg0_14:AddListener(IslandVisitorAgency.PLAYER_EXIT, arg0_14.OnFlush)
end

function var0_0.RemoveListeners(arg0_15)
	arg0_15:RemoveListener(IslandVisitorAgency.PLAYER_ADD, arg0_15.OnFlush)
	arg0_15:RemoveListener(IslandVisitorAgency.PLAYER_EXIT, arg0_15.OnFlush)
end

function var0_0.OnFlush(arg0_16)
	arg0_16:FlushList()
end

function var0_0.GetDisplayData(arg0_17, arg1_17)
	local var0_17 = {}

	if arg1_17 == var1_0 then
		local var1_17 = arg0_17:GetIsland():GetVisitorAgency():GetPlayerList()

		for iter0_17, iter1_17 in pairs(var1_17) do
			if not iter1_17:IsSelf() then
				table.insert(var0_17, iter1_17)
			end
		end
	elseif arg1_17 == var2_0 then
		local var2_17 = getProxy(IslandProxy):GetIsland():GetAccessAgency():GetVisitorLogList()
		local var3_17 = {}

		for iter2_17, iter3_17 in ipairs(var2_17) do
			if not iter3_17:IsSelf() then
				table.insert(var3_17, iter3_17)
			end
		end

		table.sort(var3_17, function(arg0_18, arg1_18)
			return arg0_18.time > arg1_18.time
		end)

		if #var3_17 <= 1 then
			return {}
		end

		table.insert(var0_17, var3_17[1])

		local var4_17 = var3_17[1].time

		for iter4_17 = 2, #var3_17 do
			local var5_17 = var3_17[iter4_17].time

			if not pg.TimeMgr.GetInstance():IsSameDay(var4_17, var5_17) then
				table.insert(var0_17, IslandVisitorLog.New({
					id = -1,
					time = var5_17
				}))
			end

			table.insert(var0_17, var3_17[iter4_17])

			var4_17 = var5_17
		end
	end

	return var0_17
end

function var0_0.SwitchPage(arg0_19, arg1_19)
	arg0_19.pageIndex = arg1_19

	arg0_19:FlushList()
end

function var0_0.OnInitItem(arg0_20, arg1_20)
	local var0_20 = IslandVisitorCard.New(arg1_20)

	onButton(arg0_20, var0_20.btn, function()
		arg0_20:emit(IslandMediator.ON_KICK_PLAYER, IslandConst.ACCESS_OP_KICK, var0_20.player.id)
	end, SFX_PANEL)

	arg0_20.cardList[arg0_20.pageIndex][arg1_20] = var0_20
end

function var0_0.OnUpdateItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cardList[arg0_22.pageIndex][arg2_22]

	if not var0_22 then
		arg0_22:OnInitItem(arg2_22)

		var0_22 = arg0_22.cardList[arg0_22.pageIndex][arg2_22]
	end

	local var1_22 = arg0_22.displays[arg1_22 + 1]

	var0_22:Update(var1_22)
end

function var0_0.OnInitItem4Log(arg0_23, arg1_23)
	local var0_23 = IslandVisitorLogCard.New(arg1_23)

	arg0_23.cardList[arg0_23.pageIndex][arg1_23] = var0_23
end

function var0_0.OnUpdateItem4Log(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.cardList[arg0_24.pageIndex][arg2_24]

	if not var0_24 then
		arg0_24:OnInitItem(arg2_24)

		var0_24 = arg0_24.cardList[arg0_24.pageIndex][arg2_24]
	end

	local var1_24 = arg0_24.displays[arg1_24 + 1]

	var0_24:Update(var1_24)
end

function var0_0.Show(arg0_25)
	var0_0.super.Show(arg0_25)
	triggerToggle(arg0_25.toggles[var1_0], true)
end

function var0_0.FlushList(arg0_26)
	arg0_26.displays = arg0_26:GetDisplayData(arg0_26.pageIndex)

	arg0_26.scrollrects[arg0_26.pageIndex]:SetTotalCount(#arg0_26.displays)
	arg0_26:FlushPeopleCnt()
end

function var0_0.FlushPeopleCnt(arg0_27)
	arg0_27.peopleCntTxt.text = #arg0_27.displays .. "/10"
end

function var0_0.OnDestroy(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.cardList) do
		for iter2_28, iter3_28 in pairs(iter1_28) do
			iter3_28:Dispose()
		end
	end

	arg0_28.cardList = nil
end

return var0_0
