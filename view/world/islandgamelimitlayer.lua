local var0_0 = class("IslandGameLimitLayer", import("view.base.BaseUI"))

var0_0.limit_type_jiujiu = "IslandGameJiuJiuLimitUI"
var0_0.limit_type_catch = "IslandGameCatchLimitUI"
var0_0.limit_type_stone = "IslandGameStoneLimitUI"

local var1_0 = "island_game_limit_help"
local var2_0 = "island_game_limit_num"
local var3_0 = "island_act_tips1"

function var0_0.getUIName(arg0_1)
	return "IslandGameLimitUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2.contextData.type or IslandGameLimitLayer.limit_type_jiujiu
	local var1_2 = ActivityConst.ISLAND_GAME_ID
	local var2_2 = pg.activity_template[var1_2].config_client.item_id

	arg0_2.itemConfig = Item.getConfigData(var2_2)

	local var3_2 = pg.activity_template[var1_2].config_id

	arg0_2.num = getProxy(MiniGameProxy):GetHubByHubId(var3_2).count or 0
	arg0_2.dayLimit = pg.mini_game_hub[var3_2].reborn_times
	arg0_2.allWindows = {}

	arg0_2:showWindow(var0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.showWindow(arg0_3, arg1_3)
	if not arg0_3.allWindows[arg1_3] then
		local var0_3 = LoadAndInstantiateSync("ui", arg1_3)

		arg0_3:prepareWindow(var0_3)
		setParent(var0_3, findTF(arg0_3._tf, "ad"))

		arg0_3.allWindows[arg1_3] = var0_3
	end

	for iter0_3, iter1_3 in pairs(arg0_3.allWindows) do
		setActive(iter1_3, iter0_3 == arg1_3)
	end
end

function var0_0.prepareWindow(arg0_4, arg1_4)
	onButton(arg0_4, findTF(arg1_4, "ad"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)

	arg0_4.dropIcon = findTF(arg1_4, "ad/icon/IconTpl")

	updateDrop(arg0_4.dropIcon, {
		id = arg0_4.itemConfig.id,
		type = DROP_TYPE_ITEM
	})
	setText(findTF(arg1_4, "ad/name"), arg0_4.itemConfig.name)
	setText(findTF(arg1_4, "ad/desc"), arg0_4.itemConfig.display)
	setText(findTF(arg1_4, "ad/num"), i18n(var2_0, arg0_4.num))
	setText(findTF(arg1_4, "ad/help"), i18n(var1_0, arg0_4.dayLimit))
	setText(findTF(arg1_4, "ad/clickClose"), i18n(var3_0))
end

function var0_0.willExit(arg0_6)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_6._tf)
end

return var0_0
