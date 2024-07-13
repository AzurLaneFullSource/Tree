local var0_0 = class("SecondSummaryPage4", import(".SummaryAnimationPage"))

var0_0.PerPageCount = 6
var0_0.PageTypeFurniture = 1
var0_0.PageTypeIconFrame = 2

function var0_0.OnInit(arg0_1)
	local var0_1 = arg0_1.summaryInfoVO.pageType

	setActive(arg0_1._tf:Find("tip"), var0_1 == var0_0.PageTypeFurniture)
	setActive(arg0_1._tf:Find("tip_2"), var0_1 == var0_0.PageTypeIconFrame)

	local var1_1

	if var0_1 == var0_0.PageTypeFurniture then
		var1_1 = arg0_1.summaryInfoVO.medalList
	elseif var0_1 == var0_0.PageTypeIconFrame then
		var1_1 = arg0_1.summaryInfoVO.iconFrameList
	else
		assert(false, "page type error")
	end

	local var2_1 = {}
	local var3_1 = var0_0.PerPageCount * (arg0_1.summaryInfoVO.samePage - 1) + 1

	for iter0_1 = var3_1, math.min(var3_1 + var0_0.PerPageCount - 1, #var1_1) do
		table.insert(var2_1, var1_1[iter0_1])
	end

	local var4_1 = getProxy(AttireProxy)
	local var5_1 = UIItemList.New(arg0_1._tf:Find("scroll_rect/content"), arg0_1._tf:Find("scroll_rect/content/item_tpl"))

	var5_1:make(function(arg0_2, arg1_2, arg2_2)
		local var0_2 = arg1_2 + 1

		if arg0_2 == UIItemList.EventUpdate then
			setActive(arg2_2:Find("icon/Image"), var0_1 == var0_0.PageTypeFurniture)
			setActive(arg2_2:Find("icon/frame"), var0_1 == var0_0.PageTypeIconFrame)
			setActive(arg2_2:Find("date"), var0_1 == var0_0.PageTypeFurniture)
			setText(arg2_2:Find("date"), i18n("player_summary_data"))
			setText(arg2_2:Find("from"), i18n("player_summary_from"))

			if arg0_1.summaryInfoVO.pageType == var0_0.PageTypeFurniture then
				local var1_2 = var2_1[var0_2]
				local var2_2 = arg0_1.summaryInfoVO.furnitures[var1_2]
				local var3_2 = pg.furniture_data_template[var1_2]

				assert(var3_2, var1_2)
				GetImageSpriteFromAtlasAsync("furnitureicon/" .. var3_2.icon, "", arg2_2:Find("icon/Image"), true)
				setText(arg2_2:Find("controll/name/Text"), var3_2.name)
				setText(arg2_2:Find("from/Text"), var3_2.gain_by)
				setText(arg2_2:Find("date/Text"), var2_2 and var2_2:getDate() or i18n("summary_page_un_rearch"))
			elseif arg0_1.summaryInfoVO.pageType == var0_0.PageTypeIconFrame then
				local var4_2, var5_2 = unpack(var2_1[var0_2])
				local var6_2 = var4_1:getAttireFrame(AttireConst.TYPE_ICON_FRAME, var4_2)

				setLocalScale(arg2_2:Find("icon/frame"), Vector3(var5_2, var5_2, var5_2))
				PoolMgr.GetInstance():GetPrefab(var6_2:getIcon(), var6_2:getConfig("id"), true, function(arg0_3)
					setParent(arg0_3, arg2_2:Find("icon/frame"), false)
				end)
				setText(arg2_2:Find("controll/name/Text"), var6_2:getConfig("name"))
				setText(arg2_2:Find("from/Text"), var6_2:getConfig("gain_by"))
			else
				assert(false, "logic error")
			end
		end
	end)
	var5_1:align(#var2_1)
end

return var0_0
