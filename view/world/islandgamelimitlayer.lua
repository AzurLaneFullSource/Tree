local var0 = class("IslandGameLimitLayer", import("view.base.BaseUI"))

var0.limit_type_jiujiu = "IslandGameJiuJiuLimitUI"
var0.limit_type_catch = "IslandGameCatchLimitUI"
var0.limit_type_stone = "IslandGameStoneLimitUI"

local var1 = "island_game_limit_help"
local var2 = "island_game_limit_num"
local var3 = "island_act_tips1"

function var0.getUIName(arg0)
	return "IslandGameLimitUI"
end

function var0.init(arg0)
	local var0 = arg0.contextData.type or IslandGameLimitLayer.limit_type_jiujiu
	local var1 = ActivityConst.ISLAND_GAME_ID
	local var2 = pg.activity_template[var1].config_client.item_id

	arg0.itemConfig = Item.getConfigData(var2)

	local var3 = pg.activity_template[var1].config_id

	arg0.num = getProxy(MiniGameProxy):GetHubByHubId(var3).count or 0
	arg0.dayLimit = pg.mini_game_hub[var3].reborn_times
	arg0.allWindows = {}

	arg0:showWindow(var0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.showWindow(arg0, arg1)
	if not arg0.allWindows[arg1] then
		local var0 = LoadAndInstantiateSync("ui", arg1)

		arg0:prepareWindow(var0)
		setParent(var0, findTF(arg0._tf, "ad"))

		arg0.allWindows[arg1] = var0
	end

	for iter0, iter1 in pairs(arg0.allWindows) do
		setActive(iter1, iter0 == arg1)
	end
end

function var0.prepareWindow(arg0, arg1)
	onButton(arg0, findTF(arg1, "ad"), function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.dropIcon = findTF(arg1, "ad/icon/IconTpl")

	updateDrop(arg0.dropIcon, {
		id = arg0.itemConfig.id,
		type = DROP_TYPE_ITEM
	})
	setText(findTF(arg1, "ad/name"), arg0.itemConfig.name)
	setText(findTF(arg1, "ad/desc"), arg0.itemConfig.display)
	setText(findTF(arg1, "ad/num"), i18n(var2, arg0.num))
	setText(findTF(arg1, "ad/help"), i18n(var1, arg0.dayLimit))
	setText(findTF(arg1, "ad/clickClose"), i18n(var3))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
