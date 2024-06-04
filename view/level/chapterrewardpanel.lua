local var0 = class("ChapterRewardPanel", BaseSubView)

function var0.getUIName(arg0)
	return "ChapterRewardPanel"
end

function var0.OnInit(arg0)
	setText(arg0:findTF("window/bg/text"), i18n("desc_defense_reward"))

	arg0.UIlist = UIItemList.New(arg0._tf:Find("window/bg/panel/list"), arg0._tf:Find("window/bg/panel/list/item"))
	arg0.closeBtn = arg0._tf:Find("window/top/btnBack")
	arg0.confirmBtn = arg0._tf:Find("window/btn_confirm")

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

local var1 = {
	"s",
	"a",
	"b"
}

local function var2(arg0, arg1, arg2, arg3)
	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setText(arg2:Find("title/Text"), "PHASE " .. arg1 + 1)

			local var0 = tostring(arg2[arg1 + 1] - 1)

			if arg2[arg1 + 1] - 1 ~= arg2[arg1 + 2] then
				var0 = tostring(arg2[arg1 + 2]) .. "-" .. var0
			end

			setText(arg2:Find("target/title"), i18n("text_rest_HP") .. "：")
			setText(arg2:Find("target/Text"), var0)

			local var1 = arg3[arg1 + 1]

			updateDrop(arg2:Find("award"), var1, {
				hideName = true
			})
			onButton(arg0, arg2:Find("award"), function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
			setActive(arg2:Find("award/mask"), false)
		end
	end)
	arg0.UIlist:align(#arg3)
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	var0.super.Show(arg0)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.Enter(arg0, arg1)
	local var0 = arg1.id
	local var1 = pg.chapter_defense[var0]

	assert(var1, "Chapter Detail should only be Defense Type")

	local var2 = Clone(var1.score)

	table.insert(var2, 1, var1.port_hp + 1)

	local var3 = {}

	for iter0, iter1 in ipairs(var1) do
		local var4 = var1["evaluation_display_" .. iter1]

		if #var4 > 0 then
			table.insert(var3, {
				type = var4[1],
				id = var4[2],
				count = var4[3]
			})
		end
	end

	var2(arg0, var1, var2, var3)
	arg0:Show()
	Canvas.ForceUpdateCanvases()
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

return var0
