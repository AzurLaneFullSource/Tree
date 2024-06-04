local var0 = class("SecondSummaryPage4", import(".SummaryAnimationPage"))

var0.PerPageCount = 6
var0.PageTypeFurniture = 1
var0.PageTypeIconFrame = 2

function var0.OnInit(arg0)
	local var0 = arg0.summaryInfoVO.pageType

	setActive(arg0._tf:Find("tip"), var0 == var0.PageTypeFurniture)
	setActive(arg0._tf:Find("tip_2"), var0 == var0.PageTypeIconFrame)

	local var1

	if var0 == var0.PageTypeFurniture then
		var1 = arg0.summaryInfoVO.medalList
	elseif var0 == var0.PageTypeIconFrame then
		var1 = arg0.summaryInfoVO.iconFrameList
	else
		assert(false, "page type error")
	end

	local var2 = {}
	local var3 = var0.PerPageCount * (arg0.summaryInfoVO.samePage - 1) + 1

	for iter0 = var3, math.min(var3 + var0.PerPageCount - 1, #var1) do
		table.insert(var2, var1[iter0])
	end

	local var4 = getProxy(AttireProxy)
	local var5 = UIItemList.New(arg0._tf:Find("scroll_rect/content"), arg0._tf:Find("scroll_rect/content/item_tpl"))

	var5:make(function(arg0, arg1, arg2)
		local var0 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("icon/Image"), var0 == var0.PageTypeFurniture)
			setActive(arg2:Find("icon/frame"), var0 == var0.PageTypeIconFrame)
			setActive(arg2:Find("date"), var0 == var0.PageTypeFurniture)
			setText(arg2:Find("date"), i18n("player_summary_data"))
			setText(arg2:Find("from"), i18n("player_summary_from"))

			if arg0.summaryInfoVO.pageType == var0.PageTypeFurniture then
				local var1 = var2[var0]
				local var2 = arg0.summaryInfoVO.furnitures[var1]
				local var3 = pg.furniture_data_template[var1]

				assert(var3, var1)
				GetImageSpriteFromAtlasAsync("furnitureicon/" .. var3.icon, "", arg2:Find("icon/Image"), true)
				setText(arg2:Find("controll/name/Text"), var3.name)
				setText(arg2:Find("from/Text"), var3.gain_by)
				setText(arg2:Find("date/Text"), var2 and var2:getDate() or i18n("summary_page_un_rearch"))
			elseif arg0.summaryInfoVO.pageType == var0.PageTypeIconFrame then
				local var4, var5 = unpack(var2[var0])
				local var6 = var4:getAttireFrame(AttireConst.TYPE_ICON_FRAME, var4)

				setLocalScale(arg2:Find("icon/frame"), Vector3(var5, var5, var5))
				PoolMgr.GetInstance():GetPrefab(var6:getIcon(), var6:getConfig("id"), true, function(arg0)
					setParent(arg0, arg2:Find("icon/frame"), false)
				end)
				setText(arg2:Find("controll/name/Text"), var6:getConfig("name"))
				setText(arg2:Find("from/Text"), var6:getConfig("gain_by"))
			else
				assert(false, "logic error")
			end
		end
	end)
	var5:align(#var2)
end

return var0
