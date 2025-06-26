local var0_0 = class("AttireCombatUIPanel", import(".AttireFramePanel"))
local var1_0 = setmetatable

local function var2_0(arg0_1, arg1_1)
	local var0_1 = {}

	var0_1.__cname = "UICARD"

	local function var1_1(arg0_2)
		pg.DelegateInfo.New(arg0_2)

		arg0_2._go = arg0_1
		arg0_2.info = findTF(arg0_2._go, "info")
		arg0_2.empty = findTF(arg0_2._go, "empty")
		arg0_2.icon = findTF(arg0_2._go, "info/icon")
		arg0_2.selected = findTF(arg0_2._go, "info/selected")
		arg0_2.nameTxt = findTF(arg0_2._go, "info/nameMask/name")
		arg0_2.descTxt = findTF(arg0_2._go, "info/desc")
		arg0_2.conditionTxt = findTF(arg0_2._go, "info/condition")
		arg0_2.tags = {
			findTF(arg0_2._go, "info/tags/new"),
			findTF(arg0_2._go, "info/tags/e")
		}
		arg0_2.crossPrint = findTF(arg0_2._go, "prints/odd")
		arg0_2.notOwn = findTF(arg0_2._go, "info/notOwn")
		arg0_2.tipsGo = findTF(arg0_2._go, "info/tips")
		arg0_2.tipsText = findTF(arg0_2._go, "info/tips/text")
		arg0_2.toggleItem = findTF(arg0_2._go, "info/elementList/main_toggle")
		arg0_2.toggleList = UIItemList.New(findTF(arg0_2._go, "info/elementList"), arg0_2.toggleItem)

		arg0_2.toggleList:make(function(arg0_3, arg1_3, arg2_3)
			if arg0_3 == UIItemList.EventUpdate then
				local var0_3 = arg0_2.uiStyle:getConfig("rare_display")
				local var1_3 = var0_3[arg1_3 + 1]

				arg1_1:GetSpriteQuiet("ui/combatskinrare", CombatSkinConst.TYPE_ICON_NAME[var1_3], findTF(arg2_3, "on"))
				arg1_1:GetSpriteQuiet("ui/combatskinrare", string.format("%s_unselected", CombatSkinConst.TYPE_ICON_NAME[var1_3]), findTF(arg2_3, "off"))
				onToggle(arg0_2, arg2_3, function(arg0_4)
					setText(arg0_2.tipsText, i18n("battleui_display" .. var0_3[arg1_3 + 1]))

					local var0_4 = findTF(arg0_2._go, "info"):InverseTransformPoint(arg2_3.transform.position)

					setLocalPosition(arg0_2.tipsGo, var0_4 + Vector3(24, 46, 0))
					arg0_2:ShowTips(arg0_4)
				end)
			end
		end)

		arg0_2.handle = UpdateBeat:CreateListener(arg0_2.UpdateClick, arg0_2)

		UpdateBeat:AddListener(arg0_2.handle)
	end

	function var0_1.ShowTips(arg0_5, arg1_5)
		setActive(arg0_5.tipsGo, arg1_5)
	end

	function var0_1.isEmpty(arg0_6)
		return not arg0_6.uiStyle or arg0_6.uiStyle.id == -1
	end

	function var0_1.Update(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7, arg5_7)
		arg0_7.uiStyle = arg1_7

		if arg0_7:isEmpty() then
			setActive(arg0_7.info, false)
			setActive(arg0_7.empty, true)

			return
		else
			setActive(arg0_7.info, true)
			setActive(arg0_7.empty, false)
		end

		LoadImageSpriteAsync("combatuistyle/" .. arg1_7:getConfig("icon"), arg0_7.icon, true)
		setScrollText(arg0_7.nameTxt, arg1_7:getConfig("name"))
		setText(arg0_7.descTxt, arg1_7:getConfig("desc"))
		setText(arg0_7.conditionTxt, arg1_7:getConfig("unlock"))

		local var0_7 = arg2_7:getAttireByType(arg1_7:getType())

		setActive(arg0_7.tags[2], arg1_7:isOwned() and var0_7 == arg1_7.id)
		setActive(arg0_7.tags[1], arg1_7:isNew())
		setActive(arg0_7.crossPrint, not arg3_7 and math.fmod(arg4_7 + 1, arg5_7) ~= 0)
		setActive(arg0_7.notOwn, not arg1_7:isOwned())

		local var1_7 = arg1_7:getConfig("rare")

		arg1_1:GetSpriteQuiet("ui/combatskinrare", string.format("rare_%s", var1_7), findTF(arg0_7._go, "info/rareImage"))

		local var2_7 = arg1_7:getConfig("rare_display")

		arg0_7.toggleList:align(#var2_7)
	end

	function var0_1.UpdateClick(arg0_8)
		if UnityEngine.Input.GetMouseButtonDown(0) then
			arg0_8.toggleList:each(function(arg0_9, arg1_9)
				GetComponent(arg1_9, typeof(Toggle)).isOn = false
			end)
		end
	end

	function var0_1.Dispose(arg0_10)
		UpdateBeat:RemoveListener(arg0_10.handle)
		pg.DelegateInfo.Dispose(arg0_10)
	end

	function var0_1.UpdateSelected(arg0_11, arg1_11)
		setActive(arg0_11.selected, arg1_11)
	end

	function var0_1.IsOwned(arg0_12)
		return arg0_12.uiStyle:isOwned()
	end

	var1_1(var0_1)

	return var0_1
end

function var0_0.OnInit(arg0_13)
	arg0_13.listPanel = arg0_13:findTF("list_panel")
	arg0_13.scolrect = arg0_13:findTF("scrollrect", arg0_13.listPanel):GetComponent("LScrollRect")
	arg0_13.confirmBtn = arg0_13:findTF("confirm", arg0_13.listPanel)
	arg0_13.previewBtn = arg0_13:findTF("preview", arg0_13.listPanel)
	arg0_13.lockBtn = arg0_13:findTF("lock", arg0_13.listPanel)

	function arg0_13.scolrect.onInitItem(arg0_14)
		arg0_13:OnInitItem(arg0_14)
	end

	function arg0_13.scolrect.onUpdateItem(arg0_15, arg1_15)
		arg0_13:OnUpdateItem(arg0_15, arg1_15)
	end

	function arg0_13.scolrect.onReturnItem(arg0_16, arg1_16)
		arg0_13:OnReturnItem(arg0_16, arg1_16)
	end

	arg0_13.cards = {}
	arg0_13.totalCount = arg0_13:findTF("total_count/Text"):GetComponent(typeof(Text))
	arg0_13.preview = arg0_13:findTF("preview")
	arg0_13.sea = arg0_13:findTF("preview/sea")
	arg0_13.rawImage = arg0_13.sea:GetComponent("RawImage")
	arg0_13.uiLayer = arg0_13:findTF("preview/ui")

	setText(arg0_13.preview:Find("bg/title/Image"), i18n("word_preview"))
	setText(arg0_13.confirmBtn:Find("Text"), i18n("attire_combatui_confirm"))
	setText(arg0_13.previewBtn:Find("Text"), i18n("attire_combatui_preview"))
	setText(arg0_13.lockBtn:Find("Text"), i18n("index_not_obtained"))
	setActive(arg0_13.preview, false)
	setActive(arg0_13.rawImage, false)
	onButton(arg0_13, arg0_13.preview, function()
		arg0_13:onBackPressed()
	end)

	arg0_13.loader = AutoLoader.New()
end

function var0_0.getUIName(arg0_18)
	return "AttireCombatUIUI"
end

function var0_0.GetData(arg0_19)
	return arg0_19.rawAttireVOs.combatUIStyles
end

function var0_0.OnInitItem(arg0_20, arg1_20)
	local var0_20 = var2_0(arg1_20, arg0_20.loader)

	arg0_20.cards[arg1_20] = var0_20

	onButton(arg0_20, var0_20._go, function()
		if not var0_20:isEmpty() then
			if arg0_20.card then
				arg0_20.card:UpdateSelected(false)
			end

			arg0_20.contextData.iconFrameId = var0_20.uiStyle.id

			arg0_20:UpdateDesc(var0_20)
			var0_20:UpdateSelected(true)

			arg0_20.card = var0_20

			if var0_20:IsOwned() then
				setActive(arg0_20.confirmBtn, true)
				setActive(arg0_20.lockBtn, false)
			else
				setActive(arg0_20.confirmBtn, false)
				setActive(arg0_20.lockBtn, true)
			end
		end
	end, SFX_PANEL)
end

function var0_0.OnReturnItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cards[arg2_22]

	if var0_22 then
		var0_22:Dispose()
	end

	arg0_22.cards[arg2_22] = nil
end

function var0_0.GetColumn(arg0_23)
	return 2
end

function var0_0.OnUpdateItem(arg0_24, arg1_24, arg2_24)
	var0_0.super.OnUpdateItem(arg0_24, arg1_24, arg2_24)

	local var0_24 = arg0_24.playerVO:getAttireByType(AttireConst.TYPE_COMBAT_UI_STYLE)
	local var1_24 = arg0_24.cards[arg2_24]

	if var1_24.uiStyle.id == var0_24 then
		triggerButton(var1_24._go)
	end
end

function var0_0.GetDisplayVOs(arg0_25)
	local var0_25 = {}
	local var1_25 = 0

	for iter0_25, iter1_25 in pairs(arg0_25:GetData()) do
		table.insert(var0_25, iter1_25)

		if iter1_25:getState() == AttireFrame.STATE_UNLOCK and iter1_25.id >= 0 then
			var1_25 = var1_25 + 1
		end
	end

	return var0_25, var1_25
end

function var0_0.UpdateDesc(arg0_26, arg1_26)
	if arg1_26:isEmpty() then
		return
	end

	onButton(arg0_26, arg0_26.confirmBtn, function()
		local var0_27 = arg1_26.uiStyle:getType()

		arg0_26:emit(AttireMediator.ON_APPLY, var0_27, arg1_26.uiStyle.id)
	end, SFX_PANEL)

	local var0_26 = Ship.New({
		id = 100001,
		configId = 100001,
		skin_id = 100000
	})
	local var1_26 = Ship.New({
		id = 100011,
		configId = 100011,
		skin_id = 100010
	})
	local var2_26 = arg1_26.uiStyle:getConfig("key")

	onButton(arg0_26, arg0_26.previewBtn, function()
		arg0_26.combatPreview = CombatPreviewLayer.New(pg.UIMgr.GetInstance().OverlayMain)

		arg0_26.combatPreview:ExecuteAction("Show", arg1_26.uiStyle:getConfig("id"), function()
			arg0_26.combatPreview:Destroy()

			arg0_26.combatPreview = nil
		end)
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_30)
	if arg0_30.combatPreview then
		arg0_30.combatPreview:Destroy()

		arg0_30.combatPreview = nil

		return true
	end
end

function var0_0.OnDestroy(arg0_31)
	arg0_31.loader:Clear()
end

return var0_0
