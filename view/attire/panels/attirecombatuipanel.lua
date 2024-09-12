local var0_0 = class("AttireCombatUIPanel", import(".AttireFramePanel"))
local var1_0 = setmetatable

local function var2_0(arg0_1)
	local var0_1 = {}

	local function var1_1(arg0_2)
		arg0_2._go = arg0_1
		arg0_2.info = findTF(arg0_2._go, "info")
		arg0_2.empty = findTF(arg0_2._go, "empty")
		arg0_2.icon = findTF(arg0_2._go, "info/icon")
		arg0_2.selected = findTF(arg0_2._go, "info/selected")
		arg0_2.nameTxt = findTF(arg0_2._go, "info/name")
		arg0_2.descTxt = findTF(arg0_2._go, "info/desc")
		arg0_2.conditionTxt = findTF(arg0_2._go, "info/condition")
		arg0_2.tags = {
			findTF(arg0_2._go, "info/tags/new"),
			findTF(arg0_2._go, "info/tags/e")
		}
		arg0_2.crossPrint = findTF(arg0_2._go, "prints/odd")
		arg0_2.own = findTF(arg0_2._go, "info/own")
		arg0_2.notOwn = findTF(arg0_2._go, "info/notOwn")

		setText(arg0_2.own, i18n("word_got"))
		setText(arg0_2.notOwn, i18n("word_not_get"))
	end

	function var0_1.isEmpty(arg0_3)
		return not arg0_3.uiStyle or arg0_3.uiStyle.id == -1
	end

	function var0_1.Update(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
		arg0_4.uiStyle = arg1_4

		if arg0_4:isEmpty() then
			setActive(arg0_4.info, false)
			setActive(arg0_4.empty, true)

			return
		end

		LoadImageSpriteAsync("combatuistyle/" .. arg1_4:getConfig("icon"), arg0_4.icon, true)
		setText(arg0_4.nameTxt, arg1_4:getConfig("name"))
		setText(arg0_4.descTxt, arg1_4:getConfig("desc"))
		setText(arg0_4.conditionTxt, arg1_4:getConfig("unlock"))

		local var0_4 = arg2_4:getAttireByType(arg1_4:getType())

		setActive(arg0_4.tags[2], arg1_4:isOwned() and var0_4 == arg1_4.id)
		setActive(arg0_4.tags[1], arg1_4:isNew())
		setActive(arg0_4.crossPrint, not arg3_4 and math.fmod(arg4_4 + 1, arg5_4) ~= 0)
		setActive(arg0_4.own, arg1_4:isOwned())
		setActive(arg0_4.notOwn, not arg1_4:isOwned())
	end

	function var0_1.UpdateSelected(arg0_5, arg1_5)
		setActive(arg0_5.selected, arg1_5)
	end

	function var0_1.IsOwned(arg0_6)
		return arg0_6.uiStyle:isOwned()
	end

	var1_1(var0_1)

	return var0_1
end

function var0_0.OnInit(arg0_7)
	arg0_7.listPanel = arg0_7:findTF("list_panel")
	arg0_7.scolrect = arg0_7:findTF("scrollrect", arg0_7.listPanel):GetComponent("LScrollRect")
	arg0_7.confirmBtn = arg0_7:findTF("confirm", arg0_7.listPanel)
	arg0_7.previewBtn = arg0_7:findTF("preview", arg0_7.listPanel)
	arg0_7.lockBtn = arg0_7:findTF("lock", arg0_7.listPanel)

	function arg0_7.scolrect.onInitItem(arg0_8)
		arg0_7:OnInitItem(arg0_8)
	end

	function arg0_7.scolrect.onUpdateItem(arg0_9, arg1_9)
		arg0_7:OnUpdateItem(arg0_9, arg1_9)
	end

	arg0_7.cards = {}
	arg0_7.totalCount = arg0_7:findTF("total_count/Text"):GetComponent(typeof(Text))
	arg0_7.preview = arg0_7:findTF("preview")
	arg0_7.sea = arg0_7:findTF("preview/sea")
	arg0_7.rawImage = arg0_7.sea:GetComponent("RawImage")
	arg0_7.uiLayer = arg0_7:findTF("preview/ui")

	setText(arg0_7.preview:Find("bg/title/Image"), i18n("word_preview"))
	setText(arg0_7.confirmBtn:Find("Text"), i18n("attire_combatui_confirm"))
	setText(arg0_7.previewBtn:Find("Text"), i18n("attire_combatui_preview"))
	setText(arg0_7.lockBtn:Find("Text"), i18n("index_not_obtained"))
	setActive(arg0_7.preview, false)
	setActive(arg0_7.rawImage, false)
	onButton(arg0_7, arg0_7.preview, function()
		arg0_7:onBackPressed()
	end)
end

function var0_0.getUIName(arg0_11)
	return "AttireCombatUIUI"
end

function var0_0.GetData(arg0_12)
	return arg0_12.rawAttireVOs.combatUIStyles
end

function var0_0.OnInitItem(arg0_13, arg1_13)
	local var0_13 = var2_0(arg1_13)

	arg0_13.cards[arg1_13] = var0_13

	onButton(arg0_13, var0_13._go, function()
		if not var0_13:isEmpty() then
			if arg0_13.card then
				arg0_13.card:UpdateSelected(false)
			end

			arg0_13.contextData.iconFrameId = var0_13.uiStyle.id

			arg0_13:UpdateDesc(var0_13)
			var0_13:UpdateSelected(true)

			arg0_13.card = var0_13

			if var0_13:IsOwned() then
				setActive(arg0_13.confirmBtn, true)
				setActive(arg0_13.lockBtn, false)
			else
				setActive(arg0_13.confirmBtn, false)
				setActive(arg0_13.lockBtn, true)
			end
		end
	end, SFX_PANEL)
end

function var0_0.GetColumn(arg0_15)
	return 2
end

function var0_0.OnUpdateItem(arg0_16, arg1_16, arg2_16)
	var0_0.super.OnUpdateItem(arg0_16, arg1_16, arg2_16)

	local var0_16 = arg0_16.contextData.iconFrameId or arg0_16.displayVOs[1].id
	local var1_16 = arg0_16.cards[arg2_16]

	if var1_16.uiStyle.id == var0_16 then
		triggerButton(var1_16._go)
		var1_16:UpdateSelected(true)
	end
end

function var0_0.GetDisplayVOs(arg0_17)
	local var0_17 = {}
	local var1_17 = 0

	for iter0_17, iter1_17 in pairs(arg0_17:GetData()) do
		table.insert(var0_17, iter1_17)

		if iter1_17:getState() == AttireFrame.STATE_UNLOCK and iter1_17.id >= 0 then
			var1_17 = var1_17 + 1
		end
	end

	return var0_17, var1_17
end

function var0_0.UpdateDesc(arg0_18, arg1_18)
	if arg1_18:isEmpty() then
		return
	end

	onButton(arg0_18, arg0_18.confirmBtn, function()
		local var0_19 = arg1_18.uiStyle:getType()

		arg0_18:emit(AttireMediator.ON_APPLY, var0_19, arg1_18.uiStyle.id)
	end, SFX_PANEL)

	local var0_18 = Ship.New({
		id = 100001,
		configId = 100001,
		skin_id = 100000
	})
	local var1_18 = Ship.New({
		id = 100011,
		configId = 100011,
		skin_id = 100010
	})
	local var2_18 = arg1_18.uiStyle:getConfig("key")

	onButton(arg0_18, arg0_18.previewBtn, function()
		local var0_20 = "CombatUI" .. var2_18
		local var1_20 = "CombatHPBar" .. var2_18
		local var2_20
		local var3_20
		local var4_20

		seriesAsync({
			function(arg0_21)
				PoolMgr.GetInstance():GetUI(var1_20, true, function(arg0_22)
					var3_20 = arg0_22

					arg0_21()
				end)
			end,
			function(arg0_23)
				PoolMgr.GetInstance():GetUI(var1_20, true, function(arg0_24)
					var4_20 = arg0_24

					arg0_23()
				end)
			end,
			function(arg0_25)
				PoolMgr.GetInstance():GetUI(var0_20, true, function(arg0_26)
					var2_20 = arg0_26

					arg0_25()
				end)
			end
		}, function()
			local var0_27 = pg.UIMgr.GetInstance().UIMain

			var2_20.transform:SetParent(arg0_18.uiLayer, false)
			var3_20.transform:SetParent(arg0_18.uiLayer, false)
			var4_20.transform:SetParent(arg0_18.uiLayer, false)
			setActive(arg0_18.preview, true)

			local var1_27 = arg0_18.sea.rect.width
			local var2_27 = arg0_18.sea.rect.height

			var2_20.transform.localScale = Vector3(var1_27 / 1920, var2_27 / 1080, 1)
			arg0_18.previewer = CombatUIPreviewer.New(arg0_18.rawImage)

			arg0_18.previewer:setDisplayWeapon({
				100
			})
			arg0_18.previewer:setCombatUI(var2_20, var3_20, var4_20, var2_18)
			arg0_18.previewer:load(40000, var0_18, var1_18, {}, function()
				return
			end)
		end)
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_29)
	if arg0_29.previewer then
		setActive(arg0_29.preview, false)
		arg0_29.previewer:clear()

		arg0_29.previewer = nil

		return true
	end
end

function var0_0.OnDestroy(arg0_30)
	if arg0_30.previewer then
		arg0_30.previewer:clear()

		arg0_30.previewer = nil
	end
end

return var0_0
