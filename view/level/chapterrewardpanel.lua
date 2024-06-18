local var0_0 = class("ChapterRewardPanel", BaseSubView)

function var0_0.getUIName(arg0_1)
	return "ChapterRewardPanel"
end

function var0_0.OnInit(arg0_2)
	setText(arg0_2:findTF("window/bg/text"), i18n("desc_defense_reward"))

	arg0_2.UIlist = UIItemList.New(arg0_2._tf:Find("window/bg/panel/list"), arg0_2._tf:Find("window/bg/panel/list/item"))
	arg0_2.closeBtn = arg0_2._tf:Find("window/top/btnBack")
	arg0_2.confirmBtn = arg0_2._tf:Find("window/btn_confirm")

	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.confirmBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)
end

local var1_0 = {
	"s",
	"a",
	"b"
}

local function var2_0(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.UIlist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			setText(arg2_7:Find("title/Text"), "PHASE " .. arg1_7 + 1)

			local var0_7 = tostring(arg2_6[arg1_7 + 1] - 1)

			if arg2_6[arg1_7 + 1] - 1 ~= arg2_6[arg1_7 + 2] then
				var0_7 = tostring(arg2_6[arg1_7 + 2]) .. "-" .. var0_7
			end

			setText(arg2_7:Find("target/title"), i18n("text_rest_HP") .. "：")
			setText(arg2_7:Find("target/Text"), var0_7)

			local var1_7 = arg3_6[arg1_7 + 1]

			updateDrop(arg2_7:Find("award"), var1_7, {
				hideName = true
			})
			onButton(arg0_6, arg2_7:Find("award"), function()
				arg0_6:emit(BaseUI.ON_DROP, var1_7)
			end, SFX_PANEL)
			setActive(arg2_7:Find("award/mask"), false)
		end
	end)
	arg0_6.UIlist:align(#arg3_6)
end

function var0_0.Show(arg0_9)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)
	var0_0.super.Show(arg0_9)
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
end

function var0_0.Enter(arg0_11, arg1_11)
	local var0_11 = arg1_11.id
	local var1_11 = pg.chapter_defense[var0_11]

	assert(var1_11, "Chapter Detail should only be Defense Type")

	local var2_11 = Clone(var1_11.score)

	table.insert(var2_11, 1, var1_11.port_hp + 1)

	local var3_11 = {}

	for iter0_11, iter1_11 in ipairs(var1_0) do
		local var4_11 = var1_11["evaluation_display_" .. iter1_11]

		if #var4_11 > 0 then
			table.insert(var3_11, {
				type = var4_11[1],
				id = var4_11[2],
				count = var4_11[3]
			})
		end
	end

	var2_0(arg0_11, var1_11, var2_11, var3_11)
	arg0_11:Show()
	Canvas.ForceUpdateCanvases()
end

function var0_0.OnDestroy(arg0_12)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf, arg0_12._parentTf)
end

return var0_0
