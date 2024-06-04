local var0 = {
	PAGE = {
		EQUIPMENT = 2,
		DETAIL = 1,
		INTENSIFY = 3,
		CORE = 7,
		UPGRADE = 4,
		REMOULD = 6,
		FASHION = 5
	}
}

var0.currentPage = nil
var0.SUB_VIEW_PAGE = {
	var0.PAGE.DETAIL,
	var0.PAGE.EQUIPMENT,
	var0.PAGE.INTENSIFY,
	var0.PAGE.UPGRADE,
	var0.PAGE.FASHION
}
var0.SUB_LAYER_PAGE = {
	var0.PAGE.REMOULD,
	var0.PAGE.CORE
}

function var0.IsSubLayerPage(arg0)
	return table.contains(var0.SUB_LAYER_PAGE, arg0)
end

var0.SWITCH_TO_PAGE = "ShipViewConst.switch_to_page"
var0.LOAD_PAINTING = "ShipViewConst.load_painting"
var0.LOAD_PAINTING_BG = "ShipViewConst.load_painting_bg"
var0.HIDE_SHIP_WORD = "ShipViewConst.hide_ship_word"
var0.SET_CLICK_ENABLE = "ShipViewConst.set_click_enable"
var0.SHOW_CUSTOM_MSG = "ShipViewConst.show_custom_msg"
var0.HIDE_CUSTOM_MSG = "ShipViewConst.hide_custom_msg"
var0.DISPLAY_HUNTING_RANGE = "ShipViewConst.display_hunting_range"
var0.PAINT_VIEW = "ShipViewConst.paint_view"
var0.SHOW_EXP_ITEM_USAGE = "ShipViewConst.SHOW_EXP_ITEM_USAGE"

return var0
