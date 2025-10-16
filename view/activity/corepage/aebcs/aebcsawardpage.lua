local var0_0 = class("AEBCSAwardPage", import("view.activity.CorePage.BRS.HeiYanAwardPage"))

function var0_0.InitData(arg0_1)
	for iter0_1, iter1_1 in ipairs(arg0_1.table_Top) do
		onToggle(arg0_1, iter1_1, function(arg0_2)
			if arg0_2 then
				arg0_1.pageIndex = iter0_1

				SetActive(arg0_1.bg_1, iter0_1 == 1)
				SetActive(arg0_1.bg_2, iter0_1 ~= 1)
				arg0_1:OnAnimation(iter0_1)
				arg0_1:DataList(iter0_1)
			end
		end, SFX_PANEL)
	end
end

function var0_0.OnAnimation(arg0_3, arg1_3)
	if arg1_3 ~= 1 then
		arg0_3.bg_2:GetComponent(typeof(Animation)):Play("AEBCSAwardPage_list_in")
	end
end

function var0_0.OnUpdateItem(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.showDataList[arg1_4 + 1]
	local var1_4 = arg2_4:Find("icon_mask/icon")
	local var2_4 = {
		type = var0_4.config.type,
		id = var0_4.config.drop_id
	}

	updateDrop(var1_4, var2_4)
	onButton(arg0_4, var1_4, function()
		local var0_5 = {
			type = MSGBOX_TYPE_LIKN_COLLECT_GUIDE,
			show_type = Msgbox4LinkCollectGuide.SHOW_TYPE_LIMIT,
			drop_type = var0_4.config.type,
			drop_id = var0_4.config.drop_id,
			count = var0_4.count,
			count_limit = var0_4.config.count,
			skipable_list = var0_4.config.link_params
		}

		arg0_4:selectBoxbg(var0_5)
		arg0_4:updateBoxPanel(var0_5)
		arg0_4:showBoxPanel(true)
	end, SFX_PANEL)
	arg0_4.super.OnUpdateItem(arg0_4, arg1_4, arg2_4)
end

function var0_0.UpdateView(arg0_6)
	for iter0_6 = 1, #arg0_6.table_Top do
		setText(arg0_6.table_Top[iter0_6]:Find("Label"), arg0_6:OnGetCount(iter0_6) .. "/" .. arg0_6:OnCount(iter0_6))
		setText(arg0_6.table_Top[iter0_6]:Find("type_image/name"), i18n("danmachi_award_" .. iter0_6))
	end

	triggerToggle(arg0_6.table_Top[arg0_6.pageIndex or 1], true)
end

function var0_0.selectBoxbg(arg0_7, arg1_7)
	if table.getCount(arg1_7.skipable_list) > 1 then
		setImageSprite(arg0_7.boxTF:Find("Panel/BG"), LoadSprite("ui/AEBCSAwardPage_atlas", "box_bg1"), true)
	elseif table.getCount(arg1_7.skipable_list) == 1 then
		setImageSprite(arg0_7.boxTF:Find("Panel/BG"), LoadSprite("ui/AEBCSAwardPage_atlas", "box_bg2"), true)
	end
end

function var0_0.RefreshCountText(arg0_8, arg1_8, arg2_8)
	setText(arg2_8:Find("owner/number"), arg1_8.count .. "/" .. arg1_8.config.count)
end

function var0_0.showBoxPanel(arg0_9, arg1_9)
	setActive(arg0_9.boxTF, arg1_9)

	if arg1_9 == true then
		pg.UIMgr.GetInstance():BlurPanel(arg0_9.boxTF)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9.boxTF, arg0_9._tf)
	end
end

function var0_0.OnDestroy(arg0_10)
	arg0_10:showBoxPanel(false)
end

return var0_0
